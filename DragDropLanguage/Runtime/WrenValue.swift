//
//  WrenValue.swift
//  DragDropLanguage
//
//  Created by Cameron Eldridge on 2018-09-25.
//  Copyright © 2018 Cameron Eldridge. All rights reserved.
//

enum WrenValue: Equatable {
    case double(Double)
    case int(Int)
    case bool(Bool)
    case string(String)
    case list([WrenValue])
    case handle(WrenHandle)
    case foreign
    case null

    static func == (lhs: WrenValue, rhs: WrenValue) -> Bool {
        switch (lhs, rhs) {
        case (.double(let x), .double(let y)): return x == y
        case (.int(let x), .int(let y)): return x == y
        case (.bool(let x), .bool(let y)): return x == y
        case (.string(let x), .string(let y)): return x == y
        case (.list(let x), .list(let y)): return x == y
        case (.null, .null): return true
        case (.handle, .handle): return false
        case (.foreign, .foreign): return false
        default: return false
        }
    }
}
