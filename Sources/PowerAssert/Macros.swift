@freestanding(expression) public macro powerAssert(_ expression: @autoclosure () throws -> Bool) = #externalMacro(module: "PowerAssertPlugin", type: "PowerAssertMacro")
