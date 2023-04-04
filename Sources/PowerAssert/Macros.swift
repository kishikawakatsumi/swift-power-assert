@freestanding(expression) public macro powerAssert(
  _ expression: @autoclosure () throws -> Bool,
  _ message: @autoclosure () -> String = "",
  file: StaticString = #filePath,
  line: UInt = #line,
  verbose: Bool = false
) = #externalMacro(module: "PowerAssertPlugin", type: "PowerAssertMacro")
