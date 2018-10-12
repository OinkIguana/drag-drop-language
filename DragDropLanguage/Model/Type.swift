//
//  Type.swift
//  DragDropLanguage
//
//  Created by Cameron Eldridge on 2018-09-07.
//  Copyright © 2018 Cameron Eldridge. All rights reserved.
//

indirect enum Type: Codable {
    case `enum`(Enum)
    case `struct`(Struct)
    case primitive(Primitive)
    case function(FunctionType)

    private enum Case: String, Codable {
        case `enum`
        case `struct`
        case primitive
        case function
    }

    private enum CodingKeys: String, CodingKey {
        case `case`
        case value
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        switch try container.decode(Case.self, forKey: .case) {
        case .enum: self = .enum(try container.decode(Enum.self, forKey: .value))
        case .struct: self = .struct(try container.decode(Struct.self, forKey: .value))
        case .primitive: self = .primitive(try container.decode(Primitive.self, forKey: .value))
        case .function: self = .function(try container.decode(FunctionType.self, forKey: .value))
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .enum(let value):
            try container.encode(Case.enum, forKey: .case)
            try container.encode(value, forKey: .value)
        case .struct(let value):
            try container.encode(Case.struct, forKey: .case)
            try container.encode(value, forKey: .value)
        case .primitive(let value):
            try container.encode(Case.primitive, forKey: .case)
            try container.encode(value, forKey: .value)
        case .function(let value):
            try container.encode(Case.function, forKey: .case)
            try container.encode(value, forKey: .value)
        }
    }
}

extension Type {
    var name: String? {
        switch self {
        case .enum(let `enum`): return `enum`.name
        case .struct(let `struct`): return `struct`.name
        default: return nil
        }
    }
}
