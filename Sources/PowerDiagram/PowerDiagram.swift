import class Foundation.FileHandle
import StringWidth
import struct Foundation.Selector

public struct PowerDiagram {
  public struct Label: Comparable {
    public let value: String
    public let column: Int

    public init(value: String, column: Int) {
      self.value = value
      self.column = column
    }

    static public func == (lhs: Self, rhs: Self) -> Bool {
      lhs.column == rhs.column
    }

    static public func < (lhs: Self, rhs: Self) -> Bool {
      lhs.column < rhs.column
    }
  }

  private let assertion: String
  private let values: [Label]

  public init(assertion: String, values: [Label] ) {
    self.assertion = assertion
    self.values = values
  }

  public func render() -> String {
    var values = self.values.sorted()

    var message = "\(assertion)\n"
    var current = 0
    for value in values {
      align(&message, current: &current, column: value.column, string: "│")
    }
    message += "\n"

    while !values.isEmpty {
      var current = 0
      var index = 0
      while index < values.count {
        if index == values.count - 1
            || ((values[index].column + stringWidth(values[index].value) < values[index + 1].column)
                && values[index].value.unicodeScalars.filter({ !$0.isASCII }).isEmpty)
        {
          let value = values[index].value
          align(&message, current: &current, column: values[index].column, string: value)
          values.remove(at: index)
        } else {
          align(&message, current: &current, column: values[index].column, string: "│")
          index += 1
        }
      }
      message += "\n"
    }

    return message
  }

  private func align(_ message: inout String, current: inout Int, column: Int, string: String) {
    while current < column {
      message += " "
      current += 1
    }
    message += string
    current += stringWidth(string)
  }
}
