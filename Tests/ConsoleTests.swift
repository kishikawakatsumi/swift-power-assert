import XCTest
@testable import PowerAssert

class ConsoleTests: XCTestCase {
  override func setUp() {
    unsetenv("NO_COLOR")
    setenv("TERM", "xterm-256color", 1)
  }

  override func tearDown() {
    unsetenv("TERM")
  }

  func testDecorate() {
    // Test bold
    #assert(
      Console.decorate([.bold], on: "Hello World") == "\u{001b}[1mHello World\u{001b}[22m",
      "Bold style not applied correctly"
    )

    // Test italic
    #assert(
      Console.decorate([.italic], on: "Hello World") == "\u{001b}[3mHello World\u{001b}[23m",
      "Italic style not applied correctly"
    )

    // Test underline
    #assert(
      Console.decorate([.underline], on: "Hello World") == "\u{001b}[4mHello World\u{001b}[24m",
      "Underline style not applied correctly"
    )

    // Test color
    #assert(
      Console.decorate([.color(.red)], on: "Hello World") == "\u{001b}[31mHello World\u{001b}[0m",
      "Color style not applied correctly"
    )

    // Test multiple styles
    #assert(
      Console.decorate([.bold, .color(.green)], on: "Hello World") == "\u{001b}[32m\u{001b}[1mHello World\u{001b}[22m\u{001b}[0m",
      "Multiple styles not applied correctly"
    )
  }
}
