import XCTest
@testable import PowerAssert

final class ExprSyntaxTests: XCTestCase {
  override func setUp() {
    setenv("NO_COLOR", "1", 1)
    setenv("SWIFTPOWERASSERT_WITHOUT_XCTEST", "1", 1)
  }

  override func tearDown() {
    unsetenv("NO_COLOR")
    unsetenv("SWIFTPOWERASSERT_WITHOUT_XCTEST")
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
      #assert(things[0] as? Int == 42)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #assert(things[0] as? Int == 42)
                │      ││ │       │  │
                │      │0 │       │  42
                │      0  │       false
                │         Optional(0)
                [0, 0.0, 42, 3.14159, "hello", (3.0, 5.0), PowerAssertTests.Movie, (Function)]

        --- [Optional<Int>] things[0] as? Int
        +++ [Int] 42
        –Optional(0)
        +42

        [Optional<Int>] things[0] as? Int
        => Optional(0)
        [Int] 42
        => 42


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
    captureConsoleOutput {
      #assert(switch "match" { case "no" : true; case "match": false; default: true;})
    } completion: { (output) in
      actExp(
        output,
        """
        #assert(switch "match" { case "no" : true; case "match": false; default: true;})
                       │              │                 │        │
                       "match"        "no"              "match"  false


        """
      )
  }
  }

  func testTernaryExprSyntax() {
    captureConsoleOutput {
      #assert("" == "no" ? true : false)
    } completion: { (output) in
      actExp(
        output,
        """
        #assert("" == "no" ? true : false)
                ││ │  │             │
                ││ │  "no"          false
                ││ false
                │false
                ""

        --- [String] ""
        +++ [String] "no"
        {+no+}

        [String] ""
        => ""
        [String] "no"
        => "no"
        [Bool] "" == "no"
        => false
        [Bool] false
        => false
        [Not Evaluated] true


        """
      )
    }
  }

  func testTryExprSyntax() {

  }

  func testTupleExprSyntax() {

  }

  func testTypeExprSyntax() {
    captureConsoleOutput {
      let metatype: String.Type = String.self
      #assert(metatype as String.Type != String.self)
      #assert(metatype as String.Type == Int.self)
      #assert(metatype as String.Type ==== Int.self)
      #assert(metatype as String.Type !=== String.self)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #assert(metatype as String.Type != String.self)
                │        │              │  │      │
                String   │              │  │      Optional(Swift.String)
                         │              │  Optional(Swift.String)
                         │              false
                         Optional(Swift.String)

        [Optional<Any.Type>] metatype as String.Type
        => Optional(Swift.String)
        [Optional<Any.Type>] String.self
        => Optional(Swift.String)

        #assert(metatype as String.Type == Int.self)
                │        │              │  │   │
                String   │              │  │   Optional(Swift.Int)
                         │              │  Optional(Swift.Int)
                         │              false
                         Optional(Swift.String)

        --- [Optional<Any.Type>] metatype as String.Type
        +++ [Optional<Any.Type>] Int.self
        –Optional(Swift.String)
        +Optional(Swift.Int)

        [Optional<Any.Type>] metatype as String.Type
        => Optional(Swift.String)
        [Optional<Any.Type>] Int.self
        => Optional(Swift.Int)

        #assert(metatype as String.Type ==== Int.self)
                │                            │   │
                String                       Int Int

        #assert(metatype as String.Type !=== String.self)
                │                            │      │
                String                       String String


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

  func testDiff() {
    let demoFails = "" == "no"
    actExp("", "")
    actExp("ok", "ok")
    if demoFails {
      actExp("not", "true", message: "# My message\n")
      actExp("fail5", "fails")
      actExp("something in the air", "something or other")
      actExp("something", "something or other")
      actExp("something in the air", "something ")
    }
  }
}
