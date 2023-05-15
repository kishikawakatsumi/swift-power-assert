import XCTest
@testable import PowerAssert

final class OutputStyleTests: XCTestCase {
  override func setUp() {
    setenv("SWIFTPOWERASSERT_WITHOUT_XCTEST", "1", 1)
  }

  override func tearDown() {
    unsetenv("SWIFTPOWERASSERT_WITHOUT_XCTEST")
  }

  func testIdenticalStrings() {
    let expected = "Hello World"
    let actual = "Hello Swift"
    #assert(expected == actual)
  }
}
