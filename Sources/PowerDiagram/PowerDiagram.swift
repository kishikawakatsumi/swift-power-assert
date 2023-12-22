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
  private let labels: [Label]

  public init(assertion: String, labels: [Label] ) {
    self.assertion = assertion
    self.labels = labels
  }

  public func render() -> String {
    var labels = self.labels.sorted()

    var message = "\(assertion)\n"
    var current = 0
    for label in labels {
      align(&message, current: &current, column: label.column, string: "│")
    }
    message += "\n"

    while !labels.isEmpty {
      var current = 0
      var index = 0
      while index < labels.count {
        if index == labels.count - 1
            || ((labels[index].column + stringWidth(labels[index].value) < labels[index + 1].column)
                && labels[index].value.unicodeScalars.filter({ !$0.isASCII }).isEmpty)
        {
          align(&message, current: &current, column: labels[index].column, string: labels[index].value)
          labels.remove(at: index)
        } else {
          align(&message, current: &current, column: labels[index].column, string: "│")
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
