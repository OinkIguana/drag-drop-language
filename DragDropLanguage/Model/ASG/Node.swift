//
//  Node.swift
//  DragDropLanguage
//
//  Created by Cameron Eldridge on 2018-09-08.
//  Copyright © 2018 Cameron Eldridge. All rights reserved.
//

import Foundation

struct NodeID: Codable, Equatable, Hashable {
    let id: UUID
}

struct Node: Codable, Equatable {
    let id: NodeID
    let kind: NodeKind

    static func == (_ lhs: Node, _ rhs: Node) -> Bool {
        return lhs.id == rhs.id
    }
}

enum NodeKind: Codable {
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
    case node(NodeID)
    case destructure(node: NodeID, field: Int)
    case match(node: NodeID, pattern: Pattern)
    case construct(node: NodeID, field: Int)
    case caseConstruct(node: NodeID, field: Int)

    var id: NodeID {
        switch self {
        case .node(let id),
             .destructure(let id, _),
             .match(let id, _),
             .construct(let id, _),
             .caseConstruct(let id, _):
            return id
        }
    }

    private enum Case: String, Codable {
        case node
        case destructure
        case match
        case construct
        case caseConstruct
    }

    private enum CodingKeys: String, CodingKey {
        case `case`
        case nodeID
        case fieldIndex
        case caseIndex
        case pattern
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        switch try container.decode(Case.self, forKey: .case) {
        case .node:
            self = .node(try container.decode(NodeID.self, forKey: .nodeID))
        case .destructure:
            self = .destructure(
                node: try container.decode(NodeID.self, forKey: .nodeID),
                field: try container.decode(Int.self, forKey: .fieldIndex)
            )
        case .match:
            self = .match(
                node: try container.decode(NodeID.self, forKey: .nodeID),
                pattern: try container.decode(Pattern.self, forKey: .pattern)
            )
        case .construct:
            self = .construct(
                node: try container.decode(NodeID.self, forKey: .nodeID),
                field: try container.decode(Int.self, forKey: .fieldIndex)
            )
        case .caseConstruct:
            self = .caseConstruct(
                node: try container.decode(NodeID.self, forKey: .nodeID),
                field: try container.decode(Int.self, forKey: .fieldIndex)
            )
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .node(let node):
            try container.encode(Case.node, forKey: .case)
            try container.encode(node, forKey: .nodeID)
        case .destructure(let node, let field):
            try container.encode(Case.destructure, forKey: .case)
            try container.encode(node, forKey: .nodeID)
            try container.encode(field, forKey: .fieldIndex)
        case .match(let node, let pattern):
            try container.encode(Case.match, forKey: .case)
            try container.encode(node, forKey: .nodeID)
            try container.encode(pattern, forKey: .pattern)
        case .construct(let node, field: let field):
            try container.encode(Case.construct, forKey: .case)
            try container.encode(node, forKey: .nodeID)
            try container.encode(field, forKey: .fieldIndex)
        case .caseConstruct(let node, let field):
            try container.encode(Case.caseConstruct, forKey: .case)
            try container.encode(node, forKey: .nodeID)
            try container.encode(field, forKey: .fieldIndex)
        }
    }
}
