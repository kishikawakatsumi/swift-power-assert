public func vassert(
  _ expression: @autoclosure () throws -> Bool,
  _ message: @autoclosure () -> String = "",
  file: StaticString = #filePath,
  line: UInt = #line,
  verbose: Bool = false
) {}

public func xassert(
  _ expression: @autoclosure () async throws -> Bool,
  _ message: @autoclosure () -> String = "",
  file: StaticString = #filePath,
  line: UInt = #line,
  verbose: Bool = false
) async {}
