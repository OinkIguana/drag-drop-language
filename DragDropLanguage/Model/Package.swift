//
//  Package.swift
//  DragDropLanguage
//
//  Created by Cameron Eldridge on 2018-09-15.
//  Copyright © 2018 Cameron Eldridge. All rights reserved.
//

struct Package: Codable {
    let name: String
    let definitions: Module
}

extension Package {
    func lookup(function definition: Definition) throws -> Function {
        return try definitions.lookup(function: definition)
    }

    func lookup(type definition: Definition) throws -> Type {
        return try definitions.lookup(type: definition)
    }
}
