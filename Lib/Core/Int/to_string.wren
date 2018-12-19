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
