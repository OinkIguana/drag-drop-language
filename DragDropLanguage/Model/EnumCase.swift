//
//  EnumCase.swift
//  DragDropLanguage
//
//  Created by Cameron Eldridge on 2018-09-07.
//  Copyright © 2018 Cameron Eldridge. All rights reserved.
//

struct EnumCase: Codable {
    let name: String
    let fields: [StructField]
}
