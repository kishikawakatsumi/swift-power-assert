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

  private let mainLine: String
  private let labels: [Label]

  public init(mainLine: String, labels: [Label] ) {
    self.mainLine = mainLine
    self.labels = labels
  }

  public func render() -> String {
    var labels = self.labels.sorted()

    var message = "\(mainLine)\n"
    renderFirstLine(for: labels, into: &message)

    while !labels.isEmpty {
      var current = 0
      var index = 0
      while index < labels.count {
        if index == labels.count - 1
            || ((labels[index].column + stringWidth(labels[index].value) < labels[index + 1].column)
                && labels[index].value.unicodeScalars.allSatisfy(\.isASCII))
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

  private func renderFirstLine(for labels: [Label], into message: inout String) {
    var current = 0
    for label in labels {
      align(&message, current: &current, column: label.column, string: "│")
    }
    message += "\n"
  }

  private func align(_ message: inout String, current: inout Int, column: Int, string: String) {
    let spacingWidth = max(0, column - current)
    message += String(repeating: " ", count: spacingWidth) + string
    current += spacingWidth + stringWidth(string)
  }
}
