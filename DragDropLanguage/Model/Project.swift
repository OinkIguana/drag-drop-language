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
                throw UndefinedFunctionError()
            }
            return try package.lookup(function: definition)
        }
        return try rootModule.lookup(function: definition)
    }

    func lookup(type definition: Definition) throws -> Type {
        if let package = definition.package {
            guard let package = packages.first(where: { $0.name == package }) else {
                throw UndefinedTypeError()
            }
            return try package.lookup(type: definition)
        }
        return try rootModule.lookup(type: definition)
    }
}
