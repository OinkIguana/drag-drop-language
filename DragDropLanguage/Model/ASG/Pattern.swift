//
//  Pattern.swift
//  DragDropLanguage
//
//  Created by Cameron Eldridge on 2018-10-03.
//  Copyright © 2018 Cameron Eldridge. All rights reserved.
//

enum Pattern: Codable {
    case value(Constant)
    case `enum`(Enum, case: Int)
    case `default`

    private enum Case: String, Codable {
        case value
        case `enum`
        case `default`
    }

    private enum CodingKeys: String, CodingKey {
        case `case`
        case value
        case enumCase
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        switch try container.decode(Case.self, forKey: .case) {
        case .value:
            self = .value(try container.decode(Constant.self, forKey: .value))
        case .enum:
            self = .enum(
                try container.decode(Enum.self, forKey: .value),
                case: try container.decode(Int.self, forKey: .enumCase)
            )
        case .default:
            self = .default
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .value(let value):
            try container.encode(Case.value, forKey: .case)
            try container.encode(value, forKey: .value)
        case .enum(let `enum`, let enumCase):
            try container.encode(Case.enum, forKey: .case)
            try container.encode(`enum`, forKey: .value)
            try container.encode(enumCase, forKey: .enumCase)
        case .default:
            try container.encode(Case.default, forKey: .case)
        }
    }
}

extension Pattern {
    func matches(_ value: Value) -> Value? {
        switch (self, value) {
        case (.enum(let patType, let patCase), .enum(let valType, let valCase, let value))
            where patType == valType && patCase == valCase:
            return value
        case (.value(let patValue), .value(let valValue))
            where patValue == valValue:
            return value
        case (.default, _):
            return value
        default:
            return nil
        }
    }
}
