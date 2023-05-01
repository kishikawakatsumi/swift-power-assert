import StringWidth
#if canImport(XCTest)
import XCTest
#endif

public enum PowerAssert {
  public class Assertion {
    let assertion: String
    let originalMessage: String
    let filePath: StaticString
    let lineNumber: UInt
    let verbose: Bool
    var binaryExpressions: [Int: String]

    var result: Bool = true
    var values = [Value]()
    var errors = [Swift.Error]()
    var binaryExpressionValues = [(String, Any)]()

    public init(
      _ assertion: String,
      message: String = "",
      file: StaticString,
      line: UInt,
      verbose: Bool = false,
      binaryExpressions: [Int: String],
      evaluate: (Assertion) throws -> Bool = { _ in true }
    ) {
      self.assertion = assertion
      self.originalMessage = message
      self.filePath = file
      self.lineNumber = line
      self.verbose = verbose
      self.binaryExpressions = binaryExpressions
      do {
        self.result = try evaluate(self)
      } catch {
        errors.append(error)
      }
    }

    public func capture<T>(_ expr: @autoclosure () throws -> T, column: Int, id: Int) rethrows -> T {
      let val = try expr()
      store(value: val, column: column, id: id)
      return val
    }

    public func capture<T>(_ expr: @autoclosure () throws -> [T], column: Int, id: Int) rethrows -> [T] {
      let val = try expr()
      store(value: val, column: column, id: id)
      return val
    }

    public func capture<T>(_ expr: @autoclosure () throws -> T?, column: Int, id: Int) rethrows -> T? {
      let val = try expr()
      store(value: val, column: column, id: id)
      return val
    }

    public func capture(_ expr: @autoclosure () throws -> Float, column: Int, id: Int) rethrows -> Float {
      let val = try expr()
      store(value: val, column: column, id: id)
      return val
    }

    public func capture(_ expr: @autoclosure () throws -> Double, column: Int, id: Int) rethrows -> Double {
      let val = try expr()
      store(value: val, column: column, id: id)
      return val
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
          Console.output(message, .color(.red))
          if !binaryExpressionValues.isEmpty {
            Console.output(
              binaryExpressionValues.map { "[\(type(of: $0.1))] \($0.0)\n=> \(valueToString($0.1))" }.joined(separator: "\n"), .color(.red)
            )
            Console.output()
          }
#endif
        } else if verbose {
          Console.output(message, .color(.red))
          if !binaryExpressionValues.isEmpty {
            Console.output(
              binaryExpressionValues.map { "[\(type(of: $0.1))] \($0.0)\n=> \(valueToString($0.1))" }.joined(separator: "\n"), .color(.red)
            )
            Console.output()
          }
        }
      }
    }

    private func store<T>(value: T, column: Int, id: Int) {
      values.append(Value(valueToString(value), column: column))
      if let expr = binaryExpressions[id] {
        binaryExpressionValues.append((expr, value))
      }
    }
  }

  struct Value: Comparable {
    let value: String
    let column: Int

    init(_ value: String, column: Int) {
      self.value = value
      self.column = column
    }

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
