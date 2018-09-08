//
//  Node.swift
//  DragDropLanguage
//
//  Created by Cameron Eldridge on 2018-09-08.
//  Copyright © 2018 Cameron Eldridge. All rights reserved.
//

enum Node: Codable {
    case input
    case output
    case constant(Constant)
    case function(FunctionCall)
    case caseConstruct(CaseConstruct)
    case construct(Construct)
    case destructure(Destructure)
    case match(Match)

    private enum Case: String, Codable {
        case input
        case output
        case constant
        case function
        case caseConstruct
        case construct
        case destructure
        case match
    }

    private enum CodingKeys: String, CodingKey {
        case `case`
        case value
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        switch try container.decode(Case.self, forKey: .case) {
        case .input:
            self = .input
        case .output:
            self = .output
        case .constant:
            self = .constant(try container.decode(Constant.self, forKey: .value))
        case .function:
            self = .function(try container.decode(FunctionCall.self, forKey: .value))
        case .caseConstruct:
            self = .caseConstruct(try container.decode(CaseConstruct.self, forKey: .value))
        case .construct:
            self = .construct(try container.decode(Construct.self, forKey: .value))
        case .destructure:
            self = .destructure(try container.decode(Destructure.self, forKey: .value))
        case .match:
            self = .match(try container.decode(Match.self, forKey: .value))
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .input:
            try container.encode(Case.input, forKey: .case)
        case .output:
            try container.encode(Case.output, forKey: .case)
        case .constant(let value):
            try container.encode(Case.constant, forKey: .case)
            try container.encode(value, forKey: .value)
        case .function(let value):
            try container.encode(Case.function, forKey: .case)
            try container.encode(value, forKey: .value)
        case .caseConstruct(let value):
            try container.encode(Case.caseConstruct, forKey: .case)
            try container.encode(value, forKey: .value)
        case .construct(let value):
            try container.encode(Case.construct, forKey: .case)
            try container.encode(value, forKey: .value)
        case .destructure(let value):
            try container.encode(Case.destructure, forKey: .case)
            try container.encode(value, forKey: .value)
        case .match(let value):
            try container.encode(Case.match, forKey: .case)
            try container.encode(value, forKey: .value)
        }
    }
}

enum NodePath: Codable {
    case index(node: Int)
    case destructure(node: Int, field: Int)
    case match(node: Int, `case`: Int, field: Int)
    case construct(node: Int, field: Int)
    case caseConstruct(node: Int, field: Int)

    private enum Case: String, Codable {
        case index
        case destructure
        case match
        case construct
        case caseConstruct
    }

    private enum CodingKeys: String, CodingKey {
        case `case`
        case nodeIndex
        case fieldIndex
        case caseIndex
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        switch try container.decode(Case.self, forKey: .case) {
        case .index:
            self = .index(node: try container.decode(Int.self, forKey: .nodeIndex))
        case .destructure:
            self = .destructure(
                node: try container.decode(Int.self, forKey: .nodeIndex),
                field: try container.decode(Int.self, forKey: .fieldIndex)
            )
        case .match:
            self = .match(
                node: try container.decode(Int.self, forKey: .nodeIndex),
                case: try container.decode(Int.self, forKey: .caseIndex),
                field: try container.decode(Int.self, forKey: .fieldIndex)
            )
        case .construct:
            self = .construct(
                node: try container.decode(Int.self, forKey: .nodeIndex),
                field: try container.decode(Int.self, forKey: .fieldIndex)
            )
        case .caseConstruct:
            self = .caseConstruct(
                node: try container.decode(Int.self, forKey: .nodeIndex),
                field: try container.decode(Int.self, forKey: .fieldIndex)
            )
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .index(let node):
            try container.encode(Case.index, forKey: .case)
            try container.encode(node, forKey: .nodeIndex)
        case .destructure(let node, let field):
            try container.encode(Case.destructure, forKey: .case)
            try container.encode(node, forKey: .nodeIndex)
            try container.encode(field, forKey: .fieldIndex)
        case .match(let node, let `case`, let field):
            try container.encode(Case.match, forKey: .case)
            try container.encode(node, forKey: .nodeIndex)
            try container.encode(`case`, forKey: .caseIndex)
            try container.encode(field, forKey: .fieldIndex)
        case .construct(let node, field: let field):
            try container.encode(Case.construct, forKey: .case)
            try container.encode(node, forKey: .nodeIndex)
            try container.encode(field, forKey: .fieldIndex)
        case .caseConstruct(let node, let field):
            try container.encode(Case.caseConstruct, forKey: .case)
            try container.encode(node, forKey: .nodeIndex)
            try container.encode(field, forKey: .fieldIndex)
        }
    }
}
