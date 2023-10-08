import XCTest
import SwiftSyntaxMacrosTestSupport

func captureConsoleOutput(execute: () -> Void, completion: @escaping (String) -> Void) {
  let pipe = Pipe()
  var output = ""

  let semaphore = XCTestExpectation(description: "semaphore")
  pipe.fileHandleForReading.readabilityHandler = { fileHandle in
    let data = fileHandle.availableData
    if data.isEmpty  {
      fileHandle.readabilityHandler = nil
      completion(output)
      semaphore.fulfill()
    } else {
      if let string = String(data: data,  encoding: .utf8) {
        output += string
      }
    }
  }

  setvbuf(stdout, nil, _IONBF, 0)
  let stdout = dup(STDOUT_FILENO)
  dup2(pipe.fileHandleForWriting.fileDescriptor, STDOUT_FILENO)

  execute()

  dup2(stdout, STDOUT_FILENO)
  try? pipe.fileHandleForWriting.close()
  close(stdout)

  if XCTWaiter.wait(for: [semaphore]) != .completed {
    XCTFail("timeout")
  }
}

func captureConsoleOutput(execute: () throws -> Void, completion: @escaping (String) -> Void) throws {
  let pipe = Pipe()
  var output = ""

  let semaphore = XCTestExpectation(description: "semaphore")
  pipe.fileHandleForReading.readabilityHandler = { fileHandle in
    let data = fileHandle.availableData
    if data.isEmpty  {
      fileHandle.readabilityHandler = nil
      completion(output)
      semaphore.fulfill()
    } else {
      if let string = String(data: data,  encoding: .utf8) {
        output += string
      }
    }
  }

  setvbuf(stdout, nil, _IONBF, 0)
  let stdout = dup(STDOUT_FILENO)
  dup2(pipe.fileHandleForWriting.fileDescriptor, STDOUT_FILENO)

  try execute()

  dup2(stdout, STDOUT_FILENO)
  try? pipe.fileHandleForWriting.close()
  close(stdout)

  if XCTWaiter.wait(for: [semaphore]) != .completed {
    XCTFail("timeout")
  }
}

func captureConsoleOutput(execute: () async -> Void, completion: @escaping (String) -> Void) async {
  let pipe = Pipe()

  class OutputRef {
    var output = ""
  }
  let ref = OutputRef()

  let semaphore = XCTestExpectation(description: "semaphore")
  pipe.fileHandleForReading.readabilityHandler = { fileHandle in
    let data = fileHandle.availableData
    if data.isEmpty  {
      fileHandle.readabilityHandler = nil
      completion(ref.output)
      semaphore.fulfill()
    } else {
      if let string = String(data: data,  encoding: .utf8) {
        ref.output += string
      }
    }
  }

  setvbuf(stdout, nil, _IONBF, 0)
  let stdout = dup(STDOUT_FILENO)
  dup2(pipe.fileHandleForWriting.fileDescriptor, STDOUT_FILENO)

  await execute()

  dup2(stdout, STDOUT_FILENO)
  try? pipe.fileHandleForWriting.close()
  close(stdout)

  if await XCTWaiter.fulfillment(of: [semaphore]) != .completed {
    XCTFail("timeout")
  }
}

func captureConsoleOutput(execute: () async throws -> Void, completion: @escaping (String) -> Void) async throws {
  let pipe = Pipe()

  class OutputRef {
    var output = ""
  }
  let ref = OutputRef()

  let semaphore = XCTestExpectation(description: "semaphore")
  pipe.fileHandleForReading.readabilityHandler = { fileHandle in
    let data = fileHandle.availableData
    if data.isEmpty  {
      fileHandle.readabilityHandler = nil
      completion(ref.output)
      semaphore.fulfill()
    } else {
      if let string = String(data: data,  encoding: .utf8) {
        ref.output += string
      }
    }
  }

  setvbuf(stdout, nil, _IONBF, 0)
  let stdout = dup(STDOUT_FILENO)
  dup2(pipe.fileHandleForWriting.fileDescriptor, STDOUT_FILENO)

  try await execute()

  dup2(stdout, STDOUT_FILENO)
  try? pipe.fileHandleForWriting.close()
  close(stdout)

  if await XCTWaiter.fulfillment(of: [semaphore]) != .completed {
    XCTFail("timeout")
  }
}
public enum DiffStyle {
  case simple(_ contextLength: Int)
  case string(_ contextLength: Int)
  public static let DEFAULT = DiffStyle.simple(8)

