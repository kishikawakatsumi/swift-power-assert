import PowerAssert
import XCTest

final class MyLibraryTests: XCTestCase {
  func testExample() {
    let numbers = [1, 2, 3, 4, 5]

    #assert(numbers[2] == 4)
    #assert(numbers.contains(6))

    let string1 = "Hello, world!"
    let string2 = "Hello, Swift!"

    #assert(string1 == string2)
  }
}
