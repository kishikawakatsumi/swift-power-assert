import XCTest
@testable import MyApp
import PowerAssert

final class MyAppTests: XCTestCase {
  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }

  func testExample() throws {
    let numbers = [1, 2, 3, 4, 5]

    #assert(numbers[2] == 4)
    #assert(numbers.contains(6))

    let string1 = "Hello, world!"
    let string2 = "Hello, Swift!"

    #assert(string1 == string2)
  }
}
