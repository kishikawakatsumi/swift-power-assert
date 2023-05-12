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

  func testApply() {
    // Test bold
    #assert(
      Console.apply([.bold], to: "Hello World") == "\u{001b}[1mHello World\u{001b}[22m",
      "Bold style not applied correctly"
    )

    // Test italic
    #assert(
      Console.apply([.italic], to: "Hello World") == "\u{001b}[3mHello World\u{001b}[23m",
      "Italic style not applied correctly"
    )

    // Test underline
    #assert(
      Console.apply([.underline], to: "Hello World") == "\u{001b}[4mHello World\u{001b}[24m",
      "Underline style not applied correctly"
    )

    // Test color
    #assert(
      Console.apply([.color(.red)], to: "Hello World") == "\u{001b}[31mHello World\u{001b}[0m",
      "Color style not applied correctly"
    )

    // Test multiple styles
    #assert(
      Console.apply([.bold, .color(.green)], to: "Hello World") == "\u{001b}[32m\u{001b}[1mHello World\u{001b}[22m\u{001b}[0m",
      "Multiple styles not applied correctly"
    )
  }
}
