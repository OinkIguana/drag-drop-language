//
//  Stdlib.swift
//  DragDropLanguage
//
//  Created by Cameron Eldridge on 2018-10-12.
//  Copyright © 2018 Cameron Eldridge. All rights reserved.
//

private let operation = Struct(
    name: "Operation",
    fields: [
        StructField(name: "lhs", type: .primitive(.int)),
        StructField(name: "rhs", type: .primitive(.int))
    ]
)

private let math = Module(
    name: "Math",
    types: [.struct(operation)],
    functions: [
        Function(
            name: "+",
            type: FunctionType(input: .struct(operation), output: .primitive(.int)),
            source: .script(Script(source: "return input.lhs + input.rhs"))
        )
    ],
    submodules: []
)

let stdlib = Package(
    name: "std",
    definitions: Module(
        name: "std",
        types: [],
        functions: [],
        submodules: [math]
    )
)
