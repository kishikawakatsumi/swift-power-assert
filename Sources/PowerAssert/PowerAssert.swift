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
    private let equalityExpressions: [(Int, Int, Int)]
    private let identicalExpressions: [(Int, Int, Int)]
    private let comparisonOperands: [Int: String]

    private var result: Bool = false
    private var values = [Value]()
    private var equalityExpressionValues = [EqualityExpressionValue]()
    private var identicalExpressionValues = [IdenticalExpressionValue]()
    private var comparisonValues = [ComparisonValue]()
    private var errors = [Error]()

    public init(
      _ assertion: String,
      message: String = "",
      file: StaticString,
      line: UInt,
      verbose: Bool = false,
      equalityExpressions: [(Int, Int, Int)],
      identicalExpressions: [(Int, Int, Int)],
      comparisonOperands: [Int: String],
      evaluateSync: (Assertion) throws -> Bool = { _ in true }
    ) {
      self.assertion = assertion
      self.originalMessage = message
      self.filePath = file
      self.lineNumber = line
      self.verbose = verbose
      self.equalityExpressions = equalityExpressions
      self.identicalExpressions = identicalExpressions
      self.comparisonOperands = comparisonOperands
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
      equalityExpressions: [(Int, Int, Int)],
      identicalExpressions: [(Int, Int, Int)],
      comparisonOperands: [Int: String],
      evaluateAsync: (Assertion) async throws -> Bool = { _ in true }
    ) async {
      self.assertion = assertion
      self.originalMessage = message
      self.filePath = file
      self.lineNumber = line
      self.verbose = verbose
      self.equalityExpressions = equalityExpressions
      self.identicalExpressions = identicalExpressions
      self.comparisonOperands = comparisonOperands
      do {
        self.result = try await evaluateAsync(self)
      } catch {
        errors.append(error)
      }
    }

    public func captureSync<T>(_ expr: @autoclosure () throws -> T, column: Int, id: Int) rethrows -> T {
      do {
        let val = try expr()
        store(value: val, column: column, id: id)
        return val
      } catch {
        store(value: error, column: column, id: id)
        throw error
      }
    }

    public func captureAsync<T>(_ expr: @autoclosure () async throws -> T, column: Int, id: Int) async rethrows -> T {
      do {
        let val = try await expr()
        store(value: val, column: column, id: id)
        return val
      } catch {
        store(value: error, column: column, id: id)
        throw error
      }
    }

    public func render() {
      if !result || verbose {
        let diagram = renderDiagram()
        let comparison = [
          renderErrors(),
          renderEqualityExpressions(),
          renderIdenticalExpressions(),
          renderComparisonOperands(),
          renderSkipped(),
        ]
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
          if ProcessInfo.processInfo.environment["SWIFTPOWERASSERT_NOXCTEST"] != "1" {
            XCTFail("\(originalMessage)\n\(message)", file: filePath, line: lineNumber)
          } else {
            print(message)
          }
#else
          print(message)
#endif
        } else if verbose {
          print(message)
        }
      }
    }

    private func store<T>(value: T, column: Int, id: Int) {
      values.append(Value(stringify(value), column: column))
      if equalityExpressions.contains(where: { $0.0 == id }) {
        equalityExpressionValues.append(EqualityExpressionValue(id: id, value: value))
      }
      if identicalExpressions.contains(where: { $0.0 == id }) {
        identicalExpressionValues.append(IdenticalExpressionValue(id: id, value: value))
      }
      if let expr = comparisonOperands[id] {
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
        message += Console.apply([.color(.red)], to: string)
        current += stringWidth(string)
      }

      var message = "\(Console.apply([.color(.red)], to: assertion))\n"
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

    private func renderErrors() -> String {
      errors.map {
        Console.apply([.color(.red)], to: "[Error] \($0)")
      }
      .joined(separator: "\n")
    }

    private func renderEqualityExpressions() -> String {
      var message = ""
      if !equalityExpressions.isEmpty {
        message += equalityExpressions.reversed()
          .compactMap { (ex) -> String? in
            guard let equalityExpressionValue = equalityExpressionValues.first(where: { $0.id == ex.0 }) else {
              return nil
            }
            guard let condition = equalityExpressionValue.value as? Bool, !condition else {
              return nil
            }
            guard let lhs = comparisonValues.first(where: { $0.id == ex.1 }), let rhs = comparisonValues.first(where: { $0.id == ex.2 }) else {
              return nil
            }

            let diff: String
            switch (lhs.value, rhs.value) {
            case (let lvalue as String, let rvalue as String):
              diff = "\(wordDiff(lvalue, rvalue))\n"
            case (let lvalue, let rvalue):
              diff = lineDiff(stringify(lvalue), stringify(rvalue))
            }
            return """
              \(Console.apply([.color(.green)], to: "--- [\(type(of: lhs.value))] \(lhs.expression)"))
              \(Console.apply([.color(.red)], to: "+++ [\(type(of: rhs.value))] \(rhs.expression)"))
              \(diff)
              """
          }
          .joined(separator: "\n")
        if !message.isEmpty {
          message = "\(Console.apply([.color(.green)], to: "- expected")) \(Console.apply([.color(.red)], to: "+ actual"))\n\n\(message)"
        }
      }
      return message
    }

    private func renderIdenticalExpressions() -> String {
      var message = ""
      if !identicalExpressions.isEmpty {
        message += identicalExpressions.reversed()
          .compactMap { (ex) -> String? in
            guard let identicalExpressionValue = identicalExpressionValues.first(where: { $0.id == ex.0 }) else {
              return nil
            }
            guard let condition = identicalExpressionValue.value as? Bool, !condition else {
              return nil
            }
            guard let lhs = comparisonValues.first(where: { $0.id == ex.1 }), let rhs = comparisonValues.first(where: { $0.id == ex.2 }) else {
              return nil
            }

            let lvalue = "<\(ObjectIdentifier(lhs.value as AnyObject))>"
            let rvalue = "<\(ObjectIdentifier(rhs.value as AnyObject))>"

            return """
              \(Console.apply([.color(.green)], to: "--- [\(type(of: lhs.value))] \(lhs.expression)"))
              \(Console.apply([.color(.red)], to: "+++ [\(type(of: rhs.value))] \(rhs.expression)"))
              \(lineDiff(lvalue, rvalue))
              """
          }
          .joined(separator: "\n")
        if !message.isEmpty {
          message = "\(Console.apply([.color(.green)], to: "- expected")) \(Console.apply([.color(.red)], to: "+ actual"))\n\n\(message)"
        }
      }
      return message
    }

    private func renderComparisonOperands() -> String {
      var message = ""
      if !comparisonValues.isEmpty {
        message += comparisonValues
          .map { Console.apply([.color(.red)], to: "[\(type(of: $0.value))] \($0.expression)\n=> \(stringify($0.value))") }
          .joined(separator: "\n")
      }
      return message
    }

    private func renderSkipped() -> String {
      var message = ""
      let skipped = comparisonOperands
        .filter { !comparisonValues.map { $0.id }.contains($0.key) }
        .sorted { $0.key < $1.key }
        .map { $0.value }
      if !skipped.isEmpty {
        message += skipped
          .map { Console.apply([.color(.red)], to: "[Not Evaluated] \($0)") }
          .joined(separator: "\n")
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
    case .some(let v) where v is String || v is Selector:
      return "\"\(escapeString("\(v)"))\""
    case .some(let v):
      return "\(v)".replacingOccurrences(of: "\n", with: " ")
    case .none: return "nil"
    }
#else
    switch value {
    case .some(let v) where v is String:
      return "\"\(escapeString("\(v)"))\""
    case .some(let v):
      return "\(v)".replacingOccurrences(of: "\n", with: " ")
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

  private struct EqualityExpressionValue {
    let id: Int
    let value: Any
  }

  private struct IdenticalExpressionValue {
    let id: Int
    let value: Any
  }

  private struct ComparisonValue {
    let id: Int
    let value: Any
    let expression: String
  }
}

extension PowerAssert.Assertion {
  public func captureSync(_ expr: @autoclosure () throws -> Int, column: Int, id: Int) rethrows -> Int {
    do {
      let val = try expr()
      store(value: val, column: column, id: id)
      return val
    } catch {
      store(value: error, column: column, id: id)
      throw error
    }
  }

  public func captureSync(_ expr: @autoclosure () throws -> Float, column: Int, id: Int) rethrows -> Float {
    do {
      let val = try expr()
      store(value: val, column: column, id: id)
      return val
    } catch {
      store(value: error, column: column, id: id)
      throw error
    }
  }

  public func captureSync(_ expr: @autoclosure () throws -> Double, column: Int, id: Int) rethrows -> Double {
    do {
      let val = try expr()
      store(value: val, column: column, id: id)
      return val
    } catch {
      store(value: error, column: column, id: id)
      throw error
    }
  }

  public func captureSync(_ expr: @autoclosure () throws -> String, column: Int, id: Int) rethrows -> String {
    do {
      let val = try expr()
      store(value: val, column: column, id: id)
      return val
    } catch {
      store(value: error, column: column, id: id)
      throw error
    }
  }

  public func captureSync<T>(_ expr: @autoclosure () throws -> T?, column: Int, id: Int) rethrows -> T? {
    do {
      let val = try expr()
      store(value: val, column: column, id: id)
      return val
    } catch {
      store(value: error, column: column, id: id)
      throw error
    }
  }

  public func captureSync<T>(_ expr: @autoclosure () throws -> [T], column: Int, id: Int) rethrows -> [T] {
    do {
      let val = try expr()
      store(value: val, column: column, id: id)
      return val
    } catch {
      store(value: error, column: column, id: id)
      throw error
    }
  }
}

extension PowerAssert.Assertion {
  public func captureAsync(_ expr: @autoclosure () async throws -> Int, column: Int, id: Int) async rethrows -> Int {
    do {
      let val = try await expr()
      store(value: val, column: column, id: id)
      return val
    } catch {
      store(value: error, column: column, id: id)
      throw error
    }
  }

  public func captureAsync(_ expr: @autoclosure () async throws -> Float, column: Int, id: Int) async rethrows -> Float {
    do {
      let val = try await expr()
      store(value: val, column: column, id: id)
      return val
    } catch {
      store(value: error, column: column, id: id)
      throw error
    }
  }

  public func captureAsync(_ expr: @autoclosure () async throws -> Double, column: Int, id: Int) async rethrows -> Double {
    do {
      let val = try await expr()
      store(value: val, column: column, id: id)
      return val
    } catch {
      store(value: error, column: column, id: id)
      throw error
    }
  }

  public func captureAsync(_ expr: @autoclosure () async throws -> String, column: Int, id: Int) async rethrows -> String {
    do {
      let val = try await expr()
      store(value: val, column: column, id: id)
      return val
    } catch {
      store(value: error, column: column, id: id)
      throw error
    }
  }

  public func captureAsync<T>(_ expr: @autoclosure () async throws -> T?, column: Int, id: Int) async rethrows -> T? {
    do {
      let val = try await expr()
      store(value: val, column: column, id: id)
      return val
    } catch {
      store(value: error, column: column, id: id)
      throw error
    }
  }

  public func captureAsync<T>(_ expr: @autoclosure () async throws -> [T], column: Int, id: Int) async rethrows -> [T] {
    do {
      let val = try await expr()
      store(value: val, column: column, id: id)
      return val
    } catch {
      store(value: error, column: column, id: id)
      throw error
    }
  }
}
