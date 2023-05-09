import XCTest
@testable import PowerAssert

final class LineDiffTests: XCTestCase {
  override func setUp() {
    setenv("NO_COLOR", "1", 1)
  }

  override func tearDown() {
    unsetenv("NO_COLOR")
  }

  func testIdenticalStrings() {
    let expected = """
      Hello
      World

      """
    let actual = """
      Hello
      World

      """
    let diff = """
       Hello
       World
      \u{0020}

      """
    #assert(lineDiff(expected, actual) == diff)
  }

  func testSingleLineDifference() {
    let expected = """
      Hello
      World

      """
    let actual = """
      Hello
      Universe

      """
    let diff = """
      \u{0020}Hello
      –World
      +Universe
      \u{0020}

      """
    #assert(lineDiff(expected, actual) == diff)
  }

  func testSingleLineInsertion() {
    let expected = """
      Hello
      World

      """
    let actual = """
      Hello
      Universe
      World

      """
    let diff = """
      \u{0020}Hello
      +Universe
      \u{0020}World
      \u{0020}

      """
    #assert(lineDiff(expected, actual) == diff)
  }

  func testSingleLineRemoval() {
    let expected = """
      Hello
      World

      """
    let actual = """
      Hello

      """
    let diff = """
      \u{0020}Hello
      –World
      \u{0020}

      """
    #assert(lineDiff(expected, actual) == diff)
  }

  func testMultipleLineDifferences() {
    let expected = """
      Hello
      World
      I am here

      """
    let actual = """
      Hello
      Universe
      I am there

      """
    let diff = """
      \u{0020}Hello
      –World
      –I am here
      +Universe
      +I am there
      \u{0020}

      """
    #assert(lineDiff(expected, actual) == diff)
  }

  func testMultipleLineInsertions() {
    let expected = """
      Hello
      World

      """
    let actual = """
      Hello
      Line 1
      Line 2
      World

      """
    let diff = """
      \u{0020}Hello
      +Line 1
      +Line 2
      \u{0020}World
      \u{0020}

      """
    #assert(lineDiff(expected, actual) == diff)
  }

  func testMultipleLineRemovals() {
    let expected = """
      Hello
      Line 1
      Line 2
      World

      """
    let actual = """
      Hello
      World

      """
    let diff = """
      \u{0020}Hello
      –Line 1
      –Line 2
      \u{0020}World
      \u{0020}

      """
    #assert(lineDiff(expected, actual) == diff)
  }

  func testEmptyStrings() {
    let expected = ""
    let actual = ""
    let diff = """
      \u{0020}

      """
    #assert(lineDiff(expected, actual) == diff)
  }

  func testActualEmptyString() {
    let expected = """
      Hello
      World

      """
    let actual = ""
    let diff = """
      –Hello
      –World
      \u{0020}

      """
    #assert(lineDiff(expected, actual) == diff)
  }

  func testExpectedEmptyString() {
    let expected = ""
    let actual = """
      Hello
      World

      """
    let diff = """
      +Hello
      +World
      \u{0020}

      """
    #assert(lineDiff(expected, actual) == diff)
  }
}
