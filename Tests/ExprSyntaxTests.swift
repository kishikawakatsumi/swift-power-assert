import XCTest
@testable import PowerAssert

final class ExprSyntaxTests: XCTestCase {
  override func setUp() {
    setenv("NO_COLOR", "1", 1)
  }

  override func tearDown() {
    unsetenv("NO_COLOR")
  }
  
  func testArrayExprSyntax() {

  }

  func testArrowExprSyntax() {

  }

  func testAsExprSyntax() {
    var things: [Any] = []

    things.append(0)
    things.append(0.0)
    things.append(42)
    things.append(3.14159)
    things.append("hello")
    things.append((3.0, 5.0))
    things.append(Movie(name: "Ghostbusters", director: "Ivan Reitman"))
    things.append({ (name: String) -> String in "Hello, \(name)" })

    captureConsoleOutput {
      #assert(things[0] as? Int == 0, verbose: true)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #assert(things[0] as? Int == 0)
                │      ││ │       │  │
                │      │0 │       │  0
                │      0  │       true
                │         Optional(0)
                [0, 0.0, 42, 3.14159, "hello", (3.0, 5.0), PowerAssertTests.Movie, (Function)]

        [Optional<Int>] things[0] as? Int
        => Optional(0)
        [Int] 0
        => 0
        

        """
      )
    }
  }

  func testAssignmentExprSyntax() {

  }

//  func testAwaitExprSyntax() async {
//    captureConsoleOutput {
//      #assert(await upload(content: "Swift") == "OK", verbose: true)
//    } completion: { (output) in
//      print(output)
//      XCTAssertEqual(
//        output,
//        """
//
//        """
//      )
//    }
//  }

  func testBinaryOperatorExprSyntax() {

  }

  func testBooleanLiteralExprSyntax() {

  }

  func testBorrowExprSyntax() {

  }

  func testClosureExprSyntax() {

  }

  func testDictionaryExprSyntax() {

  }

  func testDiscardAssignmentExprSyntax() {

  }

  func testEditorPlaceholderExprSyntax() {

  }

  func testFloatLiteralExprSyntax() {

  }

  func testForcedValueExprSyntax() {

  }

  func testFunctionCallExprSyntax() {

  }

  func testIdentifierExprSyntax() {

  }

//  func testIfExprSyntax() {
//    func c() -> Int {
//      1
//    }
//    func d() -> Int {
//      10
//    }
//    let isRoot = false
//    let count = c()
//    let willExpand = true
//    let maxDepth = d()
//
//    captureConsoleOutput {
//      #assert(
//        if isRoot && (count == 0 || !willExpand) { "" }
//        else if count == 0 { "- " }
//        else if maxDepth <= 0 { "▹ " }
//        else { "▿ " } != "- ",
//        verbose: true
//      )
//    } completion: { (output) in
//      print(output)
//      XCTAssertEqual(
//        output,
//        """
//        #assert(bullet != "- ")
//                |      |  |
//                |      |  "- "
//                |      true
//                "▿ "
//
//        """
//      )
//    }
//  }

  func testInOutExprSyntax() {

  }

  func testInfixOperatorExprSyntax() {

  }

  func testIntegerLiteralExprSyntax() {

  }

  func testIsExprSyntax() {

  }

  func testKeyPathExprSyntax() {

  }

  func testMacroExpansionExprSyntax() {

  }

  func testMemberAccessExprSyntax() {

  }

  func testMissingExprSyntax() {

  }

  func testMoveExprSyntax() {

  }

  func testNilLiteralExprSyntax() {

  }

  func testOptionalChainingExprSyntax() {

  }

  func testPackExpansionExprSyntax() {

  }

  func testPostfixIfConfigExprSyntax() {

  }

  func testPostfixUnaryExprSyntax() {

  }

  func testPrefixOperatorExprSyntax() {

  }

  func testRegexLiteralExprSyntax() {

  }

  func testSequenceExprSyntax() {

  }

  func testSpecializeExprSyntax() {

  }

  func testStringLiteralExprSyntax() {

  }

  func testSubscriptExprSyntax() {

  }

  func testSuperRefExprSyntax() {

  }

  func testSwitchExprSyntax() {

  }

  func testTernaryExprSyntax() {

  }

  func testTryExprSyntax() {

  }

  func testTupleExprSyntax() {

  }

  func testTypeExprSyntax() {
    captureConsoleOutput {
      let metatype: String.Type = String.self
      #assert(metatype as String.Type == String.self, verbose: true)
      #assert(metatype as String.Type != Int.self, verbose: true)
      #assert(metatype as String.Type ==== String.self, verbose: true)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #assert(metatype as String.Type == String.self)
                │        │              │  │      │
                String   │              │  │      Optional(Swift.String)
                         │              │  Optional(Swift.String)
                         │              true
                         Optional(Swift.String)

        [Optional<Any.Type>] metatype as String.Type
        => Optional(Swift.String)
        [Optional<Any.Type>] String.self
        => Optional(Swift.String)

        #assert(metatype as String.Type != Int.self)
                │        │              │  │   │
                String   │              │  │   Optional(Swift.Int)
                         │              │  Optional(Swift.Int)
                         │              true
                         Optional(Swift.String)

        [Optional<Any.Type>] metatype as String.Type
        => Optional(Swift.String)
        [Optional<Any.Type>] Int.self
        => Optional(Swift.Int)

        #assert(metatype as String.Type ==== String.self)
                │                       │    │      │
                String                  true String String


        """
      )
    }
  }

  func testUnresolvedAsExprSyntax() {

  }

  func testUnresolvedIsExprSyntax() {

  }

  func testUnresolvedPatternExprSyntax() {

  }

  func testUnresolvedTernaryExprSyntax() {

  }
}
