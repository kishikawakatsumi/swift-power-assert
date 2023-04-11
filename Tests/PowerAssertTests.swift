import XCTest
@testable import PowerAssert

final class PowerAssertTests: XCTestCase {
  func testBinaryExpression1() {
    captureConsoleOutput {
      let bar = Bar(foo: Foo(val: 2), val: 3)
      #expect(bar.val != bar.foo.val, verbose: true)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #expect(bar.val != bar.foo.val)
                |   |   |  |   |   |
                |   3   |  |   |   2
                |       |  |   Foo(val: 2)
                |       |  Bar(foo: PowerAssertTests.Foo(val: 2), val: 3)
                |       true
                Bar(foo: PowerAssertTests.Foo(val: 2), val: 3)

        """
      )
    }
  }

  func testBinaryExpression2() {
    captureConsoleOutput {
      let bar = Bar(foo: Foo(val: 2), val: 3)
      #expect(bar.val > bar.foo.val, verbose: true)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #expect(bar.val > bar.foo.val)
                |   |   | |   |   |
                |   3   | |   |   2
                |       | |   Foo(val: 2)
                |       | Bar(foo: PowerAssertTests.Foo(val: 2), val: 3)
                |       true
                Bar(foo: PowerAssertTests.Foo(val: 2), val: 3)

        """
      )
    }
  }

  func testBinaryExpression3() {
    captureConsoleOutput {
      let zero = 0
      let one = 1
      let two = 2
      let three = 3

      let array = [one, two, three]
      #expect(array.firstIndex(of: zero) != two, verbose: true)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #expect(array.firstIndex(of: zero) != two)
                |     |              |     |  |
                |     nil            0     |  Optional(2)
                [1, 2, 3]                  true

        """
      )
    }
  }

  func testBinaryExpression4() {
    captureConsoleOutput {
      let one = 1
      let two = 2
      let three = 3

      let array = [one, two, three]
      #expect(array.description.hasPrefix("[") == true && array.description.hasPrefix("Hello") == false, verbose: true)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #expect(array.description.hasPrefix("[") == true && array.description.hasPrefix("Hello") == false)
                |     |           |         |    |  |    |  |     |           |         |        |  |
                |     "[1, 2, 3]" true      "["  |  true |  |     "[1, 2, 3]" false     "Hello"  |  false
                [1, 2, 3]                        true    |  [1, 2, 3]                            true
                                                         true

        """
      )
    }
  }

  func testBinaryExpression5() {
    captureConsoleOutput {
      let zero = 0
      let one = 1
      let two = 2
      let three = 3

      let array = [one, two, three]

      let bar = Bar(foo: Foo(val: 2), val: 3)
      #expect(array.firstIndex(of: zero) != two && bar.val != bar.foo.val, verbose: true)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #expect(array.firstIndex(of: zero) != two && bar.val != bar.foo.val)
                |     |              |     |  |   |  |   |   |  |   |   |
                |     nil            0     |  |   |  |   3   |  |   |   2
                [1, 2, 3]                  |  |   |  |       |  |   Foo(val: 2)
                                           |  |   |  |       |  Bar(foo: PowerAssertTests.Foo(val: 2), val: 3)
                                           |  |   |  |       true
                                           |  |   |  Bar(foo: PowerAssertTests.Foo(val: 2), val: 3)
                                           |  |   true
                                           |  Optional(2)
                                           true

        """
      )
    }
  }

  func testBinaryExpression6() {
    captureConsoleOutput {
      let one = 1
      let two = 2
      let three = 3

      let array = [one, two, three]
      #expect(array.distance(from: 2, to: 3) == 1, verbose: true)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #expect(array.distance(from: 2, to: 3) == 1)
                |     |              |      |  |  |
                |     1              2      3  |  1
                [1, 2, 3]                      true

        """
      )
    }
  }

  func testBinaryExpression7() {
    captureConsoleOutput {
      let one = 1
      let two = 2
      let three = 3

      #expect([one, two, three].count == 3, verbose: true)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #expect([one, two, three].count == 3)
                ||    |    |      |     |  |
                |1    2    3      3     |  3
                [1, 2, 3]               true

        """
      )
    }
  }

  func testBinaryExpression8() {
    captureConsoleOutput {
      let alice = Person(name: "alice", age: 3)
      let bob = Person(name: "bob", age: 5)
      let index = 7

      let types: [Any?] = ["string", 98.6, true, false, nil, Double.nan, Double.infinity, alice]

      let object = Object(types: types)

      #expect((object.types[index] as! Person).name != bob.name, verbose: true)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #expect((object.types[index] as! Person).name != bob.name)
                ||      |     |    | |           |    |  |   |
                ||      |     7    | |           |    |  |   "bob"
                ||      |          | |           |    |  Person(name: "bob", age: 5)
                ||      |          | |           |    true
                ||      |          | |           "alice"
                ||      |          | Person(name: "alice", age: 3)
                ||      |          Optional(PowerAssertTests.Person(name: "alice", age: 3))
                ||      [Optional("string"), Optional(98.6), Optional(true), Optional(false), nil, Optional(nan), Optional(inf), Optional(PowerAssertTests.Person(name: "alice", age: 3))]
                |Object(types: [Optional("string"), Optional(98.6), Optional(true), Optional(false), nil, Optional(nan), Optional(inf), Optional(PowerAssertTests.Person(name: "alice", age: 3))])
                Person(name: "alice", age: 3)

        """
      )
    }
  }

  func testBinaryExpression9() {
    captureConsoleOutput {
      let one = 1
      let two = 2
      let three = 3

      let array = [one, two, three]
      #expect(array.description.hasPrefix("]") == true || array.description.hasPrefix("Hello") == false, verbose: true)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #expect(array.description.hasPrefix("]") == true || array.description.hasPrefix("Hello") == false)
                |     |           |         |    |  |    |  |     |           |         |        |  |
                |     "[1, 2, 3]" false     "]"  |  true |  |     "[1, 2, 3]" false     "Hello"  |  false
                [1, 2, 3]                        false   |  [1, 2, 3]                            true
                                                         true

        """
      )
    }
  }

  func testMultilineExpression1() {
    captureConsoleOutput {
      let bar = Bar(foo: Foo(val: 2), val: 3)

      #expect(bar.val != bar.foo.val, verbose: true)
      #expect(bar
        .val !=
             bar.foo.val, verbose: true)
      #expect(bar
        .val !=
             bar
        .foo        .val, verbose: true)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #expect(bar.val != bar.foo.val)
                |   |   |  |   |   |
                |   3   |  |   |   2
                |       |  |   Foo(val: 2)
                |       |  Bar(foo: PowerAssertTests.Foo(val: 2), val: 3)
                |       true
                Bar(foo: PowerAssertTests.Foo(val: 2), val: 3)
        #expect(bar .val != bar.foo.val)
                |    |   |  |   |   |
                |    3   |  |   |   2
                |        |  |   Foo(val: 2)
                |        |  Bar(foo: PowerAssertTests.Foo(val: 2), val: 3)
                |        true
                Bar(foo: PowerAssertTests.Foo(val: 2), val: 3)
        #expect(bar .val != bar .foo .val)
                |    |   |  |    |    |
                |    3   |  |    |    2
                |        |  |    Foo(val: 2)
                |        |  Bar(foo: PowerAssertTests.Foo(val: 2), val: 3)
                |        true
                Bar(foo: PowerAssertTests.Foo(val: 2), val: 3)

        """
      )
    }
  }

  func testMultilineExpression2() {
    captureConsoleOutput {
      let zero = 0
      let one = 1
      let two = 2
      let three = 3
      let array = [one, two, three]

      #expect(array    .        firstIndex(
        of:    zero)
             != two,
                   verbose: true
      )

      #expect(array
        .
                   firstIndex(

              of:
                zero)
             != two

                   ,     verbose: true
      )

      #expect(array
        .firstIndex(
          of:
            zero)
             != two,

                   verbose: true
      )
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #expect(array . firstIndex( of: zero) != two)
                |       |               |     |  |
                |       nil             0     |  Optional(2)
                [1, 2, 3]                     true
        #expect(array . firstIndex( of: zero) != two)
                |       |               |     |  |
                |       nil             0     |  Optional(2)
                [1, 2, 3]                     true
        #expect(array .firstIndex( of: zero) != two)
                |      |               |     |  |
                |      nil             0     |  Optional(2)
                [1, 2, 3]                    true

        """
      )
    }
  }

  func testMultilineExpression3() {
    captureConsoleOutput {
      let one = 1
      let two = 2
      let three = 3

      let array = [one, two, three]
      #expect(array
        .description
        .hasPrefix(    "["
                  )
             == true && array
        .description
        .hasPrefix    ("Hello"    ) ==
             false
             , verbose: true)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #expect(array .description .hasPrefix( "[" ) == true && array .description .hasPrefix ("Hello" ) == false)
                |      |            |          |     |  |    |  |      |            |          |         |  |
                |      "[1, 2, 3]"  true       "["   |  true |  |      "[1, 2, 3]"  false      "Hello"   |  false
                [1, 2, 3]                            true    |  [1, 2, 3]                                true
                                                             true

        """
      )
    }
  }

  func testMultilineExpression4() {
    captureConsoleOutput {
      let zero = 0
      let one = 1
      let two = 2
      let three = 3

      let array = [one, two, three]

      let bar = Bar(foo: Foo(val: 2), val: 3)

      #expect(

        array.firstIndex(
          of: zero
        )
        !=
        two
        &&
        bar
          .val
        != bar
          .foo
          .val
        , verbose: true)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #expect(array.firstIndex( of: zero ) != two && bar .val != bar .foo .val)
                |     |               |      |  |   |  |    |   |  |    |    |
                |     nil             0      |  |   |  |    3   |  |    |    2
                [1, 2, 3]                    |  |   |  |        |  |    Foo(val: 2)
                                             |  |   |  |        |  Bar(foo: PowerAssertTests.Foo(val: 2), val: 3)
                                             |  |   |  |        true
                                             |  |   |  Bar(foo: PowerAssertTests.Foo(val: 2), val: 3)
                                             |  |   true
                                             |  Optional(2)
                                             true

        """
      )
    }
  }

  func testMultilineExpression5() {
    captureConsoleOutput {
      let one = 1
      let two = 2
      let three = 3

      let array = [one, two, three]
      #expect(

        array
          .distance(
            from: 2,
            to: 3)
        != 4
        , verbose: true)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #expect(array .distance( from: 2, to: 3) != 4)
                |      |               |      |  |  |
                |      1               2      3  |  4
                [1, 2, 3]                        true

        """
      )
    }
  }

  func testMultilineExpression6() {
    captureConsoleOutput {
      let one = 1
      let two = 2
      let three = 3

      #expect([one,
              two
              , three]
        .count
             != 10
                   , verbose: true)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #expect([one, two , three] .count != 10)
                ||    |     |       |     |  |
                |1    2     3       3     |  10
                [1, 2, 3]                 true

        """
      )
    }
  }

  func testTryExpression() {
    captureConsoleOutput {
      let landmark = Landmark(
        name: "Tokyo Tower",
        foundingYear: 1957,
        location: Coordinate(latitude: 35.658581, longitude: 139.745438)
      )

      #expect(
        try! JSONEncoder().encode(landmark) != #"{"name":"Tokyo Tower"}"#.data(using: String.Encoding.utf8),
        verbose: true
      )
      #expect(
        try! JSONEncoder().encode(landmark) == #"{"name":"Tokyo Tower","location":{"longitude":139.74543800000001,"latitude":35.658580999999998},"foundingYear":1957}"#.data(using: .utf8),
        verbose: true
      )
      #expect(
        try! #"{"name":"Tokyo Tower"}"#.data(using: String.Encoding.utf8) != JSONEncoder().encode(landmark),
        verbose: true
      )
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        #"""
        #expect(try! JSONEncoder().encode(landmark) != #"{"name":"Tokyo Tower"}"#.data(using: String.Encoding.utf8))
                     |             |      |         |  |                          |           |      |        |
                     |             |      |         |  |                          |           String Encoding Unicode (UTF-8)
                     |             |      |         |  |                          Optional(22 bytes)
                     |             |      |         |  "{\"name\":\"Tokyo Tower\"}"
                     |             |      |         true
                     |             |      Landmark(name: "Tokyo Tower", foundingYear: 1957, location: PowerAssertTests.Coordinate(latitude: 35.658581, longitude: 139.745438))
                     |             Optional(116 bytes)
                     Foundation.JSONEncoder
        #expect(try! JSONEncoder().encode(landmark) == #"{"name":"Tokyo Tower","location":{"longitude":139.74543800000001,"latitude":35.658580999999998},"foundingYear":1957}"#.data(using: .utf8))
                     |             |      |         |  |                                                                                                                        |            |
                     |             |      |         |  |                                                                                                                        |            Unicode (UTF-8)
                     |             |      |         |  |                                                                                                                        Optional(116 bytes)
                     |             |      |         |  "{\"name\":\"Tokyo Tower\",\"location\":{\"longitude\":139.74543800000001,\"latitude\":35.658580999999998},\"foundingYear\":1957}"
                     |             |      |         true
                     |             |      Landmark(name: "Tokyo Tower", foundingYear: 1957, location: PowerAssertTests.Coordinate(latitude: 35.658581, longitude: 139.745438))
                     |             Optional(116 bytes)
                     Foundation.JSONEncoder
        #expect(try! #"{"name":"Tokyo Tower"}"#.data(using: String.Encoding.utf8) != JSONEncoder().encode(landmark))
                     |                          |           |      |        |     |  |             |      |
                     |                          |           String Encoding |     |  |             |      Landmark(name: "Tokyo Tower", foundingYear: 1957, location: PowerAssertTests.Coordinate(latitude: 35.658581, longitude: 139.745438))
                     |                          Optional(22 bytes)          |     |  |             Optional(116 bytes)
                     "{\"name\":\"Tokyo Tower\"}"                           |     |  Foundation.JSONEncoder
                                                                            |     true
                                                                            Unicode (UTF-8)

        """#
      )
    }
  }

  func testNilLiteral() {
    captureConsoleOutput {
      let string = "1234"
      let number = Int(string)

      #expect(number != nil && number == 1234, verbose: true)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #expect(number != nil && number == 1234)
                |      |  |   |  |      |  |
                |      |  nil |  |      |  Optional(1234)
                |      true   |  |      true
                |             |  Optional(1234)
                |             true
                Optional(1234)

        """
      )
    }
  }

  func testTernaryConditionalOperator1() {
    captureConsoleOutput {
      let string = "1234"
      let number = Int(string)
      let hello = "hello"

      #expect((number != nil ? string : hello) == string, verbose: true)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #expect((number != nil ? string : hello) == string)
                |||     |  |     |               |  |
                ||"1234"|  nil   "1234"          |  "1234"
                ||      true                     true
                |Optional(1234)
                "1234"

        """
      )
    }
  }

  func testTernaryConditionalOperator2() {
    captureConsoleOutput {
      let string = "1234"
      let number = Int(string)
      let hello = "hello"

      #expect((number == nil ? string : hello) != string, verbose: true)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #expect((number == nil ? string : hello) != string)
                |||     |  |              |      |  |
                |||     |  nil            |      |  "1234"
                |||     false             |      true
                ||"hello"                 "hello"
                |Optional(1234)
                "hello"

        """
      )
    }
  }

  func testArrayLiteralExpression() {
    captureConsoleOutput {
      let zero = 0
      let one = 1
      let two = 2
      let three = 3

      #expect([one, two, three].firstIndex(of: zero) != two, verbose: true)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #expect([one, two, three].firstIndex(of: zero) != two)
                ||    |    |      |              |     |  |
                |1    2    3      nil            0     |  Optional(2)
                [1, 2, 3]                              true

        """
      )
    }
  }

  func testDictionaryLiteralExpression() {
    captureConsoleOutput {
      let zero = 0
      let one = 1
      let two = 2
      let three = 3

      #expect([zero: one, two: three].count != three, verbose: true)
    } completion: { (output) in
      print(output)
      // Dictionary order is not guaranteed
      XCTAssertTrue(
        output ==
        """
        #expect([zero: one, two: three].count != three)
                ||     |    |    |      |     |  |
                |0     1    2    3      2     |  3
                [0: 1, 2: 3]                  true

        """
        ||
        output ==
        """
        #expect([zero: one, two: three].count != three)
                ||     |    |    |      |     |  |
                |0     1    2    3      2     |  3
                [2: 3, 0: 1]                  true

        """
      )
    }
  }

  func testMagicLiteralExpression1() {
    captureConsoleOutput {
      #expect(
        #file != "*.swift" && #line != 1 && #column != 2 && #function != "function",
        verbose: true
      )
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #expect(#file != "*.swift" && #line != 1 && #column != 2 && #function != "function")
                |     |  |         |  |     |  | |  |       |  | |  |         |  |
                |     |  "*.swift" |  3     |  1 |  250     |  2 |  |         |  "function"
                |     true         true     true true       true |  |         true
                |                                                |  "testMagicLiteralExpression1()"
                |                                                true
                "@__swiftmacro_16PowerAssertTestsAAC27testMagicLiteralExpression1yyFXefU_6expectfMf_.swift"

        """
      )
    }
  }

  func testMagicLiteralExpression2() {
    captureConsoleOutput {
      #expect(
        #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1) != .blue &&
          .blue != #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1),
        verbose: true
      )
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #expect(#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1) != .blue && .blue != #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1))
                |                  |                    |                    |                    |  |   |    |   |    |  |                  |                    |                    |                    |
                |                  0.80784315           0.02745098           0.33333334           |  |   |    |   |    |  |                  0.80784315           0.02745098           0.33333334           1.0
                sRGB IEC61966-2.1 colorspace 0.807843 0.027451 0.333333 1                         |  |   |    |   |    |  sRGB IEC61966-2.1 colorspace 0.807843 0.027451 0.333333 1
                                                                                                  |  |   |    |   |    true
                                                                                                  |  |   |    |   sRGB IEC61966-2.1 colorspace 0 0 1 1
                                                                                                  |  |   |    true
                                                                                                  |  |   sRGB IEC61966-2.1 colorspace 0 0 1 1
                                                                                                  |  true
                                                                                                  1.0

        """
      )
    }
  }

  func testSelfExpression() {
    captureConsoleOutput {
      #expect(
        self.stringValue == "string" && self.intValue == 100 && self.doubleValue == 999.9,
        verbose: true
      )
      #expect(super.continueAfterFailure == true, verbose: true)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #expect(self.stringValue == "string" && self.intValue == 100 && self.doubleValue == 999.9)
                |    |           |  |        |  |    |        |  |   |  |    |           |  |
                |    "string"    |  "string" |  |    100      |  100 |  |    999.9       |  999.9
                |                true        |  |             true   |  |                true
                |                            |  |                    |  -[PowerAssertTests testSelfExpression]
                |                            |  |                    true
                |                            |  -[PowerAssertTests testSelfExpression]
                |                            true
                -[PowerAssertTests testSelfExpression]
        #expect(super.continueAfterFailure == true)
                      |                    |  |
                      true                 |  true
                                           true

        """
      )
    }
  }

  func testImplicitMemberExpression() {
    captureConsoleOutput {
      let i = 64
      #expect(i == .bitWidth && i == Double.Exponent.bitWidth, verbose: true)

      let mask: CAAutoresizingMask = [.layerMaxXMargin, .layerMaxYMargin]
      #expect(mask == [CAAutoresizingMask.layerMaxXMargin, CAAutoresizingMask.layerMaxYMargin], verbose: true)

      #expect(mask == [CAAutoresizingMask.layerMaxXMargin, .layerMaxYMargin], verbose: true)

      #expect(mask == [.layerMaxXMargin, CAAutoresizingMask.layerMaxYMargin], verbose: true)

      #expect(mask == [.layerMaxXMargin, .layerMaxYMargin], verbose: true)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #expect(i == .bitWidth && i == Double.Exponent.bitWidth)
                | |   |        |  | |  |      |        |
                | |   64       |  | |  Double Int      64
                | true         |  | true
                64             |  64
                               true
        #expect(mask == [CAAutoresizingMask.layerMaxXMargin, CAAutoresizingMask.layerMaxYMargin])
                |    |  ||                  |                |                  |
                |    |  |CAAutoresizingMask |                CAAutoresizingMask CAAutoresizingMask(rawValue: 32)
                |    |  |                   CAAutoresizingMask(rawValue: 4)
                |    |  CAAutoresizingMask(rawValue: 36)
                |    true
                CAAutoresizingMask(rawValue: 36)
        #expect(mask == [CAAutoresizingMask.layerMaxXMargin, .layerMaxYMargin])
                |    |  ||                  |                 |
                |    |  |CAAutoresizingMask |                 CAAutoresizingMask(rawValue: 32)
                |    |  |                   CAAutoresizingMask(rawValue: 4)
                |    |  CAAutoresizingMask(rawValue: 36)
                |    true
                CAAutoresizingMask(rawValue: 36)
        #expect(mask == [.layerMaxXMargin, CAAutoresizingMask.layerMaxYMargin])
                |    |  | |                |                  |
                |    |  | |                CAAutoresizingMask CAAutoresizingMask(rawValue: 32)
                |    |  | CAAutoresizingMask(rawValue: 4)
                |    |  CAAutoresizingMask(rawValue: 36)
                |    true
                CAAutoresizingMask(rawValue: 36)
        #expect(mask == [.layerMaxXMargin, .layerMaxYMargin])
                |    |  | |                 |
                |    |  | |                 CAAutoresizingMask(rawValue: 32)
                |    |  | CAAutoresizingMask(rawValue: 4)
                |    |  CAAutoresizingMask(rawValue: 36)
                |    true
                CAAutoresizingMask(rawValue: 36)

        """
      )
    }
  }

  func testTupleExpression() {
    captureConsoleOutput {
      let dc1 = DateComponents(
        calendar: Calendar(identifier: .gregorian), timeZone: TimeZone(abbreviation: "JST")!, year: 1980, month: 10, day: 28
      )
      let date1 = dc1.date!
      let dc2 = DateComponents(
        calendar: Calendar(identifier: .gregorian), timeZone: TimeZone(abbreviation: "JST")!, year: 2000, month: 12, day: 31
      )
      let date2 = dc2.date!

      let tuple = (name: "Katsumi", age: 37, birthday: date1)

      #expect(tuple != (name: "Katsumi", age: 37, birthday: date2), verbose: true)
      #expect(tuple != ("Katsumi", 37, date2), verbose: true)
      #expect(tuple.name == ("Katsumi", 37, date2).0 || tuple.age != ("Katsumi", 37, date2).1, verbose: true)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #expect(tuple != (name: "Katsumi", age: 37, birthday: date2))
                |     |  |      |               |             |
                |     |  |      "Katsumi"       37            2000-12-30 15:00:00 +0000
                |     |  ("Katsumi", 37, 2000-12-30 15:00:00 +0000)
                |     true
                ("Katsumi", 37, 1980-10-27 15:00:00 +0000)
        #expect(tuple != ("Katsumi", 37, date2))
                |     |  ||          |   |
                |     |  |"Katsumi"  37  2000-12-30 15:00:00 +0000
                |     |  ("Katsumi", 37, 2000-12-30 15:00:00 +0000)
                |     true
                ("Katsumi", 37, 1980-10-27 15:00:00 +0000)
        #expect(tuple.name == ("Katsumi", 37, date2).0 || tuple.age != ("Katsumi", 37, date2).1)
                |     |    |  ||          |   |      | |
                |     |    |  |"Katsumi"  37  |      | true
                |     |    |  |               |      "Katsumi"
                |     |    |  |               2000-12-30 15:00:00 +0000
                |     |    |  ("Katsumi", 37, 2000-12-30 15:00:00 +0000)
                |     |    true
                |     "Katsumi"
                (name: "Katsumi", age: 37, birthday: 1980-10-27 15:00:00 +0000)

        """
      )
    }
  }

  func testKeyPathExpression() {
    captureConsoleOutput {
      let s = SomeStructure(someValue: 12)
      let pathToProperty = \SomeStructure.someValue

      #expect(s[keyPath: pathToProperty] == 12, verbose: true)
      #expect(s[keyPath: \SomeStructure.someValue] == 12, verbose: true)
      #expect(s.getValue(keyPath: \.someValue) == 12, verbose: true)

      let nested = OuterStructure(someValue: 24)
      let nestedKeyPath = \OuterStructure.outer.someValue

      #expect(nested[keyPath: nestedKeyPath] == 24, verbose: true)
      #expect(nested[keyPath: \OuterStructure.outer.someValue] == 24, verbose: true)
      #expect(nested.getValue(keyPath: \.outer.someValue) == 24, verbose: true)
    } completion: { (output) in
      print(output)

      if ProcessInfo.processInfo.environment["CI"] == "true" {
        XCTAssertEqual(
          output,
          #"""
          #expect(s[keyPath: pathToProperty] == 12)
                  |          |             | |  |
                  |          |             | |  12
                  |          |             | true
                  |          |             12
                  |          Swift.WritableKeyPath<PowerAssertTests.SomeStructure, Swift.Int>
                  SomeStructure(someValue: 12)
          #expect(s[keyPath: \SomeStructure.someValue] == 12)
                  |          |                       | |  |
                  |          |                       | |  12
                  |          |                       | true
                  |          |                       12
                  |          Swift.WritableKeyPath<PowerAssertTests.SomeStructure, Swift.Int>
                  SomeStructure(someValue: 12)
          #expect(s.getValue(keyPath: \.someValue) == 12)
                  | |                 |            |  |
                  | 12                |            |  12
                  |                   |            true
                  |                   Swift.WritableKeyPath<PowerAssertTests.SomeStructure, Swift.Int>
                  SomeStructure(someValue: 12)
          #expect(nested[keyPath: nestedKeyPath] == 24)
                  |               |            | |  |
                  |               |            | |  24
                  |               |            | true
                  |               |            24
                  |               Swift.WritableKeyPath<PowerAssertTests.OuterStructure, Swift.Int>
                  OuterStructure(outer: PowerAssertTests.SomeStructure(someValue: 24))
          #expect(nested[keyPath: \OuterStructure.outer.someValue] == 24)
                  |               |                              | |  |
                  |               |                              | |  24
                  |               |                              | true
                  |               |                              24
                  |               Swift.WritableKeyPath<PowerAssertTests.OuterStructure, Swift.Int>
                  OuterStructure(outer: PowerAssertTests.SomeStructure(someValue: 24))
          #expect(nested.getValue(keyPath: \.outer.someValue) == 24)
                  |      |                 |                  |  |
                  |      24                |                  |  24
                  |                        |                  true
                  |                        Swift.WritableKeyPath<PowerAssertTests.OuterStructure, Swift.Int>
                  OuterStructure(outer: PowerAssertTests.SomeStructure(someValue: 24))

          """#
        )
      } else {
        XCTAssertEqual(
          output,
          #"""
          #expect(s[keyPath: pathToProperty] == 12)
                  |          |             | |  |
                  |          |             | |  12
                  |          |             | true
                  |          |             12
                  |          \SomeStructure.someValue
                  SomeStructure(someValue: 12)
          #expect(s[keyPath: \SomeStructure.someValue] == 12)
                  |          |                       | |  |
                  |          |                       | |  12
                  |          |                       | true
                  |          |                       12
                  |          \SomeStructure.someValue
                  SomeStructure(someValue: 12)
          #expect(s.getValue(keyPath: \.someValue) == 12)
                  | |                 |            |  |
                  | 12                |            |  12
                  |                   |            true
                  |                   \SomeStructure.someValue
                  SomeStructure(someValue: 12)
          #expect(nested[keyPath: nestedKeyPath] == 24)
                  |               |            | |  |
                  |               |            | |  24
                  |               |            | true
                  |               |            24
                  |               \OuterStructure.outer.someValue
                  OuterStructure(outer: PowerAssertTests.SomeStructure(someValue: 24))
          #expect(nested[keyPath: \OuterStructure.outer.someValue] == 24)
                  |               |                              | |  |
                  |               |                              | |  24
                  |               |                              | true
                  |               |                              24
                  |               \OuterStructure.outer.someValue
                  OuterStructure(outer: PowerAssertTests.SomeStructure(someValue: 24))
          #expect(nested.getValue(keyPath: \.outer.someValue) == 24)
                  |      |                 |                  |  |
                  |      24                |                  |  24
                  |                        |                  true
                  |                        \OuterStructure.outer.someValue
                  OuterStructure(outer: PowerAssertTests.SomeStructure(someValue: 24))

          """#
        )
      }
    }
  }

  func testSubscriptKeyPathExpression1() {
    captureConsoleOutput {
      let greetings = ["hello", "hola", "bonjour", "안녕"]

      #expect(greetings[keyPath: \[String].[1]] == "hola", verbose: true)
      #expect(greetings[keyPath: \[String].first?.count] == 5, verbose: true)
    } completion: { (output) in
      print(output)
      if ProcessInfo.processInfo.environment["CI"] == "true" {
        XCTAssertEqual(
          output,
          #"""
          #expect(greetings[keyPath: \[String].[1]] == "hola")
                  |                  |          | | |  |
                  |                  |          1 | |  "hola"
                  |                  |            | true
                  |                  |            "hola"
                  |                  Swift.WritableKeyPath<Swift.Array<Swift.String>, Swift.String>
                  ["hello", "hola", "bonjour", "안녕"]
          #expect(greetings[keyPath: \[String].first?.count] == 5)
                  |                  |                     | |  |
                  |                  |                     | |  Optional(5)
                  |                  |                     | true
                  |                  |                     Optional(5)
                  |                  Swift.KeyPath<Swift.Array<Swift.String>, Swift.Optional<Swift.Int>>
                  ["hello", "hola", "bonjour", "안녕"]

          """#
        )
      } else {
        XCTAssertEqual(
          output,
          #"""
          #expect(greetings[keyPath: \[String].[1]] == "hola")
                  |                  |          | | |  |
                  |                  |          1 | |  "hola"
                  |                  |            | true
                  |                  |            "hola"
                  |                  \Array<String>.<computed 0x00000001a128ad3c (String)>
                  ["hello", "hola", "bonjour", "안녕"]
          #expect(greetings[keyPath: \[String].first?.count] == 5)
                  |                  |                     | |  |
                  |                  |                     | |  Optional(5)
                  |                  |                     | true
                  |                  |                     Optional(5)
                  |                  \Array<String>.first?.count?
                  ["hello", "hola", "bonjour", "안녕"]

          """#
        )
      }
    }
  }

//  func testSubscriptKeyPathExpression2() {
//    captureConsoleOutput {
//      let interestingNumbers = [
//        "prime": [2, 3, 5, 7, 11, 13, 15],
//        "triangular": [1, 3, 6, 10, 15, 21, 28],
//        "hexagonal": [1, 6, 15, 28, 45, 66, 91]
//      ]
//      #powerAssert(
//        interestingNumbers[keyPath: \[String: [Int]].["prime"]]! == [2, 3, 5, 7, 11, 13, 15],
//        verbose: true
//      )
//    } completion: { (output) in
//      print(output)
//      if ProcessInfo.processInfo.environment["CI"] == "true" {
//        // Dictionary order is not guaranteed
//        XCTAssertTrue(
//          output ==
//          #"""
//          #powerAssert(interestingNumbers[keyPath: \[String: [Int]].["prime"]]! == [2, 3, 5, 7, 11, 13, 15])
//                       ||                          ||        |      ||       |  |  ||  |  |  |  |   |   |
//                       ||                          ||        |      |"prime" |  |  |2  3  5  7  11  13  15
//                       ||                          ||        |      |        |  |  [2, 3, 5, 7, 11, 13, 15]
//                       ||                          ||        |      |        |  true
//                       ||                          ||        |      |        [2, 3, 5, 7, 11, 13, 15]
//                       ||                          ||        |      ["prime"]
//                       ||                          ||        Array<Int>
//                       ||                          |Dictionary<String, Array<Int>>
//                       ||                          Swift.WritableKeyPath<Swift.Dictionary<Swift.String, Swift.Array<Swift.Int>>, Swift.Optional<Swift.Array<Swift.Int>>>
//                       |["prime": [2, 3, 5, 7, 11, 13, 15], "hexagonal": [1, 6, 15, 28, 45, 66, 91], "triangular": [1, 3, 6, 10, 15, 21, 28]]
//                       [2, 3, 5, 7, 11, 13, 15]
//
//          """#
//          ||
//          output ==
//          #"""
//          #powerAssert(interestingNumbers[keyPath: \[String: [Int]].["prime"]]! == [2, 3, 5, 7, 11, 13, 15])
//                       ||                          ||        |      ||       |  |  ||  |  |  |  |   |   |
//                       ||                          ||        |      |"prime" |  |  |2  3  5  7  11  13  15
//                       ||                          ||        |      |        |  |  [2, 3, 5, 7, 11, 13, 15]
//                       ||                          ||        |      |        |  true
//                       ||                          ||        |      |        [2, 3, 5, 7, 11, 13, 15]
//                       ||                          ||        |      ["prime"]
//                       ||                          ||        Array<Int>
//                       ||                          |Dictionary<String, Array<Int>>
//                       ||                          Swift.WritableKeyPath<Swift.Dictionary<Swift.String, Swift.Array<Swift.Int>>, Swift.Optional<Swift.Array<Swift.Int>>>
//                       |["prime": [2, 3, 5, 7, 11, 13, 15], "triangular": [1, 3, 6, 10, 15, 21, 28], "hexagonal": [1, 6, 15, 28, 45, 66, 91]]
//                       [2, 3, 5, 7, 11, 13, 15]
//
//          """#
//          ||
//          output ==
//          #"""
//          #powerAssert(interestingNumbers[keyPath: \[String: [Int]].["prime"]]! == [2, 3, 5, 7, 11, 13, 15])
//                       ||                          ||        |      ||       |  |  ||  |  |  |  |   |   |
//                       ||                          ||        |      |"prime" |  |  |2  3  5  7  11  13  15
//                       ||                          ||        |      |        |  |  [2, 3, 5, 7, 11, 13, 15]
//                       ||                          ||        |      |        |  true
//                       ||                          ||        |      |        [2, 3, 5, 7, 11, 13, 15]
//                       ||                          ||        |      ["prime"]
//                       ||                          ||        Array<Int>
//                       ||                          |Dictionary<String, Array<Int>>
//                       ||                          Swift.WritableKeyPath<Swift.Dictionary<Swift.String, Swift.Array<Swift.Int>>, Swift.Optional<Swift.Array<Swift.Int>>>
//                       |["hexagonal": [1, 6, 15, 28, 45, 66, 91], "prime": [2, 3, 5, 7, 11, 13, 15], "triangular": [1, 3, 6, 10, 15, 21, 28]]
//                       [2, 3, 5, 7, 11, 13, 15]
//
//          """#
//          ||
//          output ==
//          #"""
//          #powerAssert(interestingNumbers[keyPath: \[String: [Int]].["prime"]]! == [2, 3, 5, 7, 11, 13, 15])
//                       ||                          ||        |      ||       |  |  ||  |  |  |  |   |   |
//                       ||                          ||        |      |"prime" |  |  |2  3  5  7  11  13  15
//                       ||                          ||        |      |        |  |  [2, 3, 5, 7, 11, 13, 15]
//                       ||                          ||        |      |        |  true
//                       ||                          ||        |      |        [2, 3, 5, 7, 11, 13, 15]
//                       ||                          ||        |      ["prime"]
//                       ||                          ||        Array<Int>
//                       ||                          |Dictionary<String, Array<Int>>
//                       ||                          Swift.WritableKeyPath<Swift.Dictionary<Swift.String, Swift.Array<Swift.Int>>, Swift.Optional<Swift.Array<Swift.Int>>>
//                       |["hexagonal": [1, 6, 15, 28, 45, 66, 91], "triangular": [1, 3, 6, 10, 15, 21, 28], "prime": [2, 3, 5, 7, 11, 13, 15]]
//                       [2, 3, 5, 7, 11, 13, 15]
//
//          """#
//          ||
//          output ==
//          #"""
//          #powerAssert(interestingNumbers[keyPath: \[String: [Int]].["prime"]]! == [2, 3, 5, 7, 11, 13, 15])
//                       ||                          ||        |      ||       |  |  ||  |  |  |  |   |   |
//                       ||                          ||        |      |"prime" |  |  |2  3  5  7  11  13  15
//                       ||                          ||        |      |        |  |  [2, 3, 5, 7, 11, 13, 15]
//                       ||                          ||        |      |        |  true
//                       ||                          ||        |      |        [2, 3, 5, 7, 11, 13, 15]
//                       ||                          ||        |      ["prime"]
//                       ||                          ||        Array<Int>
//                       ||                          |Dictionary<String, Array<Int>>
//                       ||                          Swift.WritableKeyPath<Swift.Dictionary<Swift.String, Swift.Array<Swift.Int>>, Swift.Optional<Swift.Array<Swift.Int>>>
//                       |["triangular": [1, 3, 6, 10, 15, 21, 28], "prime": [2, 3, 5, 7, 11, 13, 15], "hexagonal": [1, 6, 15, 28, 45, 66, 91]]
//                       [2, 3, 5, 7, 11, 13, 15]
//
//          """#
//          ||
//          output ==
//          #"""
//          #powerAssert(interestingNumbers[keyPath: \[String: [Int]].["prime"]]! == [2, 3, 5, 7, 11, 13, 15])
//                       ||                          ||        |      ||       |  |  ||  |  |  |  |   |   |
//                       ||                          ||        |      |"prime" |  |  |2  3  5  7  11  13  15
//                       ||                          ||        |      |        |  |  [2, 3, 5, 7, 11, 13, 15]
//                       ||                          ||        |      |        |  true
//                       ||                          ||        |      |        [2, 3, 5, 7, 11, 13, 15]
//                       ||                          ||        |      ["prime"]
//                       ||                          ||        Array<Int>
//                       ||                          |Dictionary<String, Array<Int>>
//                       ||                          Swift.WritableKeyPath<Swift.Dictionary<Swift.String, Swift.Array<Swift.Int>>, Swift.Optional<Swift.Array<Swift.Int>>>
//                       |["triangular": [1, 3, 6, 10, 15, 21, 28], "hexagonal": [1, 6, 15, 28, 45, 66, 91], "prime": [2, 3, 5, 7, 11, 13, 15]]
//                       [2, 3, 5, 7, 11, 13, 15]
//
//          """#
//        )
//      } else {
//        // Dictionary order is not guaranteed
//        XCTAssertTrue(
//          output ==
//          #"""
//          #powerAssert(interestingNumbers[keyPath: \[String: [Int]].["prime"]]! == [2, 3, 5, 7, 11, 13, 15])
//                       ||                          ||        |      ||       |  |  ||  |  |  |  |   |   |
//                       ||                          ||        |      |"prime" |  |  |2  3  5  7  11  13  15
//                       ||                          ||        |      |        |  |  [2, 3, 5, 7, 11, 13, 15]
//                       ||                          ||        |      |        |  true
//                       ||                          ||        |      |        [2, 3, 5, 7, 11, 13, 15]
//                       ||                          ||        |      ["prime"]
//                       ||                          ||        Array<Int>
//                       ||                          |Dictionary<String, Array<Int>>
//                       ||                          \Dictionary<String, Array<Int>>.<computed 0x00000001a128b19c (Optional<Array<Int>>)>
//                       |["prime": [2, 3, 5, 7, 11, 13, 15], "hexagonal": [1, 6, 15, 28, 45, 66, 91], "triangular": [1, 3, 6, 10, 15, 21, 28]]
//                       [2, 3, 5, 7, 11, 13, 15]
//
//          """#
//          ||
//          output ==
//          #"""
//          #powerAssert(interestingNumbers[keyPath: \[String: [Int]].["prime"]]! == [2, 3, 5, 7, 11, 13, 15])
//                       ||                          ||        |      ||       |  |  ||  |  |  |  |   |   |
//                       ||                          ||        |      |"prime" |  |  |2  3  5  7  11  13  15
//                       ||                          ||        |      |        |  |  [2, 3, 5, 7, 11, 13, 15]
//                       ||                          ||        |      |        |  true
//                       ||                          ||        |      |        [2, 3, 5, 7, 11, 13, 15]
//                       ||                          ||        |      ["prime"]
//                       ||                          ||        Array<Int>
//                       ||                          |Dictionary<String, Array<Int>>
//                       ||                          \Dictionary<String, Array<Int>>.<computed 0x00000001a128b19c (Optional<Array<Int>>)>
//                       |["prime": [2, 3, 5, 7, 11, 13, 15], "triangular": [1, 3, 6, 10, 15, 21, 28], "hexagonal": [1, 6, 15, 28, 45, 66, 91]]
//                       [2, 3, 5, 7, 11, 13, 15]
//
//          """#
//          ||
//          output ==
//          #"""
//          #powerAssert(interestingNumbers[keyPath: \[String: [Int]].["prime"]]! == [2, 3, 5, 7, 11, 13, 15])
//                       ||                          ||        |      ||       |  |  ||  |  |  |  |   |   |
//                       ||                          ||        |      |"prime" |  |  |2  3  5  7  11  13  15
//                       ||                          ||        |      |        |  |  [2, 3, 5, 7, 11, 13, 15]
//                       ||                          ||        |      |        |  true
//                       ||                          ||        |      |        [2, 3, 5, 7, 11, 13, 15]
//                       ||                          ||        |      ["prime"]
//                       ||                          ||        Array<Int>
//                       ||                          |Dictionary<String, Array<Int>>
//                       ||                          \Dictionary<String, Array<Int>>.<computed 0x00000001a128b19c (Optional<Array<Int>>)>
//                       |["hexagonal": [1, 6, 15, 28, 45, 66, 91], "prime": [2, 3, 5, 7, 11, 13, 15], "triangular": [1, 3, 6, 10, 15, 21, 28]]
//                       [2, 3, 5, 7, 11, 13, 15]
//
//          """#
//          ||
//          output ==
//          #"""
//          #powerAssert(interestingNumbers[keyPath: \[String: [Int]].["prime"]]! == [2, 3, 5, 7, 11, 13, 15])
//                       ||                          ||        |      ||       |  |  ||  |  |  |  |   |   |
//                       ||                          ||        |      |"prime" |  |  |2  3  5  7  11  13  15
//                       ||                          ||        |      |        |  |  [2, 3, 5, 7, 11, 13, 15]
//                       ||                          ||        |      |        |  true
//                       ||                          ||        |      |        [2, 3, 5, 7, 11, 13, 15]
//                       ||                          ||        |      ["prime"]
//                       ||                          ||        Array<Int>
//                       ||                          |Dictionary<String, Array<Int>>
//                       ||                          \Dictionary<String, Array<Int>>.<computed 0x00000001a128b19c (Optional<Array<Int>>)>
//                       |["hexagonal": [1, 6, 15, 28, 45, 66, 91], "triangular": [1, 3, 6, 10, 15, 21, 28], "prime": [2, 3, 5, 7, 11, 13, 15]]
//                       [2, 3, 5, 7, 11, 13, 15]
//
//          """#
//          ||
//          output ==
//          #"""
//          #powerAssert(interestingNumbers[keyPath: \[String: [Int]].["prime"]]! == [2, 3, 5, 7, 11, 13, 15])
//                       ||                          ||        |      ||       |  |  ||  |  |  |  |   |   |
//                       ||                          ||        |      |"prime" |  |  |2  3  5  7  11  13  15
//                       ||                          ||        |      |        |  |  [2, 3, 5, 7, 11, 13, 15]
//                       ||                          ||        |      |        |  true
//                       ||                          ||        |      |        [2, 3, 5, 7, 11, 13, 15]
//                       ||                          ||        |      ["prime"]
//                       ||                          ||        Array<Int>
//                       ||                          |Dictionary<String, Array<Int>>
//                       ||                          \Dictionary<String, Array<Int>>.<computed 0x00000001a128b19c (Optional<Array<Int>>)>
//                       |["triangular": [1, 3, 6, 10, 15, 21, 28], "prime": [2, 3, 5, 7, 11, 13, 15], "hexagonal": [1, 6, 15, 28, 45, 66, 91]]
//                       [2, 3, 5, 7, 11, 13, 15]
//
//          """#
//          ||
//          output ==
//          #"""
//          #powerAssert(interestingNumbers[keyPath: \[String: [Int]].["prime"]]! == [2, 3, 5, 7, 11, 13, 15])
//                       ||                          ||        |      ||       |  |  ||  |  |  |  |   |   |
//                       ||                          ||        |      |"prime" |  |  |2  3  5  7  11  13  15
//                       ||                          ||        |      |        |  |  [2, 3, 5, 7, 11, 13, 15]
//                       ||                          ||        |      |        |  true
//                       ||                          ||        |      |        [2, 3, 5, 7, 11, 13, 15]
//                       ||                          ||        |      ["prime"]
//                       ||                          ||        Array<Int>
//                       ||                          |Dictionary<String, Array<Int>>
//                       ||                          \Dictionary<String, Array<Int>>.<computed 0x00000001a128b19c (Optional<Array<Int>>)>
//                       |["triangular": [1, 3, 6, 10, 15, 21, 28], "hexagonal": [1, 6, 15, 28, 45, 66, 91], "prime": [2, 3, 5, 7, 11, 13, 15]]
//                       [2, 3, 5, 7, 11, 13, 15]
//
//          """#
//        )
//      }
//    }
//  }

  func testSubscriptKeyPathExpression3() {
    captureConsoleOutput {
      let interestingNumbers = [
        "prime": [2, 3, 5, 7, 11, 13, 15],
        "triangular": [1, 3, 6, 10, 15, 21, 28],
        "hexagonal": [1, 6, 15, 28, 45, 66, 91]
      ]
      #expect(
        interestingNumbers[keyPath: \[String: [Int]].["prime"]![0]] == 2,
        verbose: true
      )
    } completion: { (output) in
      print(output)
      // Dictionary order is not guaranteed
      if ProcessInfo.processInfo.environment["CI"] == "true" {
        XCTAssertTrue(
          output ==
          #"""
          #expect(interestingNumbers[keyPath: \[String: [Int]].["prime"]![0]] == 2)
                  |                           |                 |         | | |  |
                  |                           |                 "prime"   0 2 |  2
                  |                           |                               true
                  |                           Swift.WritableKeyPath<Swift.Dictionary<Swift.String, Swift.Array<Swift.Int>>, Swift.Int>
                  ["prime": [2, 3, 5, 7, 11, 13, 15], "hexagonal": [1, 6, 15, 28, 45, 66, 91], "triangular": [1, 3, 6, 10, 15, 21, 28]]

          """#
          ||
          output ==
          #"""
          #expect(interestingNumbers[keyPath: \[String: [Int]].["prime"]![0]] == 2)
                  |                           |                 |         | | |  |
                  |                           |                 "prime"   0 2 |  2
                  |                           |                               true
                  |                           Swift.WritableKeyPath<Swift.Dictionary<Swift.String, Swift.Array<Swift.Int>>, Swift.Int>
                  ["prime": [2, 3, 5, 7, 11, 13, 15], "triangular": [1, 3, 6, 10, 15, 21, 28], "hexagonal": [1, 6, 15, 28, 45, 66, 91]]

          """#
          ||
          output ==
          #"""
          #expect(interestingNumbers[keyPath: \[String: [Int]].["prime"]![0]] == 2)
                  |                           |                 |         | | |  |
                  |                           |                 "prime"   0 2 |  2
                  |                           |                               true
                  |                           Swift.WritableKeyPath<Swift.Dictionary<Swift.String, Swift.Array<Swift.Int>>, Swift.Int>
                  ["hexagonal": [1, 6, 15, 28, 45, 66, 91], "prime": [2, 3, 5, 7, 11, 13, 15], "triangular": [1, 3, 6, 10, 15, 21, 28]]

          """#
          ||
          output ==
          #"""
          #expect(interestingNumbers[keyPath: \[String: [Int]].["prime"]![0]] == 2)
                  |                           |                 |         | | |  |
                  |                           |                 "prime"   0 2 |  2
                  |                           |                               true
                  |                           Swift.WritableKeyPath<Swift.Dictionary<Swift.String, Swift.Array<Swift.Int>>, Swift.Int>
                  ["hexagonal": [1, 6, 15, 28, 45, 66, 91], "triangular": [1, 3, 6, 10, 15, 21, 28], "prime": [2, 3, 5, 7, 11, 13, 15]]

          """#
          ||
          output ==
          #"""
          #expect(interestingNumbers[keyPath: \[String: [Int]].["prime"]![0]] == 2)
                  |                           |                 |         | | |  |
                  |                           |                 "prime"   0 2 |  2
                  |                           |                               true
                  |                           Swift.WritableKeyPath<Swift.Dictionary<Swift.String, Swift.Array<Swift.Int>>, Swift.Int>
                  ["triangular": [1, 3, 6, 10, 15, 21, 28], "prime": [2, 3, 5, 7, 11, 13, 15], "hexagonal": [1, 6, 15, 28, 45, 66, 91]]

          """#
          ||
          output ==
          #"""
          #expect(interestingNumbers[keyPath: \[String: [Int]].["prime"]![0]] == 2)
                  |                           |                 |         | | |  |
                  |                           |                 "prime"   0 2 |  2
                  |                           |                               true
                  |                           Swift.WritableKeyPath<Swift.Dictionary<Swift.String, Swift.Array<Swift.Int>>, Swift.Int>
                  ["triangular": [1, 3, 6, 10, 15, 21, 28], "hexagonal": [1, 6, 15, 28, 45, 66, 91], "prime": [2, 3, 5, 7, 11, 13, 15]]

          """#
        )
      } else {
        XCTAssertTrue(
          output ==
          #"""
          #expect(interestingNumbers[keyPath: \[String: [Int]].["prime"]![0]] == 2)
                  |                           |                 |         | | |  |
                  |                           |                 "prime"   0 2 |  2
                  |                           |                               true
                  |                           \Dictionary<String, Array<Int>>.<computed 0x00000001a128b19c (Optional<Array<Int>>)>!.<computed 0x00000001a128ad3c (Int)>
                  ["prime": [2, 3, 5, 7, 11, 13, 15], "hexagonal": [1, 6, 15, 28, 45, 66, 91], "triangular": [1, 3, 6, 10, 15, 21, 28]]

          """#
          ||
          output ==
          #"""
          #expect(interestingNumbers[keyPath: \[String: [Int]].["prime"]![0]] == 2)
                  |                           |                 |         | | |  |
                  |                           |                 "prime"   0 2 |  2
                  |                           |                               true
                  |                           \Dictionary<String, Array<Int>>.<computed 0x00000001a128b19c (Optional<Array<Int>>)>!.<computed 0x00000001a128ad3c (Int)>
                  ["prime": [2, 3, 5, 7, 11, 13, 15], "triangular": [1, 3, 6, 10, 15, 21, 28], "hexagonal": [1, 6, 15, 28, 45, 66, 91]]

          """#
          ||
          output ==
          #"""
          #expect(interestingNumbers[keyPath: \[String: [Int]].["prime"]![0]] == 2)
                  |                           |                 |         | | |  |
                  |                           |                 "prime"   0 2 |  2
                  |                           |                               true
                  |                           \Dictionary<String, Array<Int>>.<computed 0x00000001a128b19c (Optional<Array<Int>>)>!.<computed 0x00000001a128ad3c (Int)>
                  ["hexagonal": [1, 6, 15, 28, 45, 66, 91], "prime": [2, 3, 5, 7, 11, 13, 15], "triangular": [1, 3, 6, 10, 15, 21, 28]]

          """#
          ||
          output ==
          #"""
          #expect(interestingNumbers[keyPath: \[String: [Int]].["prime"]![0]] == 2)
                  |                           |                 |         | | |  |
                  |                           |                 "prime"   0 2 |  2
                  |                           |                               true
                  |                           \Dictionary<String, Array<Int>>.<computed 0x00000001a128b19c (Optional<Array<Int>>)>!.<computed 0x00000001a128ad3c (Int)>
                  ["hexagonal": [1, 6, 15, 28, 45, 66, 91], "triangular": [1, 3, 6, 10, 15, 21, 28], "prime": [2, 3, 5, 7, 11, 13, 15]]

          """#
          ||
          output ==
          #"""
          #expect(interestingNumbers[keyPath: \[String: [Int]].["prime"]![0]] == 2)
                  |                           |                 |         | | |  |
                  |                           |                 "prime"   0 2 |  2
                  |                           |                               true
                  |                           \Dictionary<String, Array<Int>>.<computed 0x00000001a128b19c (Optional<Array<Int>>)>!.<computed 0x00000001a128ad3c (Int)>
                  ["triangular": [1, 3, 6, 10, 15, 21, 28], "prime": [2, 3, 5, 7, 11, 13, 15], "hexagonal": [1, 6, 15, 28, 45, 66, 91]]

          """#
          ||
          output ==
          #"""
          #expect(interestingNumbers[keyPath: \[String: [Int]].["prime"]![0]] == 2)
                  |                           |                 |         | | |  |
                  |                           |                 "prime"   0 2 |  2
                  |                           |                               true
                  |                           \Dictionary<String, Array<Int>>.<computed 0x00000001a128b19c (Optional<Array<Int>>)>!.<computed 0x00000001a128ad3c (Int)>
                  ["triangular": [1, 3, 6, 10, 15, 21, 28], "hexagonal": [1, 6, 15, 28, 45, 66, 91], "prime": [2, 3, 5, 7, 11, 13, 15]]

          """#
        )
      }
    }
  }

  func testSubscriptKeyPathExpression4() {
    captureConsoleOutput {
      let interestingNumbers = [
        "prime": [2, 3, 5, 7, 11, 13, 15],
        "triangular": [1, 3, 6, 10, 15, 21, 28],
        "hexagonal": [1, 6, 15, 28, 45, 66, 91]
      ]
      #expect(
        interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count] == 7,
        verbose: true
      )
    } completion: { (output) in
      print(output)
      // Dictionary order is not guaranteed
      if ProcessInfo.processInfo.environment["CI"] == "true" {
        XCTAssertTrue(
          output ==
          #"""
          #expect(interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count] == 7)
                  |                           |                 |                  | |  |
                  |                           |                 "hexagonal"        7 |  7
                  |                           |                                      true
                  |                           Swift.KeyPath<Swift.Dictionary<Swift.String, Swift.Array<Swift.Int>>, Swift.Int>
                  ["prime": [2, 3, 5, 7, 11, 13, 15], "hexagonal": [1, 6, 15, 28, 45, 66, 91], "triangular": [1, 3, 6, 10, 15, 21, 28]]

          """#
          ||
          output ==
          #"""
          #expect(interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count] == 7)
                  |                           |                 |                  | |  |
                  |                           |                 "hexagonal"        7 |  7
                  |                           |                                      true
                  |                           Swift.KeyPath<Swift.Dictionary<Swift.String, Swift.Array<Swift.Int>>, Swift.Int>
                  ["prime": [2, 3, 5, 7, 11, 13, 15], "triangular": [1, 3, 6, 10, 15, 21, 28], "hexagonal": [1, 6, 15, 28, 45, 66, 91]]

          """#
          ||
          output ==
          #"""
          #expect(interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count] == 7)
                  |                           |                 |                  | |  |
                  |                           |                 "hexagonal"        7 |  7
                  |                           |                                      true
                  |                           Swift.KeyPath<Swift.Dictionary<Swift.String, Swift.Array<Swift.Int>>, Swift.Int>
                  ["hexagonal": [1, 6, 15, 28, 45, 66, 91], "prime": [2, 3, 5, 7, 11, 13, 15], "triangular": [1, 3, 6, 10, 15, 21, 28]]

          """#
          ||
          output ==
          #"""
          #expect(interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count] == 7)
                  |                           |                 |                  | |  |
                  |                           |                 "hexagonal"        7 |  7
                  |                           |                                      true
                  |                           Swift.KeyPath<Swift.Dictionary<Swift.String, Swift.Array<Swift.Int>>, Swift.Int>
                  ["hexagonal": [1, 6, 15, 28, 45, 66, 91], "triangular": [1, 3, 6, 10, 15, 21, 28], "prime": [2, 3, 5, 7, 11, 13, 15]]

          """#
          ||
          output ==
          #"""
          #expect(interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count] == 7)
                  |                           |                 |                  | |  |
                  |                           |                 "hexagonal"        7 |  7
                  |                           |                                      true
                  |                           Swift.KeyPath<Swift.Dictionary<Swift.String, Swift.Array<Swift.Int>>, Swift.Int>
                  ["triangular": [1, 3, 6, 10, 15, 21, 28], "prime": [2, 3, 5, 7, 11, 13, 15], "hexagonal": [1, 6, 15, 28, 45, 66, 91]]

          """#
          ||
          output ==
          #"""
          #expect(interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count] == 7)
                  |                           |                 |                  | |  |
                  |                           |                 "hexagonal"        7 |  7
                  |                           |                                      true
                  |                           Swift.KeyPath<Swift.Dictionary<Swift.String, Swift.Array<Swift.Int>>, Swift.Int>
                  ["triangular": [1, 3, 6, 10, 15, 21, 28], "hexagonal": [1, 6, 15, 28, 45, 66, 91], "prime": [2, 3, 5, 7, 11, 13, 15]]

          """#
        )
      } else {
        XCTAssertTrue(
          output ==
          #"""
          #expect(interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count] == 7)
                  |                           |                 |                  | |  |
                  |                           |                 "hexagonal"        7 |  7
                  |                           |                                      true
                  |                           \Dictionary<String, Array<Int>>.<computed 0x00000001a128b19c (Optional<Array<Int>>)>!.count
                  ["prime": [2, 3, 5, 7, 11, 13, 15], "hexagonal": [1, 6, 15, 28, 45, 66, 91], "triangular": [1, 3, 6, 10, 15, 21, 28]]

          """#
          ||
          output ==
          #"""
          #expect(interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count] == 7)
                  |                           |                 |                  | |  |
                  |                           |                 "hexagonal"        7 |  7
                  |                           |                                      true
                  |                           \Dictionary<String, Array<Int>>.<computed 0x00000001a128b19c (Optional<Array<Int>>)>!.count
                  ["prime": [2, 3, 5, 7, 11, 13, 15], "triangular": [1, 3, 6, 10, 15, 21, 28], "hexagonal": [1, 6, 15, 28, 45, 66, 91]]

          """#
          ||
          output ==
          #"""
          #expect(interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count] == 7)
                  |                           |                 |                  | |  |
                  |                           |                 "hexagonal"        7 |  7
                  |                           |                                      true
                  |                           \Dictionary<String, Array<Int>>.<computed 0x00000001a128b19c (Optional<Array<Int>>)>!.count
                  ["hexagonal": [1, 6, 15, 28, 45, 66, 91], "prime": [2, 3, 5, 7, 11, 13, 15], "triangular": [1, 3, 6, 10, 15, 21, 28]]

          """#
          ||
          output ==
          #"""
          #expect(interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count] == 7)
                  |                           |                 |                  | |  |
                  |                           |                 "hexagonal"        7 |  7
                  |                           |                                      true
                  |                           \Dictionary<String, Array<Int>>.<computed 0x00000001a128b19c (Optional<Array<Int>>)>!.count
                  ["hexagonal": [1, 6, 15, 28, 45, 66, 91], "triangular": [1, 3, 6, 10, 15, 21, 28], "prime": [2, 3, 5, 7, 11, 13, 15]]

          """#
          ||
          output ==
          #"""
          #expect(interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count] == 7)
                  |                           |                 |                  | |  |
                  |                           |                 "hexagonal"        7 |  7
                  |                           |                                      true
                  |                           \Dictionary<String, Array<Int>>.<computed 0x00000001a128b19c (Optional<Array<Int>>)>!.count
                  ["triangular": [1, 3, 6, 10, 15, 21, 28], "prime": [2, 3, 5, 7, 11, 13, 15], "hexagonal": [1, 6, 15, 28, 45, 66, 91]]

          """#
          ||
          output ==
          #"""
          #expect(interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count] == 7)
                  |                           |                 |                  | |  |
                  |                           |                 "hexagonal"        7 |  7
                  |                           |                                      true
                  |                           \Dictionary<String, Array<Int>>.<computed 0x00000001a128b19c (Optional<Array<Int>>)>!.count
                  ["triangular": [1, 3, 6, 10, 15, 21, 28], "hexagonal": [1, 6, 15, 28, 45, 66, 91], "prime": [2, 3, 5, 7, 11, 13, 15]]

          """#
        )
      }
    }
  }

  func testSubscriptKeyPathExpression5() {
    captureConsoleOutput {
      let interestingNumbers = [
        "prime": [2, 3, 5, 7, 11, 13, 15],
        "triangular": [1, 3, 6, 10, 15, 21, 28],
        "hexagonal": [1, 6, 15, 28, 45, 66, 91]
      ]
      #expect(
        interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count.bitWidth] == 64,
        verbose: true
      )
    } completion: { (output) in
      print(output)
      // Dictionary order is not guaranteed
      if ProcessInfo.processInfo.environment["CI"] == "true" {
        XCTAssertTrue(
          output ==
          #"""
          #expect(interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count.bitWidth] == 64)
                  |                           |                 |                           | |  |
                  |                           |                 "hexagonal"                 | |  64
                  |                           |                                             | true
                  |                           |                                             64
                  |                           Swift.KeyPath<Swift.Dictionary<Swift.String, Swift.Array<Swift.Int>>, Swift.Int>
                  ["prime": [2, 3, 5, 7, 11, 13, 15], "hexagonal": [1, 6, 15, 28, 45, 66, 91], "triangular": [1, 3, 6, 10, 15, 21, 28]]

          """#
          ||
          output ==
          #"""
          #expect(interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count.bitWidth] == 64)
                  |                           |                 |                           | |  |
                  |                           |                 "hexagonal"                 | |  64
                  |                           |                                             | true
                  |                           |                                             64
                  |                           Swift.KeyPath<Swift.Dictionary<Swift.String, Swift.Array<Swift.Int>>, Swift.Int>
                  ["prime": [2, 3, 5, 7, 11, 13, 15], "triangular": [1, 3, 6, 10, 15, 21, 28], "hexagonal": [1, 6, 15, 28, 45, 66, 91]]

          """#
          ||
          output ==
          #"""
          #expect(interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count.bitWidth] == 64)
                  |                           |                 |                           | |  |
                  |                           |                 "hexagonal"                 | |  64
                  |                           |                                             | true
                  |                           |                                             64
                  |                           Swift.KeyPath<Swift.Dictionary<Swift.String, Swift.Array<Swift.Int>>, Swift.Int>
                  ["hexagonal": [1, 6, 15, 28, 45, 66, 91], "prime": [2, 3, 5, 7, 11, 13, 15], "triangular": [1, 3, 6, 10, 15, 21, 28]]

          """#
          ||
          output ==
          #"""
          #expect(interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count.bitWidth] == 64)
                  |                           |                 |                           | |  |
                  |                           |                 "hexagonal"                 | |  64
                  |                           |                                             | true
                  |                           |                                             64
                  |                           Swift.KeyPath<Swift.Dictionary<Swift.String, Swift.Array<Swift.Int>>, Swift.Int>
                  ["hexagonal": [1, 6, 15, 28, 45, 66, 91], "triangular": [1, 3, 6, 10, 15, 21, 28], "prime": [2, 3, 5, 7, 11, 13, 15]]

          """#
          ||
          output ==
          #"""
          #expect(interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count.bitWidth] == 64)
                  |                           |                 |                           | |  |
                  |                           |                 "hexagonal"                 | |  64
                  |                           |                                             | true
                  |                           |                                             64
                  |                           Swift.KeyPath<Swift.Dictionary<Swift.String, Swift.Array<Swift.Int>>, Swift.Int>
                  ["triangular": [1, 3, 6, 10, 15, 21, 28], "prime": [2, 3, 5, 7, 11, 13, 15], "hexagonal": [1, 6, 15, 28, 45, 66, 91]]

          """#
          ||
          output ==
          #"""
          #expect(interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count.bitWidth] == 64)
                  |                           |                 |                           | |  |
                  |                           |                 "hexagonal"                 | |  64
                  |                           |                                             | true
                  |                           |                                             64
                  |                           Swift.KeyPath<Swift.Dictionary<Swift.String, Swift.Array<Swift.Int>>, Swift.Int>
                  ["triangular": [1, 3, 6, 10, 15, 21, 28], "hexagonal": [1, 6, 15, 28, 45, 66, 91], "prime": [2, 3, 5, 7, 11, 13, 15]]

          """#
        )
      } else {
        XCTAssertTrue(
          output ==
          #"""
          #expect(interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count.bitWidth] == 64)
                  |                           |                 |                           | |  |
                  |                           |                 "hexagonal"                 | |  64
                  |                           |                                             | true
                  |                           |                                             64
                  |                           \Dictionary<String, Array<Int>>.<computed 0x00000001a128b19c (Optional<Array<Int>>)>!.count.bitWidth
                  ["prime": [2, 3, 5, 7, 11, 13, 15], "hexagonal": [1, 6, 15, 28, 45, 66, 91], "triangular": [1, 3, 6, 10, 15, 21, 28]]

          """#
          ||
          output ==
          #"""
          #expect(interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count.bitWidth] == 64)
                  |                           |                 |                           | |  |
                  |                           |                 "hexagonal"                 | |  64
                  |                           |                                             | true
                  |                           |                                             64
                  |                           \Dictionary<String, Array<Int>>.<computed 0x00000001a128b19c (Optional<Array<Int>>)>!.count.bitWidth
                  ["prime": [2, 3, 5, 7, 11, 13, 15], "triangular": [1, 3, 6, 10, 15, 21, 28], "hexagonal": [1, 6, 15, 28, 45, 66, 91]]

          """#
          ||
          output ==
          #"""
          #expect(interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count.bitWidth] == 64)
                  |                           |                 |                           | |  |
                  |                           |                 "hexagonal"                 | |  64
                  |                           |                                             | true
                  |                           |                                             64
                  |                           \Dictionary<String, Array<Int>>.<computed 0x00000001a128b19c (Optional<Array<Int>>)>!.count.bitWidth
                  ["hexagonal": [1, 6, 15, 28, 45, 66, 91], "prime": [2, 3, 5, 7, 11, 13, 15], "triangular": [1, 3, 6, 10, 15, 21, 28]]

          """#
          ||
          output ==
          #"""
          #expect(interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count.bitWidth] == 64)
                  |                           |                 |                           | |  |
                  |                           |                 "hexagonal"                 | |  64
                  |                           |                                             | true
                  |                           |                                             64
                  |                           \Dictionary<String, Array<Int>>.<computed 0x00000001a128b19c (Optional<Array<Int>>)>!.count.bitWidth
                  ["hexagonal": [1, 6, 15, 28, 45, 66, 91], "triangular": [1, 3, 6, 10, 15, 21, 28], "prime": [2, 3, 5, 7, 11, 13, 15]]

          """#
          ||
          output ==
          #"""
          #expect(interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count.bitWidth] == 64)
                  |                           |                 |                           | |  |
                  |                           |                 "hexagonal"                 | |  64
                  |                           |                                             | true
                  |                           |                                             64
                  |                           \Dictionary<String, Array<Int>>.<computed 0x00000001a128b19c (Optional<Array<Int>>)>!.count.bitWidth
                  ["triangular": [1, 3, 6, 10, 15, 21, 28], "prime": [2, 3, 5, 7, 11, 13, 15], "hexagonal": [1, 6, 15, 28, 45, 66, 91]]

          """#
          ||
          output ==
          #"""
          #expect(interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count.bitWidth] == 64)
                  |                           |                 |                           | |  |
                  |                           |                 "hexagonal"                 | |  64
                  |                           |                                             | true
                  |                           |                                             64
                  |                           \Dictionary<String, Array<Int>>.<computed 0x00000001a128b19c (Optional<Array<Int>>)>!.count.bitWidth
                  ["triangular": [1, 3, 6, 10, 15, 21, 28], "hexagonal": [1, 6, 15, 28, 45, 66, 91], "prime": [2, 3, 5, 7, 11, 13, 15]]

          """#
        )
      }
    }
  }

//  func testInitializerExpression() throws {
//    captureConsoleOutput {
//      let initializer: (Int) -> String = String.init
//
//      #powerAssert([1, 2, 3].map(initializer).reduce("", +) == "123", verbose: true)
//      #powerAssert([1, 2, 3].map(String.init).reduce("", +) == "123", verbose: true)
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

  func testPostfixSelfExpression() {
    captureConsoleOutput {
      #expect(String.self != Int.self && "string".self == "string", verbose: true)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #expect(String.self != Int.self && "string".self == "string")
                |      |    |  |   |    |  |        |    |  |
                |      |    |  |   |    |  "string" |    |  "string"
                |      |    |  |   |    true        |    true
                |      |    |  |   |                "string"
                |      |    |  |   Optional(Swift.Int)
                |      |    |  Optional(Swift.Int)
                |      |    true
                |      Optional(Swift.String)
                Optional(Swift.String)

        """
      )
    }
  }

  func testForcedUnwrapExpression() {
    captureConsoleOutput {
      let x: Int? = 0
      let someDictionary = ["a": [1, 2, 3], "b": [10, 20]]

      #expect(x! == 0, verbose: true)
      #expect(someDictionary["a"]![0] == 1, verbose: true)
    } completion: { (output) in
      print(output)
      // Dictionary order is not guaranteed
      XCTAssertTrue(
        output ==
        """
        #expect(x! == 0)
                || |  |
                |0 |  0
                |  true
                Optional(0)
        #expect(someDictionary["a"]![0] == 1)
                ||             |  |  || |  |
                |[1, 2, 3]     |  |  |1 |  1
                |              |  |  0  true
                |              |  Optional([1, 2, 3])
                |              "a"
                ["a": [1, 2, 3], "b": [10, 20]]

        """
        ||
        output ==
        """
        #expect(x! == 0)
                || |  |
                |0 |  0
                |  true
                Optional(0)
        #expect(someDictionary["a"]![0] == 1)
                ||             |  |  || |  |
                |[1, 2, 3]     |  |  |1 |  1
                |              |  |  0  true
                |              |  Optional([1, 2, 3])
                |              "a"
                ["b": [10, 20], "a": [1, 2, 3]]

        """
      )
    }
  }

  func testOptionalChainingExpression1() {
    captureConsoleOutput {
      var c: SomeClass?
      #expect(c?.property.performAction() == nil, verbose: true)

      c = SomeClass()
      #expect((c?.property.performAction())!, verbose: true)
      #expect(c?.property.performAction() != nil, verbose: true)

      let someDictionary = ["a": [1, 2, 3], "b": [10, 20]]
      #expect(someDictionary["not here"]?[0] != 99, verbose: true)
      #expect(someDictionary["a"]?[0] != 99, verbose: true)
    } completion: { (output) in
      print(output)
      // Dictionary order is not guaranteed
      XCTAssertTrue(
        output ==
          """
          #expect(c?.property.performAction() == nil)
                  |  |        |               |  |
                  |  nil      nil             |  nil
                  nil                         true
          #expect((c?.property.performAction())!)
                  ||| |        |
                  ||| |        Optional(true)
                  ||| Optional(PowerAssertTests.OtherClass)
                  ||Optional(PowerAssertTests.SomeClass)
                  |true
                  Optional(true)
          #expect(c?.property.performAction() != nil)
                  |  |        |               |  |
                  |  |        Optional(true)  |  nil
                  |  |                        true
                  |  Optional(PowerAssertTests.OtherClass)
                  Optional(PowerAssertTests.SomeClass)
          #expect(someDictionary["not here"]?[0] != 99)
                  |              |         |   | |  |
                  |              |         nil | |  Optional(99)
                  |              "not here"    | true
                  |                            nil
                  ["a": [1, 2, 3], "b": [10, 20]]
          #expect(someDictionary["a"]?[0] != 99)
                  |              |  |  || |  |
                  |              |  |  || |  Optional(99)
                  |              |  |  || true
                  |              |  |  |Optional(1)
                  |              |  |  0
                  |              |  Optional([1, 2, 3])
                  |              "a"
                  ["a": [1, 2, 3], "b": [10, 20]]

          """
        ||
        output ==
          """
          #expect(c?.property.performAction() == nil)
                  |  |        |               |  |
                  |  nil      nil             |  nil
                  nil                         true
          #expect((c?.property.performAction())!)
                  ||| |        |
                  ||| |        Optional(true)
                  ||| Optional(PowerAssertTests.OtherClass)
                  ||Optional(PowerAssertTests.SomeClass)
                  |true
                  Optional(true)
          #expect(c?.property.performAction() != nil)
                  |  |        |               |  |
                  |  |        Optional(true)  |  nil
                  |  |                        true
                  |  Optional(PowerAssertTests.OtherClass)
                  Optional(PowerAssertTests.SomeClass)
          #expect(someDictionary["not here"]?[0] != 99)
                  |              |         |   | |  |
                  |              |         nil | |  Optional(99)
                  |              "not here"    | true
                  |                            nil
                  ["b": [10, 20], "a": [1, 2, 3]]
          #expect(someDictionary["a"]?[0] != 99)
                  |              |  |  || |  |
                  |              |  |  || |  Optional(99)
                  |              |  |  || true
                  |              |  |  |Optional(1)
                  |              |  |  0
                  |              |  Optional([1, 2, 3])
                  |              "a"
                  ["a": [1, 2, 3], "b": [10, 20]]

          """
        ||
        output ==
          """
          #expect(c?.property.performAction() == nil)
                  |  |        |               |  |
                  |  nil      nil             |  nil
                  nil                         true
          #expect((c?.property.performAction())!)
                  ||| |        |
                  ||| |        Optional(true)
                  ||| Optional(PowerAssertTests.OtherClass)
                  ||Optional(PowerAssertTests.SomeClass)
                  |true
                  Optional(true)
          #expect(c?.property.performAction() != nil)
                  |  |        |               |  |
                  |  |        Optional(true)  |  nil
                  |  |                        true
                  |  Optional(PowerAssertTests.OtherClass)
                  Optional(PowerAssertTests.SomeClass)
          #expect(someDictionary["not here"]?[0] != 99)
                  |              |         |   | |  |
                  |              |         nil | |  Optional(99)
                  |              "not here"    | true
                  |                            nil
                  ["a": [1, 2, 3], "b": [10, 20]]
          #expect(someDictionary["a"]?[0] != 99)
                  |              |  |  || |  |
                  |              |  |  || |  Optional(99)
                  |              |  |  || true
                  |              |  |  |Optional(1)
                  |              |  |  0
                  |              |  Optional([1, 2, 3])
                  |              "a"
                  ["b": [10, 20], "a": [1, 2, 3]]

          """
        ||
        output ==
          """
          #expect(c?.property.performAction() == nil)
                  |  |        |               |  |
                  |  nil      nil             |  nil
                  nil                         true
          #expect((c?.property.performAction())!)
                  ||| |        |
                  ||| |        Optional(true)
                  ||| Optional(PowerAssertTests.OtherClass)
                  ||Optional(PowerAssertTests.SomeClass)
                  |true
                  Optional(true)
          #expect(c?.property.performAction() != nil)
                  |  |        |               |  |
                  |  |        Optional(true)  |  nil
                  |  |                        true
                  |  Optional(PowerAssertTests.OtherClass)
                  Optional(PowerAssertTests.SomeClass)
          #expect(someDictionary["not here"]?[0] != 99)
                  |              |         |   | |  |
                  |              |         nil | |  Optional(99)
                  |              "not here"    | true
                  |                            nil
                  ["b": [10, 20], "a": [1, 2, 3]]
          #expect(someDictionary["a"]?[0] != 99)
                  |              |  |  || |  |
                  |              |  |  || |  Optional(99)
                  |              |  |  || true
                  |              |  |  |Optional(1)
                  |              |  |  0
                  |              |  Optional([1, 2, 3])
                  |              "a"
                  ["b": [10, 20], "a": [1, 2, 3]]

          """
      )
    }
  }

  func testOptionalChainingExpression2() {
    captureConsoleOutput {
      var c: SomeClass?
      #expect(c?.optionalProperty?.property.optionalProperty?.performAction() == nil, verbose: true)
      c = SomeClass()
//      #expect(c?.optionalProperty?.property.property.optionalProperty?.performAction() == nil, verbose: true)
    } completion: { (output) in
      print(output)
      // Dictionary order is not guaranteed
      XCTAssertEqual(
        output,
        """
        #expect(c?.optionalProperty?.property.optionalProperty?.performAction() == nil)
                |  |                 |        |                 |               |  |
                |  nil               nil      nil               nil             |  nil
                nil                                                             true

        """
      )
    }
  }

  func testNonAsciiCharacters1() {
    captureConsoleOutput {
      let dc = DateComponents(
        calendar: Calendar(identifier: .gregorian),
        timeZone: TimeZone(abbreviation: "JST")!,
        year: 1980,
        month: 10,
        day: 28
      )
      let date = dc.date!

      let kanjiName = "岸川克己"

      let tuple = (name: kanjiName, age: 37, birthday: date)

      #expect(tuple == (name: kanjiName, age: 37, birthday: date), verbose: true)
      #expect(tuple == (kanjiName, 37, date), verbose: true)
      #expect(tuple.name == (kanjiName, 37, date).0 || tuple.age == (kanjiName, 37, date).1, verbose: true)
      #expect(tuple.name == (kanjiName, 37, date).0 && tuple.age == (kanjiName, 37, date).1, verbose: true)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #expect(tuple == (name: kanjiName, age: 37, birthday: date))
                |     |  |      |               |             |
                |     |  |      |               37            1980-10-27 15:00:00 +0000
                |     |  |      "岸川克己"
                |     |  ("岸川克己", 37, 1980-10-27 15:00:00 +0000)
                |     true
                ("岸川克己", 37, 1980-10-27 15:00:00 +0000)
        #expect(tuple == (kanjiName, 37, date))
                |     |  ||          |   |
                |     |  ||          37  1980-10-27 15:00:00 +0000
                |     |  |"岸川克己"
                |     |  ("岸川克己", 37, 1980-10-27 15:00:00 +0000)
                |     true
                ("岸川克己", 37, 1980-10-27 15:00:00 +0000)
        #expect(tuple.name == (kanjiName, 37, date).0 || tuple.age == (kanjiName, 37, date).1)
                |     |    |  ||          |   |     | |
                |     |    |  ||          37  |     | true
                |     |    |  ||              |     "岸川克己"
                |     |    |  ||              1980-10-27 15:00:00 +0000
                |     |    |  |"岸川克己"
                |     |    |  ("岸川克己", 37, 1980-10-27 15:00:00 +0000)
                |     |    true
                |     "岸川克己"
                (name: "岸川克己", age: 37, birthday: 1980-10-27 15:00:00 +0000)
        #expect(tuple.name == (kanjiName, 37, date).0 && tuple.age == (kanjiName, 37, date).1)
                |     |    |  ||          |   |     | |  |     |   |  ||          |   |     |
                |     |    |  ||          37  |     | |  |     37  |  ||          37  |     37
                |     |    |  ||              |     | |  |         |  ||              1980-10-27 15:00:00 +0000
                |     |    |  ||              |     | |  |         |  |"岸川克己"
                |     |    |  ||              |     | |  |         |  ("岸川克己", 37, 1980-10-27 15:00:00 +0000)
                |     |    |  ||              |     | |  |         true
                |     |    |  ||              |     | |  (name: "岸川克己", age: 37, birthday: 1980-10-27 15:00:00 +0000)
                |     |    |  ||              |     | true
                |     |    |  ||              |     "岸川克己"
                |     |    |  ||              1980-10-27 15:00:00 +0000
                |     |    |  |"岸川克己"
                |     |    |  ("岸川克己", 37, 1980-10-27 15:00:00 +0000)
                |     |    true
                |     "岸川克己"
                (name: "岸川克己", age: 37, birthday: 1980-10-27 15:00:00 +0000)

        """
      )
    }
  }

  func testNonAsciiCharacters2() {
    captureConsoleOutput {
      let dc = DateComponents(
        calendar: Calendar(identifier: .gregorian),
        timeZone: TimeZone(abbreviation: "JST")!,
        year: 1980,
        month: 10,
        day: 28
      )
      let date = dc.date!

      let kanjiName = "岸川克己"
      let emojiName = "😇岸川克己🇯🇵"

      let tuple = (name: kanjiName, age: 37, birthday: date)

      #expect(tuple.name != (emojiName, 37, date).0 || tuple.age == (kanjiName, 37, date).1, verbose: true)
      #expect(tuple.name == (kanjiName, 37, date).0 || tuple.age == (emojiName, 37, date).1, verbose: true)
      #expect(tuple.name != (emojiName, 37, date).0 && tuple.age == (kanjiName, 37, date).1, verbose: true)
      #expect(tuple.name == (kanjiName, 37, date).0 && tuple.age == (emojiName, 37, date).1, verbose: true)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #expect(tuple.name != (emojiName, 37, date).0 || tuple.age == (kanjiName, 37, date).1)
                |     |    |  ||          |   |     | |
                |     |    |  ||          37  |     | true
                |     |    |  ||              |     "😇岸川克己🇯🇵"
                |     |    |  ||              1980-10-27 15:00:00 +0000
                |     |    |  |"😇岸川克己🇯🇵"
                |     |    |  ("😇岸川克己🇯🇵", 37, 1980-10-27 15:00:00 +0000)
                |     |    true
                |     "岸川克己"
                (name: "岸川克己", age: 37, birthday: 1980-10-27 15:00:00 +0000)
        #expect(tuple.name == (kanjiName, 37, date).0 || tuple.age == (emojiName, 37, date).1)
                |     |    |  ||          |   |     | |
                |     |    |  ||          37  |     | true
                |     |    |  ||              |     "岸川克己"
                |     |    |  ||              1980-10-27 15:00:00 +0000
                |     |    |  |"岸川克己"
                |     |    |  ("岸川克己", 37, 1980-10-27 15:00:00 +0000)
                |     |    true
                |     "岸川克己"
                (name: "岸川克己", age: 37, birthday: 1980-10-27 15:00:00 +0000)
        #expect(tuple.name != (emojiName, 37, date).0 && tuple.age == (kanjiName, 37, date).1)
                |     |    |  ||          |   |     | |  |     |   |  ||          |   |     |
                |     |    |  ||          37  |     | |  |     37  |  ||          37  |     37
                |     |    |  ||              |     | |  |         |  ||              1980-10-27 15:00:00 +0000
                |     |    |  ||              |     | |  |         |  |"岸川克己"
                |     |    |  ||              |     | |  |         |  ("岸川克己", 37, 1980-10-27 15:00:00 +0000)
                |     |    |  ||              |     | |  |         true
                |     |    |  ||              |     | |  (name: "岸川克己", age: 37, birthday: 1980-10-27 15:00:00 +0000)
                |     |    |  ||              |     | true
                |     |    |  ||              |     "😇岸川克己🇯🇵"
                |     |    |  ||              1980-10-27 15:00:00 +0000
                |     |    |  |"😇岸川克己🇯🇵"
                |     |    |  ("😇岸川克己🇯🇵", 37, 1980-10-27 15:00:00 +0000)
                |     |    true
                |     "岸川克己"
                (name: "岸川克己", age: 37, birthday: 1980-10-27 15:00:00 +0000)
        #expect(tuple.name == (kanjiName, 37, date).0 && tuple.age == (emojiName, 37, date).1)
                |     |    |  ||          |   |     | |  |     |   |  ||          |   |     |
                |     |    |  ||          37  |     | |  |     37  |  ||          37  |     37
                |     |    |  ||              |     | |  |         |  ||              1980-10-27 15:00:00 +0000
                |     |    |  ||              |     | |  |         |  |"😇岸川克己🇯🇵"
                |     |    |  ||              |     | |  |         |  ("😇岸川克己🇯🇵", 37, 1980-10-27 15:00:00 +0000)
                |     |    |  ||              |     | |  |         true
                |     |    |  ||              |     | |  (name: "岸川克己", age: 37, birthday: 1980-10-27 15:00:00 +0000)
                |     |    |  ||              |     | true
                |     |    |  ||              |     "岸川克己"
                |     |    |  ||              1980-10-27 15:00:00 +0000
                |     |    |  |"岸川克己"
                |     |    |  ("岸川克己", 37, 1980-10-27 15:00:00 +0000)
                |     |    true
                |     "岸川克己"
                (name: "岸川克己", age: 37, birthday: 1980-10-27 15:00:00 +0000)

        """
      )
    }
  }

  func testNonAsciiCharacters3() {
    captureConsoleOutput {
      let dc = DateComponents(
        calendar: Calendar(identifier: .gregorian),
        timeZone: TimeZone(abbreviation: "JST")!,
        year: 1980,
        month: 10,
        day: 28
      )
      let date = dc.date!

      let kanjiName = "岸川克己"

      let tuple = (name: kanjiName, age: 37, birthday: date)

      #expect(tuple == (name: "岸川克己", age: 37, birthday: date), verbose: true)
      #expect(tuple == ("岸川克己", 37, date), verbose: true)
      #expect(tuple.name == ("岸川克己", 37, date).0 || tuple.age == ("岸川克己", 37, date).1, verbose: true)
      #expect(tuple.name == ("岸川克己", 37, date).0 && tuple.age == ("岸川克己", 37, date).1, verbose: true)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #expect(tuple == (name: "岸川克己", age: 37, birthday: date))
                |     |  |      |                |             |
                |     |  |      |                37            1980-10-27 15:00:00 +0000
                |     |  |      "岸川克己"
                |     |  ("岸川克己", 37, 1980-10-27 15:00:00 +0000)
                |     true
                ("岸川克己", 37, 1980-10-27 15:00:00 +0000)
        #expect(tuple == ("岸川克己", 37, date))
                |     |  ||           |   |
                |     |  ||           37  1980-10-27 15:00:00 +0000
                |     |  |"岸川克己"
                |     |  ("岸川克己", 37, 1980-10-27 15:00:00 +0000)
                |     true
                ("岸川克己", 37, 1980-10-27 15:00:00 +0000)
        #expect(tuple.name == ("岸川克己", 37, date).0 || tuple.age == ("岸川克己", 37, date).1)
                |     |    |  ||           |   |     | |
                |     |    |  ||           37  |     | true
                |     |    |  ||               |     "岸川克己"
                |     |    |  ||               1980-10-27 15:00:00 +0000
                |     |    |  |"岸川克己"
                |     |    |  ("岸川克己", 37, 1980-10-27 15:00:00 +0000)
                |     |    true
                |     "岸川克己"
                (name: "岸川克己", age: 37, birthday: 1980-10-27 15:00:00 +0000)
        #expect(tuple.name == ("岸川克己", 37, date).0 && tuple.age == ("岸川克己", 37, date).1)
                |     |    |  ||           |   |     | |  |     |   |  ||           |   |     |
                |     |    |  ||           37  |     | |  |     37  |  ||           37  |     37
                |     |    |  ||               |     | |  |         |  ||               1980-10-27 15:00:00 +0000
                |     |    |  ||               |     | |  |         |  |"岸川克己"
                |     |    |  ||               |     | |  |         |  ("岸川克己", 37, 1980-10-27 15:00:00 +0000)
                |     |    |  ||               |     | |  |         true
                |     |    |  ||               |     | |  (name: "岸川克己", age: 37, birthday: 1980-10-27 15:00:00 +0000)
                |     |    |  ||               |     | true
                |     |    |  ||               |     "岸川克己"
                |     |    |  ||               1980-10-27 15:00:00 +0000
                |     |    |  |"岸川克己"
                |     |    |  ("岸川克己", 37, 1980-10-27 15:00:00 +0000)
                |     |    true
                |     "岸川克己"
                (name: "岸川克己", age: 37, birthday: 1980-10-27 15:00:00 +0000)

        """
      )
    }
  }

  func testNonAsciiCharacters4() {
    captureConsoleOutput {
      let dc = DateComponents(
        calendar: Calendar(identifier: .gregorian),
        timeZone: TimeZone(abbreviation: "JST")!,
        year: 1980,
        month: 10,
        day: 28
      )
      let date = dc.date!

      let kanjiName = "岸川克己"

      let tuple = (name: kanjiName, age: 37, birthday: date)

      #expect(tuple.name != ("😇岸川克己🇯🇵", 37, date).0 || tuple.age == ("岸川克己", 37, date).1, verbose: true)
      #expect(tuple.name == ("岸川克己", 37, date).0 || tuple.age == ("😇岸川克己🇯🇵", 37, date).1, verbose: true)
      #expect(tuple.name != ("😇岸川克己🇯🇵", 37, date).0 && tuple.age == ("岸川克己", 37, date).1, verbose: true)
      #expect(tuple.name == ("岸川克己", 37, date).0 && tuple.age == ("😇岸川克己🇯🇵", 37, date).1, verbose: true)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #expect(tuple.name != ("😇岸川克己🇯🇵", 37, date).0 || tuple.age == ("岸川克己", 37, date).1)
                |     |    |  ||              |   |     | |
                |     |    |  ||              37  |     | true
                |     |    |  ||                  |     "😇岸川克己🇯🇵"
                |     |    |  ||                  1980-10-27 15:00:00 +0000
                |     |    |  |"😇岸川克己🇯🇵"
                |     |    |  ("😇岸川克己🇯🇵", 37, 1980-10-27 15:00:00 +0000)
                |     |    true
                |     "岸川克己"
                (name: "岸川克己", age: 37, birthday: 1980-10-27 15:00:00 +0000)
        #expect(tuple.name == ("岸川克己", 37, date).0 || tuple.age == ("😇岸川克己🇯🇵", 37, date).1)
                |     |    |  ||           |   |     | |
                |     |    |  ||           37  |     | true
                |     |    |  ||               |     "岸川克己"
                |     |    |  ||               1980-10-27 15:00:00 +0000
                |     |    |  |"岸川克己"
                |     |    |  ("岸川克己", 37, 1980-10-27 15:00:00 +0000)
                |     |    true
                |     "岸川克己"
                (name: "岸川克己", age: 37, birthday: 1980-10-27 15:00:00 +0000)
        #expect(tuple.name != ("😇岸川克己🇯🇵", 37, date).0 && tuple.age == ("岸川克己", 37, date).1)
                |     |    |  ||              |   |     | |  |     |   |  ||           |   |     |
                |     |    |  ||              37  |     | |  |     37  |  ||           37  |     37
                |     |    |  ||                  |     | |  |         |  ||               1980-10-27 15:00:00 +0000
                |     |    |  ||                  |     | |  |         |  |"岸川克己"
                |     |    |  ||                  |     | |  |         |  ("岸川克己", 37, 1980-10-27 15:00:00 +0000)
                |     |    |  ||                  |     | |  |         true
                |     |    |  ||                  |     | |  (name: "岸川克己", age: 37, birthday: 1980-10-27 15:00:00 +0000)
                |     |    |  ||                  |     | true
                |     |    |  ||                  |     "😇岸川克己🇯🇵"
                |     |    |  ||                  1980-10-27 15:00:00 +0000
                |     |    |  |"😇岸川克己🇯🇵"
                |     |    |  ("😇岸川克己🇯🇵", 37, 1980-10-27 15:00:00 +0000)
                |     |    true
                |     "岸川克己"
                (name: "岸川克己", age: 37, birthday: 1980-10-27 15:00:00 +0000)
        #expect(tuple.name == ("岸川克己", 37, date).0 && tuple.age == ("😇岸川克己🇯🇵", 37, date).1)
                |     |    |  ||           |   |     | |  |     |   |  ||              |   |     |
                |     |    |  ||           37  |     | |  |     37  |  ||              37  |     37
                |     |    |  ||               |     | |  |         |  ||                  1980-10-27 15:00:00 +0000
                |     |    |  ||               |     | |  |         |  |"😇岸川克己🇯🇵"
                |     |    |  ||               |     | |  |         |  ("😇岸川克己🇯🇵", 37, 1980-10-27 15:00:00 +0000)
                |     |    |  ||               |     | |  |         true
                |     |    |  ||               |     | |  (name: "岸川克己", age: 37, birthday: 1980-10-27 15:00:00 +0000)
                |     |    |  ||               |     | true
                |     |    |  ||               |     "岸川克己"
                |     |    |  ||               1980-10-27 15:00:00 +0000
                |     |    |  |"岸川克己"
                |     |    |  ("岸川克己", 37, 1980-10-27 15:00:00 +0000)
                |     |    true
                |     "岸川克己"
                (name: "岸川克己", age: 37, birthday: 1980-10-27 15:00:00 +0000)

        """
      )
    }
  }

  func testConditionalCompilationBlock() {
    captureConsoleOutput {
      let bar = Bar(foo: Foo(val: 2), val: 3)
#if swift(>=3.2)
      #expect(bar.val != bar.foo.val, verbose: true)
#endif
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #expect(bar.val != bar.foo.val)
                |   |   |  |   |   |
                |   3   |  |   |   2
                |       |  |   Foo(val: 2)
                |       |  Bar(foo: PowerAssertTests.Foo(val: 2), val: 3)
                |       true
                Bar(foo: PowerAssertTests.Foo(val: 2), val: 3)

        """
      )
    }
  }

//  func testSelectorExpression() {
//    captureConsoleOutput {
//      #powerAssert(
//        #selector(SomeObjCClass.doSomething(_:)) != #selector(getter: NSObjectProtocol.description),
//        verbose: true
//      )
//      #powerAssert(
//        #selector(getter: SomeObjCClass.property) != #selector(getter: NSObjectProtocol.description),
//        verbose: true
//      )
//    } completion: { (output) in
//      print(output)
//      XCTAssertEqual(
//        output,
//        """
//        #powerAssert(#selector(SomeObjCClass.doSomething(_:)) != #selector(getter: NSObjectProtocol.description))
//                     |         |                              |  |                 |
//                     |         SomeObjCClass                  |  "description"     NSObject
//                     "doSomethingWithInt:"                    true
//        #powerAssert(#selector(getter: SomeObjCClass.property) != #selector(getter: NSObjectProtocol.description))
//                     |                 |                       |  |                 |
//                     "property"        SomeObjCClass           |  "description"     NSObject
//                                                               true
//
//        """
//      )
//    }
//  }
//
//  func testClosureExpression() {
//    captureConsoleOutput {
//      let arr = [1000, 1500, 2000]
//      #powerAssert(
//        [10, 3, 20, 15, 4]
//          .sorted()
//          .filter { $0 > 5 }
//          .map { $0 * 100 } == arr,
//        verbose: true
//      )
//    } completion: { (output) in
//      print(output)
//      XCTAssertEqual(
//        output,
//        """
//        #powerAssert([10, 3, 20, 15, 4] .sorted() .filter { $0 > 5 } .map { $0 * 100 } == arr)
//                     ||   |  |   |   |   |         |                  |                |  |
//                     |10  3  20  15  4   |         [10, 15, 20]       |                |  [1000, 1500, 2000]
//                     [10, 3, 20, 15, 4]  [3, 4, 10, 15, 20]           |                true
//                                                                      [1000, 1500, 2000]
//
//        """
//      )
//    }
//  }

  // FIXME: If closures that span multiple lines are formatted on a single line,
  // such as consecutive variable definitions, the statements must be separated by a semicolon.
//  func testMultipleStatementInClosure() {
//    captureConsoleOutput {
//      let a = 5
//      let b = 10
//
//      #powerAssert(
//        { (a: Int, b: Int) -> Bool in
//          let c = a + b // error: consecutive statements on a line must be separated by ';'
//          let d = a - b
//          if c != d {
//            _ = c.distance(to: d)
//            _ = d.distance(to: c)
//          }
//          return c == d
//        }(a, b),
//        verbose: true
//      )
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

  func testMessageParameter() {
    captureConsoleOutput {
      let one = 1
      let two = 2
      let three = 3

      let array = [one, two, three]
      #expect(
        array.description.hasPrefix("[") != false && array.description.hasPrefix("Hello") != true,
        "message",
        verbose: true
      )
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #expect(array.description.hasPrefix("[") != false && array.description.hasPrefix("Hello") != true)
                |     |           |         |    |  |     |  |     |           |         |        |  |
                |     "[1, 2, 3]" true      "["  |  false |  |     "[1, 2, 3]" false     "Hello"  |  true
                [1, 2, 3]                        true     |  [1, 2, 3]                            true
                                                          true

        """
      )
    }
  }

  func testFileParameter() {
    captureConsoleOutput {
      let one = 1
      let two = 2
      let three = 3

      let array = [one, two, three]
      #expect(
        array.description.hasPrefix("[") != false && array.description.hasPrefix("Hello") != true,
        file: "path/to/Tests.swift",
        verbose: true
      )
      #expect(
        array.description.hasPrefix("[") != false && array.description.hasPrefix("Hello") != true,
        "message",
        file: "path/to/Tests.swift",
        verbose: true
      )
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #expect(array.description.hasPrefix("[") != false && array.description.hasPrefix("Hello") != true)
                |     |           |         |    |  |     |  |     |           |         |        |  |
                |     "[1, 2, 3]" true      "["  |  false |  |     "[1, 2, 3]" false     "Hello"  |  true
                [1, 2, 3]                        true     |  [1, 2, 3]                            true
                                                          true
        #expect(array.description.hasPrefix("[") != false && array.description.hasPrefix("Hello") != true)
                |     |           |         |    |  |     |  |     |           |         |        |  |
                |     "[1, 2, 3]" true      "["  |  false |  |     "[1, 2, 3]" false     "Hello"  |  true
                [1, 2, 3]                        true     |  [1, 2, 3]                            true
                                                          true

        """
      )
    }
  }

  func testLineParameter() {
    captureConsoleOutput {
      let one = 1
      let two = 2
      let three = 3

      let array = [one, two, three]
      #expect(
        array.description.hasPrefix("[") != false && array.description.hasPrefix("Hello") != true,
        line: 999,
        verbose: true
      )
      #expect(
        array.description.hasPrefix("[") != false && array.description.hasPrefix("Hello") != true,
        "message",
        line: 999,
        verbose: true
      )
      #expect(
        array.description.hasPrefix("[") != false && array.description.hasPrefix("Hello") != true,
        file: "path/to/Tests.swift",
        line: 999,
        verbose: true
      )
      #expect(
        array.description.hasPrefix("[") != false && array.description.hasPrefix("Hello") != true,
        "message",
        file: "path/to/Tests.swift",
        line: 999,
        verbose: true
      )
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #expect(array.description.hasPrefix("[") != false && array.description.hasPrefix("Hello") != true)
                |     |           |         |    |  |     |  |     |           |         |        |  |
                |     "[1, 2, 3]" true      "["  |  false |  |     "[1, 2, 3]" false     "Hello"  |  true
                [1, 2, 3]                        true     |  [1, 2, 3]                            true
                                                          true
        #expect(array.description.hasPrefix("[") != false && array.description.hasPrefix("Hello") != true)
                |     |           |         |    |  |     |  |     |           |         |        |  |
                |     "[1, 2, 3]" true      "["  |  false |  |     "[1, 2, 3]" false     "Hello"  |  true
                [1, 2, 3]                        true     |  [1, 2, 3]                            true
                                                          true
        #expect(array.description.hasPrefix("[") != false && array.description.hasPrefix("Hello") != true)
                |     |           |         |    |  |     |  |     |           |         |        |  |
                |     "[1, 2, 3]" true      "["  |  false |  |     "[1, 2, 3]" false     "Hello"  |  true
                [1, 2, 3]                        true     |  [1, 2, 3]                            true
                                                          true
        #expect(array.description.hasPrefix("[") != false && array.description.hasPrefix("Hello") != true)
                |     |           |         |    |  |     |  |     |           |         |        |  |
                |     "[1, 2, 3]" true      "["  |  false |  |     "[1, 2, 3]" false     "Hello"  |  true
                [1, 2, 3]                        true     |  [1, 2, 3]                            true
                                                          true

        """
      )
    }
  }

  func testStringContainsNewlines() {
    captureConsoleOutput {
      let loremIpsum = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
      #expect(
        loremIpsum != "Lorem ipsum dolor sit amet,\nconsectetur adipiscing elit,",
        verbose: true
      )
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        #"""
        #expect(loremIpsum != "Lorem ipsum dolor sit amet,\nconsectetur adipiscing elit,")
                |          |  |
                |          |  "Lorem ipsum dolor sit amet,\nconsectetur adipiscing elit,"
                |          true
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."

        """#
      )
    }
  }

  func testStringContainsEscapeSequences1() {
    captureConsoleOutput {
      let lyric1 = "Feet, don't fail me now."
      #expect(lyric1 == "Feet, don't fail me now.", verbose: true)
      #expect(lyric1 == "Feet, don\'t fail me now.", verbose: true)

      let lyric2 = "Feet, don\'t fail me now."
      #expect(lyric2 == "Feet, don't fail me now.", verbose: true)
      #expect(lyric2 == "Feet, don\'t fail me now.", verbose: true)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        #"""
        #expect(lyric1 == "Feet, don't fail me now.")
                |      |  |
                |      |  "Feet, don't fail me now."
                |      true
                "Feet, don't fail me now."
        #expect(lyric1 == "Feet, don\'t fail me now.")
                |      |  |
                |      |  "Feet, don't fail me now."
                |      true
                "Feet, don't fail me now."
        #expect(lyric2 == "Feet, don't fail me now.")
                |      |  |
                |      |  "Feet, don't fail me now."
                |      true
                "Feet, don't fail me now."
        #expect(lyric2 == "Feet, don\'t fail me now.")
                |      |  |
                |      |  "Feet, don't fail me now."
                |      true
                "Feet, don't fail me now."

        """#
      )
    }
  }

  func testStringContainsEscapeSequences2() {
    captureConsoleOutput {
      let nestedQuote1 = "My mother said, \"The baby started talking today. The baby said, 'Mama.'\""
      #expect(nestedQuote1 == "My mother said, \"The baby started talking today. The baby said, 'Mama.'\"", verbose: true)
      #expect(nestedQuote1 == "My mother said, \"The baby started talking today. The baby said, \'Mama.\'\"", verbose: true)

      let nestedQuote2 = "My mother said, \"The baby started talking today. The baby said, \'Mama.\'\""
      #expect(nestedQuote2 == "My mother said, \"The baby started talking today. The baby said, 'Mama.'\"", verbose: true)
      #expect(nestedQuote2 == "My mother said, \"The baby started talking today. The baby said, \'Mama.\'\"", verbose: true)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        #"""
        #expect(nestedQuote1 == "My mother said, \"The baby started talking today. The baby said, 'Mama.'\"")
                |            |  |
                |            |  "My mother said, \"The baby started talking today. The baby said, 'Mama.'\""
                |            true
                "My mother said, \"The baby started talking today. The baby said, 'Mama.'\""
        #expect(nestedQuote1 == "My mother said, \"The baby started talking today. The baby said, \'Mama.\'\"")
                |            |  |
                |            |  "My mother said, \"The baby started talking today. The baby said, 'Mama.'\""
                |            true
                "My mother said, \"The baby started talking today. The baby said, 'Mama.'\""
        #expect(nestedQuote2 == "My mother said, \"The baby started talking today. The baby said, 'Mama.'\"")
                |            |  |
                |            |  "My mother said, \"The baby started talking today. The baby said, 'Mama.'\""
                |            true
                "My mother said, \"The baby started talking today. The baby said, 'Mama.'\""
        #expect(nestedQuote2 == "My mother said, \"The baby started talking today. The baby said, \'Mama.\'\"")
                |            |  |
                |            |  "My mother said, \"The baby started talking today. The baby said, 'Mama.'\""
                |            true
                "My mother said, \"The baby started talking today. The baby said, 'Mama.'\""

        """#
      )
    }
  }

  func testStringContainsEscapeSequences3() {
    captureConsoleOutput {
      let helpText = "OPTIONS:\n  --build-path\t\tSpecify build/cache directory [default: ./.build]"
      #expect(helpText == "OPTIONS:\n  --build-path\t\tSpecify build/cache directory [default: ./.build]", verbose: true)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        #"""
        #expect(helpText == "OPTIONS:\n  --build-path\t\tSpecify build/cache directory [default: ./.build]")
                |        |  |
                |        |  "OPTIONS:\n  --build-path\t\tSpecify build/cache directory [default: ./.build]"
                |        true
                "OPTIONS:\n  --build-path\t\tSpecify build/cache directory [default: ./.build]"

        """#
      )
    }
  }

  func testStringContainsEscapeSequences4() {
    captureConsoleOutput {
      let nullCharacter = "Null character\0Null character"
      #expect(nullCharacter == "Null character\0Null character", verbose: true)

      let lineFeed = "Line feed\nLine feed"
      #expect(lineFeed == "Line feed\nLine feed", verbose: true)

      let carriageReturn = "Carriage Return\rCarriage Return"
      #expect(carriageReturn == "Carriage Return\rCarriage Return", verbose: true)

      let backslash = "Backslash\\Backslash"
      #expect(backslash == "Backslash\\Backslash", verbose: true)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        #"""
        #expect(nullCharacter == "Null character\0Null character")
                |             |  |
                |             |  "Null character\0Null character"
                |             true
                "Null character\0Null character"
        #expect(lineFeed == "Line feed\nLine feed")
                |        |  |
                |        |  "Line feed\nLine feed"
                |        true
                "Line feed\nLine feed"
        #expect(carriageReturn == "Carriage Return\rCarriage Return")
                |              |  |
                |              |  "Carriage Return\rCarriage Return"
                |              true
                "Carriage Return\rCarriage Return"
        #expect(backslash == "Backslash\\Backslash")
                |         |  |
                |         |  "Backslash\Backslash"
                |         true
                "Backslash\Backslash"

        """#
      )
    }
  }

  func testStringContainsEscapeSequences5() {
    captureConsoleOutput {
      let wiseWords = "\"Imagination is more important than knowledge\" - Einstein"
      let dollarSign = "\u{24}"        // $,  Unicode scalar U+0024
      let blackHeart = "\u{2665}"      // ♥,  Unicode scalar U+2665
      let sparklingHeart = "\u{1F496}" // 💖, Unicode scalar U+1F496
      #expect(wiseWords == "\"Imagination is more important than knowledge\" - Einstein", verbose: true)
      #expect(dollarSign == "\u{24}", verbose: true)
      #expect(blackHeart == "\u{2665}", verbose: true)
      #expect(sparklingHeart == "\u{1F496}", verbose: true)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        #"""
        #expect(wiseWords == "\"Imagination is more important than knowledge\" - Einstein")
                |         |  |
                |         |  "\"Imagination is more important than knowledge\" - Einstein"
                |         true
                "\"Imagination is more important than knowledge\" - Einstein"
        #expect(dollarSign == "\u{24}")
                |          |  |
                "$"        |  "$"
                           true
        #expect(blackHeart == "\u{2665}")
                |          |  |
                |          |  "♥"
                |          true
                "♥"
        #expect(sparklingHeart == "\u{1F496}")
                |              |  |
                |              |  "💖"
                |              true
                "💖"

        """#
      )
    }
  }

  func testMultilineStringLiterals1() {
    captureConsoleOutput {
      let multilineLiteral = """
        Lorem ipsum dolor sit amet, consectetur adipiscing elit,
        sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
        """
      #expect(
        multilineLiteral == """
          Lorem ipsum dolor sit amet, consectetur adipiscing elit,
          sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
          """,
        verbose: true
      )
      #expect(multilineLiteral == multilineLiteral, verbose: true)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        #"""
        #expect(multilineLiteral == "Lorem ipsum dolor sit amet, consectetur adipiscing elit,\nsed do eiusmod tempor incididunt ut labore et dolore magna aliqua.")
                |                |  |
                |                |  "Lorem ipsum dolor sit amet, consectetur adipiscing elit,\nsed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
                |                true
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit,\nsed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
        #expect(multilineLiteral == multilineLiteral)
                |                |  |
                |                |  "Lorem ipsum dolor sit amet, consectetur adipiscing elit,\nsed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
                |                true
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit,\nsed do eiusmod tempor incididunt ut labore et dolore magna aliqua."

        """#
      )
    }
  }

  func testMultilineStringLiterals2() {
    captureConsoleOutput {
      let multilineLiteral = """
        Escaping the first quotation mark \"""
        Escaping all three quotation marks \"\"\"
        """
      #expect(
        multilineLiteral != """
          Escaping the first quotation mark \"""
          Escaping all three quotation marks \"\"\"
          """,
        verbose: true
      )
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        ##"""
        #expect(multilineLiteral != #"Escaping the first quotation mark \"""\#nEscaping all three quotation marks \"\"\""#)
                |                |  |
                |                |  "Escaping the first quotation mark \\"\"\"\nEscaping all three quotation marks \\"\\"\\""
                |                true
                "Escaping the first quotation mark \"\"\"\nEscaping all three quotation marks \"\"\""

        """##
      )
    }
  }

  func testCustomOperator() {
    captureConsoleOutput {
      let number1 = 100.0
      let number2 = 200.0
      #expect(number1 × number2 == 20000.0, verbose: true) // FIXME: Print the value of the expression
      #expect(√number2 == 14.142135623730951, verbose: true)
      #expect(√√number2 != 200.0, verbose: true)
      #expect(3.760603093086394 == √√number2, verbose: true)
      #expect(√number2 != √√number2, verbose: true)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #expect(number1 × number2 == 20000.0)
                |       |  |          |
                100.0   |  200.0      20000.0
                        true
        #expect(√number2 == 14.142135623730951)
                | |       |  |
                | 200.0   |  14.142135623730951
                |         true
                14.142135623730951
        #expect(√√number2 != 200.0)
                |   |       |  |
                |   200.0   |  200.0
                |           true
                3.760603093086394
        #expect(3.760603093086394 == √√number2)
                |                 |  |   |
                3.760603093086394 |  |   200.0
                                  |  3.760603093086394
                                  true
        #expect(√number2 != √√number2)
                | |       |   |  |
                | 200.0   |   |  200.0
                |         |   3.760603093086394
                |         true
                14.142135623730951

        """
      )
    }
  }

  func testNoWhitespaces1() {
    captureConsoleOutput {
      let b1=false
      let i1=0
      let i2=1
      let d1=4.0
      let d2=6.0
      #expect(i2==1,verbose:true)
      #expect(b1==false&&i1<i2||false==b1&&i2==1,verbose:true)
      #expect(b1==false&&i1<i2||false==b1&&i2==1||d1×d2==24.0,verbose:true)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #expect(i2==1)
                | | |
                1 | 1
                  true
        #expect(b1==false&&i1<i2||false==b1&&i2==1)
                | | |    | | || |
                | | |    | 0 |1 true
                | | |    |   true
                | | |    true
                | | false
                | true
                false
        #expect(b1==false&&i1<i2||false==b1&&i2==1||d1×d2==24.0)
                | | |      |  |
                | | false  0  1
                | true
                false

        """
      )
    }
  }

  func testNoWhitespaces2() {
    captureConsoleOutput {
      let b1=false
      let i1=0
      let i2=1
      let d1=4.0
      let d2=6.0
      #expect(i2==1,verbose:true)
      #expect(b1==false&&i1<i2&&false==b1&&i2==1,verbose:true)
      #expect(b1==false&&i1<i2&&false==b1&&i2==1||d1×d2==24.0,verbose:true)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #expect(i2==1)
                | | |
                1 | 1
                  true
        #expect(b1==false&&i1<i2&&false==b1&&i2==1)
                | | |    | | || | |    | | | | | |
                | | |    | 0 |1 | |    | | | 1 | 1
                | | |    |   |  | |    | | |   true
                | | |    |   |  | |    | | true
                | | |    |   |  | |    | false
                | | |    |   |  | |    true
                | | |    |   |  | false
                | | |    |   |  true
                | | |    |   true
                | | |    true
                | | false
                | true
                false
        #expect(b1==false&&i1<i2&&false==b1&&i2==1||d1×d2==24.0)
                | | |      |  |   |      |   |   |
                | | false  0  1   false  |   1   1
                | true                   false
                false

        """
      )
    }
  }

  func testHigherOrderFunction() {
    captureConsoleOutput {
      func testA(_ i: Int) -> Int {
        return i + 1
      }

      func testB(_ i: Int) -> Int {
        return i + 1
      }

      let array = [0, 1, 2]
      #expect(array.map { testA($0) } == [1, 2, 3], verbose: true)
      #expect(array.map(testB) == [1, 2, 3], verbose: true)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #expect(array.map { testA($0) } == [1, 2, 3])
                |     |                 |  ||  |  |
                |     [1, 2, 3]         |  |1  2  3
                [0, 1, 2]               |  [1, 2, 3]
                                        true
        #expect(array.map(testB) == [1, 2, 3])
                |     |   |      |  ||  |  |
                |     |   |      |  |1  2  3
                |     |   |      |  [1, 2, 3]
                |     |   |      true
                |     |   (Function)
                |     [1, 2, 3]
                [0, 1, 2]

        """
      )
    }
  }

  func testStringInterpolation() {
    captureConsoleOutput {
      func testA(_ i: Int) -> Int {
        return i + 1
      }

      let string = "World!"
      #expect("Hello \(string)" == "Hello World!", verbose: true)

      let i = 99
      #expect("value == \(testA(i))" == "value == 100", verbose: true)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        #"""
        #expect("Hello \(string)" == "Hello World!")
                |        |        |  |
                |        "World!" |  "Hello World!"
                "Hello World!"    true
        #expect("value == \(testA(i))" == "value == 100")
                |           |     |    |  |
                |           100   99   |  "value == 100"
                "value == 100"         true

        """#
      )
    }
  }

//  func testStringWidth() async throws {
//    #powerAssert("12345678901234567890".count == -1)
//    #powerAssert("foo".count == -1)
//    #powerAssert("⌚⭐⺎⽋豈Ａ🚀".count == -1)
//    #powerAssert("\u{0008}\u{007F}".count == -1)
//    #powerAssert("\u{001B}[31mfoo\u{001B}[39m".count == -1)
//    #powerAssert("\u{001B}]8;;https://foo.com\u{0007}bar\u{001B}]8;;\u{0007}".count == -1)
//    #powerAssert("".count == -1)
//    #powerAssert("☠️".count == -1)
//    #powerAssert("👩".count == -1)
//    #powerAssert("👩🏿".count == -1)
//    #powerAssert("x\u{1F3FF}".count == -1)
//    #powerAssert("🇺🇸".count == -1)
//    #powerAssert("🏴󠁧󠁢󠁥󠁮󠁧󠁿".count == -1)
//    #powerAssert(#"#️⃣"#.count == -1)
//    #powerAssert("👨‍❤️‍💋‍👨🏳️‍🌈".count == -1)
//    #powerAssert("🦹🏻‍♀️".count == -1)
//    #powerAssert("🦹🏻‍♀".count == -1)
//    #powerAssert("👨️‍⚕️".count == -1)
//    #powerAssert("⛹️‍😕️".count == -1)
//    #powerAssert("😕🏻‍🦰".count == -1)
//    #powerAssert("👨‍😕🏼".count == -1)
//    #powerAssert("🙆🏾🏾‍♂️".count == -1)
//    #powerAssert("🧑🏽‍🤝🏿🏿‍🧑🏿".count == -1)
//  }

  private let stringValue = "string"
  private let intValue = 100
  private let doubleValue = 999.9
}
