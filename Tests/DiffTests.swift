import XCTest
@testable import PowerAssert

final class DiffTests: XCTestCase {
  func testIdenticalStrings() {
    let expected = "Hello\nWorld\n"
    let actual = "Hello\nWorld\n"
    let diff = """
       Hello
       World
      \u{0020}

      """
    #assert(lineDiff(expected, actual) == diff)
  }

  func testSingleLineDifference() {

  }

  func testSingleLineInsertion() {

  }

  func testSingleLineRemoval() {

  }

  func testMultipleLineDifferences() {

  }

  func testMultipleLineInsertions() {

  }

  func testMultipleLineRemovals() {

  }

  func testEmptyStrings() {

  }

  func testActualEmptyString() {

  }

  func testExpectedEmptyString() {

  }
}
