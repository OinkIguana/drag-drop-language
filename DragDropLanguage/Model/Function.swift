//
//  Function.swift
//  DragDropLanguage
//
//  Created by Cameron Eldridge on 2018-09-07.
//  Copyright © 2018 Cameron Eldridge. All rights reserved.
//

import Foundation

struct Function: Codable, Equatable {
    private let id: UUID
    let name: String
    let type: FunctionType
    let source: Executable

    init(name: String, type: FunctionType, source: Executable) {
        self.id = UUID()
        self.name = name
        self.type = type
        self.source = source
    }

    /// A unique name for this function, which must be a valid identifier name in the backing language
    var uniqueName: String {
        return "F__" + id.uuidString.replacingOccurrences(of: "-", with: "_")
    }

    static func == (lhs: Function, rhs: Function) -> Bool {
        return lhs.id == rhs.id
    }
}
