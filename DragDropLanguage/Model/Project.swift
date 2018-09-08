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

    let modules: [Module]
    let main: Function
}