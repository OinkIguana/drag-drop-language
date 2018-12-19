require_relative './generate-package'

def input name
  "Lib/#{name}"
end

def output name
  "DragDropLanguage/Lib/#{name}.swift"
end

def save file, code
  File.open file, "w" do |f|
    f.write code
  end
end

['Core'].each do |package|
  compiled = compile input package
  save output(package), compiled
end
