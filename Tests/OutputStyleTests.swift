import XCTest
@testable import PowerAssert

final class OutputStyleTests: XCTestCase {
  override func setUp() {
    setenv("SWIFTPOWERASSERT_NOXCTEST", "1", 1)
  }

  override func tearDown() {
    unsetenv("SWIFTPOWERASSERT_NOXCTEST")
  }

  func testIdenticalStrings() {
    let expected = "Hello World"
    let actual = "Hello Swift"
    #assert(expected == actual)
  }
}
