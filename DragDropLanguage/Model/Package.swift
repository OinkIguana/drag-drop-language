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
    func lookup(function definition: Definition) -> Function? {
        return definitions.lookup(function: definition)
    }

    func lookup(type definition: Definition) -> Type? {
        return definitions.lookup(type: definition)
    }
}
