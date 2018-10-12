//
//  Executor.swift
//  DragDropLanguage
//
//  Created by Cameron Eldridge on 2018-10-03.
//  Copyright © 2018 Cameron Eldridge. All rights reserved.
//

/// Indicates that the program is invalid due to an internal inconsistincy
struct InvalidGraphError: Error {}

/// Indicates that there is a branch in the tree that is missing
struct MissingBranchError: Error {}

/// Indicates that something went wrong at runtime
struct RuntimeError: Error {}

/// Indicates that there was no way to compute a value for a node, and that it should be abandoned in favor of another
/// path
struct WrongPathError: Error {}

/// Indicates that a function returned a type that was not the expected return type
struct WrongTypeError: Error {}

class Executor {
    unowned var vm: Runtime.VM
    let program: Program
    var state: [NodeID: Value] = [:]

    init(vm: Runtime.VM, program: Program) {
        self.vm = vm
        self.program = program
    }

    func run(input: Value) throws -> Value {
        if let root = program.root {
            state[root.id] = input
        }

        for output in program.returns {
            do {
                return try compute(output, at: .node(output.id))
            } catch is WrongPathError { continue }
        }
        // TODO: allow side effects
        throw WrongPathError()
    }

    func compute(at path: NodePath) throws -> Value {
        return try compute(program.node(at: path)!, at: path)
    }

    func compute(_ node: Node, at path: NodePath) throws -> Value {
        if let value = state[node.id] {
            return value
        }

        let inputs = program.predecessors(of: node)

        switch node.kind {
        case .function(let call):
            guard inputs.count == 1 else {
                throw InvalidGraphError()
            }
            state[node.id] = try vm.execute(function: call.definition, input: try compute(at: inputs[0]))
        case .constant(let constant):
            guard inputs.isEmpty else {
                throw InvalidGraphError()
            }
            state[node.id] = .value(constant)
        case .output:
            guard inputs.count == 1 else {
                throw InvalidGraphError()
            }
            state[node.id] = try compute(at: inputs[0])
        case .caseConstruct(let caseConstruct):
            guard case .caseConstruct(_, let field) = path else {
                throw InvalidGraphError()
            }
            state[node.id] = .enum(caseConstruct.type, field, try compute(at: inputs[0]))
        case .construct(let construct):
            guard inputs.count == construct.type.fields.count else {
                throw MissingBranchError()
            }
            state[node.id] = .struct(construct.type, try inputs.map(compute(at:)))
        case .match:
            guard
                case .match(_, let pattern) = path,
                inputs.count == 1
            else {
                throw InvalidGraphError()
            }
            state[node.id] = try compute(at: inputs[0])
            if let value = pattern.matches(state[node.id]!) {
                return value
            } else {
                throw WrongPathError()
            }
        case .destructure(let destructure):
            guard
                case .destructure(_, let field) = path,
                inputs.count == 1
            else {
                throw InvalidGraphError()
            }
            guard
                case .struct(let `struct`, let fields) = try compute(at: inputs[0]),
                `struct` == destructure.type
            else {
                throw RuntimeError()
            }
            guard field < fields.count else {
                throw MissingBranchError()
            }
            state[node.id] = fields[field]
        case .input: break // this one is computed by default
        }

        return state[node.id]!
    }
}
