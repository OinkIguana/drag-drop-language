//
//  Program.swift
//  DragDropLanguage
//
//  Created by Cameron Eldridge on 2018-09-15.
//  Copyright © 2018 Cameron Eldridge. All rights reserved.
//

struct Program: Codable {
    let nodes: [Node]
    let edges: [Edge]
}

extension Program {
    /// Returns the input node, if one exists
    var root: Node? {
        return nodes
            .first {
                if case .input = $0.kind {
                    return true
                } else {
                    return false
                }
            }
    }

    var returns: [Node] {
        return nodes
            .filter {
                if case .output = $0.kind {
                    return true
                } else {
                    return false
                }
            }
    }

    func node(at path: NodePath) -> Node? {
        switch path {
        case .node(let id),
             .construct(let id, _),
             .destructure(let id, _),
             .match(let id, _),
             .caseConstruct(let id, _):
            return nodes.first { $0.id == id }
        }
    }

    /// Returns the immediate inputs of a given node
    func predecessors(of node: Node) -> [NodePath] {
        return edges
            .filter { edge in edge.output.id == node.id }
            .map { edge in edge.input }
            .sorted { lhs, rhs in
                switch (lhs, rhs) {
                case (.construct(_, let a), .construct(_, let b)):
                    return a < b
                default:
                    return true
                }
            }
    }

    /// Returns the immediate outputs of a given node
    func successors(of node: Node) -> [NodePath] {
        return edges
            .filter { edge in edge.input.id == node.id }
            .map { edge in edge.output }
            .sorted { lhs, rhs in
                switch (lhs, rhs) {
                case (.destructure(_, let a), .destructure(_, let b)):
                    return a < b
                default:
                    return true
                }
            }
    }
}
