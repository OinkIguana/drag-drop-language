//
//  Struct.swift
//  DragDropLanguage
//
//  Created by Cameron Eldridge on 2018-09-07.
//  Copyright © 2018 Cameron Eldridge. All rights reserved.
//

import Foundation

struct Struct: Codable, Equatable {
    private let id: UUID
    let name: String
    let fields: [StructField]

    init(name: String, fields: [StructField]) {
        self.id = UUID()
        self.name = name
        self.fields = fields
    }

    /// A unique name for this type, which must be a valid identifier name in the backing language
    var uniqueName: String {
        return "S__" + id.uuidString.replacingOccurrences(of: "-", with: "_")
    }

    static func == (lhs: Struct, rhs: Struct) -> Bool {
        return lhs.id == rhs.id
    }
}
