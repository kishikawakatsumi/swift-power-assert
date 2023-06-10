import XCTest
import PowerAssert
@testable import StringWidth

final class StringWidthTests: XCTestCase {
  func testStripANSIEscapes() {
    #assert(stripANSIEscapes("\u{001b}[32m\u{001b}[46mfoo\u{001b}[49m\u{001b}[39m") == "foo")
    #assert(stripANSIEscapes("\u{001B}]8;;https://github.com\u{0007}foo\u{001B}]8;;\u{0007}") == "foo")
  }
}
