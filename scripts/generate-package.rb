require "tomlrb"

PACKAGE_META = "package.toml"
MODULE_META = "module.toml"
FUNCTION_FILE = ".wren"
STRUCT_KIND = "struct"
ENUM_KIND = "enum"

def quote str
  "\"#{str}\""
end

def indent ind, str
  str.split("\n").map { |s| ind + s }.join "\n"
end

module Node
  def name
    @schema["name"]
  end

  def module_path
    @parent.module_path
  end

  def package_name
    @parent.package_name
  end

  def dir
    @parent.dir
  end
end

class Type
  include Node
  def initialize parent, schema
    @parent = parent
    schema = { "name" => schema } if schema.is_a? String
    @schema = schema
  end

  def print_definition
    ".definition(Definition(package: #{quote self.package_name}, modulePath: [#{self.module_path.map { |x| quote x }.join ","}], name: #{quote self.name}))"
  end

  def print_primitive
    ".primitive(.#{self.name})"
  end

  def print
    case @schema["kind"]
    when "enum", "struct", nil
      self.print_definition
    when "primitive"
      self.print_primitive
    end
  end
end

class StructField
  include Node
  def initialize parent, schema
    @parent = parent
    @schema = schema
  end

  def type
    Type.new self, @schema["type"]
  end

  def print
    <<-SWIFT
StructField(name: #{quote self.name}, type: #{self.type.print})
    SWIFT
  end
end

class EnumCase
  include Node
  def initialize parent, schema
    @parent = parent
    @schema = schema
  end

  def type
    Type.new self, field["type"]
  end

  def print
    <<-SWIFT
EnumCase(name: #{quote self.name}, type: #{self.type.print})
    SWIFT
  end
end

class Typedef
  include Node
  def initialize parent, schema
    @parent = parent
    @schema = schema
  end

  def fields
    @schema["fields"].map { |field| StructField.new self, field }
  end

  def cases
    @schema["cases"].map { |field| EnumCase.new self, field }
  end

  def print_struct
    <<-SWIFT
.struct(Struct(
  name: #{quote self.name},
  fields: [
#{self.fields.map { |field| indent "    ", field.print }.join ",\n"}
  ]
))
    SWIFT
  end

  def print_enum
    <<-SWIFT
.enum(Enum(
  name: #{quote self.name},
  cases: [
#{self.cases.map { |field| indent "    ", field.print }.join ",\n"}
  ]
))
    SWIFT
  end

  def print
    case @schema["kind"]
    when "struct"
      self.print_struct
    when "enum"
      self.print_enum
    end
  end
end

class Function
  include Node
  attr_reader :source

  def initialize parent, schema
    @schema = schema
    @parent = parent
    @source = File.read "#{parent.dir}/#{self.name}#{FUNCTION_FILE}"
  end

  def input
    Type.new self, @schema["input"]
  end

  def output
    Type.new self, @schema["output"]
  end

  def type
    "FunctionType(input: #{self.input.print}, output: #{self.output.print})"
  end

  def print
    <<-SWIFT
Function(
  name: #{quote self.name},
  type: #{self.type},
  source: .script(Script(source: """
#{indent "  ", self.source }
  """))
)
    SWIFT
  end
end

class Module
  include Node
  def initialize parent, dir_name
    schema = Tomlrb.load_file "#{parent.dir}/#{dir_name}/#{MODULE_META}"
    @dir_name = dir_name
    @parent = parent
    @schema = schema["module"]
  end

  def name
    @schema["name"]
  end

  def module_path
    [*@parent.module_path, self.name]
  end

  def dir
    "#{@parent.dir}/#{@dir_name}"
  end

  def types
    (@schema["types"] || []).map { |type| Typedef.new self, type }
  end

  def functions
    (@schema["functions"] || []).map { |func| Function.new self, func }
  end

  def submodules
    (@schema["modules"] || []).map { |mod| Module.new self, mod }
  end

  def print
    <<-SWIFT
Module(
  name: #{quote self.name},
  types: [
#{self.types.map { |type| indent "    ", type.print }.join ",\n"}
  ],
  functions: [
#{self.functions.map { |func| indent "    ", func.print }.join ",\n"}
  ],
  submodules: [
#{self.submodules.map { |mod| indent "    ", mod.print }.join ",\n"}
  ]
)
    SWIFT
  end
end

class Package
  include Node
  attr_reader :dir
  alias package_name name

  def initialize dir
    schema = Tomlrb.load_file "#{dir}/#{PACKAGE_META}"
    @dir = dir
    @schema = schema["package"]
  end

  def module_path
    []
  end

  def modules
    @schema["modules"].map { |mod| Module.new self, mod }
  end

  def print
    <<-SWIFT
let package = Package(
  name: #{quote self.name},
  definitions: Module(
    name: #{quote self.name},
    types: [],
    functions: [],
    submodules: [
#{self.modules.map { |mod| indent "      ", mod.print }.join ",\n"}
    ]
  )
)
    SWIFT
  end
end

def compile package_dir
  Package.new(package_dir).print
end
