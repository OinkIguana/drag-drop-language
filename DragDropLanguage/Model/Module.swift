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
    func lookup(function definition: Definition) throws -> Function {
        if let root = definition.root {
            guard let module = submodules.first(where: { $0.name == root }) else {
                throw UndefinedFunctionError(definition: definition)
            }
            return try module.lookup(function: definition.childModule)
        } else {
            guard let function = functions.first(where: { $0.name == definition.name }) else {
                throw UndefinedFunctionError(definition: definition)
            }
            return function
        }
    }

    func lookup(type definition: Definition) throws -> Type {
        if let root = definition.root {
            guard let module = submodules.first(where: { $0.name == root }) else {
                throw UndefinedTypeError(definition: definition)
            }
            return try module.lookup(type: definition.childModule)
        } else {
            guard let type = types.first(where: { $0.name == definition.name }) else {
                throw UndefinedTypeError(definition: definition)
            }
            return type
        }
    }
}
