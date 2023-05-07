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
    private let comparisons: [Int: String]

    private var result: Bool = true
    private var values = [Value]()
    private var errors = [Swift.Error]()
    private var comparisonValues = [ComparisonValue]()

    public init(
      _ assertion: String,
      message: String = "",
      file: StaticString,
      line: UInt,
      verbose: Bool = false,
      comparisons: [Int: String],
      evaluateSync: (Assertion) throws -> Bool = { _ in true }
    ) {
      self.assertion = assertion
      self.originalMessage = message
      self.filePath = file
      self.lineNumber = line
      self.verbose = verbose
      self.comparisons = comparisons
      do {
        self.result = try evaluateSync(self)
      } catch {
        errors.append(error)
      }
    }

    public init(
      _ assertion: String,
      message: String = "",
      file: StaticString,
      line: UInt,
      verbose: Bool = false,
      comparisons: [Int: String],
      evaluateAsync: (Assertion) async throws -> Bool = { _ in true }
    ) async {
      self.assertion = assertion
      self.originalMessage = message
      self.filePath = file
      self.lineNumber = line
      self.verbose = verbose
      self.comparisons = comparisons
      do {
        self.result = try await evaluateAsync(self)
      } catch {
        errors.append(error)
      }
    }

    public func captureSync<T>(_ expr: @autoclosure () throws -> T, column: Int, id: Int) rethrows -> T {
      let val = try expr()
      store(value: val, column: column, id: id)
      return val
    }

    public func captureAsync<T>(_ expr: @autoclosure () async throws -> T, column: Int, id: Int) async rethrows -> T {
      let val = try await expr()
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
#if PLAYGROUND
          message = "\(diagram) \n\(comparison) \n"
#else
          message = "\(diagram)\n\(comparison)\n"
#endif
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
      if let expr = comparisons[id] {
        comparisonValues.append(
          ComparisonValue(id: id, value: value, expression: expr)
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
      if !comparisonValues.isEmpty {
        message += comparisonValues
          .map { "[\(type(of: $0.value))] \($0.expression)\n=> \(stringify($0.value))" }
          .joined(separator: "\n")
      }
      return message
    }

    private func renderSkipped() -> String {
      var message = ""
      let skipped = comparisons
        .filter { !comparisonValues.map { $0.id }.contains($0.key) }
        .sorted { $0.key < $1.key }
        .map { $0.value }
      if !skipped.isEmpty {
        message += skipped.map { "[Not Evaluated] \($0)" }.joined(separator: "\n")
      }
      return message
    }
  }

  static private func stringify<T>(_ value: T?) -> String {
    func escapeString(_ string: String) -> String {
      string
        .replacingOccurrences(of: "\"", with: "\\\"")
        .replacingOccurrences(of: "\t", with: "\\t")
        .replacingOccurrences(of: "\r", with: "\\r")
        .replacingOccurrences(of: "\n", with: "\\n")
        .replacingOccurrences(of: "\0", with: "\\0")
    }

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

  private struct ComparisonValue {
    let id: Int
    let value: Any
    let expression: String
  }
}

extension PowerAssert.Assertion {
  public func captureSync(_ expr: @autoclosure () throws -> Int, column: Int, id: Int) rethrows -> Int {
    let val = try expr()
    store(value: val, column: column, id: id)
    return val
  }

  public func captureSync(_ expr: @autoclosure () throws -> Float, column: Int, id: Int) rethrows -> Float {
    let val = try expr()
    store(value: val, column: column, id: id)
    return val
  }

  public func captureSync(_ expr: @autoclosure () throws -> Double, column: Int, id: Int) rethrows -> Double {
    let val = try expr()
    store(value: val, column: column, id: id)
    return val
  }

  public func captureSync(_ expr: @autoclosure () throws -> String, column: Int, id: Int) rethrows -> String {
    let val = try expr()
    store(value: val, column: column, id: id)
    return val
  }

  public func captureSync<T>(_ expr: @autoclosure () throws -> T?, column: Int, id: Int) rethrows -> T? {
    let val = try expr()
    store(value: val, column: column, id: id)
    return val
  }

  public func captureSync<T>(_ expr: @autoclosure () throws -> [T], column: Int, id: Int) rethrows -> [T] {
    let val = try expr()
    store(value: val, column: column, id: id)
    return val
  }
}

extension PowerAssert.Assertion {
  public func captureAsync(_ expr: @autoclosure () async throws -> Int, column: Int, id: Int) async rethrows -> Int {
    let val = try await expr()
    store(value: val, column: column, id: id)
    return val
  }

  public func captureAsync(_ expr: @autoclosure () async throws -> Float, column: Int, id: Int) async rethrows -> Float {
    let val = try await expr()
    store(value: val, column: column, id: id)
    return val
  }

  public func captureAsync(_ expr: @autoclosure () async throws -> Double, column: Int, id: Int) async rethrows -> Double {
    let val = try await expr()
    store(value: val, column: column, id: id)
    return val
  }

  public func captureAsync(_ expr: @autoclosure () async throws -> String, column: Int, id: Int) async rethrows -> String {
    let val = try await expr()
    store(value: val, column: column, id: id)
    return val
  }

  public func captureAsync<T>(_ expr: @autoclosure () async throws -> T?, column: Int, id: Int) async rethrows -> T? {
    let val = try await expr()
    store(value: val, column: column, id: id)
    return val
  }

  public func captureAsync<T>(_ expr: @autoclosure () async throws -> [T], column: Int, id: Int) async rethrows -> [T] {
    let val = try await expr()
    store(value: val, column: column, id: id)
    return val
  }
}
