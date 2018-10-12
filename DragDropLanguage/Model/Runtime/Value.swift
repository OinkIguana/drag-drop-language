//
//  Value.swift
//  DragDropLanguage
//
//  Created by Cameron Eldridge on 2018-09-15.
//  Copyright © 2018 Cameron Eldridge. All rights reserved.
//

indirect enum Value: Codable {
    case `struct`(Struct, [Value])
    case `enum`(Enum, Int, Value)
    case function(Function)
    case value(Constant)

    private enum Case: String, Codable {
        case `struct`
        case `enum`
        case function
        case value
    }

    private enum CodingKeys: String, CodingKey {
        case `case`
        case value
        case enumCase
        case fields
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        switch try container.decode(Case.self, forKey: .case) {
        case .struct:
            self = .struct(
                try container.decode(Struct.self, forKey: .value),
                try container.decode([Value].self, forKey: .fields)
            )
        case .enum:
            self = .enum(
                try container.decode(Enum.self, forKey: .value),
                try container.decode(Int.self, forKey: .enumCase),
                try container.decode(Value.self, forKey: .fields)
            )
        case .function:
            self = .function(try container.decode(Function.self, forKey: .value))
        case .value:
            self = .value(try container.decode(Constant.self, forKey: .value))
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .struct(let `struct`, let fields):
            try container.encode(Case.struct, forKey: .case)
            try container.encode(`struct`, forKey: .value)
            try container.encode(fields, forKey: .fields)
        case .enum(let `enum`, let `case`, let value):
            try container.encode(Case.enum, forKey: .case)
            try container.encode(`enum`, forKey: .value)
            try container.encode(`case`, forKey: .enumCase)
            try container.encode(value, forKey: .fields)
        case .function(let function):
            try container.encode(Case.function, forKey: .case)
            try container.encode(function, forKey: .value)
        case .value(let constant):
            try container.encode(Case.value, forKey: .case)
            try container.encode(constant, forKey: .value)
        }
    }
}

extension Value {
    var type: Type {
        switch self {
        case .struct(let `struct`, _):
            return .struct(`struct`)
        case .enum(let `enum`, _, _):
            return .enum(`enum`)
        case .value(.bool):
            return .primitive(.bool)
        case .value(.char):
            return .primitive(.char)
        case .value(.float):
            return .primitive(.float)
        case .value(.int):
            return .primitive(.int)
        case .value(.string):
            return .primitive(.string)
        case .value(.symbol):
            return .primitive(.symbol)
        case .function(let function):
            return .function(function.type)
        }
    }
}
