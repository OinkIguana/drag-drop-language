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
