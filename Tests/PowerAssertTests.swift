import XCTest
@testable import PowerAssert

final class PowerAssertTests: XCTestCase {
  override func setUp() {
    setenv("NO_COLOR", "1", 1)
  }

  func testBinaryExpression1() {
    captureConsoleOutput {
      let bar = Bar(foo: Foo(val: 2), val: 3)
      #assert(bar.val != bar.foo.val, verbose: true)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #assert(bar.val != bar.foo.val)
                |   |   |  |   |   |
                |   3   |  |   |   2
                |       |  |   Foo(val: 2)
                |       |  Bar(foo: PowerAssertTests.Foo(val: 2), val: 3)
                |       true
                Bar(foo: PowerAssertTests.Foo(val: 2), val: 3)

        [Int] bar.val
        => 3
        [Int] bar.foo.val
        => 2


        """
      )
    }
  }

  func testBinaryExpression2() {
    captureConsoleOutput {
      let bar = Bar(foo: Foo(val: 2), val: 3)
      #assert(bar.val > bar.foo.val, verbose: true)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #assert(bar.val > bar.foo.val)
                |   |   | |   |   |
                |   3   | |   |   2
                |       | |   Foo(val: 2)
                |       | Bar(foo: PowerAssertTests.Foo(val: 2), val: 3)
                |       true
                Bar(foo: PowerAssertTests.Foo(val: 2), val: 3)

        [Int] bar.val
        => 3
        [Int] bar.foo.val
        => 2


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
      #assert(array.firstIndex(of: zero) != two, verbose: true)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #assert(array.firstIndex(of: zero) != two)
                |     |              |     |  |
                |     nil            0     |  Optional(2)
                [1, 2, 3]                  true

        [Optional<Int>] array.firstIndex(of: zero)
        => nil
        [Optional<Int>] two
        => Optional(2)


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
      #assert(array.description.hasPrefix("[") == true && array.description.hasPrefix("Hello") == false, verbose: true)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #assert(array.description.hasPrefix("[") == true && array.description.hasPrefix("Hello") == false)
                |     |           |         |    |  |    |  |     |           |         |        |  |
                |     "[1, 2, 3]" true      "["  |  true |  |     "[1, 2, 3]" false     "Hello"  |  false
                [1, 2, 3]                        true    |  [1, 2, 3]                            true
                                                         true

        [Bool] array.description.hasPrefix("[")
        => true
        [Bool] true
        => true
        [Bool] array.description.hasPrefix("[") == true
        => true
        [Bool] array.description.hasPrefix("Hello")
        => false
        [Bool] false
        => false
        [Bool] array.description.hasPrefix("Hello") == false
        => true


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
      #assert(array.firstIndex(of: zero) != two && bar.val != bar.foo.val, verbose: true)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #assert(array.firstIndex(of: zero) != two && bar.val != bar.foo.val)
                |     |              |     |  |   |  |   |   |  |   |   |
                |     nil            0     |  |   |  |   3   |  |   |   2
                [1, 2, 3]                  |  |   |  |       |  |   Foo(val: 2)
                                           |  |   |  |       |  Bar(foo: PowerAssertTests.Foo(val: 2), val: 3)
                                           |  |   |  |       true
                                           |  |   |  Bar(foo: PowerAssertTests.Foo(val: 2), val: 3)
                                           |  |   true
                                           |  Optional(2)
                                           true

        [Optional<Int>] array.firstIndex(of: zero)
        => nil
        [Optional<Int>] two
        => Optional(2)
        [Bool] array.firstIndex(of: zero) != two
        => true
        [Int] bar.val
        => 3
        [Int] bar.foo.val
        => 2
        [Bool] bar.val != bar.foo.val
        => true


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
      #assert(array.distance(from: 2, to: 3) == 1, verbose: true)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #assert(array.distance(from: 2, to: 3) == 1)
                |     |              |      |  |  |
                |     1              2      3  |  1
                [1, 2, 3]                      true

        [Int] array.distance(from: 2, to: 3)
        => 1
        [Int] 1
        => 1


        """
      )
    }
  }

  func testBinaryExpression7() {
    captureConsoleOutput {
      let one = 1
      let two = 2
      let three = 3

      #assert([one, two, three].count == 3, verbose: true)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #assert([one, two, three].count == 3)
                ||    |    |      |     |  |
                |1    2    3      3     |  3
                [1, 2, 3]               true

        [Int] [one, two, three].count
        => 3
        [Int] 3
        => 3


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

      #assert((object.types[index] as! Person).name != bob.name, verbose: true)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #assert((object.types[index] as! Person).name != bob.name)
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

        [String] (object.types[index] as! Person).name
        => "alice"
        [String] bob.name
        => "bob"


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
      #assert(array.description.hasPrefix("]") == true || array.description.hasPrefix("Hello") == false, verbose: true)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #assert(array.description.hasPrefix("]") == true || array.description.hasPrefix("Hello") == false)
                |     |           |         |    |  |    |  |     |           |         |        |  |
                |     "[1, 2, 3]" false     "]"  |  true |  |     "[1, 2, 3]" false     "Hello"  |  false
                [1, 2, 3]                        false   |  [1, 2, 3]                            true
                                                         true

        [Bool] array.description.hasPrefix("]")
        => false
        [Bool] true
        => true
        [Bool] array.description.hasPrefix("]") == true
        => false
        [Bool] array.description.hasPrefix("Hello")
        => false
        [Bool] false
        => false
        [Bool] array.description.hasPrefix("Hello") == false
        => true


        """
      )
    }
  }

  func testMultilineExpression1() {
    captureConsoleOutput {
      let bar = Bar(foo: Foo(val: 2), val: 3)

      #assert(bar.val != bar.foo.val, verbose: true)
      #assert(bar
        .val !=
             bar.foo.val, verbose: true)
      #assert(bar
        .val !=
             bar
        .foo        .val, verbose: true)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #assert(bar.val != bar.foo.val)
                |   |   |  |   |   |
                |   3   |  |   |   2
                |       |  |   Foo(val: 2)
                |       |  Bar(foo: PowerAssertTests.Foo(val: 2), val: 3)
                |       true
                Bar(foo: PowerAssertTests.Foo(val: 2), val: 3)

        [Int] bar.val
        => 3
        [Int] bar.foo.val
        => 2

        #assert(bar .val != bar.foo.val)
                |    |   |  |   |   |
                |    3   |  |   |   2
                |        |  |   Foo(val: 2)
                |        |  Bar(foo: PowerAssertTests.Foo(val: 2), val: 3)
                |        true
                Bar(foo: PowerAssertTests.Foo(val: 2), val: 3)

        [Int] bar .val
        => 3
        [Int] bar.foo.val
        => 2

        #assert(bar .val != bar .foo .val)
                |    |   |  |    |    |
                |    3   |  |    |    2
                |        |  |    Foo(val: 2)
                |        |  Bar(foo: PowerAssertTests.Foo(val: 2), val: 3)
                |        true
                Bar(foo: PowerAssertTests.Foo(val: 2), val: 3)

        [Int] bar .val
        => 3
        [Int] bar .foo .val
        => 2


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

      #assert(array    .        firstIndex(
        of:    zero)
             != two,
                   verbose: true
      )

      #assert(array
        .
                   firstIndex(

              of:
                zero)
             != two

                   ,     verbose: true
      )

      #assert(array
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
        #assert(array . firstIndex( of: zero) != two)
                |       |               |     |  |
                |       nil             0     |  Optional(2)
                [1, 2, 3]                     true

        [Optional<Int>] array . firstIndex( of: zero)
        => nil
        [Optional<Int>] two
        => Optional(2)

        #assert(array . firstIndex( of: zero) != two)
                |       |               |     |  |
                |       nil             0     |  Optional(2)
                [1, 2, 3]                     true

        [Optional<Int>] array . firstIndex( of: zero)
        => nil
        [Optional<Int>] two
        => Optional(2)

        #assert(array .firstIndex( of: zero) != two)
                |      |               |     |  |
                |      nil             0     |  Optional(2)
                [1, 2, 3]                    true

        [Optional<Int>] array .firstIndex( of: zero)
        => nil
        [Optional<Int>] two
        => Optional(2)


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
      #assert(array
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
        #assert(array .description .hasPrefix( "[" ) == true && array .description .hasPrefix ("Hello" ) == false)
                |      |            |          |     |  |    |  |      |            |          |         |  |
                |      "[1, 2, 3]"  true       "["   |  true |  |      "[1, 2, 3]"  false      "Hello"   |  false
                [1, 2, 3]                            true    |  [1, 2, 3]                                true
                                                             true

        [Bool] array .description .hasPrefix( "[" )
        => true
        [Bool] true
        => true
        [Bool] array .description .hasPrefix( "[" ) == true
        => true
        [Bool] array .description .hasPrefix ("Hello" )
        => false
        [Bool] false
        => false
        [Bool] array .description .hasPrefix ("Hello" ) == false
        => true


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

      #assert(

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
        #assert(array.firstIndex( of: zero ) != two && bar .val != bar .foo .val)
                |     |               |      |  |   |  |    |   |  |    |    |
                |     nil             0      |  |   |  |    3   |  |    |    2
                [1, 2, 3]                    |  |   |  |        |  |    Foo(val: 2)
                                             |  |   |  |        |  Bar(foo: PowerAssertTests.Foo(val: 2), val: 3)
                                             |  |   |  |        true
                                             |  |   |  Bar(foo: PowerAssertTests.Foo(val: 2), val: 3)
                                             |  |   true
                                             |  Optional(2)
                                             true

        [Optional<Int>] array.firstIndex( of: zero )
        => nil
        [Optional<Int>] two
        => Optional(2)
        [Bool] array.firstIndex( of: zero ) != two
        => true
        [Int] bar .val
        => 3
        [Int] bar .foo .val
        => 2
        [Bool] bar .val != bar .foo .val
        => true


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
      #assert(

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
        #assert(array .distance( from: 2, to: 3) != 4)
                |      |               |      |  |  |
                |      1               2      3  |  4
                [1, 2, 3]                        true

        [Int] array .distance( from: 2, to: 3)
        => 1
        [Int] 4
        => 4


        """
      )
    }
  }

  func testMultilineExpression6() {
    captureConsoleOutput {
      let one = 1
      let two = 2
      let three = 3

      #assert([one,
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
        #assert([one, two , three] .count != 10)
                ||    |     |       |     |  |
                |1    2     3       3     |  10
                [1, 2, 3]                 true

        [Int] [one, two , three] .count
        => 3
        [Int] 10
        => 10


        """
      )
    }
  }

  func testMultilineExpression7() {
    captureConsoleOutput {
      let one = 1
      let two = 2
      let three = 3

      #assert([one,
               two
               , three]  /* comment in expression*/
        .count
              != 10
              , verbose: true)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #assert([one, two , three]  .count != 10)
                ||    |     |        |     |  |
                |1    2     3        3     |  10
                [1, 2, 3]                  true

        [Int] [one, two , three]  .count
        => 3
        [Int] 10
        => 10


        """
      )
    }
  }

  func testCommentsInExpression() {
    captureConsoleOutput {
      let one = 1
      let two = 2
      let three = 3

      #assert(
        [one, two, three]/* comment in assertion*/./* comment in assertion*/count/* comment in assertion*/!=/* comment in assertion*/10,
        verbose: true
      )
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #assert([one, two, three] . count != 10)
                ||    |    |        |     |  |
                |1    2    3        3     |  10
                [1, 2, 3]                 true

        [Int] [one, two, three] . count
        => 3
        [Int] 10
        => 10


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

      #assert(
        try! JSONEncoder().encode(landmark) != #"{"name":"Tokyo Tower"}"#.data(using: String.Encoding.utf8),
        verbose: true
      )
      #assert(
        try! JSONEncoder().encode(landmark) == #"{"name":"Tokyo Tower","location":{"longitude":139.74543800000001,"latitude":35.658580999999998},"foundingYear":1957}"#.data(using: .utf8),
        verbose: true
      )
      #assert(
        try! #"{"name":"Tokyo Tower"}"#.data(using: String.Encoding.utf8) != JSONEncoder().encode(landmark),
        verbose: true
      )
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        #"""
        #assert(try! JSONEncoder().encode(landmark) != #"{"name":"Tokyo Tower"}"#.data(using: String.Encoding.utf8))
                     |             |      |         |  |                          |           |      |        |
                     |             |      |         |  |                          |           String Encoding Unicode (UTF-8)
                     |             |      |         |  |                          Optional(22 bytes)
                     |             |      |         |  "{\"name\":\"Tokyo Tower\"}"
                     |             |      |         true
                     |             |      Landmark(name: "Tokyo Tower", foundingYear: 1957, location: PowerAssertTests.Coordinate(latitude: 35.658581, longitude: 139.745438))
                     |             Optional(116 bytes)
                     Foundation.JSONEncoder

        [Optional<Data>] JSONEncoder().encode(landmark)
        => Optional(116 bytes)
        [Optional<Data>] #"{"name":"Tokyo Tower"}"#.data(using: String.Encoding.utf8)
        => Optional(22 bytes)

        #assert(try! JSONEncoder().encode(landmark) == #"{"name":"Tokyo Tower","location":{"longitude":139.74543800000001,"latitude":35.658580999999998},"foundingYear":1957}"#.data(using: .utf8))
                     |             |      |         |  |                                                                                                                        |            |
                     |             |      |         |  |                                                                                                                        |            Unicode (UTF-8)
                     |             |      |         |  |                                                                                                                        Optional(116 bytes)
                     |             |      |         |  "{\"name\":\"Tokyo Tower\",\"location\":{\"longitude\":139.74543800000001,\"latitude\":35.658580999999998},\"foundingYear\":1957}"
                     |             |      |         true
                     |             |      Landmark(name: "Tokyo Tower", foundingYear: 1957, location: PowerAssertTests.Coordinate(latitude: 35.658581, longitude: 139.745438))
                     |             Optional(116 bytes)
                     Foundation.JSONEncoder

        [Optional<Data>] JSONEncoder().encode(landmark)
        => Optional(116 bytes)
        [Optional<Data>] #"{"name":"Tokyo Tower","location":{"longitude":139.74543800000001,"latitude":35.658580999999998},"foundingYear":1957}"#.data(using: .utf8)
        => Optional(116 bytes)

        #assert(try! #"{"name":"Tokyo Tower"}"#.data(using: String.Encoding.utf8) != JSONEncoder().encode(landmark))
                     |                          |           |      |        |     |  |             |      |
                     |                          |           String Encoding |     |  |             |      Landmark(name: "Tokyo Tower", foundingYear: 1957, location: PowerAssertTests.Coordinate(latitude: 35.658581, longitude: 139.745438))
                     |                          Optional(22 bytes)          |     |  |             Optional(116 bytes)
                     "{\"name\":\"Tokyo Tower\"}"                           |     |  Foundation.JSONEncoder
                                                                            |     true
                                                                            Unicode (UTF-8)

        [Optional<Data>] #"{"name":"Tokyo Tower"}"#.data(using: String.Encoding.utf8)
        => Optional(22 bytes)
        [Optional<Data>] JSONEncoder().encode(landmark)
        => Optional(116 bytes)
        

        """#
      )
    }
  }

  func testNilLiteral() {
    captureConsoleOutput {
      let string = "1234"
      let number = Int(string)

      #assert(number != nil && number == 1234, verbose: true)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #assert(number != nil && number == 1234)
                |      |  |   |  |      |  |
                |      |  nil |  |      |  Optional(1234)
                |      true   |  |      true
                |             |  Optional(1234)
                |             true
                Optional(1234)

        [Optional<Int>] number
        => Optional(1234)
        [Optional<Int>] nil
        => nil
        [Bool] number != nil
        => true
        [Optional<Int>] number
        => Optional(1234)
        [Optional<Int>] 1234
        => Optional(1234)
        [Bool] number == 1234
        => true


        """
      )
    }
  }

  func testTernaryConditionalOperator1() {
    captureConsoleOutput {
      let string = "1234"
      let number = Int(string)
      let hello = "hello"

      #assert((number != nil ? string : hello) == string, verbose: true)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #assert((number != nil ? string : hello) == string)
                |||     |  |     |               |  |
                ||"1234"|  nil   "1234"          |  "1234"
                ||      true                     true
                |Optional(1234)
                "1234"

        [Optional<Int>] number
        => Optional(1234)
        [Optional<Int>] nil
        => nil
        [String] (number != nil ? string : hello)
        => "1234"
        [String] string
        => "1234"


        """
      )
    }
  }

  func testTernaryConditionalOperator2() {
    captureConsoleOutput {
      let string = "1234"
      let number = Int(string)
      let hello = "hello"

      #assert((number == nil ? string : hello) != string, verbose: true)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #assert((number == nil ? string : hello) != string)
                |||     |  |              |      |  |
                |||     |  nil            |      |  "1234"
                |||     false             |      true
                ||"hello"                 "hello"
                |Optional(1234)
                "hello"

        [Optional<Int>] number
        => Optional(1234)
        [Optional<Int>] nil
        => nil
        [String] (number == nil ? string : hello)
        => "hello"
        [String] string
        => "1234"
        

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

      #assert([one, two, three].firstIndex(of: zero) != two, verbose: true)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #assert([one, two, three].firstIndex(of: zero) != two)
                ||    |    |      |              |     |  |
                |1    2    3      nil            0     |  Optional(2)
                [1, 2, 3]                              true

        [Optional<Int>] [one, two, three].firstIndex(of: zero)
        => nil
        [Optional<Int>] two
        => Optional(2)


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

      #assert([zero: one, two: three].count != three, verbose: true)
    } completion: { (output) in
      print(output)
      // Dictionary order is not guaranteed
      XCTAssertTrue(
        output ==
        """
        #assert([zero: one, two: three].count != three)
                ||     |    |    |      |     |  |
                |0     1    2    3      2     |  3
                [0: 1, 2: 3]                  true

        [Int] [zero: one, two: three].count
        => 2
        [Int] three
        => 3


        """
        ||
        output ==
        """
        #assert([zero: one, two: three].count != three)
                ||     |    |    |      |     |  |
                |0     1    2    3      2     |  3
                [2: 3, 0: 1]                  true

        [Int] [zero: one, two: three].count
        => 2
        [Int] three
        => 3
        

        """
      )
    }
  }

  func testMagicLiteralExpression1() {
    captureConsoleOutput {
      #assert(
        #file != "*.swift" && #line != 1 && #column != 2 && #function != "function",
        verbose: true
      )
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #assert(#file != "*.swift" && #line != 1 && #column != 2 && #function != "function")
                |     |  |         |  |     |  | |  |       |  | |  |         |  |
                |     |  "*.swift" |  2     |  1 |  301     |  2 |  |         |  "function"
                |     true         true     true true       true |  |         true
                |                                                |  "testMagicLiteralExpression1()"
                |                                                true
                "@__swiftmacro_16PowerAssertTestsAAC27testMagicLiteralExpression1yyFXefU_33_83CDEF1031207B73D1DF9E55E024D4A9Ll6assertfMf_.swift"

        [String] #file
        => "@__swiftmacro_16PowerAssertTestsAAC27testMagicLiteralExpression1yyFXefU_33_83CDEF1031207B73D1DF9E55E024D4A9Ll6assertfMf_.swift"
        [String] "*.swift"
        => "*.swift"
        [Bool] #file != "*.swift"
        => true
        [Int] #line
        => 2
        [Int] 1
        => 1
        [Bool] #line != 1
        => true
        [Bool] #file != "*.swift" && #line != 1
        => true
        [Int] #column
        => 301
        [Int] 2
        => 2
        [Bool] #column != 2
        => true
        [Bool] #file != "*.swift" && #line != 1 && #column != 2
        => true
        [String] #function
        => "testMagicLiteralExpression1()"
        [String] "function"
        => "function"
        [Bool] #function != "function"
        => true


        """
      )
    }
  }

  func testMagicLiteralExpression2() {
    captureConsoleOutput {
      #assert(
        #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1) != .blue &&
          .blue != #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1),
        verbose: true
      )
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #assert(#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1) != .blue && .blue != #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1))
                |                  |                    |                    |                    |  |   |    |   |    |  |                  |                    |                    |                    |
                |                  0.80784315           0.02745098           0.33333334           |  |   |    |   |    |  |                  0.80784315           0.02745098           0.33333334           1.0
                sRGB IEC61966-2.1 colorspace 0.807843 0.027451 0.333333 1                         |  |   |    |   |    |  sRGB IEC61966-2.1 colorspace 0.807843 0.027451 0.333333 1
                                                                                                  |  |   |    |   |    true
                                                                                                  |  |   |    |   sRGB IEC61966-2.1 colorspace 0 0 1 1
                                                                                                  |  |   |    true
                                                                                                  |  |   sRGB IEC61966-2.1 colorspace 0 0 1 1
                                                                                                  |  true
                                                                                                  1.0

        [NSColorSpaceColor] #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        => sRGB IEC61966-2.1 colorspace 0.807843 0.027451 0.333333 1
        [_NSTaggedPointerColor] .blue
        => sRGB IEC61966-2.1 colorspace 0 0 1 1
        [Bool] #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1) != .blue
        => true
        [_NSTaggedPointerColor] .blue
        => sRGB IEC61966-2.1 colorspace 0 0 1 1
        [NSColorSpaceColor] #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        => sRGB IEC61966-2.1 colorspace 0.807843 0.027451 0.333333 1
        [Bool] .blue != #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        => true


        """
      )
    }
  }

  func testSelfExpression() {
    captureConsoleOutput {
      #assert(
        self.stringValue == "string" && self.intValue == 100 && self.doubleValue == 999.9,
        verbose: true
      )
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #assert(self.stringValue == "string" && self.intValue == 100 && self.doubleValue == 999.9)
                |    |           |  |        |  |    |        |  |   |  |    |           |  |
                |    "string"    |  "string" |  |    100      |  100 |  |    999.9       |  999.9
                |                true        |  |             true   |  |                true
                |                            |  |                    |  -[PowerAssertTests testSelfExpression]
                |                            |  |                    true
                |                            |  -[PowerAssertTests testSelfExpression]
                |                            true
                -[PowerAssertTests testSelfExpression]

        [String] self.stringValue
        => "string"
        [String] "string"
        => "string"
        [Bool] self.stringValue == "string"
        => true
        [Int] self.intValue
        => 100
        [Int] 100
        => 100
        [Bool] self.intValue == 100
        => true
        [Bool] self.stringValue == "string" && self.intValue == 100
        => true
        [Double] self.doubleValue
        => 999.9
        [Double] 999.9
        => 999.9
        [Bool] self.doubleValue == 999.9
        => true


        """
      )
    }
  }

  func testSuperExpression() {
    captureConsoleOutput {
      #assert(super.continueAfterFailure == true, verbose: true)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #assert(super.continueAfterFailure == true)
                |     |                    |  |
                |     true                 |  true
                |                          true
                -[PowerAssertTests testSuperExpression]

        [Bool] super.continueAfterFailure
        => true
        [Bool] true
        => true


        """
      )
    }
  }

  func testImplicitMemberExpression() {
    captureConsoleOutput {
      let i = 64
      #assert(i == .bitWidth && i == Double.Exponent.bitWidth, verbose: true)

      let mask: CAAutoresizingMask = [.layerMaxXMargin, .layerMaxYMargin]
      #assert(mask == [CAAutoresizingMask.layerMaxXMargin, CAAutoresizingMask.layerMaxYMargin], verbose: true)

      #assert(mask == [CAAutoresizingMask.layerMaxXMargin, .layerMaxYMargin], verbose: true)

      #assert(mask == [.layerMaxXMargin, CAAutoresizingMask.layerMaxYMargin], verbose: true)

      #assert(mask == [.layerMaxXMargin, .layerMaxYMargin], verbose: true)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #assert(i == .bitWidth && i == Double.Exponent.bitWidth)
                | |   |        |  | |  |      |        |
                | |   64       |  | |  Double Int      64
                | true         |  | true
                64             |  64
                               true

        [Int] i
        => 64
        [Int] .bitWidth
        => 64
        [Bool] i == .bitWidth
        => true
        [Int] i
        => 64
        [Int] Double.Exponent.bitWidth
        => 64
        [Bool] i == Double.Exponent.bitWidth
        => true

        #assert(mask == [CAAutoresizingMask.layerMaxXMargin, CAAutoresizingMask.layerMaxYMargin])
                |    |  ||                  |                |                  |
                |    |  |CAAutoresizingMask |                CAAutoresizingMask CAAutoresizingMask(rawValue: 32)
                |    |  |                   CAAutoresizingMask(rawValue: 4)
                |    |  CAAutoresizingMask(rawValue: 36)
                |    true
                CAAutoresizingMask(rawValue: 36)

        [CAAutoresizingMask] mask
        => CAAutoresizingMask(rawValue: 36)
        [CAAutoresizingMask] [CAAutoresizingMask.layerMaxXMargin, CAAutoresizingMask.layerMaxYMargin]
        => CAAutoresizingMask(rawValue: 36)

        #assert(mask == [CAAutoresizingMask.layerMaxXMargin, .layerMaxYMargin])
                |    |  ||                  |                 |
                |    |  |CAAutoresizingMask |                 CAAutoresizingMask(rawValue: 32)
                |    |  |                   CAAutoresizingMask(rawValue: 4)
                |    |  CAAutoresizingMask(rawValue: 36)
                |    true
                CAAutoresizingMask(rawValue: 36)

        [CAAutoresizingMask] mask
        => CAAutoresizingMask(rawValue: 36)
        [CAAutoresizingMask] [CAAutoresizingMask.layerMaxXMargin, .layerMaxYMargin]
        => CAAutoresizingMask(rawValue: 36)

        #assert(mask == [.layerMaxXMargin, CAAutoresizingMask.layerMaxYMargin])
                |    |  | |                |                  |
                |    |  | |                CAAutoresizingMask CAAutoresizingMask(rawValue: 32)
                |    |  | CAAutoresizingMask(rawValue: 4)
                |    |  CAAutoresizingMask(rawValue: 36)
                |    true
                CAAutoresizingMask(rawValue: 36)

        [CAAutoresizingMask] mask
        => CAAutoresizingMask(rawValue: 36)
        [CAAutoresizingMask] [.layerMaxXMargin, CAAutoresizingMask.layerMaxYMargin]
        => CAAutoresizingMask(rawValue: 36)

        #assert(mask == [.layerMaxXMargin, .layerMaxYMargin])
                |    |  | |                 |
                |    |  | |                 CAAutoresizingMask(rawValue: 32)
                |    |  | CAAutoresizingMask(rawValue: 4)
                |    |  CAAutoresizingMask(rawValue: 36)
                |    true
                CAAutoresizingMask(rawValue: 36)

        [CAAutoresizingMask] mask
        => CAAutoresizingMask(rawValue: 36)
        [CAAutoresizingMask] [.layerMaxXMargin, .layerMaxYMargin]
        => CAAutoresizingMask(rawValue: 36)


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

      #assert(tuple != (name: "Katsumi", age: 37, birthday: date2), verbose: true)
      #assert(tuple != ("Katsumi", 37, date2), verbose: true)
      #assert(tuple.name == ("Katsumi", 37, date2).0 || tuple.age != ("Katsumi", 37, date2).1, verbose: true)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #assert(tuple != (name: "Katsumi", age: 37, birthday: date2))
                |     |  |      |               |             |
                |     |  |      "Katsumi"       37            2000-12-30 15:00:00 +0000
                |     |  ("Katsumi", 37, 2000-12-30 15:00:00 +0000)
                |     true
                ("Katsumi", 37, 1980-10-27 15:00:00 +0000)

        [(String, Int, Date)] tuple
        => ("Katsumi", 37, 1980-10-27 15:00:00 +0000)
        [(String, Int, Date)] (name: "Katsumi", age: 37, birthday: date2)
        => ("Katsumi", 37, 2000-12-30 15:00:00 +0000)

        #assert(tuple != ("Katsumi", 37, date2))
                |     |  ||          |   |
                |     |  |"Katsumi"  37  2000-12-30 15:00:00 +0000
                |     |  ("Katsumi", 37, 2000-12-30 15:00:00 +0000)
                |     true
                ("Katsumi", 37, 1980-10-27 15:00:00 +0000)

        [(String, Int, Date)] tuple
        => ("Katsumi", 37, 1980-10-27 15:00:00 +0000)
        [(String, Int, Date)] ("Katsumi", 37, date2)
        => ("Katsumi", 37, 2000-12-30 15:00:00 +0000)

        #assert(tuple.name == ("Katsumi", 37, date2).0 || tuple.age != ("Katsumi", 37, date2).1)
                |     |    |  ||          |   |      | |
                |     |    |  |"Katsumi"  37  |      | true
                |     |    |  |               |      "Katsumi"
                |     |    |  |               2000-12-30 15:00:00 +0000
                |     |    |  ("Katsumi", 37, 2000-12-30 15:00:00 +0000)
                |     |    true
                |     "Katsumi"
                (name: "Katsumi", age: 37, birthday: 1980-10-27 15:00:00 +0000)

        [String] tuple.name
        => "Katsumi"
        [String] ("Katsumi", 37, date2).0
        => "Katsumi"
        [Bool] tuple.name == ("Katsumi", 37, date2).0
        => true

        
        """
      )
    }
  }

  func testKeyPathExpression() {
    captureConsoleOutput {
      let s = SomeStructure(someValue: 12)
      let pathToProperty = \SomeStructure.someValue

      #assert(s[keyPath: pathToProperty] == 12, verbose: true)
      #assert(s[keyPath: \SomeStructure.someValue] == 12, verbose: true)
      #assert(s.getValue(keyPath: \.someValue) == 12, verbose: true)

      let nested = OuterStructure(someValue: 24)
      let nestedKeyPath = \OuterStructure.outer.someValue

      #assert(nested[keyPath: nestedKeyPath] == 24, verbose: true)
      #assert(nested[keyPath: \OuterStructure.outer.someValue] == 24, verbose: true)
      #assert(nested.getValue(keyPath: \.outer.someValue) == 24, verbose: true)
    } completion: { (output) in
      print(output)

      XCTAssertTrue(
        output ==
          #"""
          #assert(s[keyPath: pathToProperty] == 12)
                  |          |             | |  |
                  |          |             | |  12
                  |          |             | true
                  |          |             12
                  |          \SomeStructure.someValue
                  SomeStructure(someValue: 12)

          [Int] s[keyPath: pathToProperty]
          => 12
          [Int] 12
          => 12

          #assert(s[keyPath: \SomeStructure.someValue] == 12)
                  |          |                       | |  |
                  |          |                       | |  12
                  |          |                       | true
                  |          |                       12
                  |          \SomeStructure.someValue
                  SomeStructure(someValue: 12)

          [Int] s[keyPath: \SomeStructure.someValue]
          => 12
          [Int] 12
          => 12

          #assert(s.getValue(keyPath: \.someValue) == 12)
                  | |                 |            |  |
                  | 12                |            |  12
                  |                   |            true
                  |                   \SomeStructure.someValue
                  SomeStructure(someValue: 12)

          [Int] s.getValue(keyPath: \.someValue)
          => 12
          [Int] 12
          => 12

          #assert(nested[keyPath: nestedKeyPath] == 24)
                  |               |            | |  |
                  |               |            | |  24
                  |               |            | true
                  |               |            24
                  |               \OuterStructure.outer.someValue
                  OuterStructure(outer: PowerAssertTests.SomeStructure(someValue: 24))

          [Int] nested[keyPath: nestedKeyPath]
          => 24
          [Int] 24
          => 24

          #assert(nested[keyPath: \OuterStructure.outer.someValue] == 24)
                  |               |                              | |  |
                  |               |                              | |  24
                  |               |                              | true
                  |               |                              24
                  |               \OuterStructure.outer.someValue
                  OuterStructure(outer: PowerAssertTests.SomeStructure(someValue: 24))

          [Int] nested[keyPath: \OuterStructure.outer.someValue]
          => 24
          [Int] 24
          => 24

          #assert(nested.getValue(keyPath: \.outer.someValue) == 24)
                  |      |                 |                  |  |
                  |      24                |                  |  24
                  |                        |                  true
                  |                        \OuterStructure.outer.someValue
                  OuterStructure(outer: PowerAssertTests.SomeStructure(someValue: 24))

          [Int] nested.getValue(keyPath: \.outer.someValue)
          => 24
          [Int] 24
          => 24


          """#
        ||
        output ==
          #"""
          #assert(s[keyPath: pathToProperty] == 12)
                  |          |             | |  |
                  |          |             | |  12
                  |          |             | true
                  |          |             12
                  |          Swift.WritableKeyPath<PowerAssertTests.SomeStructure, Swift.Int>
                  SomeStructure(someValue: 12)

          [Int] s[keyPath: pathToProperty]
          => 12
          [Int] 12
          => 12

          #assert(s[keyPath: \SomeStructure.someValue] == 12)
                  |          |                       | |  |
                  |          |                       | |  12
                  |          |                       | true
                  |          |                       12
                  |          Swift.WritableKeyPath<PowerAssertTests.SomeStructure, Swift.Int>
                  SomeStructure(someValue: 12)

          [Int] s[keyPath: \SomeStructure.someValue]
          => 12
          [Int] 12
          => 12

          #assert(s.getValue(keyPath: \.someValue) == 12)
                  | |                 |            |  |
                  | 12                |            |  12
                  |                   |            true
                  |                   Swift.WritableKeyPath<PowerAssertTests.SomeStructure, Swift.Int>
                  SomeStructure(someValue: 12)

          [Int] s.getValue(keyPath: \.someValue)
          => 12
          [Int] 12
          => 12

          #assert(nested[keyPath: nestedKeyPath] == 24)
                  |               |            | |  |
                  |               |            | |  24
                  |               |            | true
                  |               |            24
                  |               Swift.WritableKeyPath<PowerAssertTests.OuterStructure, Swift.Int>
                  OuterStructure(outer: PowerAssertTests.SomeStructure(someValue: 24))

          [Int] nested[keyPath: nestedKeyPath]
          => 24
          [Int] 24
          => 24

          #assert(nested[keyPath: \OuterStructure.outer.someValue] == 24)
                  |               |                              | |  |
                  |               |                              | |  24
                  |               |                              | true
                  |               |                              24
                  |               Swift.WritableKeyPath<PowerAssertTests.OuterStructure, Swift.Int>
                  OuterStructure(outer: PowerAssertTests.SomeStructure(someValue: 24))

          [Int] nested[keyPath: \OuterStructure.outer.someValue]
          => 24
          [Int] 24
          => 24

          #assert(nested.getValue(keyPath: \.outer.someValue) == 24)
                  |      |                 |                  |  |
                  |      24                |                  |  24
                  |                        |                  true
                  |                        Swift.WritableKeyPath<PowerAssertTests.OuterStructure, Swift.Int>
                  OuterStructure(outer: PowerAssertTests.SomeStructure(someValue: 24))

          [Int] nested.getValue(keyPath: \.outer.someValue)
          => 24
          [Int] 24
          => 24


          """#
      )
    }
  }

  func testSubscriptKeyPathExpression1() {
    captureConsoleOutput {
      let greetings = ["hello", "hola", "bonjour", "안녕"]

      #assert(greetings[keyPath: \[String].[1]] == "hola", verbose: true)
      #assert(greetings[keyPath: \[String].first?.count] == 5, verbose: true)
    } completion: { (output) in
      print(output)
      XCTAssertTrue(
        output ==
        #"""
        #assert(greetings[keyPath: \[String].[1]] == "hola")
                |                  |          | | |  |
                |                  |          1 | |  "hola"
                |                  |            | true
                |                  |            "hola"
                |                  Swift.WritableKeyPath<Swift.Array<Swift.String>, Swift.String>
                ["hello", "hola", "bonjour", "안녕"]

        [String] greetings[keyPath: \[String].[1]]
        => "hola"
        [String] "hola"
        => "hola"

        #assert(greetings[keyPath: \[String].first?.count] == 5)
                |                  |                     | |  |
                |                  |                     | |  Optional(5)
                |                  |                     | true
                |                  |                     Optional(5)
                |                  Swift.KeyPath<Swift.Array<Swift.String>, Swift.Optional<Swift.Int>>
                ["hello", "hola", "bonjour", "안녕"]

        [Optional<Int>] greetings[keyPath: \[String].first?.count]
        => Optional(5)
        [Optional<Int>] 5
        => Optional(5)


        """#
        ||
        output.replacing(#/[:xdigit:]{16}/#, with: "0000000000000000") ==
        #"""
        #assert(greetings[keyPath: \[String].[1]] == "hola")
                |                  |          | | |  |
                |                  |          1 | |  "hola"
                |                  |            | true
                |                  |            "hola"
                |                  \Array<String>.<computed 0x0000000000000000 (String)>
                ["hello", "hola", "bonjour", "안녕"]

        [String] greetings[keyPath: \[String].[1]]
        => "hola"
        [String] "hola"
        => "hola"

        #assert(greetings[keyPath: \[String].first?.count] == 5)
                |                  |                     | |  |
                |                  |                     | |  Optional(5)
                |                  |                     | true
                |                  |                     Optional(5)
                |                  \Array<String>.first?.count?
                ["hello", "hola", "bonjour", "안녕"]

        [Optional<Int>] greetings[keyPath: \[String].first?.count]
        => Optional(5)
        [Optional<Int>] 5
        => Optional(5)


        """#
      )
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
      #assert(
        interestingNumbers[keyPath: \[String: [Int]].["prime"]![0]] == 2,
        verbose: true
      )
    } completion: { (output) in
      print(output)
      // Dictionary order is not guaranteed
      XCTAssertTrue(
        output ==
          #"""
          #assert(interestingNumbers[keyPath: \[String: [Int]].["prime"]![0]] == 2)
                  |                           |                 |         | | |  |
                  |                           |                 "prime"   0 2 |  2
                  |                           |                               true
                  |                           Swift.WritableKeyPath<Swift.Dictionary<Swift.String, Swift.Array<Swift.Int>>, Swift.Int>
                  ["prime": [2, 3, 5, 7, 11, 13, 15], "hexagonal": [1, 6, 15, 28, 45, 66, 91], "triangular": [1, 3, 6, 10, 15, 21, 28]]

          [Int] interestingNumbers[keyPath: \[String: [Int]].["prime"]![0]]
          => 2
          [Int] 2
          => 2


          """#
        ||
        output ==
          #"""
          #assert(interestingNumbers[keyPath: \[String: [Int]].["prime"]![0]] == 2)
                  |                           |                 |         | | |  |
                  |                           |                 "prime"   0 2 |  2
                  |                           |                               true
                  |                           Swift.WritableKeyPath<Swift.Dictionary<Swift.String, Swift.Array<Swift.Int>>, Swift.Int>
                  ["prime": [2, 3, 5, 7, 11, 13, 15], "triangular": [1, 3, 6, 10, 15, 21, 28], "hexagonal": [1, 6, 15, 28, 45, 66, 91]]

          [Int] interestingNumbers[keyPath: \[String: [Int]].["prime"]![0]]
          => 2
          [Int] 2
          => 2


          """#
        ||
        output ==
          #"""
          #assert(interestingNumbers[keyPath: \[String: [Int]].["prime"]![0]] == 2)
                  |                           |                 |         | | |  |
                  |                           |                 "prime"   0 2 |  2
                  |                           |                               true
                  |                           Swift.WritableKeyPath<Swift.Dictionary<Swift.String, Swift.Array<Swift.Int>>, Swift.Int>
                  ["hexagonal": [1, 6, 15, 28, 45, 66, 91], "prime": [2, 3, 5, 7, 11, 13, 15], "triangular": [1, 3, 6, 10, 15, 21, 28]]

          [Int] interestingNumbers[keyPath: \[String: [Int]].["prime"]![0]]
          => 2
          [Int] 2
          => 2


          """#
        ||
        output ==
          #"""
          #assert(interestingNumbers[keyPath: \[String: [Int]].["prime"]![0]] == 2)
                  |                           |                 |         | | |  |
                  |                           |                 "prime"   0 2 |  2
                  |                           |                               true
                  |                           Swift.WritableKeyPath<Swift.Dictionary<Swift.String, Swift.Array<Swift.Int>>, Swift.Int>
                  ["hexagonal": [1, 6, 15, 28, 45, 66, 91], "triangular": [1, 3, 6, 10, 15, 21, 28], "prime": [2, 3, 5, 7, 11, 13, 15]]

          [Int] interestingNumbers[keyPath: \[String: [Int]].["prime"]![0]]
          => 2
          [Int] 2
          => 2


          """#
        ||
        output ==
          #"""
          #assert(interestingNumbers[keyPath: \[String: [Int]].["prime"]![0]] == 2)
                  |                           |                 |         | | |  |
                  |                           |                 "prime"   0 2 |  2
                  |                           |                               true
                  |                           Swift.WritableKeyPath<Swift.Dictionary<Swift.String, Swift.Array<Swift.Int>>, Swift.Int>
                  ["triangular": [1, 3, 6, 10, 15, 21, 28], "prime": [2, 3, 5, 7, 11, 13, 15], "hexagonal": [1, 6, 15, 28, 45, 66, 91]]

          [Int] interestingNumbers[keyPath: \[String: [Int]].["prime"]![0]]
          => 2
          [Int] 2
          => 2


          """#
        ||
        output ==
          #"""
          #assert(interestingNumbers[keyPath: \[String: [Int]].["prime"]![0]] == 2)
                  |                           |                 |         | | |  |
                  |                           |                 "prime"   0 2 |  2
                  |                           |                               true
                  |                           Swift.WritableKeyPath<Swift.Dictionary<Swift.String, Swift.Array<Swift.Int>>, Swift.Int>
                  ["triangular": [1, 3, 6, 10, 15, 21, 28], "hexagonal": [1, 6, 15, 28, 45, 66, 91], "prime": [2, 3, 5, 7, 11, 13, 15]]

          [Int] interestingNumbers[keyPath: \[String: [Int]].["prime"]![0]]
          => 2
          [Int] 2
          => 2


          """#
        ||
        output.replacing(#/[:xdigit:]{16}/#, with: "0000000000000000") ==
          #"""
          #assert(interestingNumbers[keyPath: \[String: [Int]].["prime"]![0]] == 2)
                  |                           |                 |         | | |  |
                  |                           |                 "prime"   0 2 |  2
                  |                           |                               true
                  |                           \Dictionary<String, Array<Int>>.<computed 0x0000000000000000 (Optional<Array<Int>>)>!.<computed 0x0000000000000000 (Int)>
                  ["prime": [2, 3, 5, 7, 11, 13, 15], "hexagonal": [1, 6, 15, 28, 45, 66, 91], "triangular": [1, 3, 6, 10, 15, 21, 28]]

          [Int] interestingNumbers[keyPath: \[String: [Int]].["prime"]![0]]
          => 2
          [Int] 2
          => 2


          """#
        ||
        output.replacing(#/[:xdigit:]{16}/#, with: "0000000000000000") ==
          #"""
          #assert(interestingNumbers[keyPath: \[String: [Int]].["prime"]![0]] == 2)
                  |                           |                 |         | | |  |
                  |                           |                 "prime"   0 2 |  2
                  |                           |                               true
                  |                           \Dictionary<String, Array<Int>>.<computed 0x0000000000000000 (Optional<Array<Int>>)>!.<computed 0x0000000000000000 (Int)>
                  ["prime": [2, 3, 5, 7, 11, 13, 15], "triangular": [1, 3, 6, 10, 15, 21, 28], "hexagonal": [1, 6, 15, 28, 45, 66, 91]]

          [Int] interestingNumbers[keyPath: \[String: [Int]].["prime"]![0]]
          => 2
          [Int] 2
          => 2


          """#
        ||
        output.replacing(#/[:xdigit:]{16}/#, with: "0000000000000000") ==
          #"""
          #assert(interestingNumbers[keyPath: \[String: [Int]].["prime"]![0]] == 2)
                  |                           |                 |         | | |  |
                  |                           |                 "prime"   0 2 |  2
                  |                           |                               true
                  |                           \Dictionary<String, Array<Int>>.<computed 0x0000000000000000 (Optional<Array<Int>>)>!.<computed 0x0000000000000000 (Int)>
                  ["hexagonal": [1, 6, 15, 28, 45, 66, 91], "prime": [2, 3, 5, 7, 11, 13, 15], "triangular": [1, 3, 6, 10, 15, 21, 28]]

          [Int] interestingNumbers[keyPath: \[String: [Int]].["prime"]![0]]
          => 2
          [Int] 2
          => 2


          """#
        ||
        output.replacing(#/[:xdigit:]{16}/#, with: "0000000000000000") ==
          #"""
          #assert(interestingNumbers[keyPath: \[String: [Int]].["prime"]![0]] == 2)
                  |                           |                 |         | | |  |
                  |                           |                 "prime"   0 2 |  2
                  |                           |                               true
                  |                           \Dictionary<String, Array<Int>>.<computed 0x0000000000000000 (Optional<Array<Int>>)>!.<computed 0x0000000000000000 (Int)>
                  ["hexagonal": [1, 6, 15, 28, 45, 66, 91], "triangular": [1, 3, 6, 10, 15, 21, 28], "prime": [2, 3, 5, 7, 11, 13, 15]]

          [Int] interestingNumbers[keyPath: \[String: [Int]].["prime"]![0]]
          => 2
          [Int] 2
          => 2


          """#
        ||
        output.replacing(#/[:xdigit:]{16}/#, with: "0000000000000000") ==
          #"""
          #assert(interestingNumbers[keyPath: \[String: [Int]].["prime"]![0]] == 2)
                  |                           |                 |         | | |  |
                  |                           |                 "prime"   0 2 |  2
                  |                           |                               true
                  |                           \Dictionary<String, Array<Int>>.<computed 0x0000000000000000 (Optional<Array<Int>>)>!.<computed 0x0000000000000000 (Int)>
                  ["triangular": [1, 3, 6, 10, 15, 21, 28], "prime": [2, 3, 5, 7, 11, 13, 15], "hexagonal": [1, 6, 15, 28, 45, 66, 91]]

          [Int] interestingNumbers[keyPath: \[String: [Int]].["prime"]![0]]
          => 2
          [Int] 2
          => 2


          """#
        ||
        output.replacing(#/[:xdigit:]{16}/#, with: "0000000000000000") ==
          #"""
          #assert(interestingNumbers[keyPath: \[String: [Int]].["prime"]![0]] == 2)
                  |                           |                 |         | | |  |
                  |                           |                 "prime"   0 2 |  2
                  |                           |                               true
                  |                           \Dictionary<String, Array<Int>>.<computed 0x0000000000000000 (Optional<Array<Int>>)>!.<computed 0x0000000000000000 (Int)>
                  ["triangular": [1, 3, 6, 10, 15, 21, 28], "hexagonal": [1, 6, 15, 28, 45, 66, 91], "prime": [2, 3, 5, 7, 11, 13, 15]]

          [Int] interestingNumbers[keyPath: \[String: [Int]].["prime"]![0]]
          => 2
          [Int] 2
          => 2


          """#
      )
    }
  }

  func testSubscriptKeyPathExpression4() {
    captureConsoleOutput {
      let interestingNumbers = [
        "prime": [2, 3, 5, 7, 11, 13, 15],
        "triangular": [1, 3, 6, 10, 15, 21, 28],
        "hexagonal": [1, 6, 15, 28, 45, 66, 91]
      ]
      #assert(
        interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count] == 7,
        verbose: true
      )
    } completion: { (output) in
      print(output)
      // Dictionary order is not guaranteed
      XCTAssertTrue(
        output ==
          #"""
          #assert(interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count] == 7)
                  |                           |                 |                  | |  |
                  |                           |                 "hexagonal"        7 |  7
                  |                           |                                      true
                  |                           Swift.KeyPath<Swift.Dictionary<Swift.String, Swift.Array<Swift.Int>>, Swift.Int>
                  ["prime": [2, 3, 5, 7, 11, 13, 15], "hexagonal": [1, 6, 15, 28, 45, 66, 91], "triangular": [1, 3, 6, 10, 15, 21, 28]]

          [Int] interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count]
          => 7
          [Int] 7
          => 7


          """#
        ||
        output ==
          #"""
          #assert(interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count] == 7)
                  |                           |                 |                  | |  |
                  |                           |                 "hexagonal"        7 |  7
                  |                           |                                      true
                  |                           Swift.KeyPath<Swift.Dictionary<Swift.String, Swift.Array<Swift.Int>>, Swift.Int>
                  ["prime": [2, 3, 5, 7, 11, 13, 15], "triangular": [1, 3, 6, 10, 15, 21, 28], "hexagonal": [1, 6, 15, 28, 45, 66, 91]]

          [Int] interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count]
          => 7
          [Int] 7
          => 7


          """#
        ||
        output ==
          #"""
          #assert(interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count] == 7)
                  |                           |                 |                  | |  |
                  |                           |                 "hexagonal"        7 |  7
                  |                           |                                      true
                  |                           Swift.KeyPath<Swift.Dictionary<Swift.String, Swift.Array<Swift.Int>>, Swift.Int>
                  ["hexagonal": [1, 6, 15, 28, 45, 66, 91], "prime": [2, 3, 5, 7, 11, 13, 15], "triangular": [1, 3, 6, 10, 15, 21, 28]]

          [Int] interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count]
          => 7
          [Int] 7
          => 7


          """#
        ||
        output ==
          #"""
          #assert(interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count] == 7)
                  |                           |                 |                  | |  |
                  |                           |                 "hexagonal"        7 |  7
                  |                           |                                      true
                  |                           Swift.KeyPath<Swift.Dictionary<Swift.String, Swift.Array<Swift.Int>>, Swift.Int>
                  ["hexagonal": [1, 6, 15, 28, 45, 66, 91], "triangular": [1, 3, 6, 10, 15, 21, 28], "prime": [2, 3, 5, 7, 11, 13, 15]]

          [Int] interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count]
          => 7
          [Int] 7
          => 7


          """#
        ||
        output ==
          #"""
          #assert(interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count] == 7)
                  |                           |                 |                  | |  |
                  |                           |                 "hexagonal"        7 |  7
                  |                           |                                      true
                  |                           Swift.KeyPath<Swift.Dictionary<Swift.String, Swift.Array<Swift.Int>>, Swift.Int>
                  ["triangular": [1, 3, 6, 10, 15, 21, 28], "prime": [2, 3, 5, 7, 11, 13, 15], "hexagonal": [1, 6, 15, 28, 45, 66, 91]]

          [Int] interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count]
          => 7
          [Int] 7
          => 7


          """#
        ||
        output ==
          #"""
          #assert(interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count] == 7)
                  |                           |                 |                  | |  |
                  |                           |                 "hexagonal"        7 |  7
                  |                           |                                      true
                  |                           Swift.KeyPath<Swift.Dictionary<Swift.String, Swift.Array<Swift.Int>>, Swift.Int>
                  ["triangular": [1, 3, 6, 10, 15, 21, 28], "hexagonal": [1, 6, 15, 28, 45, 66, 91], "prime": [2, 3, 5, 7, 11, 13, 15]]

          [Int] interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count]
          => 7
          [Int] 7
          => 7


          """#
        ||
        output.replacing(#/[:xdigit:]{16}/#, with: "0000000000000000") ==
          #"""
          #assert(interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count] == 7)
                  |                           |                 |                  | |  |
                  |                           |                 "hexagonal"        7 |  7
                  |                           |                                      true
                  |                           \Dictionary<String, Array<Int>>.<computed 0x0000000000000000 (Optional<Array<Int>>)>!.count
                  ["prime": [2, 3, 5, 7, 11, 13, 15], "hexagonal": [1, 6, 15, 28, 45, 66, 91], "triangular": [1, 3, 6, 10, 15, 21, 28]]

          [Int] interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count]
          => 7
          [Int] 7
          => 7


          """#
        ||
        output.replacing(#/[:xdigit:]{16}/#, with: "0000000000000000") ==
          #"""
          #assert(interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count] == 7)
                  |                           |                 |                  | |  |
                  |                           |                 "hexagonal"        7 |  7
                  |                           |                                      true
                  |                           \Dictionary<String, Array<Int>>.<computed 0x0000000000000000 (Optional<Array<Int>>)>!.count
                  ["prime": [2, 3, 5, 7, 11, 13, 15], "triangular": [1, 3, 6, 10, 15, 21, 28], "hexagonal": [1, 6, 15, 28, 45, 66, 91]]

          [Int] interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count]
          => 7
          [Int] 7
          => 7


          """#
        ||
        output.replacing(#/[:xdigit:]{16}/#, with: "0000000000000000") ==
          #"""
          #assert(interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count] == 7)
                  |                           |                 |                  | |  |
                  |                           |                 "hexagonal"        7 |  7
                  |                           |                                      true
                  |                           \Dictionary<String, Array<Int>>.<computed 0x0000000000000000 (Optional<Array<Int>>)>!.count
                  ["hexagonal": [1, 6, 15, 28, 45, 66, 91], "prime": [2, 3, 5, 7, 11, 13, 15], "triangular": [1, 3, 6, 10, 15, 21, 28]]

          [Int] interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count]
          => 7
          [Int] 7
          => 7


          """#
        ||
        output.replacing(#/[:xdigit:]{16}/#, with: "0000000000000000") ==
          #"""
          #assert(interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count] == 7)
                  |                           |                 |                  | |  |
                  |                           |                 "hexagonal"        7 |  7
                  |                           |                                      true
                  |                           \Dictionary<String, Array<Int>>.<computed 0x0000000000000000 (Optional<Array<Int>>)>!.count
                  ["hexagonal": [1, 6, 15, 28, 45, 66, 91], "triangular": [1, 3, 6, 10, 15, 21, 28], "prime": [2, 3, 5, 7, 11, 13, 15]]

          [Int] interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count]
          => 7
          [Int] 7
          => 7


          """#
        ||
        output.replacing(#/[:xdigit:]{16}/#, with: "0000000000000000") ==
          #"""
          #assert(interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count] == 7)
                  |                           |                 |                  | |  |
                  |                           |                 "hexagonal"        7 |  7
                  |                           |                                      true
                  |                           \Dictionary<String, Array<Int>>.<computed 0x0000000000000000 (Optional<Array<Int>>)>!.count
                  ["triangular": [1, 3, 6, 10, 15, 21, 28], "prime": [2, 3, 5, 7, 11, 13, 15], "hexagonal": [1, 6, 15, 28, 45, 66, 91]]

          [Int] interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count]
          => 7
          [Int] 7
          => 7


          """#
        ||
        output.replacing(#/[:xdigit:]{16}/#, with: "0000000000000000") ==
          #"""
          #assert(interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count] == 7)
                  |                           |                 |                  | |  |
                  |                           |                 "hexagonal"        7 |  7
                  |                           |                                      true
                  |                           \Dictionary<String, Array<Int>>.<computed 0x0000000000000000 (Optional<Array<Int>>)>!.count
                  ["triangular": [1, 3, 6, 10, 15, 21, 28], "hexagonal": [1, 6, 15, 28, 45, 66, 91], "prime": [2, 3, 5, 7, 11, 13, 15]]

          [Int] interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count]
          => 7
          [Int] 7
          => 7


          """#
      )
    }
  }

  func testSubscriptKeyPathExpression5() {
    captureConsoleOutput {
      let interestingNumbers = [
        "prime": [2, 3, 5, 7, 11, 13, 15],
        "triangular": [1, 3, 6, 10, 15, 21, 28],
        "hexagonal": [1, 6, 15, 28, 45, 66, 91]
      ]
      #assert(
        interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count.bitWidth] == 64,
        verbose: true
      )
    } completion: { (output) in
      print(output)
      // Dictionary order is not guaranteed
      XCTAssertTrue(
        output ==
          #"""
          #assert(interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count.bitWidth] == 64)
                  |                           |                 |                           | |  |
                  |                           |                 "hexagonal"                 | |  64
                  |                           |                                             | true
                  |                           |                                             64
                  |                           Swift.KeyPath<Swift.Dictionary<Swift.String, Swift.Array<Swift.Int>>, Swift.Int>
                  ["prime": [2, 3, 5, 7, 11, 13, 15], "hexagonal": [1, 6, 15, 28, 45, 66, 91], "triangular": [1, 3, 6, 10, 15, 21, 28]]

          [Int] interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count.bitWidth]
          => 64
          [Int] 64
          => 64


          """#
        ||
        output ==
          #"""
          #assert(interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count.bitWidth] == 64)
                  |                           |                 |                           | |  |
                  |                           |                 "hexagonal"                 | |  64
                  |                           |                                             | true
                  |                           |                                             64
                  |                           Swift.KeyPath<Swift.Dictionary<Swift.String, Swift.Array<Swift.Int>>, Swift.Int>
                  ["prime": [2, 3, 5, 7, 11, 13, 15], "triangular": [1, 3, 6, 10, 15, 21, 28], "hexagonal": [1, 6, 15, 28, 45, 66, 91]]

          [Int] interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count.bitWidth]
          => 64
          [Int] 64
          => 64


          """#
        ||
        output ==
          #"""
          #assert(interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count.bitWidth] == 64)
                  |                           |                 |                           | |  |
                  |                           |                 "hexagonal"                 | |  64
                  |                           |                                             | true
                  |                           |                                             64
                  |                           Swift.KeyPath<Swift.Dictionary<Swift.String, Swift.Array<Swift.Int>>, Swift.Int>
                  ["hexagonal": [1, 6, 15, 28, 45, 66, 91], "prime": [2, 3, 5, 7, 11, 13, 15], "triangular": [1, 3, 6, 10, 15, 21, 28]]

          [Int] interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count.bitWidth]
          => 64
          [Int] 64
          => 64


          """#
        ||
        output ==
          #"""
          #assert(interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count.bitWidth] == 64)
                  |                           |                 |                           | |  |
                  |                           |                 "hexagonal"                 | |  64
                  |                           |                                             | true
                  |                           |                                             64
                  |                           Swift.KeyPath<Swift.Dictionary<Swift.String, Swift.Array<Swift.Int>>, Swift.Int>
                  ["hexagonal": [1, 6, 15, 28, 45, 66, 91], "triangular": [1, 3, 6, 10, 15, 21, 28], "prime": [2, 3, 5, 7, 11, 13, 15]]

          [Int] interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count.bitWidth]
          => 64
          [Int] 64
          => 64


          """#
        ||
        output ==
          #"""
          #assert(interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count.bitWidth] == 64)
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
          #assert(interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count.bitWidth] == 64)
                  |                           |                 |                           | |  |
                  |                           |                 "hexagonal"                 | |  64
                  |                           |                                             | true
                  |                           |                                             64
                  |                           Swift.KeyPath<Swift.Dictionary<Swift.String, Swift.Array<Swift.Int>>, Swift.Int>
                  ["triangular": [1, 3, 6, 10, 15, 21, 28], "hexagonal": [1, 6, 15, 28, 45, 66, 91], "prime": [2, 3, 5, 7, 11, 13, 15]]

          [Int] interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count.bitWidth]
          => 64
          [Int] 64
          => 64


          """#
        ||
        output.replacing(#/[:xdigit:]{16}/#, with: "0000000000000000") ==
          #"""
          #assert(interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count.bitWidth] == 64)
                  |                           |                 |                           | |  |
                  |                           |                 "hexagonal"                 | |  64
                  |                           |                                             | true
                  |                           |                                             64
                  |                           \Dictionary<String, Array<Int>>.<computed 0x0000000000000000 (Optional<Array<Int>>)>!.count.bitWidth
                  ["prime": [2, 3, 5, 7, 11, 13, 15], "hexagonal": [1, 6, 15, 28, 45, 66, 91], "triangular": [1, 3, 6, 10, 15, 21, 28]]

          [Int] interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count.bitWidth]
          => 64
          [Int] 64
          => 64


          """#
        ||
        output.replacing(#/[:xdigit:]{16}/#, with: "0000000000000000") ==
          #"""
          #assert(interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count.bitWidth] == 64)
                  |                           |                 |                           | |  |
                  |                           |                 "hexagonal"                 | |  64
                  |                           |                                             | true
                  |                           |                                             64
                  |                           \Dictionary<String, Array<Int>>.<computed 0x0000000000000000 (Optional<Array<Int>>)>!.count.bitWidth
                  ["prime": [2, 3, 5, 7, 11, 13, 15], "triangular": [1, 3, 6, 10, 15, 21, 28], "hexagonal": [1, 6, 15, 28, 45, 66, 91]]

          [Int] interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count.bitWidth]
          => 64
          [Int] 64
          => 64


          """#
        ||
        output.replacing(#/[:xdigit:]{16}/#, with: "0000000000000000") ==
          #"""
          #assert(interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count.bitWidth] == 64)
                  |                           |                 |                           | |  |
                  |                           |                 "hexagonal"                 | |  64
                  |                           |                                             | true
                  |                           |                                             64
                  |                           \Dictionary<String, Array<Int>>.<computed 0x0000000000000000 (Optional<Array<Int>>)>!.count.bitWidth
                  ["hexagonal": [1, 6, 15, 28, 45, 66, 91], "prime": [2, 3, 5, 7, 11, 13, 15], "triangular": [1, 3, 6, 10, 15, 21, 28]]

          [Int] interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count.bitWidth]
          => 64
          [Int] 64
          => 64


          """#
        ||
        output.replacing(#/[:xdigit:]{16}/#, with: "0000000000000000") ==
          #"""
          #assert(interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count.bitWidth] == 64)
                  |                           |                 |                           | |  |
                  |                           |                 "hexagonal"                 | |  64
                  |                           |                                             | true
                  |                           |                                             64
                  |                           \Dictionary<String, Array<Int>>.<computed 0x0000000000000000 (Optional<Array<Int>>)>!.count.bitWidth
                  ["hexagonal": [1, 6, 15, 28, 45, 66, 91], "triangular": [1, 3, 6, 10, 15, 21, 28], "prime": [2, 3, 5, 7, 11, 13, 15]]

          [Int] interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count.bitWidth]
          => 64
          [Int] 64
          => 64


          """#
        ||
        output.replacing(#/[:xdigit:]{16}/#, with: "0000000000000000") ==
          #"""
          #assert(interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count.bitWidth] == 64)
                  |                           |                 |                           | |  |
                  |                           |                 "hexagonal"                 | |  64
                  |                           |                                             | true
                  |                           |                                             64
                  |                           \Dictionary<String, Array<Int>>.<computed 0x0000000000000000 (Optional<Array<Int>>)>!.count.bitWidth
                  ["triangular": [1, 3, 6, 10, 15, 21, 28], "prime": [2, 3, 5, 7, 11, 13, 15], "hexagonal": [1, 6, 15, 28, 45, 66, 91]]

          [Int] interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count.bitWidth]
          => 64
          [Int] 64
          => 64


          """#
        ||
        output.replacing(#/[:xdigit:]{16}/#, with: "0000000000000000") ==
          #"""
          #assert(interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count.bitWidth] == 64)
                  |                           |                 |                           | |  |
                  |                           |                 "hexagonal"                 | |  64
                  |                           |                                             | true
                  |                           |                                             64
                  |                           \Dictionary<String, Array<Int>>.<computed 0x0000000000000000 (Optional<Array<Int>>)>!.count.bitWidth
                  ["triangular": [1, 3, 6, 10, 15, 21, 28], "hexagonal": [1, 6, 15, 28, 45, 66, 91], "prime": [2, 3, 5, 7, 11, 13, 15]]

          [Int] interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count.bitWidth]
          => 64
          [Int] 64
          => 64


          """#
      )
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
      #assert(String.self != Int.self && "string".self == "string", verbose: true)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #assert(String.self != Int.self && "string".self == "string")
                |      |    |  |   |    |  |        |    |  |
                |      |    |  |   |    |  "string" |    |  "string"
                |      |    |  |   |    true        |    true
                |      |    |  |   |                "string"
                |      |    |  |   Optional(Swift.Int)
                |      |    |  Optional(Swift.Int)
                |      |    true
                |      Optional(Swift.String)
                Optional(Swift.String)

        [Optional<Any.Type>] String.self
        => Optional(Swift.String)
        [Optional<Any.Type>] Int.self
        => Optional(Swift.Int)
        [Bool] String.self != Int.self
        => true
        [String] "string".self
        => "string"
        [String] "string"
        => "string"
        [Bool] "string".self == "string"
        => true


        """
      )
    }
  }

  func testForcedUnwrapExpression() {
    captureConsoleOutput {
      let x: Int? = 0
      let someDictionary = ["a": [1, 2, 3], "b": [10, 20]]

      #assert(x! == 0, verbose: true)
      #assert(someDictionary["a"]![0] == 1, verbose: true)
    } completion: { (output) in
      print(output)
      // Dictionary order is not guaranteed
      XCTAssertTrue(
        output ==
        """
        #assert(x! == 0)
                || |  |
                |0 |  0
                |  true
                Optional(0)

        [Int] x!
        => 0
        [Int] 0
        => 0

        #assert(someDictionary["a"]![0] == 1)
                ||             |  |  || |  |
                |[1, 2, 3]     |  |  |1 |  1
                |              |  |  0  true
                |              |  Optional([1, 2, 3])
                |              "a"
                ["a": [1, 2, 3], "b": [10, 20]]

        [Int] someDictionary["a"]![0]
        => 1
        [Int] 1
        => 1


        """
        ||
        output ==
        """
        #assert(x! == 0)
                || |  |
                |0 |  0
                |  true
                Optional(0)

        [Int] x!
        => 0
        [Int] 0
        => 0

        #assert(someDictionary["a"]![0] == 1)
                ||             |  |  || |  |
                |[1, 2, 3]     |  |  |1 |  1
                |              |  |  0  true
                |              |  Optional([1, 2, 3])
                |              "a"
                ["b": [10, 20], "a": [1, 2, 3]]

        [Int] someDictionary["a"]![0]
        => 1
        [Int] 1
        => 1


        """
      )
    }
  }

  func testOptionalChainingExpression1() {
    captureConsoleOutput {
      var c: SomeClass?
      #assert(c?.property.performAction() == nil, verbose: true)

      c = SomeClass()
      #assert((c?.property.performAction())!, verbose: true)
      #assert(c?.property.performAction() != nil, verbose: true)

      let someDictionary = ["a": [1, 2, 3], "b": [10, 20]]
      #assert(someDictionary["not here"]?[0] != 99, verbose: true)
      #assert(someDictionary["a"]?[0] != 99, verbose: true)
    } completion: { (output) in
      print(output)
      // Dictionary order is not guaranteed
      XCTAssertTrue(
        output ==
          """
          #assert(c?.property.performAction() == nil)
                  |  |        |               |  |
                  |  nil      nil             |  nil
                  nil                         true

          [Optional<Bool>] c?.property.performAction()
          => nil
          [Optional<Bool>] nil
          => nil

          #assert((c?.property.performAction())!)
                  ||| |        |
                  ||| |        Optional(true)
                  ||| Optional(PowerAssertTests.OtherClass)
                  ||Optional(PowerAssertTests.SomeClass)
                  |true
                  Optional(true)

          #assert(c?.property.performAction() != nil)
                  |  |        |               |  |
                  |  |        Optional(true)  |  nil
                  |  |                        true
                  |  Optional(PowerAssertTests.OtherClass)
                  Optional(PowerAssertTests.SomeClass)

          [Optional<Bool>] c?.property.performAction()
          => Optional(true)
          [Optional<Bool>] nil
          => nil

          #assert(someDictionary["not here"]?[0] != 99)
                  |              |         |   | |  |
                  |              |         nil | |  Optional(99)
                  |              "not here"    | true
                  |                            nil
                  ["a": [1, 2, 3], "b": [10, 20]]

          [Optional<Int>] someDictionary["not here"]?[0]
          => nil
          [Optional<Int>] 99
          => Optional(99)

          #assert(someDictionary["a"]?[0] != 99)
                  |              |  |  || |  |
                  |              |  |  || |  Optional(99)
                  |              |  |  || true
                  |              |  |  |Optional(1)
                  |              |  |  0
                  |              |  Optional([1, 2, 3])
                  |              "a"
                  ["a": [1, 2, 3], "b": [10, 20]]

          [Optional<Int>] someDictionary["a"]?[0]
          => Optional(1)
          [Optional<Int>] 99
          => Optional(99)


          """
        ||
        output ==
          """
          #assert(c?.property.performAction() == nil)
                  |  |        |               |  |
                  |  nil      nil             |  nil
                  nil                         true

          [Optional<Bool>] c?.property.performAction()
          => nil
          [Optional<Bool>] nil
          => nil

          #assert((c?.property.performAction())!)
                  ||| |        |
                  ||| |        Optional(true)
                  ||| Optional(PowerAssertTests.OtherClass)
                  ||Optional(PowerAssertTests.SomeClass)
                  |true
                  Optional(true)

          #assert(c?.property.performAction() != nil)
                  |  |        |               |  |
                  |  |        Optional(true)  |  nil
                  |  |                        true
                  |  Optional(PowerAssertTests.OtherClass)
                  Optional(PowerAssertTests.SomeClass)

          [Optional<Bool>] c?.property.performAction()
          => Optional(true)
          [Optional<Bool>] nil
          => nil

          #assert(someDictionary["not here"]?[0] != 99)
                  |              |         |   | |  |
                  |              |         nil | |  Optional(99)
                  |              "not here"    | true
                  |                            nil
                  ["b": [10, 20], "a": [1, 2, 3]]

          [Optional<Int>] someDictionary["not here"]?[0]
          => nil
          [Optional<Int>] 99
          => Optional(99)

          #assert(someDictionary["a"]?[0] != 99)
                  |              |  |  || |  |
                  |              |  |  || |  Optional(99)
                  |              |  |  || true
                  |              |  |  |Optional(1)
                  |              |  |  0
                  |              |  Optional([1, 2, 3])
                  |              "a"
                  ["a": [1, 2, 3], "b": [10, 20]]

          [Optional<Int>] someDictionary["a"]?[0]
          => Optional(1)
          [Optional<Int>] 99
          => Optional(99)

          """
        ||
        output ==
          """
          #assert(c?.property.performAction() == nil)
                  |  |        |               |  |
                  |  nil      nil             |  nil
                  nil                         true

          [Optional<Bool>] c?.property.performAction()
          => nil
          [Optional<Bool>] nil
          => nil

          #assert((c?.property.performAction())!)
                  ||| |        |
                  ||| |        Optional(true)
                  ||| Optional(PowerAssertTests.OtherClass)
                  ||Optional(PowerAssertTests.SomeClass)
                  |true
                  Optional(true)

          #assert(c?.property.performAction() != nil)
                  |  |        |               |  |
                  |  |        Optional(true)  |  nil
                  |  |                        true
                  |  Optional(PowerAssertTests.OtherClass)
                  Optional(PowerAssertTests.SomeClass)

          [Optional<Bool>] c?.property.performAction()
          => Optional(true)
          [Optional<Bool>] nil
          => nil

          #assert(someDictionary["not here"]?[0] != 99)
                  |              |         |   | |  |
                  |              |         nil | |  Optional(99)
                  |              "not here"    | true
                  |                            nil
                  ["a": [1, 2, 3], "b": [10, 20]]

          [Optional<Int>] someDictionary["not here"]?[0]
          => nil
          [Optional<Int>] 99
          => Optional(99)

          #assert(someDictionary["a"]?[0] != 99)
                  |              |  |  || |  |
                  |              |  |  || |  Optional(99)
                  |              |  |  || true
                  |              |  |  |Optional(1)
                  |              |  |  0
                  |              |  Optional([1, 2, 3])
                  |              "a"
                  ["b": [10, 20], "a": [1, 2, 3]]

          [Optional<Int>] someDictionary["a"]?[0]
          => Optional(1)
          [Optional<Int>] 99
          => Optional(99)


          """
        ||
        output ==
          """
          #assert(c?.property.performAction() == nil)
                  |  |        |               |  |
                  |  nil      nil             |  nil
                  nil                         true

          [Optional<Bool>] c?.property.performAction()
          => nil
          [Optional<Bool>] nil
          => nil

          #assert((c?.property.performAction())!)
                  ||| |        |
                  ||| |        Optional(true)
                  ||| Optional(PowerAssertTests.OtherClass)
                  ||Optional(PowerAssertTests.SomeClass)
                  |true
                  Optional(true)

          #assert(c?.property.performAction() != nil)
                  |  |        |               |  |
                  |  |        Optional(true)  |  nil
                  |  |                        true
                  |  Optional(PowerAssertTests.OtherClass)
                  Optional(PowerAssertTests.SomeClass)

          [Optional<Bool>] c?.property.performAction()
          => Optional(true)
          [Optional<Bool>] nil
          => nil

          #assert(someDictionary["not here"]?[0] != 99)
                  |              |         |   | |  |
                  |              |         nil | |  Optional(99)
                  |              "not here"    | true
                  |                            nil
                  ["b": [10, 20], "a": [1, 2, 3]]

          [Optional<Int>] someDictionary["not here"]?[0]
          => nil
          [Optional<Int>] 99
          => Optional(99)

          #assert(someDictionary["a"]?[0] != 99)
                  |              |  |  || |  |
                  |              |  |  || |  Optional(99)
                  |              |  |  || true
                  |              |  |  |Optional(1)
                  |              |  |  0
                  |              |  Optional([1, 2, 3])
                  |              "a"
                  ["b": [10, 20], "a": [1, 2, 3]]

          [Optional<Int>] someDictionary["a"]?[0]
          => Optional(1)
          [Optional<Int>] 99
          => Optional(99)


          """
      )
    }
  }

  func testOptionalChainingExpression2() {
    captureConsoleOutput {
      var c: SomeClass?
      #assert(c?.optionalProperty?.property.optionalProperty?.performAction() == nil, verbose: true)
      c = SomeClass()
//      #assert(c?.optionalProperty?.property.property.optionalProperty?.performAction() == nil, verbose: true)
    } completion: { (output) in
      print(output)
      // Dictionary order is not guaranteed
      XCTAssertEqual(
        output,
        """
        #assert(c?.optionalProperty?.property.optionalProperty?.performAction() == nil)
                |  |                 |        |                 |               |  |
                |  nil               nil      nil               nil             |  nil
                nil                                                             true

        [Optional<Bool>] c?.optionalProperty?.property.optionalProperty?.performAction()
        => nil
        [Optional<Bool>] nil
        => nil


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

      #assert(tuple == (name: kanjiName, age: 37, birthday: date), verbose: true)
      #assert(tuple == (kanjiName, 37, date), verbose: true)
      #assert(tuple.name == (kanjiName, 37, date).0 || tuple.age == (kanjiName, 37, date).1, verbose: true)
      #assert(tuple.name == (kanjiName, 37, date).0 && tuple.age == (kanjiName, 37, date).1, verbose: true)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #assert(tuple == (name: kanjiName, age: 37, birthday: date))
                |     |  |      |               |             |
                |     |  |      |               37            1980-10-27 15:00:00 +0000
                |     |  |      "岸川克己"
                |     |  ("岸川克己", 37, 1980-10-27 15:00:00 +0000)
                |     true
                ("岸川克己", 37, 1980-10-27 15:00:00 +0000)

        [(String, Int, Date)] tuple
        => ("岸川克己", 37, 1980-10-27 15:00:00 +0000)
        [(String, Int, Date)] (name: kanjiName, age: 37, birthday: date)
        => ("岸川克己", 37, 1980-10-27 15:00:00 +0000)

        #assert(tuple == (kanjiName, 37, date))
                |     |  ||          |   |
                |     |  ||          37  1980-10-27 15:00:00 +0000
                |     |  |"岸川克己"
                |     |  ("岸川克己", 37, 1980-10-27 15:00:00 +0000)
                |     true
                ("岸川克己", 37, 1980-10-27 15:00:00 +0000)

        [(String, Int, Date)] tuple
        => ("岸川克己", 37, 1980-10-27 15:00:00 +0000)
        [(String, Int, Date)] (kanjiName, 37, date)
        => ("岸川克己", 37, 1980-10-27 15:00:00 +0000)

        #assert(tuple.name == (kanjiName, 37, date).0 || tuple.age == (kanjiName, 37, date).1)
                |     |    |  ||          |   |     | |
                |     |    |  ||          37  |     | true
                |     |    |  ||              |     "岸川克己"
                |     |    |  ||              1980-10-27 15:00:00 +0000
                |     |    |  |"岸川克己"
                |     |    |  ("岸川克己", 37, 1980-10-27 15:00:00 +0000)
                |     |    true
                |     "岸川克己"
                (name: "岸川克己", age: 37, birthday: 1980-10-27 15:00:00 +0000)

        [String] tuple.name
        => "岸川克己"
        [String] (kanjiName, 37, date).0
        => "岸川克己"
        [Bool] tuple.name == (kanjiName, 37, date).0
        => true

        #assert(tuple.name == (kanjiName, 37, date).0 && tuple.age == (kanjiName, 37, date).1)
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

        [String] tuple.name
        => "岸川克己"
        [String] (kanjiName, 37, date).0
        => "岸川克己"
        [Bool] tuple.name == (kanjiName, 37, date).0
        => true
        [Int] tuple.age
        => 37
        [Int] (kanjiName, 37, date).1
        => 37
        [Bool] tuple.age == (kanjiName, 37, date).1
        => true


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

      #assert(tuple.name != (emojiName, 37, date).0 || tuple.age == (kanjiName, 37, date).1, verbose: true)
      #assert(tuple.name == (kanjiName, 37, date).0 || tuple.age == (emojiName, 37, date).1, verbose: true)
      #assert(tuple.name != (emojiName, 37, date).0 && tuple.age == (kanjiName, 37, date).1, verbose: true)
      #assert(tuple.name == (kanjiName, 37, date).0 && tuple.age == (emojiName, 37, date).1, verbose: true)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #assert(tuple.name != (emojiName, 37, date).0 || tuple.age == (kanjiName, 37, date).1)
                |     |    |  ||          |   |     | |
                |     |    |  ||          37  |     | true
                |     |    |  ||              |     "😇岸川克己🇯🇵"
                |     |    |  ||              1980-10-27 15:00:00 +0000
                |     |    |  |"😇岸川克己🇯🇵"
                |     |    |  ("😇岸川克己🇯🇵", 37, 1980-10-27 15:00:00 +0000)
                |     |    true
                |     "岸川克己"
                (name: "岸川克己", age: 37, birthday: 1980-10-27 15:00:00 +0000)

        [String] tuple.name
        => "岸川克己"
        [String] (emojiName, 37, date).0
        => "😇岸川克己🇯🇵"
        [Bool] tuple.name != (emojiName, 37, date).0
        => true

        #assert(tuple.name == (kanjiName, 37, date).0 || tuple.age == (emojiName, 37, date).1)
                |     |    |  ||          |   |     | |
                |     |    |  ||          37  |     | true
                |     |    |  ||              |     "岸川克己"
                |     |    |  ||              1980-10-27 15:00:00 +0000
                |     |    |  |"岸川克己"
                |     |    |  ("岸川克己", 37, 1980-10-27 15:00:00 +0000)
                |     |    true
                |     "岸川克己"
                (name: "岸川克己", age: 37, birthday: 1980-10-27 15:00:00 +0000)

        [String] tuple.name
        => "岸川克己"
        [String] (kanjiName, 37, date).0
        => "岸川克己"
        [Bool] tuple.name == (kanjiName, 37, date).0
        => true

        #assert(tuple.name != (emojiName, 37, date).0 && tuple.age == (kanjiName, 37, date).1)
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

        [String] tuple.name
        => "岸川克己"
        [String] (emojiName, 37, date).0
        => "😇岸川克己🇯🇵"
        [Bool] tuple.name != (emojiName, 37, date).0
        => true
        [Int] tuple.age
        => 37
        [Int] (kanjiName, 37, date).1
        => 37
        [Bool] tuple.age == (kanjiName, 37, date).1
        => true

        #assert(tuple.name == (kanjiName, 37, date).0 && tuple.age == (emojiName, 37, date).1)
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

        [String] tuple.name
        => "岸川克己"
        [String] (kanjiName, 37, date).0
        => "岸川克己"
        [Bool] tuple.name == (kanjiName, 37, date).0
        => true
        [Int] tuple.age
        => 37
        [Int] (emojiName, 37, date).1
        => 37
        [Bool] tuple.age == (emojiName, 37, date).1
        => true


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

      #assert(tuple == (name: "岸川克己", age: 37, birthday: date), verbose: true)
      #assert(tuple == ("岸川克己", 37, date), verbose: true)
      #assert(tuple.name == ("岸川克己", 37, date).0 || tuple.age == ("岸川克己", 37, date).1, verbose: true)
      #assert(tuple.name == ("岸川克己", 37, date).0 && tuple.age == ("岸川克己", 37, date).1, verbose: true)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #assert(tuple == (name: "岸川克己", age: 37, birthday: date))
                |     |  |      |                |             |
                |     |  |      |                37            1980-10-27 15:00:00 +0000
                |     |  |      "岸川克己"
                |     |  ("岸川克己", 37, 1980-10-27 15:00:00 +0000)
                |     true
                ("岸川克己", 37, 1980-10-27 15:00:00 +0000)

        [(String, Int, Date)] tuple
        => ("岸川克己", 37, 1980-10-27 15:00:00 +0000)
        [(String, Int, Date)] (name: "岸川克己", age: 37, birthday: date)
        => ("岸川克己", 37, 1980-10-27 15:00:00 +0000)

        #assert(tuple == ("岸川克己", 37, date))
                |     |  ||           |   |
                |     |  ||           37  1980-10-27 15:00:00 +0000
                |     |  |"岸川克己"
                |     |  ("岸川克己", 37, 1980-10-27 15:00:00 +0000)
                |     true
                ("岸川克己", 37, 1980-10-27 15:00:00 +0000)

        [(String, Int, Date)] tuple
        => ("岸川克己", 37, 1980-10-27 15:00:00 +0000)
        [(String, Int, Date)] ("岸川克己", 37, date)
        => ("岸川克己", 37, 1980-10-27 15:00:00 +0000)

        #assert(tuple.name == ("岸川克己", 37, date).0 || tuple.age == ("岸川克己", 37, date).1)
                |     |    |  ||           |   |     | |
                |     |    |  ||           37  |     | true
                |     |    |  ||               |     "岸川克己"
                |     |    |  ||               1980-10-27 15:00:00 +0000
                |     |    |  |"岸川克己"
                |     |    |  ("岸川克己", 37, 1980-10-27 15:00:00 +0000)
                |     |    true
                |     "岸川克己"
                (name: "岸川克己", age: 37, birthday: 1980-10-27 15:00:00 +0000)

        [String] tuple.name
        => "岸川克己"
        [String] ("岸川克己", 37, date).0
        => "岸川克己"
        [Bool] tuple.name == ("岸川克己", 37, date).0
        => true

        #assert(tuple.name == ("岸川克己", 37, date).0 && tuple.age == ("岸川克己", 37, date).1)
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

        [String] tuple.name
        => "岸川克己"
        [String] ("岸川克己", 37, date).0
        => "岸川克己"
        [Bool] tuple.name == ("岸川克己", 37, date).0
        => true
        [Int] tuple.age
        => 37
        [Int] ("岸川克己", 37, date).1
        => 37
        [Bool] tuple.age == ("岸川克己", 37, date).1
        => true


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

      #assert(tuple.name != ("😇岸川克己🇯🇵", 37, date).0 || tuple.age == ("岸川克己", 37, date).1, verbose: true)
      #assert(tuple.name == ("岸川克己", 37, date).0 || tuple.age == ("😇岸川克己🇯🇵", 37, date).1, verbose: true)
      #assert(tuple.name != ("😇岸川克己🇯🇵", 37, date).0 && tuple.age == ("岸川克己", 37, date).1, verbose: true)
      #assert(tuple.name == ("岸川克己", 37, date).0 && tuple.age == ("😇岸川克己🇯🇵", 37, date).1, verbose: true)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #assert(tuple.name != ("😇岸川克己🇯🇵", 37, date).0 || tuple.age == ("岸川克己", 37, date).1)
                |     |    |  ||              |   |     | |
                |     |    |  ||              37  |     | true
                |     |    |  ||                  |     "😇岸川克己🇯🇵"
                |     |    |  ||                  1980-10-27 15:00:00 +0000
                |     |    |  |"😇岸川克己🇯🇵"
                |     |    |  ("😇岸川克己🇯🇵", 37, 1980-10-27 15:00:00 +0000)
                |     |    true
                |     "岸川克己"
                (name: "岸川克己", age: 37, birthday: 1980-10-27 15:00:00 +0000)

        [String] tuple.name
        => "岸川克己"
        [String] ("😇岸川克己🇯🇵", 37, date).0
        => "😇岸川克己🇯🇵"
        [Bool] tuple.name != ("😇岸川克己🇯🇵", 37, date).0
        => true

        #assert(tuple.name == ("岸川克己", 37, date).0 || tuple.age == ("😇岸川克己🇯🇵", 37, date).1)
                |     |    |  ||           |   |     | |
                |     |    |  ||           37  |     | true
                |     |    |  ||               |     "岸川克己"
                |     |    |  ||               1980-10-27 15:00:00 +0000
                |     |    |  |"岸川克己"
                |     |    |  ("岸川克己", 37, 1980-10-27 15:00:00 +0000)
                |     |    true
                |     "岸川克己"
                (name: "岸川克己", age: 37, birthday: 1980-10-27 15:00:00 +0000)

        [String] tuple.name
        => "岸川克己"
        [String] ("岸川克己", 37, date).0
        => "岸川克己"
        [Bool] tuple.name == ("岸川克己", 37, date).0
        => true

        #assert(tuple.name != ("😇岸川克己🇯🇵", 37, date).0 && tuple.age == ("岸川克己", 37, date).1)
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

        [String] tuple.name
        => "岸川克己"
        [String] ("😇岸川克己🇯🇵", 37, date).0
        => "😇岸川克己🇯🇵"
        [Bool] tuple.name != ("😇岸川克己🇯🇵", 37, date).0
        => true
        [Int] tuple.age
        => 37
        [Int] ("岸川克己", 37, date).1
        => 37
        [Bool] tuple.age == ("岸川克己", 37, date).1
        => true

        #assert(tuple.name == ("岸川克己", 37, date).0 && tuple.age == ("😇岸川克己🇯🇵", 37, date).1)
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

        [String] tuple.name
        => "岸川克己"
        [String] ("岸川克己", 37, date).0
        => "岸川克己"
        [Bool] tuple.name == ("岸川克己", 37, date).0
        => true
        [Int] tuple.age
        => 37
        [Int] ("😇岸川克己🇯🇵", 37, date).1
        => 37
        [Bool] tuple.age == ("😇岸川克己🇯🇵", 37, date).1
        => true


        """
      )
    }
  }

  func testConditionalCompilationBlock() {
    captureConsoleOutput {
      let bar = Bar(foo: Foo(val: 2), val: 3)
#if swift(>=3.2)
      #assert(bar.val != bar.foo.val, verbose: true)
#endif
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #assert(bar.val != bar.foo.val)
                |   |   |  |   |   |
                |   3   |  |   |   2
                |       |  |   Foo(val: 2)
                |       |  Bar(foo: PowerAssertTests.Foo(val: 2), val: 3)
                |       true
                Bar(foo: PowerAssertTests.Foo(val: 2), val: 3)

        [Int] bar.val
        => 3
        [Int] bar.foo.val
        => 2
        

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
      #assert(
        array.description.hasPrefix("[") != false && array.description.hasPrefix("Hello") != true,
        "message",
        verbose: true
      )
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #assert(array.description.hasPrefix("[") != false && array.description.hasPrefix("Hello") != true)
                |     |           |         |    |  |     |  |     |           |         |        |  |
                |     "[1, 2, 3]" true      "["  |  false |  |     "[1, 2, 3]" false     "Hello"  |  true
                [1, 2, 3]                        true     |  [1, 2, 3]                            true
                                                          true

        [Bool] array.description.hasPrefix("[")
        => true
        [Bool] false
        => false
        [Bool] array.description.hasPrefix("[") != false
        => true
        [Bool] array.description.hasPrefix("Hello")
        => false
        [Bool] true
        => true
        [Bool] array.description.hasPrefix("Hello") != true
        => true


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
      #assert(
        array.description.hasPrefix("[") != false && array.description.hasPrefix("Hello") != true,
        file: "path/to/Tests.swift",
        verbose: true
      )
      #assert(
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
        #assert(array.description.hasPrefix("[") != false && array.description.hasPrefix("Hello") != true)
                |     |           |         |    |  |     |  |     |           |         |        |  |
                |     "[1, 2, 3]" true      "["  |  false |  |     "[1, 2, 3]" false     "Hello"  |  true
                [1, 2, 3]                        true     |  [1, 2, 3]                            true
                                                          true

        [Bool] array.description.hasPrefix("[")
        => true
        [Bool] false
        => false
        [Bool] array.description.hasPrefix("[") != false
        => true
        [Bool] array.description.hasPrefix("Hello")
        => false
        [Bool] true
        => true
        [Bool] array.description.hasPrefix("Hello") != true
        => true

        #assert(array.description.hasPrefix("[") != false && array.description.hasPrefix("Hello") != true)
                |     |           |         |    |  |     |  |     |           |         |        |  |
                |     "[1, 2, 3]" true      "["  |  false |  |     "[1, 2, 3]" false     "Hello"  |  true
                [1, 2, 3]                        true     |  [1, 2, 3]                            true
                                                          true

        [Bool] array.description.hasPrefix("[")
        => true
        [Bool] false
        => false
        [Bool] array.description.hasPrefix("[") != false
        => true
        [Bool] array.description.hasPrefix("Hello")
        => false
        [Bool] true
        => true
        [Bool] array.description.hasPrefix("Hello") != true
        => true
        

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
      #assert(
        array.description.hasPrefix("[") != false && array.description.hasPrefix("Hello") != true,
        line: 999,
        verbose: true
      )
      #assert(
        array.description.hasPrefix("[") != false && array.description.hasPrefix("Hello") != true,
        "message",
        line: 999,
        verbose: true
      )
      #assert(
        array.description.hasPrefix("[") != false && array.description.hasPrefix("Hello") != true,
        file: "path/to/Tests.swift",
        line: 999,
        verbose: true
      )
      #assert(
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
        #assert(array.description.hasPrefix("[") != false && array.description.hasPrefix("Hello") != true)
                |     |           |         |    |  |     |  |     |           |         |        |  |
                |     "[1, 2, 3]" true      "["  |  false |  |     "[1, 2, 3]" false     "Hello"  |  true
                [1, 2, 3]                        true     |  [1, 2, 3]                            true
                                                          true

        [Bool] array.description.hasPrefix("[")
        => true
        [Bool] false
        => false
        [Bool] array.description.hasPrefix("[") != false
        => true
        [Bool] array.description.hasPrefix("Hello")
        => false
        [Bool] true
        => true
        [Bool] array.description.hasPrefix("Hello") != true
        => true

        #assert(array.description.hasPrefix("[") != false && array.description.hasPrefix("Hello") != true)
                |     |           |         |    |  |     |  |     |           |         |        |  |
                |     "[1, 2, 3]" true      "["  |  false |  |     "[1, 2, 3]" false     "Hello"  |  true
                [1, 2, 3]                        true     |  [1, 2, 3]                            true
                                                          true

        [Bool] array.description.hasPrefix("[")
        => true
        [Bool] false
        => false
        [Bool] array.description.hasPrefix("[") != false
        => true
        [Bool] array.description.hasPrefix("Hello")
        => false
        [Bool] true
        => true
        [Bool] array.description.hasPrefix("Hello") != true
        => true

        #assert(array.description.hasPrefix("[") != false && array.description.hasPrefix("Hello") != true)
                |     |           |         |    |  |     |  |     |           |         |        |  |
                |     "[1, 2, 3]" true      "["  |  false |  |     "[1, 2, 3]" false     "Hello"  |  true
                [1, 2, 3]                        true     |  [1, 2, 3]                            true
                                                          true

        [Bool] array.description.hasPrefix("[")
        => true
        [Bool] false
        => false
        [Bool] array.description.hasPrefix("[") != false
        => true
        [Bool] array.description.hasPrefix("Hello")
        => false
        [Bool] true
        => true
        [Bool] array.description.hasPrefix("Hello") != true
        => true

        #assert(array.description.hasPrefix("[") != false && array.description.hasPrefix("Hello") != true)
                |     |           |         |    |  |     |  |     |           |         |        |  |
                |     "[1, 2, 3]" true      "["  |  false |  |     "[1, 2, 3]" false     "Hello"  |  true
                [1, 2, 3]                        true     |  [1, 2, 3]                            true
                                                          true

        [Bool] array.description.hasPrefix("[")
        => true
        [Bool] false
        => false
        [Bool] array.description.hasPrefix("[") != false
        => true
        [Bool] array.description.hasPrefix("Hello")
        => false
        [Bool] true
        => true
        [Bool] array.description.hasPrefix("Hello") != true
        => true


        """
      )
    }
  }

  func testStringContainsNewlines() {
    captureConsoleOutput {
      let loremIpsum = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
      #assert(
        loremIpsum != "Lorem ipsum dolor sit amet,\nconsectetur adipiscing elit,",
        verbose: true
      )
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        #"""
        #assert(loremIpsum != "Lorem ipsum dolor sit amet,\nconsectetur adipiscing elit,")
                |          |  |
                |          |  "Lorem ipsum dolor sit amet,\nconsectetur adipiscing elit,"
                |          true
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."

        [String] loremIpsum
        => "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
        [String] "Lorem ipsum dolor sit amet,\nconsectetur adipiscing elit,"
        => "Lorem ipsum dolor sit amet,\nconsectetur adipiscing elit,"


        """#
      )
    }
  }

  func testStringContainsEscapeSequences1() {
    captureConsoleOutput {
      let lyric1 = "Feet, don't fail me now."
      #assert(lyric1 == "Feet, don't fail me now.", verbose: true)
      #assert(lyric1 == "Feet, don\'t fail me now.", verbose: true)

      let lyric2 = "Feet, don\'t fail me now."
      #assert(lyric2 == "Feet, don't fail me now.", verbose: true)
      #assert(lyric2 == "Feet, don\'t fail me now.", verbose: true)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        #"""
        #assert(lyric1 == "Feet, don't fail me now.")
                |      |  |
                |      |  "Feet, don't fail me now."
                |      true
                "Feet, don't fail me now."

        [String] lyric1
        => "Feet, don't fail me now."
        [String] "Feet, don't fail me now."
        => "Feet, don't fail me now."

        #assert(lyric1 == "Feet, don\'t fail me now.")
                |      |  |
                |      |  "Feet, don't fail me now."
                |      true
                "Feet, don't fail me now."

        [String] lyric1
        => "Feet, don't fail me now."
        [String] "Feet, don\'t fail me now."
        => "Feet, don't fail me now."

        #assert(lyric2 == "Feet, don't fail me now.")
                |      |  |
                |      |  "Feet, don't fail me now."
                |      true
                "Feet, don't fail me now."

        [String] lyric2
        => "Feet, don't fail me now."
        [String] "Feet, don't fail me now."
        => "Feet, don't fail me now."

        #assert(lyric2 == "Feet, don\'t fail me now.")
                |      |  |
                |      |  "Feet, don't fail me now."
                |      true
                "Feet, don't fail me now."

        [String] lyric2
        => "Feet, don't fail me now."
        [String] "Feet, don\'t fail me now."
        => "Feet, don't fail me now."


        """#
      )
    }
  }

  func testStringContainsEscapeSequences2() {
    captureConsoleOutput {
      let nestedQuote1 = "My mother said, \"The baby started talking today. The baby said, 'Mama.'\""
      #assert(nestedQuote1 == "My mother said, \"The baby started talking today. The baby said, 'Mama.'\"", verbose: true)
      #assert(nestedQuote1 == "My mother said, \"The baby started talking today. The baby said, \'Mama.\'\"", verbose: true)

      let nestedQuote2 = "My mother said, \"The baby started talking today. The baby said, \'Mama.\'\""
      #assert(nestedQuote2 == "My mother said, \"The baby started talking today. The baby said, 'Mama.'\"", verbose: true)
      #assert(nestedQuote2 == "My mother said, \"The baby started talking today. The baby said, \'Mama.\'\"", verbose: true)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        #"""
        #assert(nestedQuote1 == "My mother said, \"The baby started talking today. The baby said, 'Mama.'\"")
                |            |  |
                |            |  "My mother said, \"The baby started talking today. The baby said, 'Mama.'\""
                |            true
                "My mother said, \"The baby started talking today. The baby said, 'Mama.'\""

        [String] nestedQuote1
        => "My mother said, \"The baby started talking today. The baby said, 'Mama.'\""
        [String] "My mother said, \"The baby started talking today. The baby said, 'Mama.'\""
        => "My mother said, \"The baby started talking today. The baby said, 'Mama.'\""

        #assert(nestedQuote1 == "My mother said, \"The baby started talking today. The baby said, \'Mama.\'\"")
                |            |  |
                |            |  "My mother said, \"The baby started talking today. The baby said, 'Mama.'\""
                |            true
                "My mother said, \"The baby started talking today. The baby said, 'Mama.'\""

        [String] nestedQuote1
        => "My mother said, \"The baby started talking today. The baby said, 'Mama.'\""
        [String] "My mother said, \"The baby started talking today. The baby said, \'Mama.\'\""
        => "My mother said, \"The baby started talking today. The baby said, 'Mama.'\""

        #assert(nestedQuote2 == "My mother said, \"The baby started talking today. The baby said, 'Mama.'\"")
                |            |  |
                |            |  "My mother said, \"The baby started talking today. The baby said, 'Mama.'\""
                |            true
                "My mother said, \"The baby started talking today. The baby said, 'Mama.'\""

        [String] nestedQuote2
        => "My mother said, \"The baby started talking today. The baby said, 'Mama.'\""
        [String] "My mother said, \"The baby started talking today. The baby said, 'Mama.'\""
        => "My mother said, \"The baby started talking today. The baby said, 'Mama.'\""

        #assert(nestedQuote2 == "My mother said, \"The baby started talking today. The baby said, \'Mama.\'\"")
                |            |  |
                |            |  "My mother said, \"The baby started talking today. The baby said, 'Mama.'\""
                |            true
                "My mother said, \"The baby started talking today. The baby said, 'Mama.'\""

        [String] nestedQuote2
        => "My mother said, \"The baby started talking today. The baby said, 'Mama.'\""
        [String] "My mother said, \"The baby started talking today. The baby said, \'Mama.\'\""
        => "My mother said, \"The baby started talking today. The baby said, 'Mama.'\""


        """#
      )
    }
  }

  func testStringContainsEscapeSequences3() {
    captureConsoleOutput {
      let helpText = "OPTIONS:\n  --build-path\t\tSpecify build/cache directory [default: ./.build]"
      #assert(helpText == "OPTIONS:\n  --build-path\t\tSpecify build/cache directory [default: ./.build]", verbose: true)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        #"""
        #assert(helpText == "OPTIONS:\n  --build-path\t\tSpecify build/cache directory [default: ./.build]")
                |        |  |
                |        |  "OPTIONS:\n  --build-path\t\tSpecify build/cache directory [default: ./.build]"
                |        true
                "OPTIONS:\n  --build-path\t\tSpecify build/cache directory [default: ./.build]"

        [String] helpText
        => "OPTIONS:\n  --build-path\t\tSpecify build/cache directory [default: ./.build]"
        [String] "OPTIONS:\n  --build-path\t\tSpecify build/cache directory [default: ./.build]"
        => "OPTIONS:\n  --build-path\t\tSpecify build/cache directory [default: ./.build]"


        """#
      )
    }
  }

  func testStringContainsEscapeSequences4() {
    captureConsoleOutput {
      let nullCharacter = "Null character\0Null character"
      #assert(nullCharacter == "Null character\0Null character", verbose: true)

      let lineFeed = "Line feed\nLine feed"
      #assert(lineFeed == "Line feed\nLine feed", verbose: true)

      let carriageReturn = "Carriage Return\rCarriage Return"
      #assert(carriageReturn == "Carriage Return\rCarriage Return", verbose: true)

      let backslash = "Backslash\\Backslash"
      #assert(backslash == "Backslash\\Backslash", verbose: true)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        #"""
        #assert(nullCharacter == "Null character\0Null character")
                |             |  |
                |             |  "Null character\0Null character"
                |             true
                "Null character\0Null character"

        [String] nullCharacter
        => "Null character\0Null character"
        [String] "Null character\0Null character"
        => "Null character\0Null character"

        #assert(lineFeed == "Line feed\nLine feed")
                |        |  |
                |        |  "Line feed\nLine feed"
                |        true
                "Line feed\nLine feed"

        [String] lineFeed
        => "Line feed\nLine feed"
        [String] "Line feed\nLine feed"
        => "Line feed\nLine feed"

        #assert(carriageReturn == "Carriage Return\rCarriage Return")
                |              |  |
                |              |  "Carriage Return\rCarriage Return"
                |              true
                "Carriage Return\rCarriage Return"

        [String] carriageReturn
        => "Carriage Return\rCarriage Return"
        [String] "Carriage Return\rCarriage Return"
        => "Carriage Return\rCarriage Return"

        #assert(backslash == "Backslash\\Backslash")
                |         |  |
                |         |  "Backslash\Backslash"
                |         true
                "Backslash\Backslash"

        [String] backslash
        => "Backslash\Backslash"
        [String] "Backslash\\Backslash"
        => "Backslash\Backslash"


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
      #assert(wiseWords == "\"Imagination is more important than knowledge\" - Einstein", verbose: true)
      #assert(dollarSign == "\u{24}", verbose: true)
      #assert(blackHeart == "\u{2665}", verbose: true)
      #assert(sparklingHeart == "\u{1F496}", verbose: true)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        #"""
        #assert(wiseWords == "\"Imagination is more important than knowledge\" - Einstein")
                |         |  |
                |         |  "\"Imagination is more important than knowledge\" - Einstein"
                |         true
                "\"Imagination is more important than knowledge\" - Einstein"

        [String] wiseWords
        => "\"Imagination is more important than knowledge\" - Einstein"
        [String] "\"Imagination is more important than knowledge\" - Einstein"
        => "\"Imagination is more important than knowledge\" - Einstein"

        #assert(dollarSign == "\u{24}")
                |          |  |
                "$"        |  "$"
                           true

        [String] dollarSign
        => "$"
        [String] "\u{24}"
        => "$"

        #assert(blackHeart == "\u{2665}")
                |          |  |
                |          |  "♥"
                |          true
                "♥"

        [String] blackHeart
        => "♥"
        [String] "\u{2665}"
        => "♥"

        #assert(sparklingHeart == "\u{1F496}")
                |              |  |
                |              |  "💖"
                |              true
                "💖"

        [String] sparklingHeart
        => "💖"
        [String] "\u{1F496}"
        => "💖"


        """#
      )
    }
  }

  func testStringContainsPoundSign() {
    captureConsoleOutput {
      let pound = "#"
      #assert(pound == "#", verbose: true)
      #assert("#" == pound, verbose: true)
      #assert(String("#") == pound, verbose: true)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        #"""
        #assert(pound == "#")
                |     |  |
                "#"   |  "#"
                      true

        [String] pound
        => "#"
        [String] "#"
        => "#"

        #assert("#" == pound)
                |   |  |
                "#" |  "#"
                    true

        [String] "#"
        => "#"
        [String] pound
        => "#"

        #assert(String("#") == pound)
                |      |    |  |
                "#"    "#"  |  "#"
                            true

        [String] String("#")
        => "#"
        [String] pound
        => "#"

        
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
      #assert(
        multilineLiteral == """
          Lorem ipsum dolor sit amet, consectetur adipiscing elit,
          sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
          """,
        verbose: true
      )
      #assert(multilineLiteral == multilineLiteral, verbose: true)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        #"""
        #assert(multilineLiteral == "Lorem ipsum dolor sit amet, consectetur adipiscing elit,\nsed do eiusmod tempor incididunt ut labore et dolore magna aliqua.")
                |                |  |
                |                |  "Lorem ipsum dolor sit amet, consectetur adipiscing elit,\nsed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
                |                true
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit,\nsed do eiusmod tempor incididunt ut labore et dolore magna aliqua."

        [String] multilineLiteral
        => "Lorem ipsum dolor sit amet, consectetur adipiscing elit,\nsed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
        [String] "Lorem ipsum dolor sit amet, consectetur adipiscing elit,\nsed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
        => "Lorem ipsum dolor sit amet, consectetur adipiscing elit,\nsed do eiusmod tempor incididunt ut labore et dolore magna aliqua."

        #assert(multilineLiteral == multilineLiteral)
                |                |  |
                |                |  "Lorem ipsum dolor sit amet, consectetur adipiscing elit,\nsed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
                |                true
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit,\nsed do eiusmod tempor incididunt ut labore et dolore magna aliqua."

        [String] multilineLiteral
        => "Lorem ipsum dolor sit amet, consectetur adipiscing elit,\nsed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
        [String] multilineLiteral
        => "Lorem ipsum dolor sit amet, consectetur adipiscing elit,\nsed do eiusmod tempor incididunt ut labore et dolore magna aliqua."


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
      #assert(
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
        #assert(multilineLiteral != #"Escaping the first quotation mark \"""\#nEscaping all three quotation marks \"\"\""#)
                |                |  |
                |                |  "Escaping the first quotation mark \\"\"\"\nEscaping all three quotation marks \\"\\"\\""
                |                true
                "Escaping the first quotation mark \"\"\"\nEscaping all three quotation marks \"\"\""

        [String] multilineLiteral
        => "Escaping the first quotation mark \"\"\"\nEscaping all three quotation marks \"\"\""
        [String] #"Escaping the first quotation mark \"""\#nEscaping all three quotation marks \"\"\""#
        => "Escaping the first quotation mark \\"\"\"\nEscaping all three quotation marks \\"\\"\\""


        """##
      )
    }
  }

  func testCustomOperator() {
    captureConsoleOutput {
      let number1 = 100.0
      let number2 = 200.0
      #assert(number1 × number2 == 20000.0, verbose: true)
      #assert(√number2 == 14.142135623730951, verbose: true)
      #assert(√√number2 != 200.0, verbose: true)
      #assert(3.760603093086394 == √√number2, verbose: true)
      #assert(√number2 != √√number2, verbose: true)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #assert(number1 × number2 == 20000.0)
                |       | |          |
                100.0   | 200.0      20000.0
                        true
        
        #assert(√number2 == 14.142135623730951)
                ||       |  |
                |200.0   |  14.142135623730951
                |        true
                14.142135623730951

        [Double] √number2
        => 14.142135623730951
        [Double] 14.142135623730951
        => 14.142135623730951

        #assert(√√number2 != 200.0)
                | |       |  |
                | 200.0   |  200.0
                |         true
                3.760603093086394

        [Double] √√number2
        => 3.760603093086394
        [Double] 200.0
        => 200.0

        #assert(3.760603093086394 == √√number2)
                |                 |  | |
                3.760603093086394 |  | 200.0
                                  |  3.760603093086394
                                  true

        [Double] 3.760603093086394
        => 3.760603093086394
        [Double] √√number2
        => 3.760603093086394

        #assert(√number2 != √√number2)
                ||       |    ||
                |200.0   true |3.760603093086394
                |             200.0
                14.142135623730951

        [Double] √number2
        => 14.142135623730951
        [Double] √√number2
        => 3.760603093086394
        

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
      #assert(i2==1,verbose:true)
      #assert(b1==false&&i1<i2||false==b1&&i2==1,verbose:true)
      #assert(b1==false&&i1<i2||false==b1&&i2==1||d1×d2==24.0,verbose:true)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #assert(i2==1)
                | | |
                1 | 1
                  true

        [Int] i2
        => 1
        [Int] 1
        => 1

        #assert(b1==false&&i1<i2||false==b1&&i2==1)
                | | |    | | || |
                | | |    | 0 |1 true
                | | |    |   true
                | | |    true
                | | false
                | true
                false

        [Bool] b1
        => false
        [Bool] false
        => false
        [Bool] b1==false
        => true
        [Int] i1
        => 0
        [Int] i2
        => 1
        [Bool] i1<i2
        => true
        [Bool] b1==false&&i1<i2
        => true

        #assert(b1==false&&i1<i2||false==b1&&i2==1||d1×d2==24.0)
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
      #assert(i2==1,verbose:true)
      #assert(b1==false&&i1<i2&&false==b1&&i2==1,verbose:true)
      #assert(b1==false&&i1<i2&&false==b1&&i2==1||d1×d2==24.0,verbose:true)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #assert(i2==1)
                | | |
                1 | 1
                  true

        [Int] i2
        => 1
        [Int] 1
        => 1

        #assert(b1==false&&i1<i2&&false==b1&&i2==1)
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

        [Bool] b1
        => false
        [Bool] false
        => false
        [Bool] b1==false
        => true
        [Int] i1
        => 0
        [Int] i2
        => 1
        [Bool] i1<i2
        => true
        [Bool] b1==false&&i1<i2
        => true
        [Bool] false
        => false
        [Bool] b1
        => false
        [Bool] false==b1
        => true
        [Bool] b1==false&&i1<i2&&false==b1
        => true
        [Int] i2
        => 1
        [Int] 1
        => 1
        [Bool] i2==1
        => true

        #assert(b1==false&&i1<i2&&false==b1&&i2==1||d1×d2==24.0)
                | | |      |  |   |      |   |   |
                | | false  0  1   false  |   1   1
                | true                   false
                false

        
        """
      )
    }
  }

  // FIXME: Temporarily disable tests due to Swift compiler bug
  // https://github.com/apple/swift-syntax/issues/1593
