let package = Package(
  name: "Core",
  definitions: Module(
    name: "Core",
    types: [],
    functions: [],
    submodules: [
      Module(
        name: "Int",
        types: [
          .struct(Struct(
            name: "Operator",
            fields: [
              StructField(name: "lhs", type: .primitive(.int)),
              StructField(name: "rhs", type: .primitive(.int))
            ]
          )),
          .struct(Struct(
            name: "ToString",
            fields: [
              StructField(name: "value", type: .primitive(.int)),
              StructField(name: "base", type: .primitive(.int))
            ]
          ))
        ],
        functions: [
          Function(
            name: "+",
            type: FunctionType(input: .definition(Definition(package: "Core", modulePath: ["Int"], name: "Operator")), output: .primitive(.int)),
            source: .script(Script(source: """
            return input.lhs + input.rhs
            """))
          ),
          Function(
            name: "-",
            type: FunctionType(input: .definition(Definition(package: "Core", modulePath: ["Int"], name: "Operator")), output: .primitive(.int)),
            source: .script(Script(source: """
            return input.lhs - input.rhs
            """))
          ),
          Function(
            name: "*",
            type: FunctionType(input: .definition(Definition(package: "Core", modulePath: ["Int"], name: "Operator")), output: .primitive(.int)),
            source: .script(Script(source: """
            return input.lhs * input.rhs
            """))
          ),
          Function(
            name: "÷",
            type: FunctionType(input: .definition(Definition(package: "Core", modulePath: ["Int"], name: "Operator")), output: .primitive(.int)),
            source: .script(Script(source: """
            return input.lhs / input.rhs
            """))
          ),
          Function(
            name: "%",
            type: FunctionType(input: .definition(Definition(package: "Core", modulePath: ["Int"], name: "Operator")), output: .primitive(.int)),
            source: .script(Script(source: """
            return input.lhs % input.rhs
            """))
          ),
          Function(
            name: "pow",
            type: FunctionType(input: .definition(Definition(package: "Core", modulePath: ["Int"], name: "Operator")), output: .primitive(.int)),
            source: .script(Script(source: """
            return input.lhs.pow(input.rhs)
            """))
          ),
          Function(
            name: "negate",
            type: FunctionType(input: .primitive(.int), output: .primitive(.int)),
            source: .script(Script(source: """
            return -input
            """))
          ),
          Function(
            name: "abs",
            type: FunctionType(input: .primitive(.int), output: .primitive(.int)),
            source: .script(Script(source: """
            return input.abs
            """))
          ),
          Function(
            name: "==",
            type: FunctionType(input: .definition(Definition(package: "Core", modulePath: ["Int"], name: "Operator")), output: .primitive(.bool)),
            source: .script(Script(source: """
            return input.lhs == input.rhs
            """))
          ),
          Function(
            name: "!=",
            type: FunctionType(input: .definition(Definition(package: "Core", modulePath: ["Int"], name: "Operator")), output: .primitive(.bool)),
            source: .script(Script(source: """
            return input.lhs != input.rhs
            """))
          ),
          Function(
            name: "<",
            type: FunctionType(input: .definition(Definition(package: "Core", modulePath: ["Int"], name: "Operator")), output: .primitive(.bool)),
            source: .script(Script(source: """
            return input.lhs < input.rhs
            """))
          ),
          Function(
            name: ">",
            type: FunctionType(input: .definition(Definition(package: "Core", modulePath: ["Int"], name: "Operator")), output: .primitive(.bool)),
            source: .script(Script(source: """
            return input.lhs > input.rhs
            """))
          ),
          Function(
            name: "≥",
            type: FunctionType(input: .definition(Definition(package: "Core", modulePath: ["Int"], name: "Operator")), output: .primitive(.bool)),
            source: .script(Script(source: """
            return input.lhs >= input.rhs
            """))
          ),
          Function(
            name: "≤",
            type: FunctionType(input: .definition(Definition(package: "Core", modulePath: ["Int"], name: "Operator")), output: .primitive(.bool)),
            source: .script(Script(source: """
            return input.lhs <= input.rhs
            """))
          ),
          Function(
            name: "as_double",
            type: FunctionType(input: .primitive(.int), output: .primitive(.double)),
            source: .script(Script(source: """
            return input
            """))
          ),
          Function(
            name: "as_bool",
            type: FunctionType(input: .primitive(.int), output: .primitive(.bool)),
            source: .script(Script(source: """
            return input != 0
            """))
          ),
          Function(
            name: "to_string",
            type: FunctionType(input: .definition(Definition(package: "Core", modulePath: ["Int"], name: "ToString")), output: .primitive(.string)),
            source: .script(Script(source: """
            var stringFor = Fn.new { |digit|
              if (digit < 10) {
                return digit.toString
              } else if (digit < 36) {
                return String.fromCodePoint(55 + digit)
              } else {
                Fiber.abort("Cannot convert a number to a string in bases above 36")
              }
            }
            
            var value = input.value
            var base = input.base
            
            if (base == 10) {
              return value.toString
            } else {
              var output = ""
              while (value != 0) {
                var digit = value % base
                output = output + stringFor.call(digit)
                value = (value - digit) / base
              }
              return output
            }
            """))
          ),
          Function(
            name: "as_char",
            type: FunctionType(input: .primitive(.int), output: .primitive(.char)),
            source: .script(Script(source: """
            return String.fromCodePoint(input)
            """))
          ),
          Function(
            name: "identity",
            type: FunctionType(input: .primitive(.int), output: .primitive(.int)),
            source: .script(Script(source: """
            return input
            """))
          )
        ],
        submodules: [
      
        ]
      ),
      Module(
        name: "Bool",
        types: [
          .struct(Struct(
            name: "Operator",
            fields: [
              StructField(name: "lhs", type: .primitive(.bool)),
              StructField(name: "rhs", type: .primitive(.bool))
            ]
          ))
        ],
        functions: [
          Function(
            name: "and",
            type: FunctionType(input: .definition(Definition(package: "Core", modulePath: ["Bool"], name: "Operator")), output: .primitive(.bool)),
            source: .script(Script(source: """
            return input.lhs && input.rhs
            """))
          ),
          Function(
            name: "or",
            type: FunctionType(input: .definition(Definition(package: "Core", modulePath: ["Bool"], name: "Operator")), output: .primitive(.bool)),
            source: .script(Script(source: """
            return input.lhs || input.rhs
            """))
          ),
          Function(
            name: "xor",
            type: FunctionType(input: .definition(Definition(package: "Core", modulePath: ["Bool"], name: "Operator")), output: .primitive(.bool)),
            source: .script(Script(source: """
            return (input.lhs && !input.rhs) || (input.rhs && !input.lhs)
            """))
          ),
          Function(
            name: "not",
            type: FunctionType(input: .primitive(.bool), output: .primitive(.bool)),
            source: .script(Script(source: """
            return !input
            """))
          ),
          Function(
            name: "identity",
            type: FunctionType(input: .primitive(.bool), output: .primitive(.bool)),
            source: .script(Script(source: """
            return input
            """))
          ),
          Function(
            name: "as_int",
            type: FunctionType(input: .primitive(.bool), output: .primitive(.int)),
            source: .script(Script(source: """
            return input ? 1 : 0
            """))
          ),
          Function(
            name: "as_double",
            type: FunctionType(input: .primitive(.bool), output: .primitive(.double)),
            source: .script(Script(source: """
            return input ? 1 : 0
            """))
          ),
          Function(
            name: "as_string",
            type: FunctionType(input: .primitive(.bool), output: .primitive(.string)),
            source: .script(Script(source: """
            return input.toString
            """))
          )
        ],
        submodules: [
      
        ]
      )
    ]
  )
)
