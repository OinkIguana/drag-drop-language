//
//  Definition.swift
//  DragDropLanguage
//
//  Created by Cameron Eldridge on 2018-09-08.
//  Copyright © 2018 Cameron Eldridge. All rights reserved.
//

struct Definition: Codable, Hashable, Equatable {
    static let main = Definition(package: nil, modulePath: [], name: "main")

    let package: String?
    let modulePath: [String]
    let name: String
}

extension Definition {
    var root: String? {
        return modulePath.first
    }
}