//  func testHigherOrderFunction() {
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
//      #assert(array.map { testA($0) } == [1, 2, 3], verbose: true)
//      #assert(array.map(testB) == [1, 2, 3], verbose: true)
//    } completion: { (output) in
//      print(output)
//      XCTAssertEqual(
//        output,
//        """
//        #assert(array.map { testA($0) } == [1, 2, 3])
//                |     |                 |  ||  |  |
//                |     [1, 2, 3]         |  |1  2  3
//                [0, 1, 2]               |  [1, 2, 3]
//                                        true
//        #assert(array.map(testB) == [1, 2, 3])
//                |     |   |      |  ||  |  |
//                |     |   |      |  |1  2  3
//                |     |   |      |  [1, 2, 3]
//                |     |   |      true
//                |     |   (Function)
//                |     [1, 2, 3]
//                [0, 1, 2]
//
//        """
//      )
//    }
//  }

  func testStringInterpolation() {
    captureConsoleOutput {
      func testA(_ i: Int) -> Int {
        return i + 1
      }

      let string = "World!"
      #assert("Hello \(string)" == "Hello World!", verbose: true)

      let i = 99
      #assert("value == \(testA(i))" == "value == 100", verbose: true)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        #"""
        #assert("Hello \(string)" == "Hello World!")
                |        |        |  |
                |        "World!" |  "Hello World!"
                "Hello World!"    true

        [String] "Hello \(string)"
        => "Hello World!"
        [String] "Hello World!"
        => "Hello World!"

        #assert("value == \(testA(i))" == "value == 100")
                |           |     |    |  |
                |           100   99   |  "value == 100"
                "value == 100"         true

        [String] "value == \(testA(i))"
        => "value == 100"
        [String] "value == 100"
        => "value == 100"


        """#
      )
    }
  }

  func testRegexLiteral() {
    captureConsoleOutput {
      do {
        let regex = #/(CREDIT|DEBIT)\s+(\d{1,2}/\d{1,2}/\d{4})/#
        let result = try #/(CREDIT|DEBIT)\s+(\d{1,2}/\d{1,2}/\d{4})/#.firstMatch(in: "CREDIT    03/01/2022    Payroll from employer      $200.23")

        #assert(try regex.firstMatch(in: "CREDIT    03/01/2022    Payroll from employer      $200.23") != nil, verbose: true)
        #assert(
          try #/(CREDIT|DEBIT)\s+(\d{1,2}/\d{1,2}/\d{4})/#.firstMatch(in: "CREDIT    03/01/2022    Payroll from employer      $200.23")?.output.0 == result?.output.0,
          verbose: true
        )
        #assert(
          try #/(CREDIT|DEBIT)\s+(\d{1,2}/\d{1,2}/\d{4})/#.firstMatch(in: "CREDIT    03/01/2022    Payroll from employer      $200.23")?.output.1 == "CREDIT",
          verbose: true
        )
      } catch {
        XCTFail()
      }
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        #"""
        #assert(try regex.firstMatch(in: "CREDIT    03/01/2022    Payroll from employer      $200.23") != nil)
                    |     |              |                                                             |  |
                    |     |              "CREDIT    03/01/2022    Payroll from employer      $200.23"  |  _OptionalNilComparisonType()
                    |     |                                                                            true
                    |     Optional(_StringProcessing.Regex<(Swift.Substring, Swift.Substring, Swift.Substring)>.Match(anyRegexOutput: _StringProcessing.AnyRegexOutput(input: "CREDIT    03/01/2022    Payroll from employer      $200.23", _elements: [_StringProcessing.AnyRegexOutput.ElementRepresentation(optionalDepth: 0, content: Optional((range: Range(Swift.String.Index(_rawBits: 15)..<Swift.String.Index(_rawBits: 1310983)), value: nil)), name: nil, referenceID: nil), _StringProcessing.AnyRegexOutput.ElementRepresentation(optionalDepth: 0, content: Optional((range: Range(Swift.String.Index(_rawBits: 15)..<Swift.String.Index(_rawBits: 393221)), value: nil)), name: nil, referenceID: nil), _StringProcessing.AnyRegexOutput.ElementRepresentation(optionalDepth: 0, content: Optional((range: Range(Swift.String.Index(_rawBits: 655623)..<Swift.String.Index(_rawBits: 1310983)), value: nil)), name: nil, referenceID: nil)]), range: Range(Swift.String.Index(_rawBits: 15)..<Swift.String.Index(_rawBits: 1310983))))
                    Regex<(Substring, Substring, Substring)>(program: _StringProcessing.Regex<(Swift.Substring, Swift.Substring, Swift.Substring)>.Program)

        [Optional<Match>] regex.firstMatch(in: "CREDIT    03/01/2022    Payroll from employer      $200.23")
        => Optional(_StringProcessing.Regex<(Swift.Substring, Swift.Substring, Swift.Substring)>.Match(anyRegexOutput: _StringProcessing.AnyRegexOutput(input: "CREDIT    03/01/2022    Payroll from employer      $200.23", _elements: [_StringProcessing.AnyRegexOutput.ElementRepresentation(optionalDepth: 0, content: Optional((range: Range(Swift.String.Index(_rawBits: 15)..<Swift.String.Index(_rawBits: 1310983)), value: nil)), name: nil, referenceID: nil), _StringProcessing.AnyRegexOutput.ElementRepresentation(optionalDepth: 0, content: Optional((range: Range(Swift.String.Index(_rawBits: 15)..<Swift.String.Index(_rawBits: 393221)), value: nil)), name: nil, referenceID: nil), _StringProcessing.AnyRegexOutput.ElementRepresentation(optionalDepth: 0, content: Optional((range: Range(Swift.String.Index(_rawBits: 655623)..<Swift.String.Index(_rawBits: 1310983)), value: nil)), name: nil, referenceID: nil)]), range: Range(Swift.String.Index(_rawBits: 15)..<Swift.String.Index(_rawBits: 1310983))))
        [_OptionalNilComparisonType] nil
        => _OptionalNilComparisonType()

        #assert(try #/(CREDIT|DEBIT)\s+(\d{1,2}/\d{1,2}/\d{4})/#.firstMatch(in: "CREDIT    03/01/2022    Payroll from employer      $200.23")?.output.0 == result?.output.0)
                    |                                            |              |                                                              |      | |  |       |      |
                    |                                            |              "CREDIT    03/01/2022    Payroll from employer      $200.23"   |      | |  |       |      Optional("CREDIT    03/01/2022")
                    |                                            |                                                                             |      | |  |       Optional(("CREDIT    03/01/2022", "CREDIT", "03/01/2022"))
                    |                                            |                                                                             |      | |  Optional(_StringProcessing.Regex<(Swift.Substring, Swift.Substring, Swift.Substring)>.Match(anyRegexOutput: _StringProcessing.AnyRegexOutput(input: "CREDIT    03/01/2022    Payroll from employer      $200.23", _elements: [_StringProcessing.AnyRegexOutput.ElementRepresentation(optionalDepth: 0, content: Optional((range: Range(Swift.String.Index(_rawBits: 15)..<Swift.String.Index(_rawBits: 1310983)), value: nil)), name: nil, referenceID: nil), _StringProcessing.AnyRegexOutput.ElementRepresentation(optionalDepth: 0, content: Optional((range: Range(Swift.String.Index(_rawBits: 15)..<Swift.String.Index(_rawBits: 393221)), value: nil)), name: nil, referenceID: nil), _StringProcessing.AnyRegexOutput.ElementRepresentation(optionalDepth: 0, content: Optional((range: Range(Swift.String.Index(_rawBits: 655623)..<Swift.String.Index(_rawBits: 1310983)), value: nil)), name: nil, referenceID: nil)]), range: Range(Swift.String.Index(_rawBits: 15)..<Swift.String.Index(_rawBits: 1310983))))
                    |                                            |                                                                             |      | true
                    |                                            |                                                                             |      Optional("CREDIT    03/01/2022")
                    |                                            |                                                                             Optional(("CREDIT    03/01/2022", "CREDIT", "03/01/2022"))
                    |                                            Optional(_StringProcessing.Regex<(Swift.Substring, Swift.Substring, Swift.Substring)>.Match(anyRegexOutput: _StringProcessing.AnyRegexOutput(input: "CREDIT    03/01/2022    Payroll from employer      $200.23", _elements: [_StringProcessing.AnyRegexOutput.ElementRepresentation(optionalDepth: 0, content: Optional((range: Range(Swift.String.Index(_rawBits: 15)..<Swift.String.Index(_rawBits: 1310983)), value: nil)), name: nil, referenceID: nil), _StringProcessing.AnyRegexOutput.ElementRepresentation(optionalDepth: 0, content: Optional((range: Range(Swift.String.Index(_rawBits: 15)..<Swift.String.Index(_rawBits: 393221)), value: nil)), name: nil, referenceID: nil), _StringProcessing.AnyRegexOutput.ElementRepresentation(optionalDepth: 0, content: Optional((range: Range(Swift.String.Index(_rawBits: 655623)..<Swift.String.Index(_rawBits: 1310983)), value: nil)), name: nil, referenceID: nil)]), range: Range(Swift.String.Index(_rawBits: 15)..<Swift.String.Index(_rawBits: 1310983))))
                    Regex<(Substring, Substring, Substring)>(program: _StringProcessing.Regex<(Swift.Substring, Swift.Substring, Swift.Substring)>.Program)

        [Optional<Substring>] #/(CREDIT|DEBIT)\s+(\d{1,2}/\d{1,2}/\d{4})/#.firstMatch(in: "CREDIT    03/01/2022    Payroll from employer      $200.23")?.output.0
        => Optional("CREDIT    03/01/2022")
        [Optional<Substring>] result?.output.0
        => Optional("CREDIT    03/01/2022")

        #assert(try #/(CREDIT|DEBIT)\s+(\d{1,2}/\d{1,2}/\d{4})/#.firstMatch(in: "CREDIT    03/01/2022    Payroll from employer      $200.23")?.output.1 == "CREDIT")
                    |                                            |              |                                                              |      | |  |
                    |                                            |              "CREDIT    03/01/2022    Payroll from employer      $200.23"   |      | |  Optional("CREDIT")
                    |                                            |                                                                             |      | true
                    |                                            |                                                                             |      Optional("CREDIT")
                    |                                            |                                                                             Optional(("CREDIT    03/01/2022", "CREDIT", "03/01/2022"))
                    |                                            Optional(_StringProcessing.Regex<(Swift.Substring, Swift.Substring, Swift.Substring)>.Match(anyRegexOutput: _StringProcessing.AnyRegexOutput(input: "CREDIT    03/01/2022    Payroll from employer      $200.23", _elements: [_StringProcessing.AnyRegexOutput.ElementRepresentation(optionalDepth: 0, content: Optional((range: Range(Swift.String.Index(_rawBits: 15)..<Swift.String.Index(_rawBits: 1310983)), value: nil)), name: nil, referenceID: nil), _StringProcessing.AnyRegexOutput.ElementRepresentation(optionalDepth: 0, content: Optional((range: Range(Swift.String.Index(_rawBits: 15)..<Swift.String.Index(_rawBits: 393221)), value: nil)), name: nil, referenceID: nil), _StringProcessing.AnyRegexOutput.ElementRepresentation(optionalDepth: 0, content: Optional((range: Range(Swift.String.Index(_rawBits: 655623)..<Swift.String.Index(_rawBits: 1310983)), value: nil)), name: nil, referenceID: nil)]), range: Range(Swift.String.Index(_rawBits: 15)..<Swift.String.Index(_rawBits: 1310983))))
                    Regex<(Substring, Substring, Substring)>(program: _StringProcessing.Regex<(Swift.Substring, Swift.Substring, Swift.Substring)>.Program)

        [Optional<Substring>] #/(CREDIT|DEBIT)\s+(\d{1,2}/\d{1,2}/\d{4})/#.firstMatch(in: "CREDIT    03/01/2022    Payroll from employer      $200.23")?.output.1
        => Optional("CREDIT")
        [Optional<Substring>] "CREDIT"
        => Optional("CREDIT")

        
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
