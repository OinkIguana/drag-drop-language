//
//  Box.swift
//  DragDropLanguage
//
//  Created by Cameron Eldridge on 2018-09-07.
//  Copyright © 2018 Cameron Eldridge. All rights reserved.
//

final class Box<T: Codable>: Codable {
    let value: T

    init(value: T) {
        self.value = value
    }
}

// MARK: - Equatable

extension Box: Equatable where T: Equatable {
    static func == (lhs: Box<T>, rhs: Box<T>) -> Bool {
        return lhs.value == rhs.value
    }
}

// MARK: - Comparable

extension Box: Comparable where T: Comparable {
    static func < (lhs: Box<T>, rhs: Box<T>) -> Bool {
        return lhs.value < rhs.value
    }
}

// MARK: - Hashable

extension Box: Hashable where T: Hashable {
    var hashValue: Int {
        return value.hashValue
    }
}