  func diff(_ exp: String, _ act: String) -> String? {
    switch self {
    case .simple(let peek): return diffSimple(exp, act, peek: peek)
    case .string: return diffString(exp, act)
    }
  }
}
/// Describe difference between expected and actual String, if any.
///
/// For first character difference (using `==`), this emits message with index, diff, and context.
///
/// This does not produce proper diffs.
/// - Parameters:
///   - exp: expected String
///   - act:  actual String
///   - style: ``DiffStyle`` (defaults to ``DiffStyle/DEFAULT``)
/// - Returns: nil if equal, or non-empty String difference for human readers otherwise
func diff(
  _ exp: String,
  _ act: String,
  _ style: DiffStyle = .DEFAULT
) -> String? {
  guard exp != act else {
    return nil
  }
  return style.diff(exp, act)
}
enum InsRem {
  case insert(_ start: Int)
  case remove(_ start: Int)
  case same
  func offset(_ current: Int) -> Int {
    switch self {
    case .insert(let start): return current - start
    case .remove(let start): return start - current
    case .same: return 0
    }
  }
}
extension CollectionDifference.Change {
  typealias ICO = (insert: Bool, c: [ChangeElement], offset: ClosedRange<Int>)
  var insertChangeOffset: ICO {
    switch self {
    case .insert(let offset, let c, _):
      return (true, [c], offset...offset)
    case .remove(let offset, let c, _):
      return (false, [c], offset...offset)
    }
  }
  func insertChangeOffsetExtended(fromLast last: ICO) -> ICO? {
    let me = insertChangeOffset
    if me.insert == last.insert
        && me.offset.upperBound == last.offset.upperBound + 1 {
      let range = last.offset.lowerBound...me.offset.upperBound
      return (me.insert, last.c + me.c, range)
    }
    return nil
  }
  static func str(insertChangeOffset ico: ICO) -> String {
    let prefix = ico.insert ? "ins" : "rem"
    let range = ico.offset.upperBound > 1 + ico.offset.lowerBound
      ? "[\(ico.offset)]" : "[\(ico.offset.lowerBound)]"
    let s = "\(ico.c)"
    return "\(prefix) \(range): \(s)"
  }
}
func diffString(_ exp: String, _ act: String) -> String {
  let diffs: CollectionDifference<Character> = act.difference(from: exp)
  var result = ""
  var last: CollectionDifference<Character>.Change.ICO?
  func printLast() {
    if let last = last {
      let str = CollectionDifference<Character>.Change.str
      result += str(last)
    }
  }
  for next in diffs {
    let ico = next.insertChangeOffset
    // no prior, just start
    guard let prior = last else {
      last = ico
      continue
    }
    // next extends prior
    if let replacement = next.insertChangeOffsetExtended(fromLast: prior) {
      last = replacement
      continue
    }

    // new diff - print old
    printLast()
    last = ico
  }
  printLast()
  return result
}

func diffSimple(
  _ exp: String,
  _ act: String,
  peek: Int = 8
) -> String? {
  func min(_ i: Int, _ vals: Int...) -> Int {
    var result = i
    for next in vals {
      if next < result {
        result = next
      }
    }
    return result
  }
  let peek = peek < 0 ? 0 : peek > 40 ? 40 : peek // look backward or forward when printing context
  func suffix(_ s: String, _ i: Int) -> String {
    let available = s.count - i
    let suffixCount = min(available - 1, peek)
    let start = s.index(s.startIndex, offsetBy: i)
    let end = s.index(start, offsetBy: suffixCount)
    return "\(s[start...end])"
  }
  let inset = "\n  "
  let minCount = min(act.count, exp.count)
  var expIndex = exp.startIndex
  var actIndex = act.startIndex
  var diffMessage = ""
  for i in 0..<minCount {
    if exp[expIndex] == act[actIndex] {
      expIndex = exp.index(after: expIndex)
      actIndex = act.index(after: actIndex)
      continue
    }
    let start = min(i, peek)
    let startIndex = exp.index(expIndex, offsetBy: -start)
    let prefix = 0 == start ? " " : "...\(exp[startIndex...expIndex])..."
    diffMessage = "diff @[\(i)] \(prefix)\(inset)"
    + "exp: \(suffix(exp, i))\(inset)act: \(suffix(act, i))"
    break
  }
  // handle suffix
  if diffMessage.isEmpty && exp.count != act.count {
    let expBigger = exp.count > act.count
    let maxCount = expBigger ? exp.count : act.count
    diffMessage = "diff @[\(minCount)...\(maxCount)] "
    let message = "is longer by \(maxCount-minCount)"
    if expBigger {
      diffMessage += "expect \(message)\(inset)exp: \(suffix(exp, minCount))"
    } else {
      diffMessage += "actual \(message)\(inset)act: \(suffix(act, minCount))"
    }
  }
  return diffMessage.isEmpty ? nil : diffMessage
}

@discardableResult
func actExp(
  _ act: String,
  _ exp: String,
  message: String? = nil,
  file: StaticString = #file,
  line: UInt = #line,
  funcName: StaticString = #function
) -> Bool {
  guard let fail = diff(exp, act) else {
    return true
  }
  let prefix = message ?? "# \(funcName) Macro output differs\n## "
  let m = "\(prefix)\(fail)\n## Expected\n\(exp)\n## Actual\n\(act)\n# End \(funcName)()\n"
  XCTFail(m, file: file, line: line)
  return false
}

