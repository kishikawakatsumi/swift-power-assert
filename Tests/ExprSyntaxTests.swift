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
    let ra = [0]
    captureConsoleOutput {
      #assert(ra == [1])
    } completion: { (output) in
      actExp(
        output,
        """
        #assert(ra == [1])
                │  │  ││
                │  │  │1
                │  │  [1]
                │  false
                [0]

        --- [Array<Int>] ra
        +++ [Array<Int>] [1]
        –[0]
        +[1]

        [Array<Int>] ra
        => [0]
        [Array<Int>] [1]
        => [1]


        """
      )
    }
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
    captureConsoleOutput {
      #assert(0 == 1 - 2)
    } completion: { (output) in
      actExp(
        output,
        """
        #assert(0 == 1 - 2)
                │ │  │ │ │
                0 │  1 │ 2
                  │    -1
                  false

        --- [Int] 0
        +++ [Int] 1 - 2
        –0
        +-1

        [Int] 0
        => 0
        [Int] 1
        => 1
        [Int] 2
        => 2
        [Int] 1 - 2
        => -1


        """
      )
    }
  }

  func testBooleanLiteralExprSyntax() {
    captureConsoleOutput {
      #assert(true == (0 == 1) || false == (0 == 0))
    } completion: { (output) in
      actExp(
        output,
        """
        #assert(true == (0 == 1) || false == (0 == 0))
                │    │  ││ │  │  │  │     │  ││ │  │
                true │  │0 │  1  │  false │  │0 │  0
                     │  │  false false    │  │  true
                     │  false             │  true
                     false                false

        --- [Int] 0
        +++ [Int] 1
        –0
        +1

        --- [Bool] true
        +++ [Bool] (0 == 1)
        –true
        +false

        --- [Bool] false
        +++ [Bool] (0 == 0)
        –false
        +true

        [Bool] true
        => true
        [Int] 0
        => 0
        [Int] 1
        => 1
        [Bool] (0 == 1)
        => false
        [Bool] true == (0 == 1)
        => false
        [Bool] false
        => false
        [Int] 0
        => 0
        [Int] 0
        => 0
        [Bool] (0 == 0)
        => true
        [Bool] false == (0 == 0)
        => false


        """
      )
    }
  }

  func testBorrowExprSyntax() {

  }

  func testClosureExprSyntax() {
    captureConsoleOutput {
      #assert(0 == {1}())
    } completion: { (output) in
      actExp(
        output,
        """
        #assert(0 == {1}())
                │ │    │
                0 │    1
                  false

        --- [Int] 0
        +++ [Int] {1}()
        –0
        +1

        [Int] 0
        => 0
        [Int] {1}()
        => 1


        """
      )
    }
  }

  func testDictionaryExprSyntax() {
    let dict = ["1": 1] // order random, so only 1 element to avoid failure
    captureConsoleOutput {
      #assert(0 == dict["1"])
    } completion: { (output) in
      actExp(
        output,
        """
        #assert(0 == dict["1"])
                │ │  │    │  │
                0 │  │    │  Optional(1)
                  │  │    "1"
                  │  ["1": 1]
                  false

        --- [Int] 0
        +++ [Optional<Int>] dict["1"]
        –0
        +Optional(1)

        [Int] 0
        => 0
        [Optional<Int>] dict["1"]
        => Optional(1)


        """
      )
    }
  }

  func testDiscardAssignmentExprSyntax() {

  }

  func testEditorPlaceholderExprSyntax() {

  }

  /// "float" literals default to Double type
  func testFloatLiteralExprSyntax() {
    let f1 = Float(1.1)
    captureConsoleOutput {
      #assert(f1 == 1.0)
    } completion: { (output) in
      actExp(
        output,
        """
        #assert(f1 == 1.0)
                │  │  │
                │  │  1.0
                │  false
                1.1

        --- [Float] f1
        +++ [Double] 1.0
        –1.1
        +1.0

        [Float] f1
        => 1.1
        [Double] 1.0
        => 1.0


        """
      )
    }
  }

  func testFloatLiteralExponentExprSyntax() {
    let f1 = Float(1.1)
    captureConsoleOutput {
      #assert(f1 == 1.1e-1)
    } completion: { (output) in
      actExp(
        output,
        """
        #assert(f1 == 1.1e-1)
                │  │  │
                │  │  0.11
                │  false
                1.1

        --- [Float] f1
        +++ [Double] 1.1e-1
        –1.1
        +0.11

        [Float] f1
        => 1.1
        [Double] 1.1e-1
        => 0.11


        """
      )
    }
  }

  func testFloatLiteralHexExprSyntax() {
    let f1 = Float(1.1)
    captureConsoleOutput {
      #assert(f1 == 0xA.Fp-1)
    } completion: { (output) in
      actExp(
        output,
        """
        #assert(f1 == 0xA.Fp-1)
                │  │  │
                │  │  5.46875
                │  false
                1.1

        --- [Float] f1
        +++ [Double] 0xA.Fp-1
        –1.1
        +5.46875

        [Float] f1
        => 1.1
        [Double] 0xA.Fp-1
        => 5.46875


        """
      )
    }
  }

  func testFloatLiteralLeadingZeroAndDelimitedExprSyntax() {
    let f1 = Float(1.1)
    captureConsoleOutput {
      #assert(f1 == 000_100.1)
    } completion: { (output) in
      actExp(
        output,
        """
        #assert(f1 == 000_100.1)
                │  │  │
                │  │  100.1
                │  false
                1.1

        --- [Float] f1
        +++ [Double] 000_100.1
        –1.1
        +100.1

        [Float] f1
        => 1.1
        [Double] 000_100.1
        => 100.1


        """
      )
    }
  }

  func testForcedValueExprSyntax() {
    let i: Int? = 1
    captureConsoleOutput {
      #assert(0 == i!)
    } completion: { (output) in
      actExp(
        output,
        """
        #assert(0 == i!)
                │ │  ││
                0 │  │1
                  │  Optional(1)
                  false

        --- [Int] 0
        +++ [Int] i!
        –0
        +1

        [Int] 0
        => 0
        [Int] i!
        => 1


        """
      )
    }
  }

  func testFunctionCallExprSyntax() {
    func f(_ i: Int) -> String {
      "\(i)"
    }
    captureConsoleOutput {
      #assert("0" == f(1))
    } completion: { (output) in
      actExp(
        output,
        """
        #assert("0" == f(1))
                │   │  │ │
                "0" │  │ 1
                    │  "1"
                    false

        --- [String] "0"
        +++ [String] f(1)
        [-0-]{+1+}

        [String] "0"
        => "0"
        [String] f(1)
        => "1"


        """
      )
    }
  }

  func testIdentifierExprSyntax() {
    let `class` = "class"
    captureConsoleOutput {
      #assert("name" == `class`)
    } completion: { (output) in
      actExp(
        output,
        """
        #assert("name" == `class`)
                │      │  │
                "name" │  "class"
                       false

        --- [String] "name"
        +++ [String] `class`
        [-n-]{+cl+}a[-me-]{+ss+}

        [String] "name"
        => "name"
        [String] `class`
        => "class"


        """
      )
    }
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
    func io(_ i: inout Int) -> Int {
      i += 1
      return 2 * i
    }
    var i = 1
    i += 1
    // XCTExpectFailure("inout variable is constant in macro expansion")
    // macro fails compile - uncomment to observe:
    // #assert(0 == io(&i))
  }

  func testInfixOperatorExprSyntax() {
    captureConsoleOutput {
      #assert(0 == 1-2)
    } completion: { (output) in
      actExp(
        output,
        """
        #assert(0 == 1-2)
                │ │  │││
                0 │  ││2
                  │  │-1
                  │  1
                  false

        --- [Int] 0
        +++ [Int] 1-2
        –0
        +-1

        [Int] 0
        => 0
        [Int] 1
        => 1
        [Int] 2
        => 2
        [Int] 1-2
        => -1


        """
      )
    }
  }

  func testIntegerLiteralExprSyntax() {
    captureConsoleOutput {
      #assert(0 == 42)
    } completion: { (output) in
      actExp(
        output,
        """
        #assert(0 == 42)
                │ │  │
                0 │  42
                  false

        --- [Int] 0
        +++ [Int] 42
        –0
        +42

        [Int] 0
        => 0
        [Int] 42
        => 42


        """
      )
    }
  }

  func testIsExprSyntax() {

  }

  func testKeyPathExprSyntax() {
    struct S {
      let m = 42
    }
    let s = S()
    captureConsoleOutput {
      #assert(43 == s[keyPath: \S.m])
    } completion: { (output) in
      actExp(
        output,
        """
        #assert(43 == s[keyPath: \\S.m])
                │  │  │          │   │
                43 │  S(m: 42)   │   42
                   false         \\S.m

        --- [Int] 43
        +++ [Int] s[keyPath: \\S.m]
        –43
        +42

        [Int] 43
        => 43
        [Int] s[keyPath: \\S.m]
        => 42


        """
      )
    }
  }

  func testMacroExpansionExprSyntax() {

  }

  func testMemberAccessExprSyntax() {
    struct S {
      let m = 42
    }
    let s = S()
    captureConsoleOutput {
      #assert(43 == s.m)
    } completion: { (output) in
      actExp(
        output,
        """
        #assert(43 == s.m)
                │  │  │ │
                43 │  │ 42
                   │  S(m: 42)
                   false

        --- [Int] 43
        +++ [Int] s.m
        –43
        +42

        [Int] 43
        => 43
        [Int] s.m
        => 42


        """
      )
    }
  }

  func testMissingExprSyntax() {

  }

  func testMoveExprSyntax() {

  }

  func testNilLiteralExprSyntax() {
    let i0: Int? = 0
    captureConsoleOutput {
      #assert(i0 == nil)
    } completion: { (output) in
      actExp(
        output,
        """
        #assert(i0 == nil)
                │  │  │
                │  │  nil
                │  false
                Optional(0)

        --- [Optional<Int>] i0
        +++ [Optional<Int>] nil
        –Optional(0)
        +nil

        [Optional<Int>] i0
        => Optional(0)
        [Optional<Int>] nil
        => nil


        """
      )
    }
  }

  func testOptionalStringExprSyntax() {
    // RFE: avoid quotes around optional string?
    // RFE: avoid escapes before optional string literals?
    let s0: String? = "0"
    let s1: String? = "1"
    captureConsoleOutput {
      #assert(s0 == s1)
    } completion: { (output) in
      actExp(
        output,
        """
        #assert(s0 == s1)
                │  │  │
                │  │  "Optional(\\"1\\")"
                │  false
                "Optional(\\"0\\")"

        --- [Optional<String>] s0
        +++ [Optional<String>] s1
        [-0-]{+1+}

        [Optional<String>] s0
        => "Optional(\\"0\\")"
        [Optional<String>] s1
        => "Optional(\\"1\\")"


        """
      )
    }
  }

  func testOptionalIntExprSyntax() {
    let i0: Int? = 0
    let i1: Int? = 1
    captureConsoleOutput {
      #assert(i0 == i1)
    } completion: { (output) in
      actExp(
        output,
        """
        #assert(i0 == i1)
                │  │  │
                │  │  Optional(1)
                │  false
                Optional(0)

        --- [Optional<Int>] i0
        +++ [Optional<Int>] i1
        –Optional(0)
        +Optional(1)

        [Optional<Int>] i0
        => Optional(0)
        [Optional<Int>] i1
        => Optional(1)


        """
      )
    }
  }

  func testOptionalChainingExprSyntax() {
    let iNil: Int? = nil
    captureConsoleOutput {
      #assert(0 == iNil ?? 1)
    } completion: { (output) in
      actExp(
        output,
        """
        #assert(0 == iNil ?? 1)
                │ │  │    │  │
                0 │  nil  1  1
                  false

        --- [Int] 0
        +++ [Int] iNil ?? 1
        –0
        +1

        [Int] 0
        => 0
        [Optional<Int>] iNil
        => nil
        [Int] 1
        => 1
        [Int] iNil ?? 1
        => 1


        """
      )
    }
  }

  func testPackExpansionExprSyntax() {

  }

  func testPostfixIfConfigExprSyntax() {

  }

  func testPostfixUnaryExprSyntax() {
    let i: Int? = 0
    captureConsoleOutput {
      #assert(i! == 1)
    } completion: { (output) in
      actExp(
        output,
        """
        #assert(i! == 1)
                ││ │  │
                │0 │  1
                │  false
                Optional(0)

        --- [Int] i!
        +++ [Int] 1
        –0
        +1

        [Int] i!
        => 0
        [Int] 1
        => 1


        """
      )
    }
  }

  func testPrefixOperatorExprSyntax() {
    captureConsoleOutput {
      #assert(-1 == -2)
    } completion: { (output) in
      actExp(
        output,
        """
        #assert(-1 == -2)
                ││ │  ││
                │1 │  │2
                -1 │  -2
                   false

        --- [Int] -1
        +++ [Int] -2
        –-1
        +-2

        [Int] -1
        => -1
        [Int] -2
        => -2


        """
      )
    }
  }

  func testRegexLiteralExprSyntax() {

  }

  func testSequenceExprSyntax() {

  }

  func testSpecializeExprSyntax() {

  }

  func testStringLiteralExprSyntax() {
    captureConsoleOutput {
      #assert("0" == "1")
    } completion: { (output) in
      actExp(
        output,
        """
        #assert("0" == "1")
                │   │  │
                "0" │  "1"
                    false

        --- [String] "0"
        +++ [String] "1"
        [-0-]{+1+}

        [String] "0"
        => "0"
        [String] "1"
        => "1"


        """
      )
    }
  }

  func testSubscriptExprSyntax() {
    let ra = [0, 1]
    captureConsoleOutput {
      #assert(0 == ra[1])
    } completion: { (output) in
      actExp(
        output,
        """
        #assert(0 == ra[1])
                │ │  │  ││
                0 │  │  │1
                  │  │  1
                  │  [0, 1]
                  false

        --- [Int] 0
        +++ [Int] ra[1]
        –0
        +1

        [Int] 0
        => 0
        [Int] ra[1]
        => 1


        """
      )
    }
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
    func try1() throws -> String {
      "1"
    }
    captureConsoleOutput {
      #assert(try try1() == "0")
    } completion: { (output) in
      actExp(
        output,
        """
        #assert(try try1() == "0")
                    │      │  │
                    "1"    │  "0"
                           false

        --- [String] try1()
        +++ [String] "0"
        [-1-]{+0+}

        [String] try1()
        => "1"
        [String] "0"
        => "0"


        """
      )
    }
  }

  func testTupleExprSyntax() {
    captureConsoleOutput {
      #assert((0, 2) == (first: 0, second: 1))
    } completion: { (output) in
      actExp(
       output,
       """
       #assert((0, 2) == (first: 0, second: 1))
               ││  │  │  │       │          │
               │0  2  │  (0, 1)  0          1
               (0, 2) false

       --- [(Int, Int)] (0, 2)
       +++ [(Int, Int)] (first: 0, second: 1)
       –(0, 2)
       +(0, 1)

       [(Int, Int)] (0, 2)
       => (0, 2)
       [(Int, Int)] (first: 0, second: 1)
       => (0, 1)


       """
      )
    }
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
