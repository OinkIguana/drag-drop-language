//
//  Module.swift
//  DragDropLanguage
//
//  Created by Cameron Eldridge on 2018-09-07.
//  Copyright © 2018 Cameron Eldridge. All rights reserved.
//

struct Module: Codable {
    let name: String
    let types: [Type]
    let functions: [Function]
    let submodules: [Module]
}

extension Module {
    func lookup(function definition: Definition) -> Function? {
        if let root = definition.root {
            return submodules.first(where: { $0.name == root })?.lookup(function: definition)
        } else {
            return functions.first(where: { $0.name == definition.name })
        }
    }

    func lookup(type definition: Definition) -> Type? {
        if let root = definition.root {
            return submodules.first(where: { $0.name == root })?.lookup(type: definition)
        } else {
            return types.first(where: { $0.name == definition.name })
        }
    }
}
