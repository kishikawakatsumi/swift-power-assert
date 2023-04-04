import XCTest
@testable import PowerAssert

final class PowerAssertTests: XCTestCase {
  private let stringValue = "string"
  private let intValue = 100
  private let doubleValue = 999.9

  func testBinaryExpression1() {
    captureConsoleOutput {
      let bar = Bar(foo: Foo(val: 2), val: 3)
      #powerAssert(bar.val != bar.foo.val, verbose: true)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #powerAssert(bar.val != bar.foo.val)
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
      #powerAssert(bar.val > bar.foo.val, verbose: true)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #powerAssert(bar.val > bar.foo.val)
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
      #powerAssert(array.firstIndex(of: zero) != two, verbose: true)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #powerAssert(array.firstIndex(of: zero) != two)
                     |     |              |     |  |
                     |     nil            0     |  2
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
      #powerAssert(array.description.hasPrefix("[") == true && array.description.hasPrefix("Hello") == false, verbose: true)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #powerAssert(array.description.hasPrefix("[") == true && array.description.hasPrefix("Hello") == false)
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
      #powerAssert(array.firstIndex(of: zero) != two && bar.val != bar.foo.val, verbose: true)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #powerAssert(array.firstIndex(of: zero) != two && bar.val != bar.foo.val)
                     |     |              |     |  |   |  |   |   |  |   |   |
                     |     nil            0     |  2   |  |   3   |  |   |   2
                     [1, 2, 3]                  true   |  |       |  |   Foo(val: 2)
                                                       |  |       |  Bar(foo: PowerAssertTests.Foo(val: 2), val: 3)
                                                       |  |       true
                                                       |  Bar(foo: PowerAssertTests.Foo(val: 2), val: 3)
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
      #powerAssert(array.distance(from: 2, to: 3) == 1, verbose: true)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #powerAssert(array.distance(from: 2, to: 3) == 1)
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

      #powerAssert([one, two, three].count == 3, verbose: true)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #powerAssert([one, two, three].count == 3)
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

      #powerAssert((object.types[index] as! Person).name != bob.name, verbose: true)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #powerAssert((object.types[index] as! Person).name != bob.name)
                     ||      |     |    |             |    |  |   |
                     ||      |     7    |             |    |  |   "bob"
                     ||      |          |             |    |  Person(name: "bob", age: 5)
                     ||      |          |             |    true
                     ||      |          |             "alice"
                     ||      |          Person(name: "alice", age: 3)
                     ||      [Optional("string"), Optional(98.6), Optional(true), Optional(false), nil, Optional(nan), Optional(inf), Optional(PowerAssertTests.Person(name: "alice", age: 3))]
                     |Object(types: [Optional("string"), Optional(98.6), Optional(true), Optional(false), nil, Optional(nan), Optional(inf), Optional(PowerAssertTests.Person(name: "alice", age: 3))])
                     Person(name: "alice", age: 3)

        """
      )
    }
  }

  func testMultilineExpression1() {
    captureConsoleOutput {
      let bar = Bar(foo: Foo(val: 2), val: 3)

      #powerAssert(bar.val != bar.foo.val, verbose: true)
      #powerAssert(bar
        .val !=
             bar.foo.val, verbose: true)
      #powerAssert(bar
        .val !=
             bar
        .foo        .val, verbose: true)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #powerAssert(bar.val != bar.foo.val)
                     |   |   |  |   |   |
                     |   3   |  |   |   2
                     |       |  |   Foo(val: 2)
                     |       |  Bar(foo: PowerAssertTests.Foo(val: 2), val: 3)
                     |       true
                     Bar(foo: PowerAssertTests.Foo(val: 2), val: 3)
        #powerAssert(bar .val != bar.foo.val)
                     |    |   |  |   |   |
                     |    3   |  |   |   2
                     |        |  |   Foo(val: 2)
                     |        |  Bar(foo: PowerAssertTests.Foo(val: 2), val: 3)
                     |        true
                     Bar(foo: PowerAssertTests.Foo(val: 2), val: 3)
        #powerAssert(bar .val != bar .foo .val)
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

      #powerAssert(array    .        firstIndex(
        of:    zero)
             != two,
                   verbose: true
      )

      #powerAssert(array
        .
                   firstIndex(

              of:
                zero)
             != two

                   ,     verbose: true
      )

      #powerAssert(array
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
        #powerAssert(array . firstIndex( of: zero) != two)
                     |       |               |     |  |
                     |       nil             0     |  2
                     [1, 2, 3]                     true
        #powerAssert(array . firstIndex( of: zero) != two)
                     |       |               |     |  |
                     |       nil             0     |  2
                     [1, 2, 3]                     true
        #powerAssert(array .firstIndex( of: zero) != two)
                     |      |               |     |  |
                     |      nil             0     |  2
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
      #powerAssert(array
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
        #powerAssert(array .description .hasPrefix( "[" ) == true && array .description .hasPrefix ("Hello" ) == false)
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

      #powerAssert(

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
        #powerAssert(array.firstIndex( of: zero ) != two && bar .val != bar .foo .val)
                     |     |               |      |  |   |  |    |   |  |    |    |
                     |     nil             0      |  2   |  |    3   |  |    |    2
                     [1, 2, 3]                    true   |  |        |  |    Foo(val: 2)
                                                         |  |        |  Bar(foo: PowerAssertTests.Foo(val: 2), val: 3)
                                                         |  |        true
                                                         |  Bar(foo: PowerAssertTests.Foo(val: 2), val: 3)
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
      #powerAssert(

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
        #powerAssert(array .distance( from: 2, to: 3) != 4)
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

      #powerAssert([one,
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
        #powerAssert([one, two , three] .count != 10)
                     ||    |     |       |     |  |
                     |1    2     3       3     |  10
                     [1, 2, 3]                 true

        """
      )
    }
  }

