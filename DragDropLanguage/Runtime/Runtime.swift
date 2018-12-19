//
//  Runtime.swift
//  DragDropLanguage
//
//  Created by Cameron Eldridge on 2018-09-24.
//  Copyright © 2018 Cameron Eldridge. All rights reserved.
//

private let TYPES_MODULE = "MODULE__types"
private let FUNCTION_EXEC_NAME = "exec"
private let CONSTRUCTOR_NAME = "new"
private let STRUCT_SENTINEL = "struct"
private let ENUM_SENTINEL = "enum"

extension Definition {
    fileprivate var moduleName: String {
        return "M__" + modulePath.joined(separator: "___")
    }
}

extension Value {
    init(from wrenValue: WrenValue, expecting: Type) throws {
        switch (wrenValue, expecting) {
        case (.bool(let bool), .primitive(.bool)): self = .value(.bool(bool))
        case (.double(let double), .primitive(.double)): self = .value(.float(double))
        case (.double(let double), .primitive(.int)): self = .value(.int(Int(double)))
        case (.int(let int), .primitive(.int)): self = .value(.int(int))
        case (.string(let string), .primitive(.string)): self = .value(.string(string))
        case (.string(let string), .primitive(.symbol)): self = .value(.symbol(string))
        case (.string(let string), .primitive(.char)) where string.count == 1: self = .value(.char(string.first!))
        case (.double(let double), .primitive(.char)): self = .value(.char(Character(Unicode.Scalar(UInt32(double))!)))
        case (.list(let list), .struct(let `struct`))
            where list[0] == .string(STRUCT_SENTINEL) && list.count == `struct`.fields.count + 1:
            self = .struct(
                `struct`,
                try zip(list.dropFirst(), `struct`.fields).map { value, field in
                    try Value(from: value, expecting: field.type)
                }
            )
        case (.list(let list), .enum(let `enum`)) where list[0] == .string(ENUM_SENTINEL) && list.count == 3:
            guard case .double(let index) = list[1] else {
                throw WrongTypeError(expected: .primitive(.double), found: list[1])
            }
            let caseIndex = Int(index)
            self = .enum(
                `enum`,
                caseIndex,
                try Value(from: list[2], expecting: `enum`.cases[caseIndex].type)
            )
        case (.handle, _): fatalError("Unimplemented")
        default: throw WrongTypeError(expected: expecting, found: wrenValue)
        }
    }

    fileprivate func asWrenValue(in vm: WrenVM) throws -> WrenValue {
        switch self {
        case .value(.bool(let bool)):
            return .bool(bool)
        case .value(.char(let char)):
            return .string(String(char))
        case .value(.float(let float)):
            return .double(Double(float))
        case .value(.int(let int)):
            return .int(int)
        case .value(.string(let string)):
            return .string(string)
        case .value(.symbol(let symbol)):
            return .string(symbol)
        case .struct(let `struct`, let fields):
            let receiver = vm.variable(module: TYPES_MODULE, name: `struct`.uniqueName)
            return try vm.call(receiver, CONSTRUCTOR_NAME, args: try fields.map { try $0.asWrenValue(in: vm) })
        case .enum(let `enum`, let `case`, let value):
            let receiver = vm.variable(module: TYPES_MODULE, name: `enum`.uniqueName)
            return try vm.call(receiver, CONSTRUCTOR_NAME, args: [.string(`enum`.cases[`case`].name), try value.asWrenValue(in: vm)])
        case .function(_):
            fatalError("Cannot pass a function to the Wren layer")
        }
    }
}

extension Package {
    func load(into vm: WrenVM) throws {
        try definitions.load(into: vm, package: name)
    }
}

extension Module {
    func load(into vm: WrenVM, package: String? = nil) throws {
        for function in functions {
            if case .script(let script) = function.source {
                let source = """
                // Function: \(name).\(function.name)
                class \(function.uniqueName) {
                    static \(FUNCTION_EXEC_NAME)(input) {
                        \(script.source)
                    }
                }
                """
                try vm.interpret(module: package, source)
            }
        }
        for type in types {
            switch type {
            case .struct(let `struct`):
                let source = """
                // Struct: \(name).\(`struct`.name)
                class \(`struct`.uniqueName) {
                    construct \(CONSTRUCTOR_NAME)(\(`struct`.fields.map { "\($0.name)" }.joined(separator: ", "))) {
                        \(`struct`.fields.map { "_\($0.name) = \($0.name)" }.joined(separator: "\n        "))
                    }

                    \(`struct`.fields.map { "\($0.name) { _\($0.name) }" }.joined(separator: "\n    "))
                    \(`struct`.fields.map { "\($0.name)=(value) { _\($0.name) = value }" }.joined(separator: "\n    "))

                    serialized {
                        return ["\(STRUCT_SENTINEL)", \(`struct`.fields.map {
                            switch $0.type {
                            case .struct, .enum:
                                return "_\($0.name).serialized"
                            default:
                                return "_\($0.name)"
                            }
                        }.joined(separator: ", "))]
                    }
                }
                """
                try vm.interpret(module: TYPES_MODULE, source)
            case .enum(let `enum`):
                let source = """
                // Enum: \(name).\(`enum`.name)
                class \(`enum`.uniqueName) {
                    construct \(CONSTRUCTOR_NAME)(case, value) {
                        _case = case
                        _value = value
                    }

                    case { _case }
                    value { _value }

                    serialized { ["\(ENUM_SENTINEL)", _case, _value] }
                }
                """
                try vm.interpret(module: TYPES_MODULE, source)
            default: break
            }
        }
        for submodule in submodules {
            try submodule.load(into: vm, package: package)
        }
    }
}

extension Project {
    func load(into vm: WrenVM) throws {
        for package in packages {
            try package.load(into: vm)
        }
        try rootModule.load(into: vm)
    }
}

struct Runtime {
    class VM {
        private let vm = WrenVM()
        private var loadedScripts: Set<Definition> = []

        let project: Project

        init(project: Project) {
            self.project = project
        }

        func run() throws {
            try project.load(into: vm)
            let result = try execute(function: .main, input: project.initialValue)
            print(result) // DEBUG
        }

        func execute(function definition: Definition, input: Value) throws -> Value {
            let function = try project.lookup(function: definition)
            return try execute(function: function, input: input, qualification: definition)
        }

        func execute(function: Function, input: Value, qualification: Definition? = nil) throws -> Value {
            switch function.source {
            case .program(let program):
                return try execute(program: program, input: input)
            case .script:
                let receiver = vm.variable(module: qualification?.package, name: function.uniqueName)
                let wrenValue = try vm.call(receiver, FUNCTION_EXEC_NAME, args: [try input.asWrenValue(in: vm)])
                return try Value(from: wrenValue, expecting: project.resolve(type: function.type.output))
            }
        }

        func execute(program: Program, input: Value) throws -> Value {
            return try Executor(vm: self, program: program).run(input: input)
        }
    }

    static func run(project: Project) {
        try! VM(project: project).run()
    }
}
