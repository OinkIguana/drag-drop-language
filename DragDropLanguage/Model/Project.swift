//
//  Project.swift
//  DragDropLanguage
//
//  Created by Cameron Eldridge on 2018-09-07.
//  Copyright © 2018 Cameron Eldridge. All rights reserved.
//

import Foundation

struct Project: Codable {
    let name: String
    let lastModified: Date

    let packages: [Package]
    let rootModule: Module

    let initialValue: Value
}

extension Project {
    func lookup(function definition: Definition) throws -> Function {
        if let package = definition.package {
            guard let package = packages.first(where: { $0.name == package }) else {
                throw UndefinedFunctionError(definition: definition)
            }
            do {
                return try package.lookup(function: definition)
            } catch is UndefinedFunctionError {
                throw UndefinedFunctionError(definition: definition)
            }
        }
        do {
            return try rootModule.lookup(function: definition)
        } catch is UndefinedFunctionError {
            throw UndefinedFunctionError(definition: definition)
        }
    }

    func lookup(type definition: Definition) throws -> Type {
        if let package = definition.package {
            guard let package = packages.first(where: { $0.name == package }) else {
                throw UndefinedTypeError(definition: definition)
            }
            do {
                return try package.lookup(type: definition)
            } catch is UndefinedTypeError {
                throw UndefinedTypeError(definition: definition)
            }
        }
        do {
            return try rootModule.lookup(type: definition)
        } catch is UndefinedTypeError {
            throw UndefinedTypeError(definition: definition)
        }
    }

    func resolve(type: Type) throws -> Type {
        guard case .definition(let definition) = type else {
            return type
        }
        return try lookup(type: definition)
    }
}
