//
//  Constant.swift
//  DragDropLanguage
//
//  Created by Cameron Eldridge on 2018-09-07.
//  Copyright © 2018 Cameron Eldridge. All rights reserved.
//

enum Constant: Codable, Equatable {
    case int(Int)
    case char(Character)
    case float(Double)
    case bool(Bool)
    case symbol(String)
    case string(String)

    private enum Case: String, Codable {
        case int
        case char
        case float
        case bool
        case symbol
        case string
    }

    private enum CodingKeys: String, CodingKey {
        case `case`
        case value
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        switch try container.decode(Case.self, forKey: .case) {
        case .int: self = .int(try container.decode(Int.self, forKey: .value))
        case .char: self = .char(try container.decode(String.self, forKey: .value).first!)
        case .float: self = .float(try container.decode(Double.self, forKey: .value))
        case .bool: self = .bool(try container.decode(Bool.self, forKey: .value))
        case .symbol: self = .symbol(try container.decode(String.self, forKey: .value))
        case .string: self = .string(try container.decode(String.self, forKey: .value))
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .int(let value):
            try container.encode(Case.int, forKey: .case)
            try container.encode(value, forKey: .value)
        case .char(let value):
            try container.encode(Case.char, forKey: .case)
            try container.encode("\(value)", forKey: .value)
        case .float(let value):
            try container.encode(Case.float, forKey: .case)
            try container.encode(value, forKey: .value)
        case .bool(let value):
            try container.encode(Case.bool, forKey: .case)
            try container.encode(value, forKey: .value)
        case .symbol(let value):
            try container.encode(Case.symbol, forKey: .case)
            try container.encode(value, forKey: .value)
        case .string(let value):
            try container.encode(Case.string, forKey: .case)
            try container.encode(value, forKey: .value)
        }
    }
}