//  func testTryExpression() {
//    captureConsoleOutput {
//      let landmark = Landmark(
//        name: "Tokyo Tower",
//        foundingYear: 1957,
//        location: Coordinate(latitude: 35.658581, longitude: 139.745438)
//      )
//
//      #powerAssert(
//        try! JSONEncoder().encode(landmark) == "{ name: \"Tokyo Tower\" }".data(using: String.Encoding.utf8),
//        verbose: true
//      )
//      #powerAssert(
//        try! JSONEncoder().encode(landmark) == #"{ name: "Tokyo Tower" }"#.data(using: .utf8),
//        verbose: true
//      )
//      #powerAssert(
//        try! #"{ name: "Tokyo Tower" }"#.data(using: String.Encoding.utf8) == JSONEncoder().encode(landmark),
//        verbose: true
//      )
//    } completion: { (output) in
//      print(output)
//      XCTAssertEqual(
//        output,
//        """
//        #powerAssert([one, two , three] .count != 10)
//                     ||    |     |       |     |  |
//                     |1    2     3       3     |  10
//                     [1, 2, 3]                 true
//
//        """
//      )
//    }
//  }

  func testNilLiteral() {
    captureConsoleOutput {
      let string = "1234"
      let number = Int(string)

      #powerAssert(number != nil && number == 1234, verbose: true)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #powerAssert(number != nil && number == 1234)
                     |      |      |  |      |  |
                     1234   true   |  1234   |  1234
                                   true      true

        """
      )
    }
  }

  func testTernaryConditionalOperator() {
    captureConsoleOutput {
      let string = "1234"
      let number = Int(string)
      let hello = "hello"

      #powerAssert((number != nil ? string : hello) == string, verbose: true)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #powerAssert((number != nil ? string : hello) == string)
                     ||      |        |        |      |  |
                     |1234   "1234"   "1234"   |      |  "1234"
                     "1234"                    |      true
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

      #powerAssert([one, two, three].firstIndex(of: zero) != two, verbose: true)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #powerAssert([one, two, three].firstIndex(of: zero) != two)
                     ||    |    |      |              |     |  |
                     |1    2    3      nil            0     |  2
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

      #powerAssert([zero: one, two: three].count != three, verbose: true)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #powerAssert([zero: one, two: three].count != three)
                     ||     |    |    |      |     |  |
                     |0     1    2    3      2     |  3
                     [0: 1, 2: 3]                  true

        """
      )
    }
  }

  func testMagicLiteralExpression() {
    captureConsoleOutput {
      #powerAssert(
        #file != "*.swift" && #line != 1 && #column != 2 && #function != "function",
        verbose: true
      )
      #powerAssert(
        #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1) != .blue &&
          .blue != #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1),
        verbose: true
      )
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #powerAssert(#file != "*.swift" && #line != 1 && #column != 2 && #function != "function")
                     |     |  |         |  |     |  | |  |       |  | |  |         |  |
                     |     |  "*.swift" |  2     |  1 |  912     |  2 |  |         |  "function"
                     |     true         true     true true       true |  |         true
                     |                                                |  "testMagicLiteralExpression()"
                     |                                                true
                     "@__swiftmacro_16PowerAssertTestsAAC26testMagicLiteralExpressionyyFyyXEfU_05powerB0fMf_.swift"
        #powerAssert(#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1) != .blue && .blue != #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1))
                     |                  |                    |                    |                    |  |        |        |  |                  |                    |                    |                    |
                     |                  0.8078431487         0.02745098062        0.3333333433         1  true     true     |  |                  0.8078431487         0.02745098062        0.3333333433         1
                     sRGB IEC61966-2.1 colorspace 0.807843 0.027451 0.333333 1                                              |  sRGB IEC61966-2.1 colorspace 0.807843 0.027451 0.333333 1
                                                                                                                            true

        """
      )
    }
  }

  func testSelfExpression() {
    captureConsoleOutput {
      #powerAssert(
        self.stringValue == "string" && self.intValue == 100 && self.doubleValue == 999.9,
        verbose: true
      )
      #powerAssert(super.continueAfterFailure == true, verbose: true)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #powerAssert(self.stringValue == "string" && self.intValue == 100 && self.doubleValue == 999.9)
                     |    |           |  |        |  |    |        |  |   |  |    |           |  |
                     |    "string"    |  "string" |  |    100      |  100 |  |    999.9       |  999.9
                     |                true        |  |             true   |  |                true
                     |                            |  |                    |  -[PowerAssertTests testSelfExpression]
                     |                            |  |                    true
                     |                            |  -[PowerAssertTests testSelfExpression]
                     |                            true
                     -[PowerAssertTests testSelfExpression]
        #powerAssert(super.continueAfterFailure == true)
                           |                    |  |
                           true                 |  true
                                                true

        """
      )
    }
  }

