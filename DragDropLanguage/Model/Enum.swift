//
//  Enum.swift
//  DragDropLanguage
//
//  Created by Cameron Eldridge on 2018-09-07.
//  Copyright © 2018 Cameron Eldridge. All rights reserved.
//

import Foundation

struct Enum: Codable, Equatable {
    private let id: UUID
    let name: String
    let cases: [EnumCase]

    init(name: String, cases: [EnumCase]) {
        self.id = UUID()
        self.name = name
        self.cases = cases
    }

    /// A unique name for this type, which must be a valid identifier name in the backing language
    var uniqueName: String {
        return "E__" + id.uuidString.replacingOccurrences(of: "-", with: "_")
    }

    static func == (lhs: Enum, rhs: Enum) -> Bool {
        return lhs.id == rhs.id
    }
}
