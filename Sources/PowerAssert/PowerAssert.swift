import StringWidth
#if canImport(XCTest)
import XCTest
#endif

public enum PowerAssert {
  public class Assertion {
    let assertion: String
    let filePath: StaticString
    let lineNumber: UInt
    let verbose: Bool
    var result: Bool = true
    let originalMessage: String
    var values = [Value]()
    var errors = [Swift.Error]()

    public init(_ assertion: String, message: String = "", file: StaticString, line: UInt, verbose: Bool = false, evaluate: (Assertion) -> Bool = { _ in true }) {
      self.assertion = assertion
      self.originalMessage = message
      self.filePath = file
      self.lineNumber = line
      self.verbose = verbose
      self.result = evaluate(self)
    }

    public func capture<T>(_ expr: @autoclosure () throws -> T, column: Int) rethrows -> T {
      let val = try expr()
      store(value: val, column: column)
      return val
    }

    public func capture<T>(_ expr: @autoclosure () throws -> [T], column: Int) rethrows -> [T] {
      let val = try expr()
      store(value: val, column: column)
      return val
    }

    public func capture<T>(_ expr: @autoclosure () throws -> T?, column: Int) rethrows -> T? {
      let val = try expr()
      store(value: val, column: column)
      return val
    }

    public func capture(_ expr: @autoclosure () throws -> Float, column: Int) rethrows -> Float {
      let val = try expr()
      store(value: val, column: column)
      return val
    }

    public func capture(_ expr: @autoclosure () throws -> Double, column: Int) rethrows -> Double {
      let val = try expr()
      store(value: val, column: column)
      return val
    }

    public func store<T>(value: T, column: Int) {
      values.append(Value(value: valueToString(value), column: column))
    }

    public func render() {
      if !result || verbose {
        var message = ""
        message += "\(assertion)\n"
        values.sort()
        var current = 0
        for value in values {
          PowerAssert.align(&message, current: &current, column: value.column, string: "|")
        }
        message += "\n"
        while !values.isEmpty {
          var current = 0
          var index = 0
          while index < values.count {
            if index == values.count - 1 || ((values[index].column + values[index].value.count < values[index + 1].column) && values[index].value.unicodeScalars.filter({ !$0.isASCII }).isEmpty) {
              PowerAssert.align(&message, current: &current, column: values[index].column, string: values[index].value)
              values.remove(at: index)
            } else {
              PowerAssert.align(&message, current: &current, column: values[index].column, string: "|")
              index += 1
            }
          }
          message += "\n"
        }
        if !result {
#if canImport(XCTest)
          XCTFail("\(originalMessage)\n" + message, file: filePath, line: lineNumber)
#else
          print(message, terminator: "")
#endif
        } else if verbose {
          print(message, terminator: "")
        }
      }
    }
  }

  struct Value: Comparable {
    let value: String
    let column: Int

    static func <(lhs: Value, rhs: Value) -> Bool {
      return lhs.column < rhs.column
    }

    static func ==(lhs: Value, rhs: Value) -> Bool {
      return lhs.column == rhs.column
    }
  }

  static private func escapeString(_ s: String) -> String {
    return s
      .replacingOccurrences(of: "\"", with: "\\\"")
      .replacingOccurrences(of: "\t", with: "\\t")
      .replacingOccurrences(of: "\r", with: "\\r")
      .replacingOccurrences(of: "\n", with: "\\n")
      .replacingOccurrences(of: "\0", with: "\\0")
  }

  static private func valueToString<T>(_ value: T?) -> String {
#if os(macOS)
    switch value {
    case .some(let v) where v is String || v is Selector: return "\"\(escapeString("\(v)"))\""
    case .some(let v): return "\(v)".replacingOccurrences(of: "\n", with: " ")
    case .none: return "nil"
    }
#else
    switch value {
    case .some(let v) where v is String: return "\"\(escapeString("\(v)"))\""
    case .some(let v): return "\(v)".replacingOccurrences(of: "\n", with: " ")
    case .none: return "nil"
    }
#endif
  }

  static private func align(_ message: inout String, current: inout Int, column: Int, string: String) {
    while current < column {
      message += " "
      current += 1
    }
    message += string
    current += stringWidth(string)
  }
}