//  func testImplicitMemberExpression() {
//    captureConsoleOutput {
//      let i = 16
//      #powerAssert(i == .bitWidth && i == Double.Exponent.bitWidth, verbose: true)
//
//      let mask: CAAutoresizingMask = [.layerMaxXMargin, .layerMaxYMargin]
//      #powerAssert(mask != [.layerMaxXMargin, .layerMaxYMargin], verbose: true)
//    } completion: { (output) in
//      print(output)
//      XCTAssertEqual(
//        output,
//        """
//        #powerAssert(self.stringValue == "string" && self.intValue == 100 && self.doubleValue == 999.9)
//                     |    |           |  |        |  |    |        |  |   |  |    |           |  |
//                     |    "string"    |  "string" |  |    100      |  100 |  |    999.9       |  999.9
//                     |                true        |  |             true   |  |                true
//                     |                            |  |                    |  -[PowerAssertTests testSelfExpression]
//                     |                            |  |                    true
//                     |                            |  -[PowerAssertTests testSelfExpression]
//                     |                            true
//                     -[PowerAssertTests testSelfExpression]
//        #powerAssert(super.continueAfterFailure == true)
//                           |                    |  |
//                           true                 |  true
//                                                true
//
//        """
//      )
//    }
//  }

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

      #powerAssert(tuple != (name: "Katsumi", age: 37, birthday: date2), verbose: true)
      #powerAssert(tuple != ("Katsumi", 37, date2), verbose: true)
      #powerAssert(tuple.name == ("Katsumi", 37, date2).0 || tuple.age != ("Katsumi", 37, date2).1, verbose: true)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #powerAssert(tuple != (name: "Katsumi", age: 37, birthday: date2))
                     |     |  |      |               |             |
                     |     |  |      "Katsumi"       37            2000-12-30 15:00:00 +0000
                     |     |  (name: "Katsumi", age: 37, birthday: 2000-12-30 15:00:00 +0000)
                     |     true
                     (name: "Katsumi", age: 37, birthday: 1980-10-27 15:00:00 +0000)
        #powerAssert(tuple != ("Katsumi", 37, date2))
                     |     |  ||          |   |
                     |     |  |"Katsumi"  37  2000-12-30 15:00:00 +0000
                     |     |  ("Katsumi", 37, 2000-12-30 15:00:00 +0000)
                     |     true
                     (name: "Katsumi", age: 37, birthday: 1980-10-27 15:00:00 +0000)
        #powerAssert(tuple.name == ("Katsumi", 37, date2).0 || tuple.age != ("Katsumi", 37, date2).1)
                     |     |    |  ||          |   |      | |  |     |   |  ||          |   |      |
                     |     |    |  |"Katsumi"  37  |      | |  |     37  |  |"Katsumi"  37  |      37
                     |     |    |  |               |      | |  |         |  |               2000-12-30 15:00:00 +0000
                     |     |    |  |               |      | |  |         |  ("Katsumi", 37, 2000-12-30 15:00:00 +0000)
                     |     |    |  |               |      | |  |         true
                     |     |    |  |               |      | |  (name: "Katsumi", age: 37, birthday: 1980-10-27 15:00:00 +0000)
                     |     |    |  |               |      | true
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

      #powerAssert(s[keyPath: pathToProperty] == 12, verbose: true)
      #powerAssert(s[keyPath: \SomeStructure.someValue] == 12, verbose: true)
      #powerAssert(s.getValue(keyPath: \.someValue) == 12, verbose: true)

      let nested = OuterStructure(someValue: 24)
      let nestedKeyPath = \OuterStructure.outer.someValue

      #powerAssert(nested[keyPath: nestedKeyPath] == 24, verbose: true)
      #powerAssert(nested[keyPath: \OuterStructure.outer.someValue] == 24, verbose: true)
      #powerAssert(nested.getValue(keyPath: \.outer.someValue) == 24, verbose: true)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        #"""
        #powerAssert(s[keyPath: pathToProperty] == 12)
                     |          |             | |  |
                     |          |             | |  12
                     |          |             | true
                     |          |             12
                     |          \SomeStructure.someValue
                     SomeStructure(someValue: 12)
        #powerAssert(s[keyPath: \SomeStructure.someValue] == 12)
                     |          |                       | |  |
                     |          |                       | |  12
                     |          |                       | true
                     |          |                       12
                     |          \SomeStructure.someValue
                     SomeStructure(someValue: 12)
        #powerAssert(s.getValue(keyPath: \.someValue) == 12)
                     | |                              |  |
                     | 12                             |  12
                     SomeStructure(someValue: 12)     true
        #powerAssert(nested[keyPath: nestedKeyPath] == 24)
                     |               |            | |  |
                     |               |            | |  24
                     |               |            | true
                     |               |            24
                     |               \OuterStructure.outer.someValue
                     OuterStructure(outer: PowerAssertTests.SomeStructure(someValue: 24))
        #powerAssert(nested[keyPath: \OuterStructure.outer.someValue] == 24)
                     |               |                              | |  |
                     |               |                              | |  24
                     |               |                              | true
                     |               |                              24
                     |               \OuterStructure.outer.someValue
                     OuterStructure(outer: PowerAssertTests.SomeStructure(someValue: 24))
        #powerAssert(nested.getValue(keyPath: \.outer.someValue) == 24)
                     |      |                                    |  |
                     |      24                                   |  24
                     |                                           true
                     OuterStructure(outer: PowerAssertTests.SomeStructure(someValue: 24))

        """#
      )
    }
  }

  func testSubscriptKeyPathExpression() throws {
    throw XCTSkip()

    captureConsoleOutput {
      let greetings = ["hello", "hola", "bonjour", "안녕"]

      #powerAssert(greetings[keyPath: \[String].[1]] == "hola", verbose: true)
      #powerAssert(greetings[keyPath: \[String].first?.count] == 5, verbose: true)

      let interestingNumbers = [
        "prime": [2, 3, 5, 7, 11, 13, 15],
        "triangular": [1, 3, 6, 10, 15, 21, 28],
        "hexagonal": [1, 6, 15, 28, 45, 66, 91]
      ]
      #powerAssert(
        interestingNumbers[keyPath: \[String: [Int]].["prime"]]! == [2, 3, 5, 7, 11, 13, 15],
        verbose: true
      )
      #powerAssert(
        interestingNumbers[keyPath: \[String: [Int]].["prime"]![0]] == 2,
        verbose: true
      )
      #powerAssert(
        interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count] == 7,
        verbose: true
      )
      #powerAssert(
        interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count.bitWidth] == 64,
        verbose: true
      )
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        #"""
        #powerAssert(greetings[keyPath: \[String].[1]] == "hola")
                     |                  ||        || | |  |
                     |                  ||        |1 | |  "hola"
                     |                  ||        |  | true
                     |                  ||        |  "hola"
                     |                  ||        [1]
                     |                  |Array<String>
                     |                  \Array<String>.<computed 0x00000001a128ad3c (String)>
                     ["hello", "hola", "bonjour", "안녕"]
        #powerAssert(greetings[keyPath: \[String].first?.count] == 5)
                     |                  ||                    | |  |
                     |                  |Array<String>        5 |  5
                     |                  |                       true
                     |                  \Array<String>.first?.count?
                     ["hello", "hola", "bonjour", "안녕"]
        #powerAssert(interestingNumbers[keyPath: \[String: [Int]].["prime"]]! == [2, 3, 5, 7, 11, 13, 15])
                     ||                          ||        |      ||       |  |  ||  |  |  |  |   |   |
                     ||                          ||        |      |"prime" |  |  |2  3  5  7  11  13  15
                     ||                          ||        |      |        |  |  [2, 3, 5, 7, 11, 13, 15]
                     ||                          ||        |      |        |  true
                     ||                          ||        |      |        [2, 3, 5, 7, 11, 13, 15]
                     ||                          ||        |      ["prime"]
                     ||                          ||        Array<Int>
                     ||                          |Dictionary<String, Array<Int>>
                     ||                          \Dictionary<String, Array<Int>>.<computed 0x00000001a128b19c (Optional<Array<Int>>)>
                     |["hexagonal": [1, 6, 15, 28, 45, 66, 91], "prime": [2, 3, 5, 7, 11, 13, 15], "triangular": [1, 3, 6, 10, 15, 21, 28]]
                     [2, 3, 5, 7, 11, 13, 15]
        #powerAssert(interestingNumbers[keyPath: \[String: [Int]].["prime"]![0]] == 2)
                     |                           ||        |      ||        || | |  |
                     |                           ||        |      |"prime"  |0 2 |  2
                     |                           ||        |      ["prime"] [0]  true
                     |                           ||        Array<Int>
                     |                           |Dictionary<String, Array<Int>>
                     |                           \Dictionary<String, Array<Int>>.<computed 0x00000001a128b19c (Optional<Array<Int>>)>!.<computed 0x00000001a128ad3c (Int)>
                     ["hexagonal": [1, 6, 15, 28, 45, 66, 91], "prime": [2, 3, 5, 7, 11, 13, 15], "triangular": [1, 3, 6, 10, 15, 21, 28]]
        #powerAssert(interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count] == 7)
                     |                           ||        |      ||                  | |  |
                     |                           ||        |      |"hexagonal"        7 |  7
                     |                           ||        |      ["hexagonal"]         true
                     |                           ||        Array<Int>
                     |                           |Dictionary<String, Array<Int>>
                     |                           \Dictionary<String, Array<Int>>.<computed 0x00000001a128b19c (Optional<Array<Int>>)>!.count
                     ["hexagonal": [1, 6, 15, 28, 45, 66, 91], "prime": [2, 3, 5, 7, 11, 13, 15], "triangular": [1, 3, 6, 10, 15, 21, 28]]
        #powerAssert(interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count.bitWidth] == 64)
                     |                           ||        |      ||                           | |  |
                     |                           ||        |      |"hexagonal"                 | |  64
                     |                           ||        |      ["hexagonal"]                | true
                     |                           ||        Array<Int>                          64
                     |                           |Dictionary<String, Array<Int>>
                     |                           \Dictionary<String, Array<Int>>.<computed 0x00000001a128b19c (Optional<Array<Int>>)>!.count.bitWidth
                     ["hexagonal": [1, 6, 15, 28, 45, 66, 91], "prime": [2, 3, 5, 7, 11, 13, 15], "triangular": [1, 3, 6, 10, 15, 21, 28]]

        """#
      )
    }
  }

//  func testInitializerExpression() {
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
      #powerAssert(String.self != Int.self && "string".self == "string", verbose: true)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #powerAssert(String.self != Int.self && "string".self == "string")
                     |      |    |  |   |    |  |        |    |  |
                     String |    |  Int Int  |  "string" |    |  "string"
                            |    true        true        |    true
                            String                       "string"

        """
      )
    }
  }

  func testForcedValueExpression() {
    captureConsoleOutput {
      let x: Int? = 0
      let someDictionary = ["a": [1, 2, 3], "b": [10, 20]]

      #powerAssert(x! == 0, verbose: true)
      #powerAssert(someDictionary["a"]![0] == 1, verbose: true)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #powerAssert(x! == 0)
                     || |  |
                     |0 |  0
                     0  true
        #powerAssert(someDictionary["a"]![0] == 1)
                     ||             |  |  || |  |
                     ||             |  |  |1 |  1
                     ||             |  |  0  true
                     ||             |  [1, 2, 3]
                     ||             "a"
                     |["a": [1, 2, 3], "b": [10, 20]]
                     [1, 2, 3]

        """
      )
    }
  }

  func testOptionalChainingExpression() {
    captureConsoleOutput {
      var c: SomeClass?
      #powerAssert(c?.property.performAction() == nil, verbose: true)

      c = SomeClass()
      #powerAssert((c?.property.performAction())!, verbose: true)
      #powerAssert(c?.property.performAction() != nil, verbose: true)

      let someDictionary = ["a": [1, 2, 3], "b": [10, 20]]
      #powerAssert(someDictionary["not here"]?[0] != 99, verbose: true)
      #powerAssert(someDictionary["a"]?[0] != 99, verbose: true)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #powerAssert(c?.property.performAction() == nil)
                     |  |        |               |
                     |  nil      nil             true
                     nil
        #powerAssert((c?.property.performAction())!)
                     ||| |        |
                     ||| |        true
                     ||| PowerAssertTests.OtherClass
                     ||PowerAssertTests.SomeClass
                     |true
                     true
        #powerAssert(c?.property.performAction() != nil)
                     |  |        |               |
                     |  |        true            true
                     |  PowerAssertTests.OtherClass
                     PowerAssertTests.SomeClass
        #powerAssert(someDictionary["not here"]?[0] != 99)
                     |              |         |  || |  |
                     |              |         |  || |  99
                     |              |         |  || true
                     |              |         |  |nil
                     |              |         |  0
                     |              |         nil
                     |              "not here"
                     ["a": [1, 2, 3], "b": [10, 20]]
        #powerAssert(someDictionary["a"]?[0] != 99)
                     |              |  |  || |  |
                     |              |  |  |1 |  99
                     |              |  |  0  true
                     |              |  [1, 2, 3]
                     |              "a"
                     ["a": [1, 2, 3], "b": [10, 20]]

        """
      )
    }
  }

  func testNonAsciiCharacters() {
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

      #powerAssert(tuple != (name: kanjiName, age: 37, birthday: date), verbose: true)
      #powerAssert(tuple != (kanjiName, 37, date), verbose: true)
      #powerAssert(tuple.name != (kanjiName, 37, date).0 || tuple.age != (kanjiName, 37, date).1, verbose: true)

      #powerAssert(tuple.name == (emojiName, 37, date).0 || tuple.age != (kanjiName, 37, date).1, verbose: true)
      #powerAssert(tuple.name != (kanjiName, 37, date).0 || tuple.age != (emojiName, 37, date).1, verbose: true)

      #powerAssert(tuple != (name: "岸川克己", age: 37, birthday: date), verbose: true)
      #powerAssert(tuple != ("岸川克己", 37, date), verbose: true)
      #powerAssert(tuple.name != ("岸川克己", 37, date).0 || tuple.age != ("岸川克己", 37, date).1, verbose: true)

      #powerAssert(tuple.name == ("😇岸川克己🇯🇵", 37, date).0 || tuple.age != ("岸川克己", 37, date).1, verbose: true)
      #powerAssert(tuple.name != ("岸川克己", 37, date).0 || tuple.age != ("😇岸川克己🇯🇵", 37, date).1, verbose: true)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #powerAssert(x! == 0)
                     || |  |
                     |0 |  0
                     0  true
        #powerAssert(someDictionary["a"]![0] == 1)
                     ||             |  |  || |  |
                     ||             |  |  |1 |  1
                     ||             |  |  0  true
                     ||             |  [1, 2, 3]
                     ||             "a"
                     |["a": [1, 2, 3], "b": [10, 20]]
                     [1, 2, 3]

        """
      )
    }
  }

  func testConditionalCompilationBlock() {
    captureConsoleOutput {
      let bar = Bar(foo: Foo(val: 2), val: 3)
#if swift(>=3.2)
      #powerAssert(bar.val != bar.foo.val, verbose: true)
#endif
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #powerAssert(bar.val != bar.foo.val)
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
//
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
//        #powerAssert(bar.val != bar.foo.val)
//                     |   |   |  |   |   |
//                     |   3   |  |   |   2
//                     |       |  |   Foo(val: 2)
//                     |       |  Bar(foo: PowerAssertTests.Foo(val: 2), val: 3)
//                     |       true
//                     Bar(foo: PowerAssertTests.Foo(val: 2), val: 3)
//
//        """
//      )
//    }
//  }

//  func testExplicitMemberExpression() {
//    captureConsoleOutput {
//      let arr = [1, 2, 3]
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
//        #powerAssert(bar.val != bar.foo.val)
//                     |   |   |  |   |   |
//                     |   3   |  |   |   2
//                     |       |  |   Foo(val: 2)
//                     |       |  Bar(foo: PowerAssertTests.Foo(val: 2), val: 3)
//                     |       true
//                     Bar(foo: PowerAssertTests.Foo(val: 2), val: 3)
//
//        """
//      )
//    }
//  }

//  func testMultipleStatementInClosure() {
//    captureConsoleOutput {
//      let a = 5
//      let b = 10
//
//      #powerAssert(
//        { (a: Int, b: Int) -> Bool in
//          let c = a + b
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
//        #powerAssert(bar.val != bar.foo.val)
//                     |   |   |  |   |   |
//                     |   3   |  |   |   2
//                     |       |  |   Foo(val: 2)
//                     |       |  Bar(foo: PowerAssertTests.Foo(val: 2), val: 3)
//                     |       true
//                     Bar(foo: PowerAssertTests.Foo(val: 2), val: 3)
//
//        """
//      )
//    }
//  }

//  func testMessageParameters() {
//    captureConsoleOutput {
//      let zero = 0
//      let one = 1
//      let two = 2
//      let three = 3
//
//      let array = [one, two, three]
//      #powerAssert(
//        array.description.hasPrefix("[") != false && array.description.hasPrefix("Hello") != true,
//        "message",
//        verbose: true
//      )
//    } completion: { (output) in
//      print(output)
//      XCTAssertEqual(
//        output,
//        """
//        #powerAssert(bar.val != bar.foo.val)
//                     |   |   |  |   |   |
//                     |   3   |  |   |   2
//                     |       |  |   Foo(val: 2)
//                     |       |  Bar(foo: PowerAssertTests.Foo(val: 2), val: 3)
//                     |       true
//                     Bar(foo: PowerAssertTests.Foo(val: 2), val: 3)
//
//        """
//      )
//    }
//  }

  func testStringContainsNewlines() {
    captureConsoleOutput {
      let loremIpsum = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
      #powerAssert(
        loremIpsum != "Lorem ipsum dolor sit amet,\nconsectetur adipiscing elit,",
        verbose: true
      )
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        #"""
        #powerAssert(loremIpsum != "Lorem ipsum dolor sit amet,\nconsectetur adipiscing elit,")
                     |          |  |
                     |          |  "Lorem ipsum dolor sit amet,\nconsectetur adipiscing elit,"
                     |          true
                     "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."

        """#
      )
    }
  }

  func testStringContainsEscapeSequences() {
    captureConsoleOutput {
      let lyric1 = "Feet, don't fail me now."
      #powerAssert(lyric1 != "Feet, don't fail me now.", verbose: true)
      #powerAssert(lyric1 != "Feet, don\'t fail me now.", verbose: true)

      let lyric2 = "Feet, don\'t fail me now."
      #powerAssert(lyric2 != "Feet, don't fail me now.", verbose: true)
      #powerAssert(lyric2 != "Feet, don\'t fail me now.", verbose: true)

      let nestedQuote1 = "My mother said, \"The baby started talking today. The baby said, 'Mama.'\""
      #powerAssert(nestedQuote1 != "My mother said, \"The baby started talking today. The baby said, 'Mama.'\"", verbose: true)
      #powerAssert(nestedQuote1 != "My mother said, \"The baby started talking today. The baby said, \'Mama.\'\"", verbose: true)

      let nestedQuote2 = "My mother said, \"The baby started talking today. The baby said, \'Mama.\'\""
      #powerAssert(nestedQuote2 != "My mother said, \"The baby started talking today. The baby said, 'Mama.'\"", verbose: true)
      #powerAssert(nestedQuote2 != "My mother said, \"The baby started talking today. The baby said, \'Mama.\'\"", verbose: true)

      let helpText = "OPTIONS:\n  --build-path\t\tSpecify build/cache directory [default: ./.build]"
      #powerAssert(helpText != "OPTIONS:\n  --build-path\t\tSpecify build/cache directory [default: ./.build]", verbose: true)

      let nullCharacter = "Null character\0Null character"
      #powerAssert(nullCharacter != "Null character\0Null character", verbose: true)

      let lineFeed = "Line feed\nLine feed"
      #powerAssert(lineFeed != "Line feed\nLine feed", verbose: true)

      let carriageReturn = "Carriage Return\rCarriage Return"
      #powerAssert(carriageReturn != "Carriage Return\rCarriage Return", verbose: true)

      let backslash = "Backslash\\Backslash"
      #powerAssert(backslash != "Backslash\\Backslash", verbose: true)

      let wiseWords = "\"Imagination is more important than knowledge\" - Einstein"
      let dollarSign = "\u{24}"        // $,  Unicode scalar U+0024
      let blackHeart = "\u{2665}"      // ♥,  Unicode scalar U+2665
      let sparklingHeart = "\u{1F496}" // 💖, Unicode scalar U+1F496
      #powerAssert(wiseWords != "\"Imagination is more important than knowledge\" - Einstein", verbose: true)
      #powerAssert(dollarSign != "\u{24}", verbose: true)
      #powerAssert(blackHeart != "\u{2665}", verbose: true)
      #powerAssert(sparklingHeart != "\u{1F496}", verbose: true)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        #"""
        #powerAssert(loremIpsum != "Lorem ipsum dolor sit amet,\nconsectetur adipiscing elit,")
                     |          |  |
                     |          |  "Lorem ipsum dolor sit amet,\nconsectetur adipiscing elit,"
                     |          true
                     "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."

        """#
      )
    }
  }

//  func testMultilineStringLiterals() {
//    captureConsoleOutput {
//      let multilineLiteral = """
//                        Lorem ipsum dolor sit amet, consectetur adipiscing elit,
//                        sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
//                        """
//      #powerAssert(
//        multilineLiteral != """
//                        Lorem ipsum dolor sit amet, consectetur adipiscing elit,
//                        sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
//                        """,
//        verbose: true
//      )
//      #powerAssert(multilineLiteral != multilineLiteral)
//
//      let threeDoubleQuotationMarks = """
//                        Escaping the first quotation mark \"""
//                        Escaping all three quotation marks \"\"\"
//                        """
//      #powerAssert(
//        threeDoubleQuotationMarks != """
//                        Escaping the first quotation mark \"""
//                        Escaping all three quotation marks \"\"\"
//                        """,
//        verbose: true
//      )
//    } completion: { (output) in
//      print(output)
//      XCTAssertEqual(
//        output,
//        #"""
//        #powerAssert(loremIpsum != "Lorem ipsum dolor sit amet,\nconsectetur adipiscing elit,")
//                     |          |  |
//                     |          |  "Lorem ipsum dolor sit amet,\nconsectetur adipiscing elit,"
//                     |          true
//                     "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
//
//        """#
//      )
//    }
//  }

  func testCustomOperator() {
    captureConsoleOutput {
      let number1 = 100.0
      let number2 = 200.0
      #powerAssert(number1 × number2 == 200.0, verbose: true)
      #powerAssert(√number2 == 200.0, verbose: true)
      #powerAssert(√√number2 == 200.0, verbose: true)
      #powerAssert(200.0 == √√number2, verbose: true)
      #powerAssert(√number2 == √√number2, verbose: true)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        #"""
        #powerAssert(loremIpsum != "Lorem ipsum dolor sit amet,\nconsectetur adipiscing elit,")
                     |          |  |
                     |          |  "Lorem ipsum dolor sit amet,\nconsectetur adipiscing elit,"
                     |          true
                     "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."

        """#
      )
    }
  }

  func testNoWhitespaces() {
    captureConsoleOutput {
      let b1=false
      let i1=0
      let i2=1
      let d1=4.0
      let d2=6.0
      #powerAssert(i2==4,verbose:true)
      #powerAssert(b1==true&&i1>i2||true==b1&&i2==4,verbose:true)
      #powerAssert(b1==true&&i1>i2||true==b1&&i2==4||d1×d2==1,verbose:true)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        #"""
        #powerAssert(loremIpsum != "Lorem ipsum dolor sit amet,\nconsectetur adipiscing elit,")
                     |          |  |
                     |          |  "Lorem ipsum dolor sit amet,\nconsectetur adipiscing elit,"
                     |          true
                     "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."

        """#
      )
    }
  }

//  func testHigerOrderFunction() {
//    captureConsoleOutput {
//      func testA(_ i: Int) -> Int {
//        return i + 1
//      }
//
//      func testB(_ i: Int) -> Int {
//        return i + 1
//      }
//
//      let array = [0, 1, 2]
//      #powerAssert(array.map { testA($0) } == [3, 4], verbose: true)
//      #powerAssert(array.map(testB) == [3, 4], verbose: true)
//    } completion: { (output) in
//      print(output)
//      XCTAssertEqual(
//        output,
//        #"""
//        #powerAssert(loremIpsum != "Lorem ipsum dolor sit amet,\nconsectetur adipiscing elit,")
//                     |          |  |
//                     |          |  "Lorem ipsum dolor sit amet,\nconsectetur adipiscing elit,"
//                     |          true
//                     "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
//
//        """#
//      )
//    }
//  }

  func testStringWidth() async throws {
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
  }
}

func captureConsoleOutput(execute: () -> Void, completion: @escaping (String) -> Void) {
  let pipe = Pipe()
  var output = ""
  let semaphore = DispatchSemaphore(value: 0)
  pipe.fileHandleForReading.readabilityHandler = { fileHandle in
    let data = fileHandle.availableData
    if data.isEmpty  { // end-of-file condition
      fileHandle.readabilityHandler = nil
      completion(output)
      semaphore.signal()
    } else {
      if let string = String(data: data,  encoding: .utf8) {
        output += string
      }
    }
  }

  setvbuf(stdout, nil, _IONBF, 0)
  let stdout = dup(STDOUT_FILENO)
  dup2(pipe.fileHandleForWriting.fileDescriptor, STDOUT_FILENO)

  execute()

  dup2(stdout, STDOUT_FILENO)
  try? pipe.fileHandleForWriting.close()
  close(stdout)
  semaphore.wait()
}

struct Bar {
  let foo: Foo
  var val: Int
}

struct Foo {
  var val: Int
}

struct Object {
  let types: [Any?]
}

struct Person {
  let name: String
  let age: Int
}

struct Coordinate: Codable {
  var latitude: Double
  var longitude: Double
}

struct Landmark: Codable {
  var name: String
  var foundingYear: Int
  var location: Coordinate
}

struct SomeStructure {
  var someValue: Int

  func getValue(keyPath: KeyPath<SomeStructure, Int>) -> Int {
    return self[keyPath: keyPath]
  }
}

struct OuterStructure {
  var outer: SomeStructure

  init(someValue: Int) {
    self.outer = SomeStructure(someValue: someValue)
  }

  func getValue(keyPath: KeyPath<OuterStructure, Int>) -> Int {
    return self[keyPath: keyPath]
  }
}

class SomeClass {
  var property = OtherClass()
  init() {}
}

class OtherClass {
  func performAction() -> Bool {
    return true
  }
}

class SomeObjCClass: NSObject {
  @objc let property: String
  @objc(doSomethingWithInt:)
  func doSomething(_ x: Int) {}

  init(property: String) {
    self.property = property
  }
}

infix operator ×: MultiplicationPrecedence
func ×(left: Double, right: Double) -> Double {
  return left * right
}

prefix operator √
prefix func √(number: Double) -> Double {
  return sqrt(number)
}

prefix operator √√
prefix func √√(number: Double) -> Double {
  return sqrt(sqrt(number))
}
