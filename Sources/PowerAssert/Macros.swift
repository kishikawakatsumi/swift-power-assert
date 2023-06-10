/// Asserts that the given expression is true.
/// - Parameters:
///   - expression: The expression to evaluate.
///   - message: An optional description of a failure.
///   - file: The file where the failure occurs. The default is the filename of the test case where you call this function.
///   - line: The line number where the failure occurs. The default is the line number where you call this function.
///   - verbose: If `true`, the result is always printed instead of only when the assertion fails.
@freestanding(expression)
public macro assert(
    _ expression: @autoclosure () throws -> Bool,
    _ message: @autoclosure () -> String = "",
    file: StaticString = #filePath,
    line: UInt = #line,
    verbose: Bool = false
) = #externalMacro(module: "PowerAssertPlugin", type: "PowerAssertMacro")
