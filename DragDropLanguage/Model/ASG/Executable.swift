//
//  Executable.swift
//  DragDropLanguage
//
//  Created by Cameron Eldridge on 2018-09-07.
//  Copyright © 2018 Cameron Eldridge. All rights reserved.
//

enum Executable: Codable {
    case script(Script)
    case program(Program)

    private enum Case: String, Codable {
        case script
        case program
    }

    private enum CodingKeys: String, CodingKey {
        case `case`
        case value
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        switch try container.decode(Case.self, forKey: .case) {
        case .script:
            self = .script(try container.decode(Script.self, forKey: .value))
        case .program:
            self = .program(try container.decode(Program.self, forKey: .value))
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .script(let script):
            try container.encode(Case.script, forKey: .case)
            try container.encode(script, forKey: .value)
        case .program(let program):
            try container.encode(Case.program, forKey: .case)
            try container.encode(program, forKey: .value)
        }
    }
}
