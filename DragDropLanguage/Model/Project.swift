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
    func lookup(function definition: Definition) -> Function? {
        if let package = definition.package {
            return packages.first(where: { $0.name == package })?.lookup(function: definition)
        }
        return rootModule.lookup(function: definition)
    }

    func lookup(type definition: Definition) -> Type? {
        if let package = definition.package {
            return packages.first(where: { $0.name == package })?.lookup(type: definition)
        }
        return rootModule.lookup(type: definition)
    }
}
