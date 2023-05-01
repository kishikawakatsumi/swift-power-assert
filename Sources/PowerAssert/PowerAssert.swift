import StringWidth
#if canImport(XCTest)
import XCTest
#endif

public enum PowerAssert {
  public class Assertion {
    private let assertion: String
    private let originalMessage: String
    private let filePath: StaticString
    private let lineNumber: UInt
    private let verbose: Bool
    private let binaryExpressions: [Int: String]

    private var result: Bool = true
    private var values = [Value]()
    private var errors = [Swift.Error]()
    private var binaryExpressionValues = [BinaryExpressionValue]()

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
        let diagram = renderDiagram()
        let comparison = [renderComparison(), renderSkipped()]
          .filter { !$0.isEmpty }
          .joined(separator: "\n")
        let message: String
        if comparison.isEmpty {
          message = diagram
        } else {
          message = "\(diagram)\n\(comparison)\n"
        }

        if !result {
#if canImport(XCTest)
          XCTFail("\(originalMessage)\n\(Console.apply([.color(.red)], to: message))", file: filePath, line: lineNumber)
#else
          Console.output(message, .color(.red))
#endif
        } else if verbose {
          Console.output(message, .color(.red))
        }
      }
    }

    private func store<T>(value: T, column: Int, id: Int) {
      values.append(Value(stringify(value), column: column))
      if let expr = binaryExpressions[id] {
        binaryExpressionValues.append(
          BinaryExpressionValue(id: id, value: value, expression: expr)
        )
      }
    }

    private func renderDiagram() -> String {
      func align(_ message: inout String, current: inout Int, column: Int, string: String) {
        while current < column {
          message += " "
          current += 1
        }
        message += string
        current += stringWidth(string)
      }

      var message = ""
      message += "\(assertion)\n"
      values.sort()
      var current = 0
      for value in values {
        align(&message, current: &current, column: value.column, string: "│")
      }
      message += "\n"

      while !values.isEmpty {
        var current = 0
        var index = 0
        while index < values.count {
          if index == values.count - 1 || ((values[index].column + values[index].value.count < values[index + 1].column) && values[index].value.unicodeScalars.filter({ !$0.isASCII }).isEmpty) {
            align(&message, current: &current, column: values[index].column, string: values[index].value)
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

    private func renderComparison() -> String {
      var message = ""
      if !binaryExpressionValues.isEmpty {
        message += binaryExpressionValues
          .map { "[\(type(of: $0.value))] \($0.expression)\n=> \(stringify($0.value))" }
          .joined(separator: "\n")
      }
      return message
    }

    private func renderSkipped() -> String {
      var message = ""
      let skipped = binaryExpressions
        .filter { !binaryExpressionValues.map { $0.id }.contains($0.key) }
        .sorted { $0.key < $1.key }
        .map { $0.value }
      if !skipped.isEmpty {
        message += skipped.map { "[Not Evaluated] \($0)" }.joined(separator: "\n")
      }
      return message
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

  private struct BinaryExpressionValue {
    let id: Int
    let value: Any
    let expression: String
  }

  static private func escapeString(_ s: String) -> String {
    return s
      .replacingOccurrences(of: "\"", with: "\\\"")
      .replacingOccurrences(of: "\t", with: "\\t")
      .replacingOccurrences(of: "\r", with: "\\r")
      .replacingOccurrences(of: "\n", with: "\\n")
      .replacingOccurrences(of: "\0", with: "\\0")
  }

  static private func stringify<T>(_ value: T?) -> String {
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
}
