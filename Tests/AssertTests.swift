import XCTest
@testable import PowerAssert

final class AssertTests: XCTestCase {
  override func setUp() {
    setenv("NO_COLOR", "1", 1)
    setenv("SWIFTPOWERASSERT_WITHOUT_XCTEST", "1", 1)
  }

  override func tearDown() {
    unsetenv("NO_COLOR")
    unsetenv("SWIFTPOWERASSERT_WITHOUT_XCTEST")
  }

  func testBinaryExpression1() {
    captureConsoleOutput {
      let bar = Bar(foo: Foo(val: 2), val: 3)
      #assert(bar.val == bar.foo.val)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #assert(bar.val == bar.foo.val)
                │   │   │  │   │   │
                │   3   │  │   │   2
                │       │  │   Foo(val: 2)
                │       │  Bar(foo: PowerAssertTests.Foo(val: 2), val: 3)
                │       false
                Bar(foo: PowerAssertTests.Foo(val: 2), val: 3)

        --- [Int] bar.val
        +++ [Int] bar.foo.val
        –3
        +2

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
      #assert(bar.val < bar.foo.val)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #assert(bar.val < bar.foo.val)
                │   │   │ │   │   │
                │   3   │ │   │   2
                │       │ │   Foo(val: 2)
                │       │ Bar(foo: PowerAssertTests.Foo(val: 2), val: 3)
                │       false
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
      #assert(array.firstIndex(of: zero) == two)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #assert(array.firstIndex(of: zero) == two)
                │     │              │     │  │
                │     nil            0     │  2
                [1, 2, 3]                  false

        --- [Optional<Int>] array.firstIndex(of: zero)
        +++ [Int] two
        –nil
        +2

        [Optional<Int>] array.firstIndex(of: zero)
        => nil
        [Int] two
        => 2


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
      #assert(array.description.hasPrefix("[") == false && array.description.hasPrefix("Hello") == true)
      #assert(array.description.hasPrefix("]") == false && array.description.hasPrefix("Hello") == true)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #assert(array.description.hasPrefix("[") == false && array.description.hasPrefix("Hello") == true)
                │     │           │         │    │  │     │
                │     "[1, 2, 3]" true      "["  │  false false
                [1, 2, 3]                        false

        --- [Bool] array.description.hasPrefix("[")
        +++ [Bool] false
        –true
        +false

        [Bool] array.description.hasPrefix("[")
        => true
        [Bool] false
        => false
        [Bool] array.description.hasPrefix("[") == false
        => false
        [Not Evaluated] array.description.hasPrefix("Hello")
        [Not Evaluated] true
        [Not Evaluated] array.description.hasPrefix("Hello") == true

        #assert(array.description.hasPrefix("]") == false && array.description.hasPrefix("Hello") == true)
                │     │           │         │    │  │     │  │     │           │         │        │  │
                │     "[1, 2, 3]" false     "]"  │  false │  │     "[1, 2, 3]" false     "Hello"  │  true
                [1, 2, 3]                        true     │  [1, 2, 3]                            false
                                                          false

        --- [Bool] array.description.hasPrefix("Hello")
        +++ [Bool] true
        –false
        +true

        [Bool] array.description.hasPrefix("]")
        => false
        [Bool] false
        => false
        [Bool] array.description.hasPrefix("]") == false
        => true
        [Bool] array.description.hasPrefix("Hello")
        => false
        [Bool] true
        => true
        [Bool] array.description.hasPrefix("Hello") == true
        => false


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
      #assert(array.firstIndex(of: zero) == two && bar.val == bar.foo.val)
      #assert(array.firstIndex(of: one) == zero && bar.val == bar.foo.val)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #assert(array.firstIndex(of: zero) == two && bar.val == bar.foo.val)
                │     │              │     │  │   │
                │     nil            0     │  2   false
                [1, 2, 3]                  false

        --- [Optional<Int>] array.firstIndex(of: zero)
        +++ [Int] two
        –nil
        +2

        [Optional<Int>] array.firstIndex(of: zero)
        => nil
        [Int] two
        => 2
        [Bool] array.firstIndex(of: zero) == two
        => false
        [Not Evaluated] bar.val
        [Not Evaluated] bar.foo.val
        [Not Evaluated] bar.val == bar.foo.val

        #assert(array.firstIndex(of: one) == zero && bar.val == bar.foo.val)
                │     │              │    │  │    │  │   │   │  │   │   │
                │     Optional(0)    1    │  0    │  │   3   │  │   │   2
                [1, 2, 3]                 true    │  │       │  │   Foo(val: 2)
                                                  │  │       │  Bar(foo: PowerAssertTests.Foo(val: 2), val: 3)
                                                  │  │       false
                                                  │  Bar(foo: PowerAssertTests.Foo(val: 2), val: 3)
                                                  false

        --- [Int] bar.val
        +++ [Int] bar.foo.val
        –3
        +2

        [Optional<Int>] array.firstIndex(of: one)
        => Optional(0)
        [Int] zero
        => 0
        [Bool] array.firstIndex(of: one) == zero
        => true
        [Int] bar.val
        => 3
        [Int] bar.foo.val
        => 2
        [Bool] bar.val == bar.foo.val
        => false


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
      #assert(array.distance(from: 2, to: 3) == 4)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #assert(array.distance(from: 2, to: 3) == 4)
                │     │              │      │  │  │
                │     1              2      3  │  4
                [1, 2, 3]                      false

        --- [Int] array.distance(from: 2, to: 3)
        +++ [Int] 4
        –1
        +4

        [Int] array.distance(from: 2, to: 3)
        => 1
        [Int] 4
        => 4


        """
      )
    }
  }

  func testBinaryExpression7() {
    captureConsoleOutput {
      let one = 1
      let two = 2
      let three = 3

      #assert([one, two, three].count == 10)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #assert([one, two, three].count == 10)
                ││    │    │      │     │  │
                │1    2    3      3     │  10
                [1, 2, 3]               false

        --- [Int] [one, two, three].count
        +++ [Int] 10
        –3
        +10

        [Int] [one, two, three].count
        => 3
        [Int] 10
        => 10


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

      #assert((object.types[index] as! Person).name == bob.name)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #assert((object.types[index] as! Person).name == bob.name)
                ││      │     │    │ │           │    │  │   │
                ││      │     7    │ │           │    │  │   "bob"
                ││      │          │ │           │    │  Person(name: "bob", age: 5)
                ││      │          │ │           │    false
                ││      │          │ │           "alice"
                ││      │          │ Person(name: "alice", age: 3)
                ││      │          Optional(PowerAssertTests.Person(name: "alice", age: 3))
                ││      [Optional("string"), Optional(98.6), Optional(true), Optional(false), nil, Optional(nan), Optional(inf), Optional(PowerAssertTests.Person(name: "alice", age: 3))]
                │Object(types: [Optional("string"), Optional(98.6), Optional(true), Optional(false), nil, Optional(nan), Optional(inf), Optional(PowerAssertTests.Person(name: "alice", age: 3))])
                Person(name: "alice", age: 3)

        --- [String] (object.types[index] as! Person).name
        +++ [String] bob.name
        [-alice-]{+bob+}

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
      #assert(array.description.hasPrefix("[") == false || array.description.hasPrefix("Hello") == true)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #assert(array.description.hasPrefix("[") == false || array.description.hasPrefix("Hello") == true)
                │     │           │         │    │  │     │  │     │           │         │        │  │
                │     "[1, 2, 3]" true      "["  │  false │  │     "[1, 2, 3]" false     "Hello"  │  true
                [1, 2, 3]                        false    │  [1, 2, 3]                            false
                                                          false

        --- [Bool] array.description.hasPrefix("[")
        +++ [Bool] false
        –true
        +false

        --- [Bool] array.description.hasPrefix("Hello")
        +++ [Bool] true
        –false
        +true

        [Bool] array.description.hasPrefix("[")
        => true
        [Bool] false
        => false
        [Bool] array.description.hasPrefix("[") == false
        => false
        [Bool] array.description.hasPrefix("Hello")
        => false
        [Bool] true
        => true
        [Bool] array.description.hasPrefix("Hello") == true
        => false


        """
      )
    }
  }

  func testEqualityExpression1() {
    captureConsoleOutput {
      let input1 = "apple"
      let input2 = "orange"
      #assert(input1 == input2)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #assert(input1 == input2)
                │      │  │
                │      │  "orange"
                │      false
                "apple"

        --- [String] input1
        +++ [String] input2
        {+or+}a[-ppl-]{+ng+}e

        [String] input1
        => "apple"
        [String] input2
        => "orange"


        """
      )
    }
  }

  func testEqualityExpression2() {
    captureConsoleOutput {
      let input1 = "The quick brown fox"
      let input2 = "The slow brown fox"
      #assert(input1 == input2)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #assert(input1 == input2)
                │      │  │
                │      │  "The slow brown fox"
                │      false
                "The quick brown fox"

        --- [String] input1
        +++ [String] input2
        The [-quick-]{+slow+} brown fox

        [String] input1
        => "The quick brown fox"
        [String] input2
        => "The slow brown fox"


        """
      )
    }
  }

  func testIdenticalExpression() {
    captureConsoleOutput {
      let number1 = IntegerRef(100)
      let number2 = IntegerRef(200)
      #assert(number1 === number2)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output.replacingOccurrences(
          of: #"<ObjectIdentifier\S+>"#,
          with: "<ObjectIdentifier(0x0000000000000000)>",
          options: .regularExpression
        ),
        """
        #assert(number1 === number2)
                │       │   │
                │       │   Optional(PowerAssertTests.IntegerRef)
                │       false
                Optional(PowerAssertTests.IntegerRef)

        --- [Optional<AnyObject>] number1
        +++ [Optional<AnyObject>] number2
        –<ObjectIdentifier(0x0000000000000000)>
        +<ObjectIdentifier(0x0000000000000000)>

        [Optional<AnyObject>] number1
        => Optional(PowerAssertTests.IntegerRef)
        [Optional<AnyObject>] number2
        => Optional(PowerAssertTests.IntegerRef)


        """
      )
    }
  }

  func testMultilineExpression1() {
    captureConsoleOutput {
      let bar = Bar(foo: Foo(val: 2), val: 3)
      #assert(bar.val == bar.foo.val)
      #assert(bar
        .val ==
        bar.foo.val)
      #assert(bar
        .val ==
        bar
          .foo        .val)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #assert(bar.val == bar.foo.val)
                │   │   │  │   │   │
                │   3   │  │   │   2
                │       │  │   Foo(val: 2)
                │       │  Bar(foo: PowerAssertTests.Foo(val: 2), val: 3)
                │       false
                Bar(foo: PowerAssertTests.Foo(val: 2), val: 3)

        --- [Int] bar.val
        +++ [Int] bar.foo.val
        –3
        +2

        [Int] bar.val
        => 3
        [Int] bar.foo.val
        => 2

        #assert(bar .val == bar.foo.val)
                │    │   │  │   │   │
                │    3   │  │   │   2
                │        │  │   Foo(val: 2)
                │        │  Bar(foo: PowerAssertTests.Foo(val: 2), val: 3)
                │        false
                Bar(foo: PowerAssertTests.Foo(val: 2), val: 3)

        --- [Int] bar .val
        +++ [Int] bar.foo.val
        –3
        +2

        [Int] bar .val
        => 3
        [Int] bar.foo.val
        => 2

        #assert(bar .val == bar .foo .val)
                │    │   │  │    │    │
                │    3   │  │    │    2
                │        │  │    Foo(val: 2)
                │        │  Bar(foo: PowerAssertTests.Foo(val: 2), val: 3)
                │        false
                Bar(foo: PowerAssertTests.Foo(val: 2), val: 3)

        --- [Int] bar .val
        +++ [Int] bar .foo .val
        –3
        +2

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
        == two
      )

      #assert(array
        .
              firstIndex(

          of:
          zero)
        == two
      )

      #assert(array
        .firstIndex(
          of:
          zero)
        == two
      )
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #assert(array . firstIndex( of: zero) == two)
                │       │               │     │  │
                │       nil             0     │  2
                [1, 2, 3]                     false

        --- [Optional<Int>] array . firstIndex( of: zero)
        +++ [Int] two
        –nil
        +2

        [Optional<Int>] array . firstIndex( of: zero)
        => nil
        [Int] two
        => 2

        #assert(array . firstIndex( of: zero) == two)
                │       │               │     │  │
                │       nil             0     │  2
                [1, 2, 3]                     false

        --- [Optional<Int>] array . firstIndex( of: zero)
        +++ [Int] two
        –nil
        +2

        [Optional<Int>] array . firstIndex( of: zero)
        => nil
        [Int] two
        => 2

        #assert(array .firstIndex( of: zero) == two)
                │      │               │     │  │
                │      nil             0     │  2
                [1, 2, 3]                    false

        --- [Optional<Int>] array .firstIndex( of: zero)
        +++ [Int] two
        –nil
        +2

        [Optional<Int>] array .firstIndex( of: zero)
        => nil
        [Int] two
        => 2


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
        == false && array
          .description
          .hasPrefix    ("Hello"    ) ==
        true)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #assert(array .description .hasPrefix( "[" ) == false && array .description .hasPrefix ("Hello" ) == true)
                │      │            │          │     │  │     │
                │      "[1, 2, 3]"  true       "["   │  false false
                [1, 2, 3]                            false

        --- [Bool] array .description .hasPrefix( "[" )
        +++ [Bool] false
        –true
        +false

        [Bool] array .description .hasPrefix( "[" )
        => true
        [Bool] false
        => false
        [Bool] array .description .hasPrefix( "[" ) == false
        => false
        [Not Evaluated] array .description .hasPrefix ("Hello" )
        [Not Evaluated] true
        [Not Evaluated] array .description .hasPrefix ("Hello" ) == true


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
          ==
          two
          &&
          bar
            .val
          == bar
            .foo
            .val
        )
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #assert(array.firstIndex( of: zero ) == two && bar .val == bar .foo .val)
                │     │               │      │  │   │
                │     nil             0      │  2   false
                [1, 2, 3]                    false

        --- [Optional<Int>] array.firstIndex( of: zero )
        +++ [Int] two
        –nil
        +2

        [Optional<Int>] array.firstIndex( of: zero )
        => nil
        [Int] two
        => 2
        [Bool] array.firstIndex( of: zero ) == two
        => false
        [Not Evaluated] bar .val
        [Not Evaluated] bar .foo .val
        [Not Evaluated] bar .val == bar .foo .val


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
          == 4)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #assert(array .distance( from: 2, to: 3) == 4)
                │      │               │      │  │  │
                │      1               2      3  │  4
                [1, 2, 3]                        false

        --- [Int] array .distance( from: 2, to: 3)
        +++ [Int] 4
        –1
        +4

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
        == 10)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #assert([one, two , three] .count == 10)
                ││    │     │       │     │  │
                │1    2     3       3     │  10
                [1, 2, 3]                 false

        --- [Int] [one, two , three] .count
        +++ [Int] 10
        –3
        +10

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
              == 10)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #assert([one, two , three]  .count == 10)
                ││    │     │        │     │  │
                │1    2     3        3     │  10
                [1, 2, 3]                  false

        --- [Int] [one, two , three]  .count
        +++ [Int] 10
        –3
        +10

        [Int] [one, two , three]  .count
        => 3
        [Int] 10
        => 10


        """
      )
    }
  }

  func testMultilineExpression8() {
    captureConsoleOutput {
      let numbers = [1, 2, 3, 4, 5]
      #assert   (
        numbers
        .

      contains (
        6
      )
        )
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #assert(numbers . contains ( 6 ))
                │         │          │
                │         false      6
                [1, 2, 3, 4, 5]


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
        [one, two, three]/* comment in assertion*/./* comment in assertion*/count/* comment in assertion*/==/* comment in assertion*/10
      )
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #assert([one, two, three] . count == 10)
                ││    │    │        │     │  │
                │1    2    3        3     │  10
                [1, 2, 3]                 false

        --- [Int] [one, two, three] . count
        +++ [Int] 10
        –3
        +10

        [Int] [one, two, three] . count
        => 3
        [Int] 10
        => 10


        """
      )
    }
  }

  func testTryExpression1() throws {
    try skip("Test fails on main branch")
    captureConsoleOutput {
      let landmark = Landmark(
        name: "Tokyo Tower",
        foundingYear: 1957,
        location: Coordinate(latitude: 35.658581, longitude: 139.745438)
      )

      #assert(
        try! JSONEncoder().encode(landmark) == #"{ "name": "Tokyo Tower" }"#.data(using: String.Encoding.utf8)
      )
      #assert(
        try! JSONEncoder().encode(landmark) == #"{ "name": "Tokyo Tower" }"#.data(using: .utf8)
      )
      #assert(
        try! #"{ "name": "Tokyo Tower" }"#.data(using: String.Encoding.utf8) == JSONEncoder().encode(landmark)
      )
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        #"""
        #assert(try! JSONEncoder().encode(landmark) == #"{ "name": "Tokyo Tower" }"#.data(using: String.Encoding.utf8))
                     │             │      │         │  │                             │           │      │        │
                     │             │      │         │  │                             │           String Encoding Unicode (UTF-8)
                     │             │      │         │  │                             Optional(25 bytes)
                     │             │      │         │  "{ \"name\": \"Tokyo Tower\" }"
                     │             │      │         false
                     │             │      Landmark(name: "Tokyo Tower", foundingYear: 1957, location: PowerAssertTests.Coordinate(latitude: 35.658581, longitude: 139.745438))
                     │             Optional(116 bytes)
                     Foundation.JSONEncoder

        --- [Optional<Data>] JSONEncoder().encode(landmark)
        +++ [Optional<Data>] #"{ "name": "Tokyo Tower" }"#.data(using: String.Encoding.utf8)
        –Optional(116 bytes)
        +Optional(25 bytes)

        [Optional<Data>] JSONEncoder().encode(landmark)
        => Optional(116 bytes)
        [Optional<Data>] #"{ "name": "Tokyo Tower" }"#.data(using: String.Encoding.utf8)
        => Optional(25 bytes)

        #assert(try! JSONEncoder().encode(landmark) == #"{ "name": "Tokyo Tower" }"#.data(using: .utf8))
                     │             │      │         │  │                             │            │
                     │             │      │         │  │                             │            Unicode (UTF-8)
                     │             │      │         │  │                             Optional(25 bytes)
                     │             │      │         │  "{ \"name\": \"Tokyo Tower\" }"
                     │             │      │         false
                     │             │      Landmark(name: "Tokyo Tower", foundingYear: 1957, location: PowerAssertTests.Coordinate(latitude: 35.658581, longitude: 139.745438))
                     │             Optional(116 bytes)
                     Foundation.JSONEncoder

        --- [Optional<Data>] JSONEncoder().encode(landmark)
        +++ [Optional<Data>] #"{ "name": "Tokyo Tower" }"#.data(using: .utf8)
        –Optional(116 bytes)
        +Optional(25 bytes)

        [Optional<Data>] JSONEncoder().encode(landmark)
        => Optional(116 bytes)
        [Optional<Data>] #"{ "name": "Tokyo Tower" }"#.data(using: .utf8)
        => Optional(25 bytes)

        #assert(try! #"{ "name": "Tokyo Tower" }"#.data(using: String.Encoding.utf8) == JSONEncoder().encode(landmark))
                     │                             │           │      │        │     │  │             │      │
                     │                             │           String Encoding │     │  │             │      Landmark(name: "Tokyo Tower", foundingYear: 1957, location: PowerAssertTests.Coordinate(latitude: 35.658581, longitude: 139.745438))
                     │                             Optional(25 bytes)          │     │  │             Optional(116 bytes)
                     "{ \"name\": \"Tokyo Tower\" }"                           │     │  Foundation.JSONEncoder
                                                                               │     false
                                                                               Unicode (UTF-8)

        --- [Optional<Data>] #"{ "name": "Tokyo Tower" }"#.data(using: String.Encoding.utf8)
        +++ [Optional<Data>] JSONEncoder().encode(landmark)
        –Optional(25 bytes)
        +Optional(116 bytes)

        [Optional<Data>] #"{ "name": "Tokyo Tower" }"#.data(using: String.Encoding.utf8)
        => Optional(25 bytes)
        [Optional<Data>] JSONEncoder().encode(landmark)
        => Optional(116 bytes)


        """#
      )
    }
  }

  func testTryExpression2() throws {
    try skip("Test fails on main branch")
    captureConsoleOutput {
      let landmark = Landmark(
        name: "Tokyo Tower",
        foundingYear: 1957,
        location: Coordinate(latitude: 35.658581, longitude: 139.745438)
      )

      #assert(try JSONEncoder().encode(landmark).count > 200)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        #"""
        #assert(try JSONEncoder().encode(landmark).count > 200)
                    │             │      │         │     │ │
                    │             │      │         116   │ 200
                    │             │      │               false
                    │             │      Landmark(name: "Tokyo Tower", foundingYear: 1957, location: PowerAssertTests.Coordinate(latitude: 35.658581, longitude: 139.745438))
                    │             116 bytes
                    Foundation.JSONEncoder

        [Int] JSONEncoder().encode(landmark).count
        => 116
        [Int] 200
        => 200


        """#
      )
    }
  }

  func testThrowError() {
    captureConsoleOutput {
      #assert(
        try throwRecoverableError() == "Unrecoverable error"
      )
      #assert(try throwUnrecoverableError())

      let input1 = "test"
      let input2 = "test"
      #assert(
        try input1 == input2 && throwRecoverableError() == "Unrecoverable error"
      )
      #assert(
        try input1 == input2 && throwUnrecoverableError()
      )
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        #"""
        #assert(try throwRecoverableError() == "Unrecoverable error")
                    │                       │
                    │                       recoverableError("Recoverable error")
                    recoverableError("Recoverable error")

        [Error] recoverableError("Recoverable error")
        [MyError] throwRecoverableError()
        => recoverableError("Recoverable error")
        [Not Evaluated] "Unrecoverable error"

        #assert(try throwUnrecoverableError())
                    │
                    unrecoverableError("Unrecoverable error")

        [Error] unrecoverableError("Unrecoverable error")

        #assert(try input1 == input2 && throwRecoverableError() == "Unrecoverable error")
                    │      │  │      │  │                       │
                    "test" │  "test" │  │                       recoverableError("Recoverable error")
                           true      │  recoverableError("Recoverable error")
                                     recoverableError("Recoverable error")

        [Error] recoverableError("Recoverable error")
        [String] input1
        => "test"
        [String] input2
        => "test"
        [Bool] input1 == input2
        => true
        [MyError] throwRecoverableError()
        => recoverableError("Recoverable error")
        [MyError] throwRecoverableError() == "Unrecoverable error"
        => recoverableError("Recoverable error")
        [Not Evaluated] "Unrecoverable error"

        #assert(try input1 == input2 && throwUnrecoverableError())
                    │      │  │      │  │
                    "test" │  "test" │  unrecoverableError("Unrecoverable error")
                           true      unrecoverableError("Unrecoverable error")

        [Error] unrecoverableError("Unrecoverable error")
        [String] input1
        => "test"
        [String] input2
        => "test"
        [Bool] input1 == input2
        => true
        [MyError] throwUnrecoverableError()
        => unrecoverableError("Unrecoverable error")


        """#
      )
    }
  }

  func testNilLiteral() {
    captureConsoleOutput {
      let string = "1234"
      let number = Int(string)

      #assert(number != nil && number == 1111)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #assert(number != nil && number == 1111)
                │      │  │   │  │      │  │
                │      │  nil │  │      │  1111
                │      true   │  │      false
                │             │  Optional(1234)
                │             false
                Optional(1234)

        --- [Optional<Int>] number
        +++ [Int] 1111
        –Optional(1234)
        +1111

        [Optional<Int>] number
        => Optional(1234)
        [Optional<Int>] nil
        => nil
        [Bool] number != nil
        => true
        [Optional<Int>] number
        => Optional(1234)
        [Int] 1111
        => 1111
        [Bool] number == 1111
        => false


        """
      )
    }
  }

  func testTernaryConditionalOperator1() {
    captureConsoleOutput {
      let string = "1234"
      let number = Int(string)
      let hello = "hello"

      #assert((number != nil ? string : "hello") == hello)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #assert((number != nil ? string : "hello") == hello)
                │││     │  │     │                 │  │
                ││"1234"│  nil   "1234"            │  "hello"
                ││      true                       false
                │Optional(1234)
                "1234"

        --- [String] (number != nil ? string : "hello")
        +++ [String] hello
        [-1234-]{+hello+}

        [Optional<Int>] number
        => Optional(1234)
        [Optional<Int>] nil
        => nil
        [Bool] number != nil
        => true
        [String] string
        => "1234"
        [String] (number != nil ? string : "hello")
        => "1234"
        [String] hello
        => "hello"
        [Not Evaluated] "hello"


        """
      )
    }
  }

  func testTernaryConditionalOperator2() {
    captureConsoleOutput {
      let string = "1234"
      let number = Int(string)
      let hello = "hello"

      #assert((number == nil ? string : hello) == string)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #assert((number == nil ? string : hello) == string)
                │││     │  │              │      │  │
                │││     │  nil            │      │  "1234"
                │││     false             │      false
                ││"hello"                 "hello"
                │Optional(1234)
                "hello"

        --- [Optional<Int>] number
        +++ [Optional<Int>] nil
        –Optional(1234)
        +nil

        --- [String] (number == nil ? string : hello)
        +++ [String] string
        [-hello-]{+1234+}

        [Optional<Int>] number
        => Optional(1234)
        [Optional<Int>] nil
        => nil
        [Bool] number == nil
        => false
        [String] hello
        => "hello"
        [String] (number == nil ? string : hello)
        => "hello"
        [String] string
        => "1234"
        [Not Evaluated] string


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

      #assert([one, two, three].firstIndex(of: zero) == two)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #assert([one, two, three].firstIndex(of: zero) == two)
                ││    │    │      │              │     │  │
                │1    2    3      nil            0     │  2
                [1, 2, 3]                              false

        --- [Optional<Int>] [one, two, three].firstIndex(of: zero)
        +++ [Int] two
        –nil
        +2

        [Optional<Int>] [one, two, three].firstIndex(of: zero)
        => nil
        [Int] two
        => 2


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

      #assert([zero: one, two: three].count == three)
    } completion: { (output) in
      print(output)
      // Dictionary order is not guaranteed
      XCTAssertTrue(
        output ==
        """
        #assert([zero: one, two: three].count == three)
                ││     │    │    │      │     │  │
                │0     1    2    3      2     │  3
                [0: 1, 2: 3]                  false

        --- [Int] [zero: one, two: three].count
        +++ [Int] three
        –2
        +3

        [Int] [zero: one, two: three].count
        => 2
        [Int] three
        => 3


        """
        ||
        output ==
        """
        #assert([zero: one, two: three].count == three)
                ││     │    │    │      │     │  │
                │0     1    2    3      2     │  3
                [2: 3, 0: 1]                  false

        --- [Int] [zero: one, two: three].count
        +++ [Int] three
        –2
        +3

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
      #assert(#file == "*.swift" && #line == 1 && #column == 2 && #function == "function")
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output.replacingOccurrences(
          of: "(/.+/)(Tests/)",
          with: "/swift-power-assert/Tests/",
          options: .regularExpression
        ),
        """
        #assert(#file == "*.swift" && #line == 1 && #column == 2 && #function == "function")
                │     │  │         │           │ │             │ │
                │     │  "*.swift" false       1 false         2 false
                │     false
                "/swift-power-assert/Tests/AssertTests.swift"

        --- [String] #file
        +++ [String] "*.swift"
        [-/swift-power-assert/Tests/AssertTests-]{+*+}.swift

        [String] #file
        => "/swift-power-assert/Tests/AssertTests.swift"
        [String] "*.swift"
        => "*.swift"
        [Bool] #file == "*.swift"
        => false
        [Int] 1
        => 1
        [Bool] #file == "*.swift" && #line == 1
        => false
        [Int] 2
        => 2
        [Bool] #file == "*.swift" && #line == 1 && #column == 2
        => false
        [Not Evaluated] #line
        [Not Evaluated] #line == 1
        [Not Evaluated] #column
        [Not Evaluated] #column == 2
        [Not Evaluated] #function
        [Not Evaluated] "function"
        [Not Evaluated] #function == "function"


        """
      )
    }
  }

  func testMagicLiteralExpression2() {
    captureConsoleOutput {
      #assert(
        #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1) == .blue &&
          .blue == #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
      )
      #assert(
        #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1) == .blue ||
          .blue == #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
      )
      #assert(
        #colorLiteral(red: 0.0, green: 0.0, blue: 1.0, alpha: 1) != .blue &&
          .blue != #colorLiteral(red: 0.0, green: 0.0, blue: 1.0, alpha: 1)
      )
      #assert(
        #colorLiteral(red: 0.0, green: 0.0, blue: 1.0, alpha: 1) != .blue ||
          .blue != #colorLiteral(red: 0.0, green: 0.0, blue: 1.0, alpha: 1)
      )
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #assert(#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1) == .blue && .blue == #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1))
                │                  │                    │                    │                    │  │   │    │                              │                    │                    │                    │
                │                  0.8078431487         0.02745098062        0.3333333433         1  │   │    false                          0.8078431487         0.02745098062        0.3333333433         1
                sRGB IEC61966-2.1 colorspace 0.807843 0.027451 0.333333 1                            │   sRGB IEC61966-2.1 colorspace 0 0 1 1
                                                                                                     false

        --- [NSColorSpaceColor] #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        +++ [_NSTaggedPointerColor] .blue
        –sRGB IEC61966-2.1 colorspace 0.807843 0.027451 0.333333 1
        +sRGB IEC61966-2.1 colorspace 0 0 1 1

        [NSColorSpaceColor] #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        => sRGB IEC61966-2.1 colorspace 0.807843 0.027451 0.333333 1
        [_NSTaggedPointerColor] .blue
        => sRGB IEC61966-2.1 colorspace 0 0 1 1
        [Bool] #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1) == .blue
        => false
        [Not Evaluated] .blue
        [Not Evaluated] #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        [Not Evaluated] .blue == #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)

        #assert(#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1) == .blue || .blue == #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1))
                │                  │                    │                    │                    │  │   │    │   │    │  │                  │                    │                    │                    │
                │                  0.8078431487         0.02745098062        0.3333333433         1  │   │    │   │    │  │                  0.8078431487         0.02745098062        0.3333333433         1
                sRGB IEC61966-2.1 colorspace 0.807843 0.027451 0.333333 1                            │   │    │   │    │  sRGB IEC61966-2.1 colorspace 0.807843 0.027451 0.333333 1
                                                                                                     │   │    │   │    false
                                                                                                     │   │    │   sRGB IEC61966-2.1 colorspace 0 0 1 1
                                                                                                     │   │    false
                                                                                                     │   sRGB IEC61966-2.1 colorspace 0 0 1 1
                                                                                                     false

        --- [NSColorSpaceColor] #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        +++ [_NSTaggedPointerColor] .blue
        –sRGB IEC61966-2.1 colorspace 0.807843 0.027451 0.333333 1
        +sRGB IEC61966-2.1 colorspace 0 0 1 1

        --- [_NSTaggedPointerColor] .blue
        +++ [NSColorSpaceColor] #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        –sRGB IEC61966-2.1 colorspace 0 0 1 1
        +sRGB IEC61966-2.1 colorspace 0.807843 0.027451 0.333333 1

        [NSColorSpaceColor] #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        => sRGB IEC61966-2.1 colorspace 0.807843 0.027451 0.333333 1
        [_NSTaggedPointerColor] .blue
        => sRGB IEC61966-2.1 colorspace 0 0 1 1
        [Bool] #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1) == .blue
        => false
        [_NSTaggedPointerColor] .blue
        => sRGB IEC61966-2.1 colorspace 0 0 1 1
        [NSColorSpaceColor] #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        => sRGB IEC61966-2.1 colorspace 0.807843 0.027451 0.333333 1
        [Bool] .blue == #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        => false

        #assert(#colorLiteral(red: 0.0, green: 0.0, blue: 1.0, alpha: 1) != .blue && .blue != #colorLiteral(red: 0.0, green: 0.0, blue: 1.0, alpha: 1))
                │                  │           │          │           │  │   │    │                              │           │          │           │
                │                  0.0         0.0        1.0         1  │   │    false                          0.0         0.0        1.0         1
                sRGB IEC61966-2.1 colorspace 0 0 1 1                     │   sRGB IEC61966-2.1 colorspace 0 0 1 1
                                                                         false

        [_NSTaggedPointerColor] #colorLiteral(red: 0.0, green: 0.0, blue: 1.0, alpha: 1)
        => sRGB IEC61966-2.1 colorspace 0 0 1 1
        [_NSTaggedPointerColor] .blue
        => sRGB IEC61966-2.1 colorspace 0 0 1 1
        [Bool] #colorLiteral(red: 0.0, green: 0.0, blue: 1.0, alpha: 1) != .blue
        => false
        [Not Evaluated] .blue
        [Not Evaluated] #colorLiteral(red: 0.0, green: 0.0, blue: 1.0, alpha: 1)
        [Not Evaluated] .blue != #colorLiteral(red: 0.0, green: 0.0, blue: 1.0, alpha: 1)

        #assert(#colorLiteral(red: 0.0, green: 0.0, blue: 1.0, alpha: 1) != .blue || .blue != #colorLiteral(red: 0.0, green: 0.0, blue: 1.0, alpha: 1))
                │                  │           │          │           │  │   │    │   │    │  │                  │           │          │           │
                │                  0.0         0.0        1.0         1  │   │    │   │    │  │                  0.0         0.0        1.0         1
                sRGB IEC61966-2.1 colorspace 0 0 1 1                     │   │    │   │    │  sRGB IEC61966-2.1 colorspace 0 0 1 1
                                                                         │   │    │   │    false
                                                                         │   │    │   sRGB IEC61966-2.1 colorspace 0 0 1 1
                                                                         │   │    false
                                                                         │   sRGB IEC61966-2.1 colorspace 0 0 1 1
                                                                         false

        [_NSTaggedPointerColor] #colorLiteral(red: 0.0, green: 0.0, blue: 1.0, alpha: 1)
        => sRGB IEC61966-2.1 colorspace 0 0 1 1
        [_NSTaggedPointerColor] .blue
        => sRGB IEC61966-2.1 colorspace 0 0 1 1
        [Bool] #colorLiteral(red: 0.0, green: 0.0, blue: 1.0, alpha: 1) != .blue
        => false
        [_NSTaggedPointerColor] .blue
        => sRGB IEC61966-2.1 colorspace 0 0 1 1
        [_NSTaggedPointerColor] #colorLiteral(red: 0.0, green: 0.0, blue: 1.0, alpha: 1)
        => sRGB IEC61966-2.1 colorspace 0 0 1 1
        [Bool] .blue != #colorLiteral(red: 0.0, green: 0.0, blue: 1.0, alpha: 1)
        => false


        """
      )
    }
  }

  func testSelfExpression() {
    captureConsoleOutput {
      #assert(self.stringValue == "string" && self.intValue == 100 && self.doubleValue == 0.1)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #assert(self.stringValue == "string" && self.intValue == 100 && self.doubleValue == 0.1)
                │    │           │  │        │  │    │        │  │   │  │    │           │  │
                │    "string"    │  "string" │  │    100      │  100 │  │    999.9       │  0.1
                │                true        │  │             true   │  │                false
                │                            │  │                    │  -[AssertTests testSelfExpression]
                │                            │  │                    false
                │                            │  -[AssertTests testSelfExpression]
                │                            true
                -[AssertTests testSelfExpression]

        --- [Double] self.doubleValue
        +++ [Double] 0.1
        –999.9
        +0.1

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
        [Double] 0.1
        => 0.1
        [Bool] self.doubleValue == 0.1
        => false


        """
      )
    }
  }

  func testSuperExpression() {
    captureConsoleOutput {
      #assert(super.continueAfterFailure == false)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #assert(super.continueAfterFailure == false)
                │     │                    │  │
                │     true                 │  false
                │                          false
                -[AssertTests testSuperExpression]

        --- [Bool] super.continueAfterFailure
        +++ [Bool] false
        –true
        +false

        [Bool] super.continueAfterFailure
        => true
        [Bool] false
        => false


        """
      )
    }
  }

  func testImplicitMemberExpression1() {
    captureConsoleOutput {
      #assert(.false)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #assert(.false)
                 │
                 false


        """
      )
    }
  }

  func testImplicitMemberExpression2() {
    captureConsoleOutput {
      let i = 16
      #assert(i == .bitWidth && i == Double.Exponent.bitWidth)

      let mask: CAAutoresizingMask = [.layerMaxXMargin, .layerMaxYMargin]
      #assert(mask != [CAAutoresizingMask.layerMaxXMargin, CAAutoresizingMask.layerMaxYMargin])
      #assert(mask != [CAAutoresizingMask.layerMaxXMargin, .layerMaxYMargin])
      #assert(mask != [.layerMaxXMargin, CAAutoresizingMask.layerMaxYMargin])
      #assert(mask != [.layerMaxXMargin, .layerMaxYMargin])
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #assert(i == .bitWidth && i == Double.Exponent.bitWidth)
                │ │   │        │
                │ │   64       false
                │ false
                16

        --- [Int] i
        +++ [Int] .bitWidth
        –16
        +64

        [Int] i
        => 16
        [Int] .bitWidth
        => 64
        [Bool] i == .bitWidth
        => false
        [Not Evaluated] i
        [Not Evaluated] Double.Exponent.bitWidth
        [Not Evaluated] i == Double.Exponent.bitWidth

        #assert(mask != [CAAutoresizingMask.layerMaxXMargin, CAAutoresizingMask.layerMaxYMargin])
                │    │  ││                  │                │                  │
                │    │  │CAAutoresizingMask │                CAAutoresizingMask CAAutoresizingMask(rawValue: 32)
                │    │  │                   CAAutoresizingMask(rawValue: 4)
                │    │  CAAutoresizingMask(rawValue: 36)
                │    false
                CAAutoresizingMask(rawValue: 36)

        [CAAutoresizingMask] mask
        => CAAutoresizingMask(rawValue: 36)
        [CAAutoresizingMask] [CAAutoresizingMask.layerMaxXMargin, CAAutoresizingMask.layerMaxYMargin]
        => CAAutoresizingMask(rawValue: 36)

        #assert(mask != [CAAutoresizingMask.layerMaxXMargin, .layerMaxYMargin])
                │    │  ││                  │                 │
                │    │  │CAAutoresizingMask │                 CAAutoresizingMask(rawValue: 32)
                │    │  │                   CAAutoresizingMask(rawValue: 4)
                │    │  CAAutoresizingMask(rawValue: 36)
                │    false
                CAAutoresizingMask(rawValue: 36)

        [CAAutoresizingMask] mask
        => CAAutoresizingMask(rawValue: 36)
        [CAAutoresizingMask] [CAAutoresizingMask.layerMaxXMargin, .layerMaxYMargin]
        => CAAutoresizingMask(rawValue: 36)

        #assert(mask != [.layerMaxXMargin, CAAutoresizingMask.layerMaxYMargin])
                │    │  │ │                │                  │
                │    │  │ │                CAAutoresizingMask CAAutoresizingMask(rawValue: 32)
                │    │  │ CAAutoresizingMask(rawValue: 4)
                │    │  CAAutoresizingMask(rawValue: 36)
                │    false
                CAAutoresizingMask(rawValue: 36)

        [CAAutoresizingMask] mask
        => CAAutoresizingMask(rawValue: 36)
        [CAAutoresizingMask] [.layerMaxXMargin, CAAutoresizingMask.layerMaxYMargin]
        => CAAutoresizingMask(rawValue: 36)

        #assert(mask != [.layerMaxXMargin, .layerMaxYMargin])
                │    │  │ │                 │
                │    │  │ │                 CAAutoresizingMask(rawValue: 32)
                │    │  │ CAAutoresizingMask(rawValue: 4)
                │    │  CAAutoresizingMask(rawValue: 36)
                │    false
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

      #assert(tuple == (name: "Katsumi", age: 37, birthday: date2))
      #assert(tuple == ("Katsumi", 37, date2))
      #assert(tuple.name != ("Katsumi", 37, date2).0 || tuple.age != ("Katsumi", 37, date2).1)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #assert(tuple == (name: "Katsumi", age: 37, birthday: date2))
                │     │  │      │               │             │
                │     │  │      "Katsumi"       37            2000-12-30 15:00:00 +0000
                │     │  ("Katsumi", 37, 2000-12-30 15:00:00 +0000)
                │     false
                ("Katsumi", 37, 1980-10-27 15:00:00 +0000)

        --- [(String, Int, Date)] tuple
        +++ [(String, Int, Date)] (name: "Katsumi", age: 37, birthday: date2)
        –("Katsumi", 37, 1980-10-27 15:00:00 +0000)
        +("Katsumi", 37, 2000-12-30 15:00:00 +0000)

        [(String, Int, Date)] tuple
        => ("Katsumi", 37, 1980-10-27 15:00:00 +0000)
        [(String, Int, Date)] (name: "Katsumi", age: 37, birthday: date2)
        => ("Katsumi", 37, 2000-12-30 15:00:00 +0000)

        #assert(tuple == ("Katsumi", 37, date2))
                │     │  ││          │   │
                │     │  │"Katsumi"  37  2000-12-30 15:00:00 +0000
                │     │  ("Katsumi", 37, 2000-12-30 15:00:00 +0000)
                │     false
                ("Katsumi", 37, 1980-10-27 15:00:00 +0000)

        --- [(String, Int, Date)] tuple
        +++ [(String, Int, Date)] ("Katsumi", 37, date2)
        –("Katsumi", 37, 1980-10-27 15:00:00 +0000)
        +("Katsumi", 37, 2000-12-30 15:00:00 +0000)

        [(String, Int, Date)] tuple
        => ("Katsumi", 37, 1980-10-27 15:00:00 +0000)
        [(String, Int, Date)] ("Katsumi", 37, date2)
        => ("Katsumi", 37, 2000-12-30 15:00:00 +0000)

        #assert(tuple.name != ("Katsumi", 37, date2).0 || tuple.age != ("Katsumi", 37, date2).1)
                │     │    │  ││          │   │      │ │  │     │   │  ││          │   │      │
                │     │    │  │"Katsumi"  37  │      │ │  │     37  │  │"Katsumi"  37  │      37
                │     │    │  │               │      │ │  │         │  │               2000-12-30 15:00:00 +0000
                │     │    │  │               │      │ │  │         │  ("Katsumi", 37, 2000-12-30 15:00:00 +0000)
                │     │    │  │               │      │ │  │         false
                │     │    │  │               │      │ │  (name: "Katsumi", age: 37, birthday: 1980-10-27 15:00:00 +0000)
                │     │    │  │               │      │ false
                │     │    │  │               │      "Katsumi"
                │     │    │  │               2000-12-30 15:00:00 +0000
                │     │    │  ("Katsumi", 37, 2000-12-30 15:00:00 +0000)
                │     │    false
                │     "Katsumi"
                (name: "Katsumi", age: 37, birthday: 1980-10-27 15:00:00 +0000)

        [String] tuple.name
        => "Katsumi"
        [String] ("Katsumi", 37, date2).0
        => "Katsumi"
        [Bool] tuple.name != ("Katsumi", 37, date2).0
        => false
        [Int] tuple.age
        => 37
        [Int] ("Katsumi", 37, date2).1
        => 37
        [Bool] tuple.age != ("Katsumi", 37, date2).1
        => false


        """
      )
    }
  }

  func testKeyPathExpression() {
    captureConsoleOutput {
      let s = SomeStructure(someValue: 12)
      let pathToProperty = \SomeStructure.someValue

      #assert(s[keyPath: pathToProperty] == 13)
      #assert(s[keyPath: \SomeStructure.someValue] == 13)
      #assert(s.getValue(keyPath: \.someValue) == 13)

      let nested = OuterStructure(someValue: 24)
      let nestedKeyPath = \OuterStructure.outer.someValue

      #assert(nested[keyPath: nestedKeyPath] == 13)
      #assert(nested[keyPath: \OuterStructure.outer.someValue] == 13)
      #assert(nested.getValue(keyPath: \.outer.someValue) == 13)
    } completion: { (output) in
      print(output)
      XCTAssertTrue(
        output ==
          #"""
          #assert(s[keyPath: pathToProperty] == 13)
                  │          │             │ │  │
                  │          │             │ │  13
                  │          │             │ false
                  │          │             12
                  │          \SomeStructure.someValue
                  SomeStructure(someValue: 12)

          --- [Int] s[keyPath: pathToProperty]
          +++ [Int] 13
          –12
          +13

          [Int] s[keyPath: pathToProperty]
          => 12
          [Int] 13
          => 13

          #assert(s[keyPath: \SomeStructure.someValue] == 13)
                  │          │                       │ │  │
                  │          │                       │ │  13
                  │          │                       │ false
                  │          │                       12
                  │          \SomeStructure.someValue
                  SomeStructure(someValue: 12)

          --- [Int] s[keyPath: \SomeStructure.someValue]
          +++ [Int] 13
          –12
          +13

          [Int] s[keyPath: \SomeStructure.someValue]
          => 12
          [Int] 13
          => 13

          #assert(s.getValue(keyPath: \.someValue) == 13)
                  │ │                 │            │  │
                  │ 12                │            │  13
                  │                   │            false
                  │                   \SomeStructure.someValue
                  SomeStructure(someValue: 12)

          --- [Int] s.getValue(keyPath: \.someValue)
          +++ [Int] 13
          –12
          +13

          [Int] s.getValue(keyPath: \.someValue)
          => 12
          [Int] 13
          => 13

          #assert(nested[keyPath: nestedKeyPath] == 13)
                  │               │            │ │  │
                  │               │            │ │  13
                  │               │            │ false
                  │               │            24
                  │               \OuterStructure.outer.someValue
                  OuterStructure(outer: PowerAssertTests.SomeStructure(someValue: 24))

          --- [Int] nested[keyPath: nestedKeyPath]
          +++ [Int] 13
          –24
          +13

          [Int] nested[keyPath: nestedKeyPath]
          => 24
          [Int] 13
          => 13

          #assert(nested[keyPath: \OuterStructure.outer.someValue] == 13)
                  │               │                              │ │  │
                  │               │                              │ │  13
                  │               │                              │ false
                  │               │                              24
                  │               \OuterStructure.outer.someValue
                  OuterStructure(outer: PowerAssertTests.SomeStructure(someValue: 24))

          --- [Int] nested[keyPath: \OuterStructure.outer.someValue]
          +++ [Int] 13
          –24
          +13

          [Int] nested[keyPath: \OuterStructure.outer.someValue]
          => 24
          [Int] 13
          => 13

          #assert(nested.getValue(keyPath: \.outer.someValue) == 13)
                  │      │                 │                  │  │
                  │      24                │                  │  13
                  │                        │                  false
                  │                        \OuterStructure.outer.someValue
                  OuterStructure(outer: PowerAssertTests.SomeStructure(someValue: 24))

          --- [Int] nested.getValue(keyPath: \.outer.someValue)
          +++ [Int] 13
          –24
          +13

          [Int] nested.getValue(keyPath: \.outer.someValue)
          => 24
          [Int] 13
          => 13


          """#
        ||
        output ==
          #"""
          #assert(s[keyPath: pathToProperty] == 13)
                  │          │             │ │  │
                  │          │             │ │  13
                  │          │             │ false
                  │          │             12
                  │          Swift.WritableKeyPath<PowerAssertTests.SomeStructure, Swift.Int>
                  SomeStructure(someValue: 12)

          --- [Int] s[keyPath: pathToProperty]
          +++ [Int] 13
          –12
          +13

          [Int] s[keyPath: pathToProperty]
          => 12
          [Int] 13
          => 13

          #assert(s[keyPath: \SomeStructure.someValue] == 13)
                  │          │                       │ │  │
                  │          │                       │ │  13
                  │          │                       │ false
                  │          │                       12
                  │          Swift.WritableKeyPath<PowerAssertTests.SomeStructure, Swift.Int>
                  SomeStructure(someValue: 12)

          --- [Int] s[keyPath: \SomeStructure.someValue]
          +++ [Int] 13
          –12
          +13

          [Int] s[keyPath: \SomeStructure.someValue]
          => 12
          [Int] 13
          => 13

          #assert(s.getValue(keyPath: \.someValue) == 13)
                  │ │                 │            │  │
                  │ 12                │            │  13
                  │                   │            false
                  │                   Swift.WritableKeyPath<PowerAssertTests.SomeStructure, Swift.Int>
                  SomeStructure(someValue: 12)

          --- [Int] s.getValue(keyPath: \.someValue)
          +++ [Int] 13
          –12
          +13

          [Int] s.getValue(keyPath: \.someValue)
          => 12
          [Int] 13
          => 13

          #assert(nested[keyPath: nestedKeyPath] == 13)
                  │               │            │ │  │
                  │               │            │ │  13
                  │               │            │ false
                  │               │            24
                  │               Swift.WritableKeyPath<PowerAssertTests.OuterStructure, Swift.Int>
                  OuterStructure(outer: PowerAssertTests.SomeStructure(someValue: 24))

          --- [Int] nested[keyPath: nestedKeyPath]
          +++ [Int] 13
          –24
          +13

          [Int] nested[keyPath: nestedKeyPath]
          => 24
          [Int] 13
          => 13

          #assert(nested[keyPath: \OuterStructure.outer.someValue] == 13)
                  │               │                              │ │  │
                  │               │                              │ │  13
                  │               │                              │ false
                  │               │                              24
                  │               Swift.WritableKeyPath<PowerAssertTests.OuterStructure, Swift.Int>
                  OuterStructure(outer: PowerAssertTests.SomeStructure(someValue: 24))

          --- [Int] nested[keyPath: \OuterStructure.outer.someValue]
          +++ [Int] 13
          –24
          +13

          [Int] nested[keyPath: \OuterStructure.outer.someValue]
          => 24
          [Int] 13
          => 13

          #assert(nested.getValue(keyPath: \.outer.someValue) == 13)
                  │      │                 │                  │  │
                  │      24                │                  │  13
                  │                        │                  false
                  │                        Swift.WritableKeyPath<PowerAssertTests.OuterStructure, Swift.Int>
                  OuterStructure(outer: PowerAssertTests.SomeStructure(someValue: 24))

          --- [Int] nested.getValue(keyPath: \.outer.someValue)
          +++ [Int] 13
          –24
          +13
          
          [Int] nested.getValue(keyPath: \.outer.someValue)
          => 24
          [Int] 13
          => 13


          """#
      )
    }
  }

  func testSubscriptKeyPathExpression1() {
    captureConsoleOutput {
      let greetings = ["hello", "hola", "bonjour", "안녕"]

      #assert(greetings[keyPath: \[String].[1]] == "hello")
      #assert(greetings[keyPath: \[String].first?.count] == 4)
    } completion: { (output) in
      print(output)
      XCTAssertTrue(
        output ==
        #"""
        #assert(greetings[keyPath: \[String].[1]] == "hello")
                │                  │          │ │ │  │
                │                  │          1 │ │  "hello"
                │                  │            │ false
                │                  │            "hola"
                │                  Swift.WritableKeyPath<Swift.Array<Swift.String>, Swift.String>
                ["hello", "hola", "bonjour", "안녕"]

        --- [String] greetings[keyPath: \[String].[1]]
        +++ [String] "hello"
        h[-o-]{+e+}l[-a-]{+lo+}

        [String] greetings[keyPath: \[String].[1]]
        => "hola"
        [String] "hello"
        => "hello"

        #assert(greetings[keyPath: \[String].first?.count] == 4)
                │                  │                     │ │  │
                │                  │                     │ │  4
                │                  │                     │ false
                │                  │                     Optional(5)
                │                  Swift.KeyPath<Swift.Array<Swift.String>, Swift.Optional<Swift.Int>>
                ["hello", "hola", "bonjour", "안녕"]

        --- [Optional<Int>] greetings[keyPath: \[String].first?.count]
        +++ [Int] 4
        –Optional(5)
        +4

        [Optional<Int>] greetings[keyPath: \[String].first?.count]
        => Optional(5)
        [Int] 4
        => 4


        """#
        ||
        output.replacingOccurrences(
          of: "0x[:xdigit:]{16}",
          with: "0x0000000000000000",
          options: .regularExpression
        ) ==
        #"""
        #assert(greetings[keyPath: \[String].[1]] == "hello")
                │                  │          │ │ │  │
                │                  │          1 │ │  "hello"
                │                  │            │ false
                │                  │            "hola"
                │                  \Array<String>.<computed 0x0000000000000000 (String)>
                ["hello", "hola", "bonjour", "안녕"]

        --- [String] greetings[keyPath: \[String].[1]]
        +++ [String] "hello"
        h[-o-]{+e+}l[-a-]{+lo+}

        [String] greetings[keyPath: \[String].[1]]
        => "hola"
        [String] "hello"
        => "hello"

        #assert(greetings[keyPath: \[String].first?.count] == 4)
                │                  │                     │ │  │
                │                  │                     │ │  4
                │                  │                     │ false
                │                  │                     Optional(5)
                │                  \Array<String>.first?.count?
                ["hello", "hola", "bonjour", "안녕"]

        --- [Optional<Int>] greetings[keyPath: \[String].first?.count]
        +++ [Int] 4
        –Optional(5)
        +4

        [Optional<Int>] greetings[keyPath: \[String].first?.count]
        => Optional(5)
        [Int] 4
        => 4


        """#
      )
    }
  }

  func testSubscriptKeyPathExpression2() {
    captureConsoleOutput {
      let interestingNumbers = [
        "prime": [2, 3, 5, 7, 11, 13, 17],
        "triangular": [1, 3, 6, 10, 15, 21, 28],
        "hexagonal": [1, 6, 15, 28, 45, 66, 91]
      ]
      #assert(
        interestingNumbers[keyPath: \[String: [Int]].["prime"]]! == [2, 3, 5, 7, 11, 13, 17, 19]
      )
    } completion: { (output) in
      print(output)
      // Dictionary order is not guaranteed
      XCTAssertTrue(
        output ==
          #"""
          #assert(interestingNumbers[keyPath: \[String: [Int]].["prime"]]! == [2, 3, 5, 7, 11, 13, 17, 19])
                  ││                          │                 │       │  │  ││  │  │  │  │   │   │   │
                  │[2, 3, 5, 7, 11, 13, 17]   │                 "prime" │  │  │2  3  5  7  11  13  17  19
                  │                           │                         │  │  [2, 3, 5, 7, 11, 13, 17, 19]
                  │                           │                         │  false
                  │                           │                         Optional([2, 3, 5, 7, 11, 13, 17])
                  │                           Swift.WritableKeyPath<Swift.Dictionary<Swift.String, Swift.Array<Swift.Int>>, Swift.Optional<Swift.Array<Swift.Int>>>
                  ["prime": [2, 3, 5, 7, 11, 13, 17], "hexagonal": [1, 6, 15, 28, 45, 66, 91], "triangular": [1, 3, 6, 10, 15, 21, 28]]

          --- [Array<Int>] interestingNumbers[keyPath: \[String: [Int]].["prime"]]!
          +++ [Array<Int>] [2, 3, 5, 7, 11, 13, 17, 19]
          –[2, 3, 5, 7, 11, 13, 17]
          +[2, 3, 5, 7, 11, 13, 17, 19]

          [Array<Int>] interestingNumbers[keyPath: \[String: [Int]].["prime"]]!
          => [2, 3, 5, 7, 11, 13, 17]
          [Array<Int>] [2, 3, 5, 7, 11, 13, 17, 19]
          => [2, 3, 5, 7, 11, 13, 17, 19]


          """#
        ||
        output ==
          #"""
          #assert(interestingNumbers[keyPath: \[String: [Int]].["prime"]]! == [2, 3, 5, 7, 11, 13, 17, 19])
                  ││                          │                 │       │  │  ││  │  │  │  │   │   │   │
                  │[2, 3, 5, 7, 11, 13, 17]   │                 "prime" │  │  │2  3  5  7  11  13  17  19
                  │                           │                         │  │  [2, 3, 5, 7, 11, 13, 17, 19]
                  │                           │                         │  false
                  │                           │                         Optional([2, 3, 5, 7, 11, 13, 17])
                  │                           Swift.WritableKeyPath<Swift.Dictionary<Swift.String, Swift.Array<Swift.Int>>, Swift.Optional<Swift.Array<Swift.Int>>>
                  ["prime": [2, 3, 5, 7, 11, 13, 17], "triangular": [1, 3, 6, 10, 15, 21, 28], "hexagonal": [1, 6, 15, 28, 45, 66, 91]]

          --- [Array<Int>] interestingNumbers[keyPath: \[String: [Int]].["prime"]]!
          +++ [Array<Int>] [2, 3, 5, 7, 11, 13, 17, 19]
          –[2, 3, 5, 7, 11, 13, 17]
          +[2, 3, 5, 7, 11, 13, 17, 19]

          [Array<Int>] interestingNumbers[keyPath: \[String: [Int]].["prime"]]!
          => [2, 3, 5, 7, 11, 13, 17]
          [Array<Int>] [2, 3, 5, 7, 11, 13, 17, 19]
          => [2, 3, 5, 7, 11, 13, 17, 19]


          """#
        ||
        output ==
          #"""
          #assert(interestingNumbers[keyPath: \[String: [Int]].["prime"]]! == [2, 3, 5, 7, 11, 13, 17, 19])
                  ││                          │                 │       │  │  ││  │  │  │  │   │   │   │
                  │[2, 3, 5, 7, 11, 13, 17]   │                 "prime" │  │  │2  3  5  7  11  13  17  19
                  │                           │                         │  │  [2, 3, 5, 7, 11, 13, 17, 19]
                  │                           │                         │  false
                  │                           │                         Optional([2, 3, 5, 7, 11, 13, 17])
                  │                           Swift.WritableKeyPath<Swift.Dictionary<Swift.String, Swift.Array<Swift.Int>>, Swift.Optional<Swift.Array<Swift.Int>>>
                  ["hexagonal": [1, 6, 15, 28, 45, 66, 91], "prime": [2, 3, 5, 7, 11, 13, 17], "triangular": [1, 3, 6, 10, 15, 21, 28]]

          --- [Array<Int>] interestingNumbers[keyPath: \[String: [Int]].["prime"]]!
          +++ [Array<Int>] [2, 3, 5, 7, 11, 13, 17, 19]
          –[2, 3, 5, 7, 11, 13, 17]
          +[2, 3, 5, 7, 11, 13, 17, 19]

          [Array<Int>] interestingNumbers[keyPath: \[String: [Int]].["prime"]]!
          => [2, 3, 5, 7, 11, 13, 17]
          [Array<Int>] [2, 3, 5, 7, 11, 13, 17, 19]
          => [2, 3, 5, 7, 11, 13, 17, 19]


          """#
        ||
        output ==
          #"""
          #assert(interestingNumbers[keyPath: \[String: [Int]].["prime"]]! == [2, 3, 5, 7, 11, 13, 17, 19])
                  ││                          │                 │       │  │  ││  │  │  │  │   │   │   │
                  │[2, 3, 5, 7, 11, 13, 17]   │                 "prime" │  │  │2  3  5  7  11  13  17  19
                  │                           │                         │  │  [2, 3, 5, 7, 11, 13, 17, 19]
                  │                           │                         │  false
                  │                           │                         Optional([2, 3, 5, 7, 11, 13, 17])
                  │                           Swift.WritableKeyPath<Swift.Dictionary<Swift.String, Swift.Array<Swift.Int>>, Swift.Optional<Swift.Array<Swift.Int>>>
                  ["hexagonal": [1, 6, 15, 28, 45, 66, 91], "triangular": [1, 3, 6, 10, 15, 21, 28], "prime": [2, 3, 5, 7, 11, 13, 17]]

          --- [Array<Int>] interestingNumbers[keyPath: \[String: [Int]].["prime"]]!
          +++ [Array<Int>] [2, 3, 5, 7, 11, 13, 17, 19]
          –[2, 3, 5, 7, 11, 13, 17]
          +[2, 3, 5, 7, 11, 13, 17, 19]

          [Array<Int>] interestingNumbers[keyPath: \[String: [Int]].["prime"]]!
          => [2, 3, 5, 7, 11, 13, 17]
          [Array<Int>] [2, 3, 5, 7, 11, 13, 17, 19]
          => [2, 3, 5, 7, 11, 13, 17, 19]


          """#
        ||
        output ==
          #"""
          #assert(interestingNumbers[keyPath: \[String: [Int]].["prime"]]! == [2, 3, 5, 7, 11, 13, 17, 19])
                  ││                          │                 │       │  │  ││  │  │  │  │   │   │   │
                  │[2, 3, 5, 7, 11, 13, 17]   │                 "prime" │  │  │2  3  5  7  11  13  17  19
                  │                           │                         │  │  [2, 3, 5, 7, 11, 13, 17, 19]
                  │                           │                         │  false
                  │                           │                         Optional([2, 3, 5, 7, 11, 13, 17])
                  │                           Swift.WritableKeyPath<Swift.Dictionary<Swift.String, Swift.Array<Swift.Int>>, Swift.Optional<Swift.Array<Swift.Int>>>
                  ["triangular": [1, 3, 6, 10, 15, 21, 28], "prime": [2, 3, 5, 7, 11, 13, 17], "hexagonal": [1, 6, 15, 28, 45, 66, 91]]

          --- [Array<Int>] interestingNumbers[keyPath: \[String: [Int]].["prime"]]!
          +++ [Array<Int>] [2, 3, 5, 7, 11, 13, 17, 19]
          –[2, 3, 5, 7, 11, 13, 17]
          +[2, 3, 5, 7, 11, 13, 17, 19]

          [Array<Int>] interestingNumbers[keyPath: \[String: [Int]].["prime"]]!
          => [2, 3, 5, 7, 11, 13, 17]
          [Array<Int>] [2, 3, 5, 7, 11, 13, 17, 19]
          => [2, 3, 5, 7, 11, 13, 17, 19]


          """#
        ||
        output ==
          #"""
          #assert(interestingNumbers[keyPath: \[String: [Int]].["prime"]]! == [2, 3, 5, 7, 11, 13, 17, 19])
                  ││                          │                 │       │  │  ││  │  │  │  │   │   │   │
                  │[2, 3, 5, 7, 11, 13, 17]   │                 "prime" │  │  │2  3  5  7  11  13  17  19
                  │                           │                         │  │  [2, 3, 5, 7, 11, 13, 17, 19]
                  │                           │                         │  false
                  │                           │                         Optional([2, 3, 5, 7, 11, 13, 17])
                  │                           Swift.WritableKeyPath<Swift.Dictionary<Swift.String, Swift.Array<Swift.Int>>, Swift.Optional<Swift.Array<Swift.Int>>>
                  ["triangular": [1, 3, 6, 10, 15, 21, 28], "hexagonal": [1, 6, 15, 28, 45, 66, 91], "prime": [2, 3, 5, 7, 11, 13, 17]]

          --- [Array<Int>] interestingNumbers[keyPath: \[String: [Int]].["prime"]]!
          +++ [Array<Int>] [2, 3, 5, 7, 11, 13, 17, 19]
          –[2, 3, 5, 7, 11, 13, 17]
          +[2, 3, 5, 7, 11, 13, 17, 19]

          [Array<Int>] interestingNumbers[keyPath: \[String: [Int]].["prime"]]!
          => [2, 3, 5, 7, 11, 13, 17]
          [Array<Int>] [2, 3, 5, 7, 11, 13, 17, 19]
          => [2, 3, 5, 7, 11, 13, 17, 19]


          """#
        ||
        output.replacingOccurrences(
          of: "0x[:xdigit:]{16}",
          with: "0x0000000000000000",
          options: .regularExpression
        ) ==
          #"""
          #assert(interestingNumbers[keyPath: \[String: [Int]].["prime"]]! == [2, 3, 5, 7, 11, 13, 17, 19])
                  ││                          │                 │       │  │  ││  │  │  │  │   │   │   │
                  │[2, 3, 5, 7, 11, 13, 17]   │                 "prime" │  │  │2  3  5  7  11  13  17  19
                  │                           │                         │  │  [2, 3, 5, 7, 11, 13, 17, 19]
                  │                           │                         │  false
                  │                           │                         Optional([2, 3, 5, 7, 11, 13, 17])
                  │                           \Dictionary<String, Array<Int>>.<computed 0x0000000000000000 (Optional<Array<Int>>)>
                  ["prime": [2, 3, 5, 7, 11, 13, 17], "hexagonal": [1, 6, 15, 28, 45, 66, 91], "triangular": [1, 3, 6, 10, 15, 21, 28]]

          --- [Array<Int>] interestingNumbers[keyPath: \[String: [Int]].["prime"]]!
          +++ [Array<Int>] [2, 3, 5, 7, 11, 13, 17, 19]
          –[2, 3, 5, 7, 11, 13, 17]
          +[2, 3, 5, 7, 11, 13, 17, 19]

          [Array<Int>] interestingNumbers[keyPath: \[String: [Int]].["prime"]]!
          => [2, 3, 5, 7, 11, 13, 17]
          [Array<Int>] [2, 3, 5, 7, 11, 13, 17, 19]
          => [2, 3, 5, 7, 11, 13, 17, 19]


          """#
        ||
        output.replacingOccurrences(
          of: "0x[:xdigit:]{16}",
          with: "0x0000000000000000",
          options: .regularExpression
        ) ==
          #"""
          #assert(interestingNumbers[keyPath: \[String: [Int]].["prime"]]! == [2, 3, 5, 7, 11, 13, 17, 19])
                  ││                          │                 │       │  │  ││  │  │  │  │   │   │   │
                  │[2, 3, 5, 7, 11, 13, 17]   │                 "prime" │  │  │2  3  5  7  11  13  17  19
                  │                           │                         │  │  [2, 3, 5, 7, 11, 13, 17, 19]
                  │                           │                         │  false
                  │                           │                         Optional([2, 3, 5, 7, 11, 13, 17])
                  │                           \Dictionary<String, Array<Int>>.<computed 0x0000000000000000 (Optional<Array<Int>>)>
                  ["prime": [2, 3, 5, 7, 11, 13, 17], "triangular": [1, 3, 6, 10, 15, 21, 28], "hexagonal": [1, 6, 15, 28, 45, 66, 91]]

          --- [Array<Int>] interestingNumbers[keyPath: \[String: [Int]].["prime"]]!
          +++ [Array<Int>] [2, 3, 5, 7, 11, 13, 17, 19]
          –[2, 3, 5, 7, 11, 13, 17]
          +[2, 3, 5, 7, 11, 13, 17, 19]

          [Array<Int>] interestingNumbers[keyPath: \[String: [Int]].["prime"]]!
          => [2, 3, 5, 7, 11, 13, 17]
          [Array<Int>] [2, 3, 5, 7, 11, 13, 17, 19]
          => [2, 3, 5, 7, 11, 13, 17, 19]


          """#
        ||
        output.replacingOccurrences(
          of: "0x[:xdigit:]{16}",
          with: "0x0000000000000000",
          options: .regularExpression
        ) ==
          #"""
          #assert(interestingNumbers[keyPath: \[String: [Int]].["prime"]]! == [2, 3, 5, 7, 11, 13, 17, 19])
                  ││                          │                 │       │  │  ││  │  │  │  │   │   │   │
                  │[2, 3, 5, 7, 11, 13, 17]   │                 "prime" │  │  │2  3  5  7  11  13  17  19
                  │                           │                         │  │  [2, 3, 5, 7, 11, 13, 17, 19]
                  │                           │                         │  false
                  │                           │                         Optional([2, 3, 5, 7, 11, 13, 17])
                  │                           \Dictionary<String, Array<Int>>.<computed 0x0000000000000000 (Optional<Array<Int>>)>
                  ["hexagonal": [1, 6, 15, 28, 45, 66, 91], "prime": [2, 3, 5, 7, 11, 13, 17], "triangular": [1, 3, 6, 10, 15, 21, 28]]

          --- [Array<Int>] interestingNumbers[keyPath: \[String: [Int]].["prime"]]!
          +++ [Array<Int>] [2, 3, 5, 7, 11, 13, 17, 19]
          –[2, 3, 5, 7, 11, 13, 17]
          +[2, 3, 5, 7, 11, 13, 17, 19]

          [Array<Int>] interestingNumbers[keyPath: \[String: [Int]].["prime"]]!
          => [2, 3, 5, 7, 11, 13, 17]
          [Array<Int>] [2, 3, 5, 7, 11, 13, 17, 19]
          => [2, 3, 5, 7, 11, 13, 17, 19]


          """#
        ||
        output.replacingOccurrences(
          of: "0x[:xdigit:]{16}",
          with: "0x0000000000000000",
          options: .regularExpression
        ) ==
          #"""
          #assert(interestingNumbers[keyPath: \[String: [Int]].["prime"]]! == [2, 3, 5, 7, 11, 13, 17, 19])
                  ││                          │                 │       │  │  ││  │  │  │  │   │   │   │
                  │[2, 3, 5, 7, 11, 13, 17]   │                 "prime" │  │  │2  3  5  7  11  13  17  19
                  │                           │                         │  │  [2, 3, 5, 7, 11, 13, 17, 19]
                  │                           │                         │  false
                  │                           │                         Optional([2, 3, 5, 7, 11, 13, 17])
                  │                           \Dictionary<String, Array<Int>>.<computed 0x0000000000000000 (Optional<Array<Int>>)>
                  ["hexagonal": [1, 6, 15, 28, 45, 66, 91], "triangular": [1, 3, 6, 10, 15, 21, 28], "prime": [2, 3, 5, 7, 11, 13, 17]]

          --- [Array<Int>] interestingNumbers[keyPath: \[String: [Int]].["prime"]]!
          +++ [Array<Int>] [2, 3, 5, 7, 11, 13, 17, 19]
          –[2, 3, 5, 7, 11, 13, 17]
          +[2, 3, 5, 7, 11, 13, 17, 19]

          [Array<Int>] interestingNumbers[keyPath: \[String: [Int]].["prime"]]!
          => [2, 3, 5, 7, 11, 13, 17]
          [Array<Int>] [2, 3, 5, 7, 11, 13, 17, 19]
          => [2, 3, 5, 7, 11, 13, 17, 19]


          """#
        ||
        output.replacingOccurrences(
          of: "0x[:xdigit:]{16}",
          with: "0x0000000000000000",
          options: .regularExpression
        ) ==
          #"""
          #assert(interestingNumbers[keyPath: \[String: [Int]].["prime"]]! == [2, 3, 5, 7, 11, 13, 17, 19])
                  ││                          │                 │       │  │  ││  │  │  │  │   │   │   │
                  │[2, 3, 5, 7, 11, 13, 17]   │                 "prime" │  │  │2  3  5  7  11  13  17  19
                  │                           │                         │  │  [2, 3, 5, 7, 11, 13, 17, 19]
                  │                           │                         │  false
                  │                           │                         Optional([2, 3, 5, 7, 11, 13, 17])
                  │                           \Dictionary<String, Array<Int>>.<computed 0x0000000000000000 (Optional<Array<Int>>)>
                  ["triangular": [1, 3, 6, 10, 15, 21, 28], "prime": [2, 3, 5, 7, 11, 13, 17], "hexagonal": [1, 6, 15, 28, 45, 66, 91]]

          --- [Array<Int>] interestingNumbers[keyPath: \[String: [Int]].["prime"]]!
          +++ [Array<Int>] [2, 3, 5, 7, 11, 13, 17, 19]
          –[2, 3, 5, 7, 11, 13, 17]
          +[2, 3, 5, 7, 11, 13, 17, 19]

          [Array<Int>] interestingNumbers[keyPath: \[String: [Int]].["prime"]]!
          => [2, 3, 5, 7, 11, 13, 17]
          [Array<Int>] [2, 3, 5, 7, 11, 13, 17, 19]
          => [2, 3, 5, 7, 11, 13, 17, 19]


          """#
        ||
        output.replacingOccurrences(
          of: "0x[:xdigit:]{16}",
          with: "0x0000000000000000",
          options: .regularExpression
        ) ==
          #"""
          #assert(interestingNumbers[keyPath: \[String: [Int]].["prime"]]! == [2, 3, 5, 7, 11, 13, 17, 19])
                  ││                          │                 │       │  │  ││  │  │  │  │   │   │   │
                  │[2, 3, 5, 7, 11, 13, 17]   │                 "prime" │  │  │2  3  5  7  11  13  17  19
                  │                           │                         │  │  [2, 3, 5, 7, 11, 13, 17, 19]
                  │                           │                         │  false
                  │                           │                         Optional([2, 3, 5, 7, 11, 13, 17])
                  │                           \Dictionary<String, Array<Int>>.<computed 0x0000000000000000 (Optional<Array<Int>>)>
                  ["triangular": [1, 3, 6, 10, 15, 21, 28], "hexagonal": [1, 6, 15, 28, 45, 66, 91], "prime": [2, 3, 5, 7, 11, 13, 17]]

          --- [Array<Int>] interestingNumbers[keyPath: \[String: [Int]].["prime"]]!
          +++ [Array<Int>] [2, 3, 5, 7, 11, 13, 17, 19]
          –[2, 3, 5, 7, 11, 13, 17]
          +[2, 3, 5, 7, 11, 13, 17, 19]

          [Array<Int>] interestingNumbers[keyPath: \[String: [Int]].["prime"]]!
          => [2, 3, 5, 7, 11, 13, 17]
          [Array<Int>] [2, 3, 5, 7, 11, 13, 17, 19]
          => [2, 3, 5, 7, 11, 13, 17, 19]


          """#
      )
    }
  }

  func testSubscriptKeyPathExpression3() {
    captureConsoleOutput {
      let interestingNumbers = [
        "prime": [2, 3, 5, 7, 11, 13, 17],
        "triangular": [1, 3, 6, 10, 15, 21, 28],
        "hexagonal": [1, 6, 15, 28, 45, 66, 91]
      ]
      #assert(
        interestingNumbers[keyPath: \[String: [Int]].["prime"]![0]] != 2
      )
    } completion: { (output) in
      print(output)
      // Dictionary order is not guaranteed
      XCTAssertTrue(
        output ==
          #"""
          #assert(interestingNumbers[keyPath: \[String: [Int]].["prime"]![0]] != 2)
                  │                           │                 │         │ │ │  │
                  │                           │                 "prime"   0 2 │  2
                  │                           │                               false
                  │                           Swift.WritableKeyPath<Swift.Dictionary<Swift.String, Swift.Array<Swift.Int>>, Swift.Int>
                  ["prime": [2, 3, 5, 7, 11, 13, 17], "hexagonal": [1, 6, 15, 28, 45, 66, 91], "triangular": [1, 3, 6, 10, 15, 21, 28]]

          [Int] interestingNumbers[keyPath: \[String: [Int]].["prime"]![0]]
          => 2
          [Int] 2
          => 2


          """#
        ||
        output ==
          #"""
          #assert(interestingNumbers[keyPath: \[String: [Int]].["prime"]![0]] != 2)
                  │                           │                 │         │ │ │  │
                  │                           │                 "prime"   0 2 │  2
                  │                           │                               false
                  │                           Swift.WritableKeyPath<Swift.Dictionary<Swift.String, Swift.Array<Swift.Int>>, Swift.Int>
                  ["prime": [2, 3, 5, 7, 11, 13, 17], "triangular": [1, 3, 6, 10, 15, 21, 28], "hexagonal": [1, 6, 15, 28, 45, 66, 91]]

          [Int] interestingNumbers[keyPath: \[String: [Int]].["prime"]![0]]
          => 2
          [Int] 2
          => 2


          """#
        ||
        output ==
          #"""
          #assert(interestingNumbers[keyPath: \[String: [Int]].["prime"]![0]] != 2)
                  │                           │                 │         │ │ │  │
                  │                           │                 "prime"   0 2 │  2
                  │                           │                               false
                  │                           Swift.WritableKeyPath<Swift.Dictionary<Swift.String, Swift.Array<Swift.Int>>, Swift.Int>
                  ["hexagonal": [1, 6, 15, 28, 45, 66, 91], "prime": [2, 3, 5, 7, 11, 13, 17], "triangular": [1, 3, 6, 10, 15, 21, 28]]

          [Int] interestingNumbers[keyPath: \[String: [Int]].["prime"]![0]]
          => 2
          [Int] 2
          => 2


          """#
        ||
        output ==
          #"""
          #assert(interestingNumbers[keyPath: \[String: [Int]].["prime"]![0]] != 2)
                  │                           │                 │         │ │ │  │
                  │                           │                 "prime"   0 2 │  2
                  │                           │                               false
                  │                           Swift.WritableKeyPath<Swift.Dictionary<Swift.String, Swift.Array<Swift.Int>>, Swift.Int>
                  ["hexagonal": [1, 6, 15, 28, 45, 66, 91], "triangular": [1, 3, 6, 10, 15, 21, 28], "prime": [2, 3, 5, 7, 11, 13, 17]]

          [Int] interestingNumbers[keyPath: \[String: [Int]].["prime"]![0]]
          => 2
          [Int] 2
          => 2


          """#
        ||
        output ==
          #"""
          #assert(interestingNumbers[keyPath: \[String: [Int]].["prime"]![0]] != 2)
                  │                           │                 │         │ │ │  │
                  │                           │                 "prime"   0 2 │  2
                  │                           │                               false
                  │                           Swift.WritableKeyPath<Swift.Dictionary<Swift.String, Swift.Array<Swift.Int>>, Swift.Int>
                  ["triangular": [1, 3, 6, 10, 15, 21, 28], "prime": [2, 3, 5, 7, 11, 13, 17], "hexagonal": [1, 6, 15, 28, 45, 66, 91]]

          [Int] interestingNumbers[keyPath: \[String: [Int]].["prime"]![0]]
          => 2
          [Int] 2
          => 2


          """#
        ||
        output ==
          #"""
          #assert(interestingNumbers[keyPath: \[String: [Int]].["prime"]![0]] != 2)
                  │                           │                 │         │ │ │  │
                  │                           │                 "prime"   0 2 │  2
                  │                           │                               false
                  │                           Swift.WritableKeyPath<Swift.Dictionary<Swift.String, Swift.Array<Swift.Int>>, Swift.Int>
                  ["triangular": [1, 3, 6, 10, 15, 21, 28], "hexagonal": [1, 6, 15, 28, 45, 66, 91], "prime": [2, 3, 5, 7, 11, 13, 17]]

          [Int] interestingNumbers[keyPath: \[String: [Int]].["prime"]![0]]
          => 2
          [Int] 2
          => 2


          """#
        ||
        output.replacingOccurrences(
          of: "0x[:xdigit:]{16}",
          with: "0x0000000000000000",
          options: .regularExpression
        ) ==
          #"""
          #assert(interestingNumbers[keyPath: \[String: [Int]].["prime"]![0]] != 2)
                  │                           │                 │         │ │ │  │
                  │                           │                 "prime"   0 2 │  2
                  │                           │                               false
                  │                           \Dictionary<String, Array<Int>>.<computed 0x0000000000000000 (Optional<Array<Int>>)>!.<computed 0x0000000000000000 (Int)>
                  ["prime": [2, 3, 5, 7, 11, 13, 17], "hexagonal": [1, 6, 15, 28, 45, 66, 91], "triangular": [1, 3, 6, 10, 15, 21, 28]]

          [Int] interestingNumbers[keyPath: \[String: [Int]].["prime"]![0]]
          => 2
          [Int] 2
          => 2


          """#
        ||
        output.replacingOccurrences(
          of: "0x[:xdigit:]{16}",
          with: "0x0000000000000000",
          options: .regularExpression
        ) ==
          #"""
          #assert(interestingNumbers[keyPath: \[String: [Int]].["prime"]![0]] != 2)
                  │                           │                 │         │ │ │  │
                  │                           │                 "prime"   0 2 │  2
                  │                           │                               false
                  │                           \Dictionary<String, Array<Int>>.<computed 0x0000000000000000 (Optional<Array<Int>>)>!.<computed 0x0000000000000000 (Int)>
                  ["prime": [2, 3, 5, 7, 11, 13, 17], "triangular": [1, 3, 6, 10, 15, 21, 28], "hexagonal": [1, 6, 15, 28, 45, 66, 91]]

          [Int] interestingNumbers[keyPath: \[String: [Int]].["prime"]![0]]
          => 2
          [Int] 2
          => 2


          """#
        ||
        output.replacingOccurrences(
          of: "0x[:xdigit:]{16}",
          with: "0x0000000000000000",
          options: .regularExpression
        ) ==
          #"""
          #assert(interestingNumbers[keyPath: \[String: [Int]].["prime"]![0]] != 2)
                  │                           │                 │         │ │ │  │
                  │                           │                 "prime"   0 2 │  2
                  │                           │                               false
                  │                           \Dictionary<String, Array<Int>>.<computed 0x0000000000000000 (Optional<Array<Int>>)>!.<computed 0x0000000000000000 (Int)>
                  ["hexagonal": [1, 6, 15, 28, 45, 66, 91], "prime": [2, 3, 5, 7, 11, 13, 17], "triangular": [1, 3, 6, 10, 15, 21, 28]]

          [Int] interestingNumbers[keyPath: \[String: [Int]].["prime"]![0]]
          => 2
          [Int] 2
          => 2


          """#
        ||
        output.replacingOccurrences(
          of: "0x[:xdigit:]{16}",
          with: "0x0000000000000000",
          options: .regularExpression
        ) ==
          #"""
          #assert(interestingNumbers[keyPath: \[String: [Int]].["prime"]![0]] != 2)
                  │                           │                 │         │ │ │  │
                  │                           │                 "prime"   0 2 │  2
                  │                           │                               false
                  │                           \Dictionary<String, Array<Int>>.<computed 0x0000000000000000 (Optional<Array<Int>>)>!.<computed 0x0000000000000000 (Int)>
                  ["hexagonal": [1, 6, 15, 28, 45, 66, 91], "triangular": [1, 3, 6, 10, 15, 21, 28], "prime": [2, 3, 5, 7, 11, 13, 17]]

          [Int] interestingNumbers[keyPath: \[String: [Int]].["prime"]![0]]
          => 2
          [Int] 2
          => 2


          """#
        ||
        output.replacingOccurrences(
          of: "0x[:xdigit:]{16}",
          with: "0x0000000000000000",
          options: .regularExpression
        ) ==
          #"""
          #assert(interestingNumbers[keyPath: \[String: [Int]].["prime"]![0]] != 2)
                  │                           │                 │         │ │ │  │
                  │                           │                 "prime"   0 2 │  2
                  │                           │                               false
                  │                           \Dictionary<String, Array<Int>>.<computed 0x0000000000000000 (Optional<Array<Int>>)>!.<computed 0x0000000000000000 (Int)>
                  ["triangular": [1, 3, 6, 10, 15, 21, 28], "prime": [2, 3, 5, 7, 11, 13, 17], "hexagonal": [1, 6, 15, 28, 45, 66, 91]]

          [Int] interestingNumbers[keyPath: \[String: [Int]].["prime"]![0]]
          => 2
          [Int] 2
          => 2


          """#
        ||
        output.replacingOccurrences(
          of: "0x[:xdigit:]{16}",
          with: "0x0000000000000000",
          options: .regularExpression
        ) ==
          #"""
          #assert(interestingNumbers[keyPath: \[String: [Int]].["prime"]![0]] != 2)
                  │                           │                 │         │ │ │  │
                  │                           │                 "prime"   0 2 │  2
                  │                           │                               false
                  │                           \Dictionary<String, Array<Int>>.<computed 0x0000000000000000 (Optional<Array<Int>>)>!.<computed 0x0000000000000000 (Int)>
                  ["triangular": [1, 3, 6, 10, 15, 21, 28], "hexagonal": [1, 6, 15, 28, 45, 66, 91], "prime": [2, 3, 5, 7, 11, 13, 17]]

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
        "prime": [2, 3, 5, 7, 11, 13, 17],
        "triangular": [1, 3, 6, 10, 15, 21, 28],
        "hexagonal": [1, 6, 15, 28, 45, 66, 91]
      ]
      #assert(
        interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count] != 7
      )
    } completion: { (output) in
      print(output)
      // Dictionary order is not guaranteed
      XCTAssertTrue(
        output ==
          #"""
          #assert(interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count] != 7)
                  │                           │                 │                  │ │  │
                  │                           │                 "hexagonal"        7 │  7
                  │                           │                                      false
                  │                           Swift.KeyPath<Swift.Dictionary<Swift.String, Swift.Array<Swift.Int>>, Swift.Int>
                  ["prime": [2, 3, 5, 7, 11, 13, 17], "hexagonal": [1, 6, 15, 28, 45, 66, 91], "triangular": [1, 3, 6, 10, 15, 21, 28]]

          [Int] interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count]
          => 7
          [Int] 7
          => 7


          """#
        ||
        output ==
          #"""
          #assert(interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count] != 7)
                  │                           │                 │                  │ │  │
                  │                           │                 "hexagonal"        7 │  7
                  │                           │                                      false
                  │                           Swift.KeyPath<Swift.Dictionary<Swift.String, Swift.Array<Swift.Int>>, Swift.Int>
                  ["prime": [2, 3, 5, 7, 11, 13, 17], "triangular": [1, 3, 6, 10, 15, 21, 28], "hexagonal": [1, 6, 15, 28, 45, 66, 91]]

          [Int] interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count]
          => 7
          [Int] 7
          => 7


          """#
        ||
        output ==
          #"""
          #assert(interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count] != 7)
                  │                           │                 │                  │ │  │
                  │                           │                 "hexagonal"        7 │  7
                  │                           │                                      false
                  │                           Swift.KeyPath<Swift.Dictionary<Swift.String, Swift.Array<Swift.Int>>, Swift.Int>
                  ["hexagonal": [1, 6, 15, 28, 45, 66, 91], "prime": [2, 3, 5, 7, 11, 13, 17], "triangular": [1, 3, 6, 10, 15, 21, 28]]

          [Int] interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count]
          => 7
          [Int] 7
          => 7


          """#
        ||
        output ==
          #"""
          #assert(interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count] != 7)
                  │                           │                 │                  │ │  │
                  │                           │                 "hexagonal"        7 │  7
                  │                           │                                      false
                  │                           Swift.KeyPath<Swift.Dictionary<Swift.String, Swift.Array<Swift.Int>>, Swift.Int>
                  ["hexagonal": [1, 6, 15, 28, 45, 66, 91], "triangular": [1, 3, 6, 10, 15, 21, 28], "prime": [2, 3, 5, 7, 11, 13, 17]]

          [Int] interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count]
          => 7
          [Int] 7
          => 7


          """#
        ||
        output ==
          #"""
          #assert(interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count] != 7)
                  │                           │                 │                  │ │  │
                  │                           │                 "hexagonal"        7 │  7
                  │                           │                                      false
                  │                           Swift.KeyPath<Swift.Dictionary<Swift.String, Swift.Array<Swift.Int>>, Swift.Int>
                  ["triangular": [1, 3, 6, 10, 15, 21, 28], "prime": [2, 3, 5, 7, 11, 13, 17], "hexagonal": [1, 6, 15, 28, 45, 66, 91]]

          [Int] interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count]
          => 7
          [Int] 7
          => 7


          """#
        ||
        output ==
          #"""
          #assert(interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count] != 7)
                  │                           │                 │                  │ │  │
                  │                           │                 "hexagonal"        7 │  7
                  │                           │                                      false
                  │                           Swift.KeyPath<Swift.Dictionary<Swift.String, Swift.Array<Swift.Int>>, Swift.Int>
                  ["triangular": [1, 3, 6, 10, 15, 21, 28], "hexagonal": [1, 6, 15, 28, 45, 66, 91], "prime": [2, 3, 5, 7, 11, 13, 17]]

          [Int] interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count]
          => 7
          [Int] 7
          => 7


          """#
        ||
        output.replacingOccurrences(
          of: "0x[:xdigit:]{16}",
          with: "0x0000000000000000",
          options: .regularExpression
        ) ==
          #"""
          #assert(interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count] != 7)
                  │                           │                 │                  │ │  │
                  │                           │                 "hexagonal"        7 │  7
                  │                           │                                      false
                  │                           \Dictionary<String, Array<Int>>.<computed 0x0000000000000000 (Optional<Array<Int>>)>!.count
                  ["prime": [2, 3, 5, 7, 11, 13, 17], "hexagonal": [1, 6, 15, 28, 45, 66, 91], "triangular": [1, 3, 6, 10, 15, 21, 28]]

          [Int] interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count]
          => 7
          [Int] 7
          => 7


          """#
        ||
        output.replacingOccurrences(
          of: "0x[:xdigit:]{16}",
          with: "0x0000000000000000",
          options: .regularExpression
        ) ==
          #"""
          #assert(interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count] != 7)
                  │                           │                 │                  │ │  │
                  │                           │                 "hexagonal"        7 │  7
                  │                           │                                      false
                  │                           \Dictionary<String, Array<Int>>.<computed 0x0000000000000000 (Optional<Array<Int>>)>!.count
                  ["prime": [2, 3, 5, 7, 11, 13, 17], "triangular": [1, 3, 6, 10, 15, 21, 28], "hexagonal": [1, 6, 15, 28, 45, 66, 91]]

          [Int] interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count]
          => 7
          [Int] 7
          => 7


          """#
        ||
        output.replacingOccurrences(
          of: "0x[:xdigit:]{16}",
          with: "0x0000000000000000",
          options: .regularExpression
        ) ==
          #"""
          #assert(interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count] != 7)
                  │                           │                 │                  │ │  │
                  │                           │                 "hexagonal"        7 │  7
                  │                           │                                      false
                  │                           \Dictionary<String, Array<Int>>.<computed 0x0000000000000000 (Optional<Array<Int>>)>!.count
                  ["hexagonal": [1, 6, 15, 28, 45, 66, 91], "prime": [2, 3, 5, 7, 11, 13, 17], "triangular": [1, 3, 6, 10, 15, 21, 28]]

          [Int] interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count]
          => 7
          [Int] 7
          => 7


          """#
        ||
        output.replacingOccurrences(
          of: "0x[:xdigit:]{16}",
          with: "0x0000000000000000",
          options: .regularExpression
        ) ==
          #"""
          #assert(interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count] != 7)
                  │                           │                 │                  │ │  │
                  │                           │                 "hexagonal"        7 │  7
                  │                           │                                      false
                  │                           \Dictionary<String, Array<Int>>.<computed 0x0000000000000000 (Optional<Array<Int>>)>!.count
                  ["hexagonal": [1, 6, 15, 28, 45, 66, 91], "triangular": [1, 3, 6, 10, 15, 21, 28], "prime": [2, 3, 5, 7, 11, 13, 17]]

          [Int] interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count]
          => 7
          [Int] 7
          => 7


          """#
        ||
        output.replacingOccurrences(
          of: "0x[:xdigit:]{16}",
          with: "0x0000000000000000",
          options: .regularExpression
        ) ==
          #"""
          #assert(interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count] != 7)
                  │                           │                 │                  │ │  │
                  │                           │                 "hexagonal"        7 │  7
                  │                           │                                      false
                  │                           \Dictionary<String, Array<Int>>.<computed 0x0000000000000000 (Optional<Array<Int>>)>!.count
                  ["triangular": [1, 3, 6, 10, 15, 21, 28], "prime": [2, 3, 5, 7, 11, 13, 17], "hexagonal": [1, 6, 15, 28, 45, 66, 91]]

          [Int] interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count]
          => 7
          [Int] 7
          => 7


          """#
        ||
        output.replacingOccurrences(
          of: "0x[:xdigit:]{16}",
          with: "0x0000000000000000",
          options: .regularExpression
        ) ==
          #"""
          #assert(interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count] != 7)
                  │                           │                 │                  │ │  │
                  │                           │                 "hexagonal"        7 │  7
                  │                           │                                      false
                  │                           \Dictionary<String, Array<Int>>.<computed 0x0000000000000000 (Optional<Array<Int>>)>!.count
                  ["triangular": [1, 3, 6, 10, 15, 21, 28], "hexagonal": [1, 6, 15, 28, 45, 66, 91], "prime": [2, 3, 5, 7, 11, 13, 17]]

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
        "prime": [2, 3, 5, 7, 11, 13, 17],
        "triangular": [1, 3, 6, 10, 15, 21, 28],
        "hexagonal": [1, 6, 15, 28, 45, 66, 91]
      ]
      #assert(
        interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count.bitWidth] != 64
      )
    } completion: { (output) in
      print(output)
      // Dictionary order is not guaranteed
      XCTAssertTrue(
        output ==
          #"""
          #assert(interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count.bitWidth] != 64)
                  │                           │                 │                           │ │  │
                  │                           │                 "hexagonal"                 │ │  64
                  │                           │                                             │ false
                  │                           │                                             64
                  │                           Swift.KeyPath<Swift.Dictionary<Swift.String, Swift.Array<Swift.Int>>, Swift.Int>
                  ["prime": [2, 3, 5, 7, 11, 13, 17], "hexagonal": [1, 6, 15, 28, 45, 66, 91], "triangular": [1, 3, 6, 10, 15, 21, 28]]

          [Int] interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count.bitWidth]
          => 64
          [Int] 64
          => 64


          """#
        ||
        output ==
          #"""
          #assert(interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count.bitWidth] != 64)
                  │                           │                 │                           │ │  │
                  │                           │                 "hexagonal"                 │ │  64
                  │                           │                                             │ false
                  │                           │                                             64
                  │                           Swift.KeyPath<Swift.Dictionary<Swift.String, Swift.Array<Swift.Int>>, Swift.Int>
                  ["prime": [2, 3, 5, 7, 11, 13, 17], "triangular": [1, 3, 6, 10, 15, 21, 28], "hexagonal": [1, 6, 15, 28, 45, 66, 91]]

          [Int] interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count.bitWidth]
          => 64
          [Int] 64
          => 64


          """#
        ||
        output ==
          #"""
          #assert(interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count.bitWidth] != 64)
                  │                           │                 │                           │ │  │
                  │                           │                 "hexagonal"                 │ │  64
                  │                           │                                             │ false
                  │                           │                                             64
                  │                           Swift.KeyPath<Swift.Dictionary<Swift.String, Swift.Array<Swift.Int>>, Swift.Int>
                  ["hexagonal": [1, 6, 15, 28, 45, 66, 91], "prime": [2, 3, 5, 7, 11, 13, 17], "triangular": [1, 3, 6, 10, 15, 21, 28]]

          [Int] interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count.bitWidth]
          => 64
          [Int] 64
          => 64


          """#
        ||
        output ==
          #"""
          #assert(interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count.bitWidth] != 64)
                  │                           │                 │                           │ │  │
                  │                           │                 "hexagonal"                 │ │  64
                  │                           │                                             │ false
                  │                           │                                             64
                  │                           Swift.KeyPath<Swift.Dictionary<Swift.String, Swift.Array<Swift.Int>>, Swift.Int>
                  ["hexagonal": [1, 6, 15, 28, 45, 66, 91], "triangular": [1, 3, 6, 10, 15, 21, 28], "prime": [2, 3, 5, 7, 11, 13, 17]]

          [Int] interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count.bitWidth]
          => 64
          [Int] 64
          => 64


          """#
        ||
        output ==
          #"""
          #assert(interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count.bitWidth] != 64)
                  │                           │                 │                           │ │  │
                  │                           │                 "hexagonal"                 │ │  64
                  │                           │                                             │ false
                  │                           │                                             64
                  │                           Swift.KeyPath<Swift.Dictionary<Swift.String, Swift.Array<Swift.Int>>, Swift.Int>
                  ["triangular": [1, 3, 6, 10, 15, 21, 28], "prime": [2, 3, 5, 7, 11, 13, 17], "hexagonal": [1, 6, 15, 28, 45, 66, 91]]

          [Int] interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count.bitWidth]
          => 64
          [Int] 64
          => 64


          """#
        ||
        output ==
          #"""
          #assert(interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count.bitWidth] != 64)
                  │                           │                 │                           │ │  │
                  │                           │                 "hexagonal"                 │ │  64
                  │                           │                                             │ false
                  │                           │                                             64
                  │                           Swift.KeyPath<Swift.Dictionary<Swift.String, Swift.Array<Swift.Int>>, Swift.Int>
                  ["triangular": [1, 3, 6, 10, 15, 21, 28], "hexagonal": [1, 6, 15, 28, 45, 66, 91], "prime": [2, 3, 5, 7, 11, 13, 17]]

          [Int] interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count.bitWidth]
          => 64
          [Int] 64
          => 64


          """#
        ||
        output.replacingOccurrences(
          of: "0x[:xdigit:]{16}",
          with: "0x0000000000000000",
          options: .regularExpression
        ) ==
          #"""
          #assert(interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count.bitWidth] != 64)
                  │                           │                 │                           │ │  │
                  │                           │                 "hexagonal"                 │ │  64
                  │                           │                                             │ false
                  │                           │                                             64
                  │                           \Dictionary<String, Array<Int>>.<computed 0x0000000000000000 (Optional<Array<Int>>)>!.count.bitWidth
                  ["prime": [2, 3, 5, 7, 11, 13, 17], "hexagonal": [1, 6, 15, 28, 45, 66, 91], "triangular": [1, 3, 6, 10, 15, 21, 28]]

          [Int] interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count.bitWidth]
          => 64
          [Int] 64
          => 64


          """#
        ||
        output.replacingOccurrences(
          of: "0x[:xdigit:]{16}",
          with: "0x0000000000000000",
          options: .regularExpression
        ) ==
          #"""
          #assert(interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count.bitWidth] != 64)
                  │                           │                 │                           │ │  │
                  │                           │                 "hexagonal"                 │ │  64
                  │                           │                                             │ false
                  │                           │                                             64
                  │                           \Dictionary<String, Array<Int>>.<computed 0x0000000000000000 (Optional<Array<Int>>)>!.count.bitWidth
                  ["prime": [2, 3, 5, 7, 11, 13, 17], "triangular": [1, 3, 6, 10, 15, 21, 28], "hexagonal": [1, 6, 15, 28, 45, 66, 91]]

          [Int] interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count.bitWidth]
          => 64
          [Int] 64
          => 64


          """#
        ||
        output.replacingOccurrences(
          of: "0x[:xdigit:]{16}",
          with: "0x0000000000000000",
          options: .regularExpression
        ) ==
          #"""
          #assert(interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count.bitWidth] != 64)
                  │                           │                 │                           │ │  │
                  │                           │                 "hexagonal"                 │ │  64
                  │                           │                                             │ false
                  │                           │                                             64
                  │                           \Dictionary<String, Array<Int>>.<computed 0x0000000000000000 (Optional<Array<Int>>)>!.count.bitWidth
                  ["hexagonal": [1, 6, 15, 28, 45, 66, 91], "prime": [2, 3, 5, 7, 11, 13, 17], "triangular": [1, 3, 6, 10, 15, 21, 28]]

          [Int] interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count.bitWidth]
          => 64
          [Int] 64
          => 64


          """#
        ||
        output.replacingOccurrences(
          of: "0x[:xdigit:]{16}",
          with: "0x0000000000000000",
          options: .regularExpression
        ) ==
          #"""
          #assert(interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count.bitWidth] != 64)
                  │                           │                 │                           │ │  │
                  │                           │                 "hexagonal"                 │ │  64
                  │                           │                                             │ false
                  │                           │                                             64
                  │                           \Dictionary<String, Array<Int>>.<computed 0x0000000000000000 (Optional<Array<Int>>)>!.count.bitWidth
                  ["hexagonal": [1, 6, 15, 28, 45, 66, 91], "triangular": [1, 3, 6, 10, 15, 21, 28], "prime": [2, 3, 5, 7, 11, 13, 17]]

          [Int] interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count.bitWidth]
          => 64
          [Int] 64
          => 64


          """#
        ||
        output.replacingOccurrences(
          of: "0x[:xdigit:]{16}",
          with: "0x0000000000000000",
          options: .regularExpression
        ) ==
          #"""
          #assert(interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count.bitWidth] != 64)
                  │                           │                 │                           │ │  │
                  │                           │                 "hexagonal"                 │ │  64
                  │                           │                                             │ false
                  │                           │                                             64
                  │                           \Dictionary<String, Array<Int>>.<computed 0x0000000000000000 (Optional<Array<Int>>)>!.count.bitWidth
                  ["triangular": [1, 3, 6, 10, 15, 21, 28], "prime": [2, 3, 5, 7, 11, 13, 17], "hexagonal": [1, 6, 15, 28, 45, 66, 91]]

          [Int] interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count.bitWidth]
          => 64
          [Int] 64
          => 64


          """#
        ||
        output.replacingOccurrences(
          of: "0x[:xdigit:]{16}",
          with: "0x0000000000000000",
          options: .regularExpression
        ) ==
          #"""
          #assert(interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count.bitWidth] != 64)
                  │                           │                 │                           │ │  │
                  │                           │                 "hexagonal"                 │ │  64
                  │                           │                                             │ false
                  │                           │                                             64
                  │                           \Dictionary<String, Array<Int>>.<computed 0x0000000000000000 (Optional<Array<Int>>)>!.count.bitWidth
                  ["triangular": [1, 3, 6, 10, 15, 21, 28], "hexagonal": [1, 6, 15, 28, 45, 66, 91], "prime": [2, 3, 5, 7, 11, 13, 17]]

          [Int] interestingNumbers[keyPath: \[String: [Int]].["hexagonal"]!.count.bitWidth]
          => 64
          [Int] 64
          => 64


          """#
      )
    }
  }

  func testInitializerExpression() throws {
    captureConsoleOutput {
      let initializer: (Int) -> String = String.init.self

      #assert([1, 2, 3].map(initializer).reduce("", +) == "321")
      // FIXME: The compiler is unable to type-check this expression in reasonable time; try breaking up the expression into distinct sub-expressions
      // #assert([1, 2, 3].reversed().map(initializer).reduce("", +) == "321")
      // FIXME: The compiler is unable to type-check this expression in reasonable time; try breaking up the expression into distinct sub-expressions
      // #assert([1, 2, 3].map(String.init).reduce("", +) == "123")
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #assert([1, 2, 3].map(initializer).reduce("", +) == "321")
                ││  │  │  │   │            │      │      │  │
                │1  2  3  │   (Function)   "123"  ""     │  "321"
                [1, 2, 3] ["1", "2", "3"]                false

        --- [String] [1, 2, 3].map(initializer).reduce("", +)
        +++ [String] "321"
        [-12-]3{+21+}

        [String] [1, 2, 3].map(initializer).reduce("", +)
        => "123"
        [String] "321"
        => "321"


        """
      )
    }
  }

  func testPostfixSelfExpression() {
    captureConsoleOutput {
      #assert(String.self == Int.self && "string".self == "string")
      #assert(String.self == Int.self || "string".self != "string")
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #assert(String.self == Int.self && "string".self == "string")
                │      │    │  │   │    │
                │      │    │  │   │    false
                │      │    │  │   Optional(Swift.Int)
                │      │    │  Optional(Swift.Int)
                │      │    false
                │      Optional(Swift.String)
                Optional(Swift.String)

        --- [Optional<Any.Type>] String.self
        +++ [Optional<Any.Type>] Int.self
        –Optional(Swift.String)
        +Optional(Swift.Int)

        [Optional<Any.Type>] String.self
        => Optional(Swift.String)
        [Optional<Any.Type>] Int.self
        => Optional(Swift.Int)
        [Bool] String.self == Int.self
        => false
        [Not Evaluated] "string".self
        [Not Evaluated] "string"
        [Not Evaluated] "string".self == "string"

        #assert(String.self == Int.self || "string".self != "string")
                │      │    │  │   │    │  │        │    │  │
                │      │    │  │   │    │  "string" │    │  "string"
                │      │    │  │   │    false       │    false
                │      │    │  │   │                "string"
                │      │    │  │   Optional(Swift.Int)
                │      │    │  Optional(Swift.Int)
                │      │    false
                │      Optional(Swift.String)
                Optional(Swift.String)

        --- [Optional<Any.Type>] String.self
        +++ [Optional<Any.Type>] Int.self
        –Optional(Swift.String)
        +Optional(Swift.Int)

        [Optional<Any.Type>] String.self
        => Optional(Swift.String)
        [Optional<Any.Type>] Int.self
        => Optional(Swift.Int)
        [Bool] String.self == Int.self
        => false
        [String] "string".self
        => "string"
        [String] "string"
        => "string"
        [Bool] "string".self != "string"
        => false


        """
      )
    }
  }

  func testForcedUnwrapExpression() {
    captureConsoleOutput {
      let x: Int? = 0
      let someDictionary = ["a": [1, 2, 3], "b": [10, 20]]

      #assert(x! == 1)
      #assert(someDictionary["a"]![0] == 100)
    } completion: { (output) in
      print(output)
      // Dictionary order is not guaranteed
      XCTAssertTrue(
        output ==
        """
        #assert(x! == 1)
                ││ │  │
                │0 │  1
                │  false
                Optional(0)

        --- [Int] x!
        +++ [Int] 1
        –0
        +1

        [Int] x!
        => 0
        [Int] 1
        => 1

        #assert(someDictionary["a"]![0] == 100)
                ││             │  │  ││ │  │
                │[1, 2, 3]     │  │  │1 │  100
                │              │  │  0  false
                │              │  Optional([1, 2, 3])
                │              "a"
                ["a": [1, 2, 3], "b": [10, 20]]

        --- [Int] someDictionary["a"]![0]
        +++ [Int] 100
        –1
        +100

        [Int] someDictionary["a"]![0]
        => 1
        [Int] 100
        => 100


        """
        ||
        output ==
        """
        #assert(x! == 1)
                ││ │  │
                │0 │  1
                │  false
                Optional(0)

        --- [Int] x!
        +++ [Int] 1
        –0
        +1

        [Int] x!
        => 0
        [Int] 1
        => 1

        #assert(someDictionary["a"]![0] == 100)
                ││             │  │  ││ │  │
                │[1, 2, 3]     │  │  │1 │  100
                │              │  │  0  false
                │              │  Optional([1, 2, 3])
                │              "a"
                ["b": [10, 20], "a": [1, 2, 3]]

        --- [Int] someDictionary["a"]![0]
        +++ [Int] 100
        –1
        +100

        [Int] someDictionary["a"]![0]
        => 1
        [Int] 100
        => 100


        """
      )
    }
  }

  func testOptionalChainingExpression1() {
    captureConsoleOutput {
      var c: SomeClass?
      #assert(c?.property.performAction() != nil)

      c = SomeClass()
      #assert((c?.property.performAction())!)
      #assert(c?.property.performAction() == nil)

      let someDictionary = ["a": [1, 2, 3], "b": [10, 20]]
      #assert(someDictionary["not here"]?[0] == 99)
      #assert(someDictionary["a"]?[0] == 99)
    } completion: { (output) in
      print(output)
      // Dictionary order is not guaranteed
      XCTAssertTrue(
        output ==
          """
          #assert(c?.property.performAction() != nil)
                  │  │        │               │  │
                  │  nil      nil             │  nil
                  nil                         false

          [Optional<Bool>] c?.property.performAction()
          => nil
          [Optional<Bool>] nil
          => nil

          #assert((c?.property.performAction())!)
                  │││ │        │
                  │││ │        Optional(false)
                  │││ Optional(PowerAssertTests.OtherClass)
                  ││Optional(PowerAssertTests.SomeClass)
                  │false
                  Optional(false)

          #assert(c?.property.performAction() == nil)
                  │  │        │               │  │
                  │  │        Optional(false) │  nil
                  │  │                        false
                  │  Optional(PowerAssertTests.OtherClass)
                  Optional(PowerAssertTests.SomeClass)

          --- [Optional<Bool>] c?.property.performAction()
          +++ [Optional<Bool>] nil
          –Optional(false)
          +nil

          [Optional<Bool>] c?.property.performAction()
          => Optional(false)
          [Optional<Bool>] nil
          => nil

          #assert(someDictionary["not here"]?[0] == 99)
                  │              │         │  ││ │  │
                  │              │         │  ││ │  99
                  │              │         │  ││ false
                  │              │         │  │nil
                  │              │         │  0
                  │              │         nil
                  │              "not here"
                  ["a": [1, 2, 3], "b": [10, 20]]

          --- [Optional<Int>] someDictionary["not here"]?[0]
          +++ [Int] 99
          –nil
          +99

          [Optional<Int>] someDictionary["not here"]?[0]
          => nil
          [Int] 99
          => 99

          #assert(someDictionary["a"]?[0] == 99)
                  │              │  │  ││ │  │
                  │              │  │  ││ │  99
                  │              │  │  ││ false
                  │              │  │  │Optional(1)
                  │              │  │  0
                  │              │  Optional([1, 2, 3])
                  │              "a"
                  ["a": [1, 2, 3], "b": [10, 20]]

          --- [Optional<Int>] someDictionary["a"]?[0]
          +++ [Int] 99
          –Optional(1)
          +99

          [Optional<Int>] someDictionary["a"]?[0]
          => Optional(1)
          [Int] 99
          => 99


          """
        ||
        output ==
          """
          #assert(c?.property.performAction() != nil)
                  │  │        │               │  │
                  │  nil      nil             │  nil
                  nil                         false

          [Optional<Bool>] c?.property.performAction()
          => nil
          [Optional<Bool>] nil
          => nil

          #assert((c?.property.performAction())!)
                  │││ │        │
                  │││ │        Optional(false)
                  │││ Optional(PowerAssertTests.OtherClass)
                  ││Optional(PowerAssertTests.SomeClass)
                  │false
                  Optional(false)

          #assert(c?.property.performAction() == nil)
                  │  │        │               │  │
                  │  │        Optional(false) │  nil
                  │  │                        false
                  │  Optional(PowerAssertTests.OtherClass)
                  Optional(PowerAssertTests.SomeClass)

          --- [Optional<Bool>] c?.property.performAction()
          +++ [Optional<Bool>] nil
          –Optional(false)
          +nil

          [Optional<Bool>] c?.property.performAction()
          => Optional(false)
          [Optional<Bool>] nil
          => nil

          #assert(someDictionary["not here"]?[0] == 99)
                  │              │         │  ││ │  │
                  │              │         │  ││ │  99
                  │              │         │  ││ false
                  │              │         │  │nil
                  │              │         │  0
                  │              │         nil
                  │              "not here"
                  ["b": [10, 20], "a": [1, 2, 3]]

          --- [Optional<Int>] someDictionary["not here"]?[0]
          +++ [Int] 99
          –nil
          +99

          [Optional<Int>] someDictionary["not here"]?[0]
          => nil
          [Int] 99
          => 99

          #assert(someDictionary["a"]?[0] == 99)
                  │              │  │  ││ │  │
                  │              │  │  ││ │  99
                  │              │  │  ││ false
                  │              │  │  │Optional(1)
                  │              │  │  0
                  │              │  Optional([1, 2, 3])
                  │              "a"
                  ["a": [1, 2, 3], "b": [10, 20]]

          --- [Optional<Int>] someDictionary["a"]?[0]
          +++ [Int] 99
          –Optional(1)
          +99

          [Optional<Int>] someDictionary["a"]?[0]
          => Optional(1)
          [Int] 99
          => 99


          """
        ||
        output ==
          """
          #assert(c?.property.performAction() != nil)
                  │  │        │               │  │
                  │  nil      nil             │  nil
                  nil                         false

          [Optional<Bool>] c?.property.performAction()
          => nil
          [Optional<Bool>] nil
          => nil

          #assert((c?.property.performAction())!)
                  │││ │        │
                  │││ │        Optional(false)
                  │││ Optional(PowerAssertTests.OtherClass)
                  ││Optional(PowerAssertTests.SomeClass)
                  │false
                  Optional(false)

          #assert(c?.property.performAction() == nil)
                  │  │        │               │  │
                  │  │        Optional(false) │  nil
                  │  │                        false
                  │  Optional(PowerAssertTests.OtherClass)
                  Optional(PowerAssertTests.SomeClass)

          --- [Optional<Bool>] c?.property.performAction()
          +++ [Optional<Bool>] nil
          –Optional(false)
          +nil

          [Optional<Bool>] c?.property.performAction()
          => Optional(false)
          [Optional<Bool>] nil
          => nil

          #assert(someDictionary["not here"]?[0] == 99)
                  │              │         │  ││ │  │
                  │              │         │  ││ │  99
                  │              │         │  ││ false
                  │              │         │  │nil
                  │              │         │  0
                  │              │         nil
                  │              "not here"
                  ["a": [1, 2, 3], "b": [10, 20]]

          --- [Optional<Int>] someDictionary["not here"]?[0]
          +++ [Int] 99
          –nil
          +99

          [Optional<Int>] someDictionary["not here"]?[0]
          => nil
          [Int] 99
          => 99

          #assert(someDictionary["a"]?[0] == 99)
                  │              │  │  ││ │  │
                  │              │  │  ││ │  99
                  │              │  │  ││ false
                  │              │  │  │Optional(1)
                  │              │  │  0
                  │              │  Optional([1, 2, 3])
                  │              "a"
                  ["b": [10, 20], "a": [1, 2, 3]]

          --- [Optional<Int>] someDictionary["a"]?[0]
          +++ [Int] 99
          –Optional(1)
          +99

          [Optional<Int>] someDictionary["a"]?[0]
          => Optional(1)
          [Int] 99
          => 99


          """
        ||
        output ==
          """
          #assert(c?.property.performAction() != nil)
                  │  │        │               │  │
                  │  nil      nil             │  nil
                  nil                         false

          [Optional<Bool>] c?.property.performAction()
          => nil
          [Optional<Bool>] nil
          => nil

          #assert((c?.property.performAction())!)
                  │││ │        │
                  │││ │        Optional(false)
                  │││ Optional(PowerAssertTests.OtherClass)
                  ││Optional(PowerAssertTests.SomeClass)
                  │false
                  Optional(false)

          #assert(c?.property.performAction() == nil)
                  │  │        │               │  │
                  │  │        Optional(false) │  nil
                  │  │                        false
                  │  Optional(PowerAssertTests.OtherClass)
                  Optional(PowerAssertTests.SomeClass)

          --- [Optional<Bool>] c?.property.performAction()
          +++ [Optional<Bool>] nil
          –Optional(false)
          +nil

          [Optional<Bool>] c?.property.performAction()
          => Optional(false)
          [Optional<Bool>] nil
          => nil

          #assert(someDictionary["not here"]?[0] == 99)
                  │              │         │  ││ │  │
                  │              │         │  ││ │  99
                  │              │         │  ││ false
                  │              │         │  │nil
                  │              │         │  0
                  │              │         nil
                  │              "not here"
                  ["b": [10, 20], "a": [1, 2, 3]]

          --- [Optional<Int>] someDictionary["not here"]?[0]
          +++ [Int] 99
          –nil
          +99

          [Optional<Int>] someDictionary["not here"]?[0]
          => nil
          [Int] 99
          => 99

          #assert(someDictionary["a"]?[0] == 99)
                  │              │  │  ││ │  │
                  │              │  │  ││ │  99
                  │              │  │  ││ false
                  │              │  │  │Optional(1)
                  │              │  │  0
                  │              │  Optional([1, 2, 3])
                  │              "a"
                  ["b": [10, 20], "a": [1, 2, 3]]

          --- [Optional<Int>] someDictionary["a"]?[0]
          +++ [Int] 99
          –Optional(1)
          +99

          [Optional<Int>] someDictionary["a"]?[0]
          => Optional(1)
          [Int] 99
          => 99


          """
      )
    }
  }

  func testOptionalChainingExpression2() {
    captureConsoleOutput {
      var c: SomeClass?
      #assert(c?.optionalProperty?.property.optionalProperty?.performAction() != nil)
      c = SomeClass()
      #assert(c?.optionalProperty?.property.property.optionalProperty?.performAction() != nil)
    } completion: { (output) in
      print(output)
      // Dictionary order is not guaranteed
      XCTAssertEqual(
        output,
        """
        #assert(c?.optionalProperty?.property.optionalProperty?.performAction() != nil)
                │  │                 │        │                 │               │  │
                │  nil               nil      nil               nil             │  nil
                nil                                                             false

        [Optional<Bool>] c?.optionalProperty?.property.optionalProperty?.performAction()
        => nil
        [Optional<Bool>] nil
        => nil

        #assert(c?.optionalProperty?.property.property.optionalProperty?.performAction() != nil)
                │  │                 │        │        │                 │               │  │
                │  Optional(nil)     nil      nil      nil               nil             │  nil
                Optional(PowerAssertTests.SomeClass)                                     false

        [Optional<Bool>] c?.optionalProperty?.property.property.optionalProperty?.performAction()
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

      #assert(tuple != (name: kanjiName, age: 37, birthday: date))
      #assert(tuple != (kanjiName, 37, date))
      #assert(tuple.name != (kanjiName, 37, date).0 || tuple.age != (kanjiName, 37, date).1)
      #assert(tuple.name != (kanjiName, 37, date).0 && tuple.age != (kanjiName, 37, date).1)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #assert(tuple != (name: kanjiName, age: 37, birthday: date))
                │     │  │      │               │             │
                │     │  │      │               37            1980-10-27 15:00:00 +0000
                │     │  │      "岸川克己"
                │     │  ("岸川克己", 37, 1980-10-27 15:00:00 +0000)
                │     false
                ("岸川克己", 37, 1980-10-27 15:00:00 +0000)

        [(String, Int, Date)] tuple
        => ("岸川克己", 37, 1980-10-27 15:00:00 +0000)
        [(String, Int, Date)] (name: kanjiName, age: 37, birthday: date)
        => ("岸川克己", 37, 1980-10-27 15:00:00 +0000)

        #assert(tuple != (kanjiName, 37, date))
                │     │  ││          │   │
                │     │  ││          37  1980-10-27 15:00:00 +0000
                │     │  │"岸川克己"
                │     │  ("岸川克己", 37, 1980-10-27 15:00:00 +0000)
                │     false
                ("岸川克己", 37, 1980-10-27 15:00:00 +0000)

        [(String, Int, Date)] tuple
        => ("岸川克己", 37, 1980-10-27 15:00:00 +0000)
        [(String, Int, Date)] (kanjiName, 37, date)
        => ("岸川克己", 37, 1980-10-27 15:00:00 +0000)

        #assert(tuple.name != (kanjiName, 37, date).0 || tuple.age != (kanjiName, 37, date).1)
                │     │    │  ││          │   │     │ │  │     │   │  ││          │   │     │
                │     │    │  ││          37  │     │ │  │     37  │  ││          37  │     37
                │     │    │  ││              │     │ │  │         │  ││              1980-10-27 15:00:00 +0000
                │     │    │  ││              │     │ │  │         │  │"岸川克己"
                │     │    │  ││              │     │ │  │         │  ("岸川克己", 37, 1980-10-27 15:00:00 +0000)
                │     │    │  ││              │     │ │  │         false
                │     │    │  ││              │     │ │  (name: "岸川克己", age: 37, birthday: 1980-10-27 15:00:00 +0000)
                │     │    │  ││              │     │ false
                │     │    │  ││              │     "岸川克己"
                │     │    │  ││              1980-10-27 15:00:00 +0000
                │     │    │  │"岸川克己"
                │     │    │  ("岸川克己", 37, 1980-10-27 15:00:00 +0000)
                │     │    false
                │     "岸川克己"
                (name: "岸川克己", age: 37, birthday: 1980-10-27 15:00:00 +0000)

        [String] tuple.name
        => "岸川克己"
        [String] (kanjiName, 37, date).0
        => "岸川克己"
        [Bool] tuple.name != (kanjiName, 37, date).0
        => false
        [Int] tuple.age
        => 37
        [Int] (kanjiName, 37, date).1
        => 37
        [Bool] tuple.age != (kanjiName, 37, date).1
        => false

        #assert(tuple.name != (kanjiName, 37, date).0 && tuple.age != (kanjiName, 37, date).1)
                │     │    │  ││          │   │     │ │                           │
                │     │    │  ││          37  │     │ false                       37
                │     │    │  ││              │     "岸川克己"
                │     │    │  ││              1980-10-27 15:00:00 +0000
                │     │    │  │"岸川克己"
                │     │    │  ("岸川克己", 37, 1980-10-27 15:00:00 +0000)
                │     │    false
                │     "岸川克己"
                (name: "岸川克己", age: 37, birthday: 1980-10-27 15:00:00 +0000)

        [String] tuple.name
        => "岸川克己"
        [String] (kanjiName, 37, date).0
        => "岸川克己"
        [Bool] tuple.name != (kanjiName, 37, date).0
        => false
        [Not Evaluated] tuple.age
        [Not Evaluated] (kanjiName, 37, date).1
        [Not Evaluated] tuple.age != (kanjiName, 37, date).1


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


      #assert(tuple.name == (emojiName, 37, date).0 || tuple.age != (kanjiName, 37, date).1)
      #assert(tuple.name != (kanjiName, 37, date).0 || tuple.age != (emojiName, 37, date).1)

      #assert(tuple.name == (emojiName, 37, date).0 && tuple.age != (kanjiName, 37, date).1)
      #assert(tuple.name != (kanjiName, 37, date).0 && tuple.age != (emojiName, 37, date).1)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #assert(tuple.name == (emojiName, 37, date).0 || tuple.age != (kanjiName, 37, date).1)
                │     │    │  ││          │   │     │ │  │     │   │  ││          │   │     │
                │     │    │  ││          37  │     │ │  │     37  │  ││          37  │     37
                │     │    │  ││              │     │ │  │         │  ││              1980-10-27 15:00:00 +0000
                │     │    │  ││              │     │ │  │         │  │"岸川克己"
                │     │    │  ││              │     │ │  │         │  ("岸川克己", 37, 1980-10-27 15:00:00 +0000)
                │     │    │  ││              │     │ │  │         false
                │     │    │  ││              │     │ │  (name: "岸川克己", age: 37, birthday: 1980-10-27 15:00:00 +0000)
                │     │    │  ││              │     │ false
                │     │    │  ││              │     "😇岸川克己🇯🇵"
                │     │    │  ││              1980-10-27 15:00:00 +0000
                │     │    │  │"😇岸川克己🇯🇵"
                │     │    │  ("😇岸川克己🇯🇵", 37, 1980-10-27 15:00:00 +0000)
                │     │    false
                │     "岸川克己"
                (name: "岸川克己", age: 37, birthday: 1980-10-27 15:00:00 +0000)

        --- [String] tuple.name
        +++ [String] (emojiName, 37, date).0
        {+😇+}岸川克己{+🇯🇵+}

        [String] tuple.name
        => "岸川克己"
        [String] (emojiName, 37, date).0
        => "😇岸川克己🇯🇵"
        [Bool] tuple.name == (emojiName, 37, date).0
        => false
        [Int] tuple.age
        => 37
        [Int] (kanjiName, 37, date).1
        => 37
        [Bool] tuple.age != (kanjiName, 37, date).1
        => false

        #assert(tuple.name != (kanjiName, 37, date).0 || tuple.age != (emojiName, 37, date).1)
                │     │    │  ││          │   │     │ │  │     │   │  ││          │   │     │
                │     │    │  ││          37  │     │ │  │     37  │  ││          37  │     37
                │     │    │  ││              │     │ │  │         │  ││              1980-10-27 15:00:00 +0000
                │     │    │  ││              │     │ │  │         │  │"😇岸川克己🇯🇵"
                │     │    │  ││              │     │ │  │         │  ("😇岸川克己🇯🇵", 37, 1980-10-27 15:00:00 +0000)
                │     │    │  ││              │     │ │  │         false
                │     │    │  ││              │     │ │  (name: "岸川克己", age: 37, birthday: 1980-10-27 15:00:00 +0000)
                │     │    │  ││              │     │ false
                │     │    │  ││              │     "岸川克己"
                │     │    │  ││              1980-10-27 15:00:00 +0000
                │     │    │  │"岸川克己"
                │     │    │  ("岸川克己", 37, 1980-10-27 15:00:00 +0000)
                │     │    false
                │     "岸川克己"
                (name: "岸川克己", age: 37, birthday: 1980-10-27 15:00:00 +0000)

        [String] tuple.name
        => "岸川克己"
        [String] (kanjiName, 37, date).0
        => "岸川克己"
        [Bool] tuple.name != (kanjiName, 37, date).0
        => false
        [Int] tuple.age
        => 37
        [Int] (emojiName, 37, date).1
        => 37
        [Bool] tuple.age != (emojiName, 37, date).1
        => false

        #assert(tuple.name == (emojiName, 37, date).0 && tuple.age != (kanjiName, 37, date).1)
                │     │    │  ││          │   │     │ │                           │
                │     │    │  ││          37  │     │ false                       37
                │     │    │  ││              │     "😇岸川克己🇯🇵"
                │     │    │  ││              1980-10-27 15:00:00 +0000
                │     │    │  │"😇岸川克己🇯🇵"
                │     │    │  ("😇岸川克己🇯🇵", 37, 1980-10-27 15:00:00 +0000)
                │     │    false
                │     "岸川克己"
                (name: "岸川克己", age: 37, birthday: 1980-10-27 15:00:00 +0000)

        --- [String] tuple.name
        +++ [String] (emojiName, 37, date).0
        {+😇+}岸川克己{+🇯🇵+}

        [String] tuple.name
        => "岸川克己"
        [String] (emojiName, 37, date).0
        => "😇岸川克己🇯🇵"
        [Bool] tuple.name == (emojiName, 37, date).0
        => false
        [Not Evaluated] tuple.age
        [Not Evaluated] (kanjiName, 37, date).1
        [Not Evaluated] tuple.age != (kanjiName, 37, date).1

        #assert(tuple.name != (kanjiName, 37, date).0 && tuple.age != (emojiName, 37, date).1)
                │     │    │  ││          │   │     │ │                           │
                │     │    │  ││          37  │     │ false                       37
                │     │    │  ││              │     "岸川克己"
                │     │    │  ││              1980-10-27 15:00:00 +0000
                │     │    │  │"岸川克己"
                │     │    │  ("岸川克己", 37, 1980-10-27 15:00:00 +0000)
                │     │    false
                │     "岸川克己"
                (name: "岸川克己", age: 37, birthday: 1980-10-27 15:00:00 +0000)

        [String] tuple.name
        => "岸川克己"
        [String] (kanjiName, 37, date).0
        => "岸川克己"
        [Bool] tuple.name != (kanjiName, 37, date).0
        => false
        [Not Evaluated] tuple.age
        [Not Evaluated] (emojiName, 37, date).1
        [Not Evaluated] tuple.age != (emojiName, 37, date).1


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

      #assert(tuple != (name: "岸川克己", age: 37, birthday: date))
      #assert(tuple != ("岸川克己", 37, date))
      #assert(tuple.name != ("岸川克己", 37, date).0 || tuple.age != ("岸川克己", 37, date).1)
      #assert(tuple.name != ("岸川克己", 37, date).0 && tuple.age != ("岸川克己", 37, date).1)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #assert(tuple != (name: "岸川克己", age: 37, birthday: date))
                │     │  │      │                │             │
                │     │  │      │                37            1980-10-27 15:00:00 +0000
                │     │  │      "岸川克己"
                │     │  ("岸川克己", 37, 1980-10-27 15:00:00 +0000)
                │     false
                ("岸川克己", 37, 1980-10-27 15:00:00 +0000)

        [(String, Int, Date)] tuple
        => ("岸川克己", 37, 1980-10-27 15:00:00 +0000)
        [(String, Int, Date)] (name: "岸川克己", age: 37, birthday: date)
        => ("岸川克己", 37, 1980-10-27 15:00:00 +0000)

        #assert(tuple != ("岸川克己", 37, date))
                │     │  ││           │   │
                │     │  ││           37  1980-10-27 15:00:00 +0000
                │     │  │"岸川克己"
                │     │  ("岸川克己", 37, 1980-10-27 15:00:00 +0000)
                │     false
                ("岸川克己", 37, 1980-10-27 15:00:00 +0000)

        [(String, Int, Date)] tuple
        => ("岸川克己", 37, 1980-10-27 15:00:00 +0000)
        [(String, Int, Date)] ("岸川克己", 37, date)
        => ("岸川克己", 37, 1980-10-27 15:00:00 +0000)

        #assert(tuple.name != ("岸川克己", 37, date).0 || tuple.age != ("岸川克己", 37, date).1)
                │     │    │  ││           │   │     │ │  │     │   │  ││           │   │     │
                │     │    │  ││           37  │     │ │  │     37  │  ││           37  │     37
                │     │    │  ││               │     │ │  │         │  ││               1980-10-27 15:00:00 +0000
                │     │    │  ││               │     │ │  │         │  │"岸川克己"
                │     │    │  ││               │     │ │  │         │  ("岸川克己", 37, 1980-10-27 15:00:00 +0000)
                │     │    │  ││               │     │ │  │         false
                │     │    │  ││               │     │ │  (name: "岸川克己", age: 37, birthday: 1980-10-27 15:00:00 +0000)
                │     │    │  ││               │     │ false
                │     │    │  ││               │     "岸川克己"
                │     │    │  ││               1980-10-27 15:00:00 +0000
                │     │    │  │"岸川克己"
                │     │    │  ("岸川克己", 37, 1980-10-27 15:00:00 +0000)
                │     │    false
                │     "岸川克己"
                (name: "岸川克己", age: 37, birthday: 1980-10-27 15:00:00 +0000)

        [String] tuple.name
        => "岸川克己"
        [String] ("岸川克己", 37, date).0
        => "岸川克己"
        [Bool] tuple.name != ("岸川克己", 37, date).0
        => false
        [Int] tuple.age
        => 37
        [Int] ("岸川克己", 37, date).1
        => 37
        [Bool] tuple.age != ("岸川克己", 37, date).1
        => false

        #assert(tuple.name != ("岸川克己", 37, date).0 && tuple.age != ("岸川克己", 37, date).1)
                │     │    │  ││           │   │     │ │                            │
                │     │    │  ││           37  │     │ false                        37
                │     │    │  ││               │     "岸川克己"
                │     │    │  ││               1980-10-27 15:00:00 +0000
                │     │    │  │"岸川克己"
                │     │    │  ("岸川克己", 37, 1980-10-27 15:00:00 +0000)
                │     │    false
                │     "岸川克己"
                (name: "岸川克己", age: 37, birthday: 1980-10-27 15:00:00 +0000)

        [String] tuple.name
        => "岸川克己"
        [String] ("岸川克己", 37, date).0
        => "岸川克己"
        [Bool] tuple.name != ("岸川克己", 37, date).0
        => false
        [Not Evaluated] tuple.age
        [Not Evaluated] ("岸川克己", 37, date).1
        [Not Evaluated] tuple.age != ("岸川克己", 37, date).1


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

      #assert(tuple.name == ("😇岸川克己🇯🇵", 37, date).0 || tuple.age != ("岸川克己", 37, date).1)
      #assert(tuple.name != ("岸川克己", 37, date).0 || tuple.age != ("😇岸川克己🇯🇵", 37, date).1)
      #assert(tuple.name == ("😇岸川克己🇯🇵", 37, date).0 && tuple.age != ("岸川克己", 37, date).1)
      #assert(tuple.name != ("岸川克己", 37, date).0 && tuple.age != ("😇岸川克己🇯🇵", 37, date).1)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #assert(tuple.name == ("😇岸川克己🇯🇵", 37, date).0 || tuple.age != ("岸川克己", 37, date).1)
                │     │    │  ││              │   │     │ │  │     │   │  ││           │   │     │
                │     │    │  ││              37  │     │ │  │     37  │  ││           37  │     37
                │     │    │  ││                  │     │ │  │         │  ││               1980-10-27 15:00:00 +0000
                │     │    │  ││                  │     │ │  │         │  │"岸川克己"
                │     │    │  ││                  │     │ │  │         │  ("岸川克己", 37, 1980-10-27 15:00:00 +0000)
                │     │    │  ││                  │     │ │  │         false
                │     │    │  ││                  │     │ │  (name: "岸川克己", age: 37, birthday: 1980-10-27 15:00:00 +0000)
                │     │    │  ││                  │     │ false
                │     │    │  ││                  │     "😇岸川克己🇯🇵"
                │     │    │  ││                  1980-10-27 15:00:00 +0000
                │     │    │  │"😇岸川克己🇯🇵"
                │     │    │  ("😇岸川克己🇯🇵", 37, 1980-10-27 15:00:00 +0000)
                │     │    false
                │     "岸川克己"
                (name: "岸川克己", age: 37, birthday: 1980-10-27 15:00:00 +0000)

        --- [String] tuple.name
        +++ [String] ("😇岸川克己🇯🇵", 37, date).0
        {+😇+}岸川克己{+🇯🇵+}

        [String] tuple.name
        => "岸川克己"
        [String] ("😇岸川克己🇯🇵", 37, date).0
        => "😇岸川克己🇯🇵"
        [Bool] tuple.name == ("😇岸川克己🇯🇵", 37, date).0
        => false
        [Int] tuple.age
        => 37
        [Int] ("岸川克己", 37, date).1
        => 37
        [Bool] tuple.age != ("岸川克己", 37, date).1
        => false

        #assert(tuple.name != ("岸川克己", 37, date).0 || tuple.age != ("😇岸川克己🇯🇵", 37, date).1)
                │     │    │  ││           │   │     │ │  │     │   │  ││              │   │     │
                │     │    │  ││           37  │     │ │  │     37  │  ││              37  │     37
                │     │    │  ││               │     │ │  │         │  ││                  1980-10-27 15:00:00 +0000
                │     │    │  ││               │     │ │  │         │  │"😇岸川克己🇯🇵"
                │     │    │  ││               │     │ │  │         │  ("😇岸川克己🇯🇵", 37, 1980-10-27 15:00:00 +0000)
                │     │    │  ││               │     │ │  │         false
                │     │    │  ││               │     │ │  (name: "岸川克己", age: 37, birthday: 1980-10-27 15:00:00 +0000)
                │     │    │  ││               │     │ false
                │     │    │  ││               │     "岸川克己"
                │     │    │  ││               1980-10-27 15:00:00 +0000
                │     │    │  │"岸川克己"
                │     │    │  ("岸川克己", 37, 1980-10-27 15:00:00 +0000)
                │     │    false
                │     "岸川克己"
                (name: "岸川克己", age: 37, birthday: 1980-10-27 15:00:00 +0000)

        [String] tuple.name
        => "岸川克己"
        [String] ("岸川克己", 37, date).0
        => "岸川克己"
        [Bool] tuple.name != ("岸川克己", 37, date).0
        => false
        [Int] tuple.age
        => 37
        [Int] ("😇岸川克己🇯🇵", 37, date).1
        => 37
        [Bool] tuple.age != ("😇岸川克己🇯🇵", 37, date).1
        => false

        #assert(tuple.name == ("😇岸川克己🇯🇵", 37, date).0 && tuple.age != ("岸川克己", 37, date).1)
                │     │    │  ││              │   │     │ │                            │
                │     │    │  ││              37  │     │ false                        37
                │     │    │  ││                  │     "😇岸川克己🇯🇵"
                │     │    │  ││                  1980-10-27 15:00:00 +0000
                │     │    │  │"😇岸川克己🇯🇵"
                │     │    │  ("😇岸川克己🇯🇵", 37, 1980-10-27 15:00:00 +0000)
                │     │    false
                │     "岸川克己"
                (name: "岸川克己", age: 37, birthday: 1980-10-27 15:00:00 +0000)

        --- [String] tuple.name
        +++ [String] ("😇岸川克己🇯🇵", 37, date).0
        {+😇+}岸川克己{+🇯🇵+}

        [String] tuple.name
        => "岸川克己"
        [String] ("😇岸川克己🇯🇵", 37, date).0
        => "😇岸川克己🇯🇵"
        [Bool] tuple.name == ("😇岸川克己🇯🇵", 37, date).0
        => false
        [Not Evaluated] tuple.age
        [Not Evaluated] ("岸川克己", 37, date).1
        [Not Evaluated] tuple.age != ("岸川克己", 37, date).1

        #assert(tuple.name != ("岸川克己", 37, date).0 && tuple.age != ("😇岸川克己🇯🇵", 37, date).1)
                │     │    │  ││           │   │     │ │                               │
                │     │    │  ││           37  │     │ false                           37
                │     │    │  ││               │     "岸川克己"
                │     │    │  ││               1980-10-27 15:00:00 +0000
                │     │    │  │"岸川克己"
                │     │    │  ("岸川克己", 37, 1980-10-27 15:00:00 +0000)
                │     │    false
                │     "岸川克己"
                (name: "岸川克己", age: 37, birthday: 1980-10-27 15:00:00 +0000)

        [String] tuple.name
        => "岸川克己"
        [String] ("岸川克己", 37, date).0
        => "岸川克己"
        [Bool] tuple.name != ("岸川克己", 37, date).0
        => false
        [Not Evaluated] tuple.age
        [Not Evaluated] ("😇岸川克己🇯🇵", 37, date).1
        [Not Evaluated] tuple.age != ("😇岸川克己🇯🇵", 37, date).1


        """
      )
    }
  }

  func testConditionalCompilationBlock() {
    captureConsoleOutput {
      let bar = Bar(foo: Foo(val: 2), val: 3)
#if swift(>=3.2)
      #assert(bar.val == bar.foo.val)
#endif
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #assert(bar.val == bar.foo.val)
                │   │   │  │   │   │
                │   3   │  │   │   2
                │       │  │   Foo(val: 2)
                │       │  Bar(foo: PowerAssertTests.Foo(val: 2), val: 3)
                │       false
                Bar(foo: PowerAssertTests.Foo(val: 2), val: 3)

        --- [Int] bar.val
        +++ [Int] bar.foo.val
        –3
        +2

        [Int] bar.val
        => 3
        [Int] bar.foo.val
        => 2


        """
      )
    }
  }

  func testSelectorExpression1() {
    captureConsoleOutput {
      #assert(
        #selector(SomeObjCClass.doSomething(_:)) == #selector(getter: NSObjectProtocol.description)
      )
      #assert(
        #selector(getter: SomeObjCClass.property) == #selector(getter: NSObjectProtocol.description)
      )
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #assert(#selector(SomeObjCClass.doSomething(_:)) == #selector(getter: NSObjectProtocol.description))
                │                                        │  │
                "doSomethingWithInt:"                    │  "description"
                                                         false

        --- [Selector] #selector(SomeObjCClass.doSomething(_:))
        +++ [Selector] #selector(getter: NSObjectProtocol.description)
        –"doSomethingWithInt:"
        +"description"

        [Selector] #selector(SomeObjCClass.doSomething(_:))
        => "doSomethingWithInt:"
        [Selector] #selector(getter: NSObjectProtocol.description)
        => "description"

        #assert(#selector(getter: SomeObjCClass.property) == #selector(getter: NSObjectProtocol.description))
                │                                         │  │
                "property"                                │  "description"
                                                          false

        --- [Selector] #selector(getter: SomeObjCClass.property)
        +++ [Selector] #selector(getter: NSObjectProtocol.description)
        –"property"
        +"description"

        [Selector] #selector(getter: SomeObjCClass.property)
        => "property"
        [Selector] #selector(getter: NSObjectProtocol.description)
        => "description"


        """
      )
    }
  }

  func testSelectorExpression2() {
    captureConsoleOutput {
      #assert(
        #selector(SomeObjCClass.doSomething(_:)) == #selector(getter: (any NSObjectProtocol).description)
      )
      #assert(
        #selector(getter: SomeObjCClass.property) == #selector(getter: (any NSObjectProtocol).description)
      )
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #assert(#selector(SomeObjCClass.doSomething(_:)) == #selector(getter: (any NSObjectProtocol).description))
                │                                        │  │
                "doSomethingWithInt:"                    │  "description"
                                                         false

        --- [Selector] #selector(SomeObjCClass.doSomething(_:))
        +++ [Selector] #selector(getter: (any NSObjectProtocol).description)
        –"doSomethingWithInt:"
        +"description"

        [Selector] #selector(SomeObjCClass.doSomething(_:))
        => "doSomethingWithInt:"
        [Selector] #selector(getter: (any NSObjectProtocol).description)
        => "description"

        #assert(#selector(getter: SomeObjCClass.property) == #selector(getter: (any NSObjectProtocol).description))
                │                                         │  │
                "property"                                │  "description"
                                                          false

        --- [Selector] #selector(getter: SomeObjCClass.property)
        +++ [Selector] #selector(getter: (any NSObjectProtocol).description)
        –"property"
        +"description"

        [Selector] #selector(getter: SomeObjCClass.property)
        => "property"
        [Selector] #selector(getter: (any NSObjectProtocol).description)
        => "description"


        """
      )
    }
  }

   func testClosureExpression() {
     captureConsoleOutput {
       let arr = [2000, 1500, 1000]
       #assert(
         [10, 3, 20, 15, 4]
           .sorted()
           .filter { $0 > 5 }
           .map { $0 * 100 } == arr
       )
     } completion: { (output) in
       print(output)
       XCTAssertEqual(
         output,
         """
         #assert([10, 3, 20, 15, 4] .sorted() .filter { $0 > 5 } .map { $0 * 100 } == arr)
                 ││   │  │   │   │   │         │                  │                │  │
                 │10  3  20  15  4   │         [10, 15, 20]       │                │  [2000, 1500, 1000]
                 [10, 3, 20, 15, 4]  [3, 4, 10, 15, 20]           │                false
                                                                  [1000, 1500, 2000]

         --- [Array<Int>] [10, 3, 20, 15, 4] .sorted() .filter { $0 > 5 } .map { $0 * 100 }
         +++ [Array<Int>] arr
         –[1000, 1500, 2000]
         +[2000, 1500, 1000]

         [Array<Int>] [10, 3, 20, 15, 4] .sorted() .filter { $0 > 5 } .map { $0 * 100 }
         => [1000, 1500, 2000]
         [Array<Int>] arr
         => [2000, 1500, 1000]


         """
       )
     }
   }

  func testMultipleStatementInClosure() {
    captureConsoleOutput {
      let a = 5
      let b = 10

      #assert(
        { (a: Int, b: Int) -> Bool in
          let c = a + b
          let d = a - b
          if c != d {
            _ = c.distance(to: d)
            _ = d.distance(to: c)
          }
          return c == d
        }(a, b)
      )
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #assert({ (a: Int, b: Int) -> Bool in let c = a + b let d = a - b if c != d { _ = c.distance(to: d) _ = d.distance(to: c) } return c == d }(a, b))
                                                                                                                                                  │ │  │
                                                                                                                                                  │ 5  10
                                                                                                                                                  false

        
        """
      )
    }
  }

  func testMessageParameter() {
    captureConsoleOutput {
      let one = 1
      let two = 2
      let three = 3

      let array = [one, two, three]
      #assert(
        array.description.hasPrefix("[") == false && array.description.hasPrefix("Hello") == true,
        "message"
      )
      #assert(
        array.description.hasPrefix("[") == false || array.description.hasPrefix("Hello") == true,
        "message"
      )
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #assert(array.description.hasPrefix("[") == false && array.description.hasPrefix("Hello") == true)
                │     │           │         │    │  │     │
                │     "[1, 2, 3]" true      "["  │  false false
                [1, 2, 3]                        false

        --- [Bool] array.description.hasPrefix("[")
        +++ [Bool] false
        –true
        +false

        [Bool] array.description.hasPrefix("[")
        => true
        [Bool] false
        => false
        [Bool] array.description.hasPrefix("[") == false
        => false
        [Not Evaluated] array.description.hasPrefix("Hello")
        [Not Evaluated] true
        [Not Evaluated] array.description.hasPrefix("Hello") == true

        #assert(array.description.hasPrefix("[") == false || array.description.hasPrefix("Hello") == true)
                │     │           │         │    │  │     │  │     │           │         │        │  │
                │     "[1, 2, 3]" true      "["  │  false │  │     "[1, 2, 3]" false     "Hello"  │  true
                [1, 2, 3]                        false    │  [1, 2, 3]                            false
                                                          false

        --- [Bool] array.description.hasPrefix("[")
        +++ [Bool] false
        –true
        +false

        --- [Bool] array.description.hasPrefix("Hello")
        +++ [Bool] true
        –false
        +true

        [Bool] array.description.hasPrefix("[")
        => true
        [Bool] false
        => false
        [Bool] array.description.hasPrefix("[") == false
        => false
        [Bool] array.description.hasPrefix("Hello")
        => false
        [Bool] true
        => true
        [Bool] array.description.hasPrefix("Hello") == true
        => false


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
        array.description.hasPrefix("[") == false && array.description.hasPrefix("Hello") == true,
        file: "path/to/Tests.swift"
      )
      #assert(
        array.description.hasPrefix("[") == false && array.description.hasPrefix("Hello") == true,
        "message",
        file: "path/to/Tests.swift"
      )
      #assert(
        array.description.hasPrefix("[") == false || array.description.hasPrefix("Hello") == true,
        file: "path/to/Tests.swift"
      )
      #assert(
        array.description.hasPrefix("[") == false || array.description.hasPrefix("Hello") == true,
        "message",
        file: "path/to/Tests.swift"
      )
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #assert(array.description.hasPrefix("[") == false && array.description.hasPrefix("Hello") == true)
                │     │           │         │    │  │     │
                │     "[1, 2, 3]" true      "["  │  false false
                [1, 2, 3]                        false

        --- [Bool] array.description.hasPrefix("[")
        +++ [Bool] false
        –true
        +false

        [Bool] array.description.hasPrefix("[")
        => true
        [Bool] false
        => false
        [Bool] array.description.hasPrefix("[") == false
        => false
        [Not Evaluated] array.description.hasPrefix("Hello")
        [Not Evaluated] true
        [Not Evaluated] array.description.hasPrefix("Hello") == true

        #assert(array.description.hasPrefix("[") == false && array.description.hasPrefix("Hello") == true)
                │     │           │         │    │  │     │
                │     "[1, 2, 3]" true      "["  │  false false
                [1, 2, 3]                        false

        --- [Bool] array.description.hasPrefix("[")
        +++ [Bool] false
        –true
        +false

        [Bool] array.description.hasPrefix("[")
        => true
        [Bool] false
        => false
        [Bool] array.description.hasPrefix("[") == false
        => false
        [Not Evaluated] array.description.hasPrefix("Hello")
        [Not Evaluated] true
        [Not Evaluated] array.description.hasPrefix("Hello") == true

        #assert(array.description.hasPrefix("[") == false || array.description.hasPrefix("Hello") == true)
                │     │           │         │    │  │     │  │     │           │         │        │  │
                │     "[1, 2, 3]" true      "["  │  false │  │     "[1, 2, 3]" false     "Hello"  │  true
                [1, 2, 3]                        false    │  [1, 2, 3]                            false
                                                          false

        --- [Bool] array.description.hasPrefix("[")
        +++ [Bool] false
        –true
        +false

        --- [Bool] array.description.hasPrefix("Hello")
        +++ [Bool] true
        –false
        +true

        [Bool] array.description.hasPrefix("[")
        => true
        [Bool] false
        => false
        [Bool] array.description.hasPrefix("[") == false
        => false
        [Bool] array.description.hasPrefix("Hello")
        => false
        [Bool] true
        => true
        [Bool] array.description.hasPrefix("Hello") == true
        => false

        #assert(array.description.hasPrefix("[") == false || array.description.hasPrefix("Hello") == true)
                │     │           │         │    │  │     │  │     │           │         │        │  │
                │     "[1, 2, 3]" true      "["  │  false │  │     "[1, 2, 3]" false     "Hello"  │  true
                [1, 2, 3]                        false    │  [1, 2, 3]                            false
                                                          false

        --- [Bool] array.description.hasPrefix("[")
        +++ [Bool] false
        –true
        +false

        --- [Bool] array.description.hasPrefix("Hello")
        +++ [Bool] true
        –false
        +true

        [Bool] array.description.hasPrefix("[")
        => true
        [Bool] false
        => false
        [Bool] array.description.hasPrefix("[") == false
        => false
        [Bool] array.description.hasPrefix("Hello")
        => false
        [Bool] true
        => true
        [Bool] array.description.hasPrefix("Hello") == true
        => false


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
        array.description.hasPrefix("[") == false && array.description.hasPrefix("Hello") == true,
        line: 999
      )
      #assert(
        array.description.hasPrefix("[") == false && array.description.hasPrefix("Hello") == true,
        "message",
        line: 999
      )
      #assert(
        array.description.hasPrefix("[") == false && array.description.hasPrefix("Hello") == true,
        file: "path/to/Tests.swift",
        line: 999
      )
      #assert(
        array.description.hasPrefix("[") == false && array.description.hasPrefix("Hello") == true,
        "message",
        file: "path/to/Tests.swift",
        line: 999
      )
      #assert(
        array.description.hasPrefix("[") == false || array.description.hasPrefix("Hello") == true,
        line: 999
      )
      #assert(
        array.description.hasPrefix("[") == false || array.description.hasPrefix("Hello") == true,
        "message",
        line: 999
      )
      #assert(
        array.description.hasPrefix("[") == false || array.description.hasPrefix("Hello") == true,
        file: "path/to/Tests.swift",
        line: 999
      )
      #assert(
        array.description.hasPrefix("[") == false || array.description.hasPrefix("Hello") == true,
        "message",
        file: "path/to/Tests.swift",
        line: 999
      )
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #assert(array.description.hasPrefix("[") == false && array.description.hasPrefix("Hello") == true)
                │     │           │         │    │  │     │
                │     "[1, 2, 3]" true      "["  │  false false
                [1, 2, 3]                        false

        --- [Bool] array.description.hasPrefix("[")
        +++ [Bool] false
        –true
        +false

        [Bool] array.description.hasPrefix("[")
        => true
        [Bool] false
        => false
        [Bool] array.description.hasPrefix("[") == false
        => false
        [Not Evaluated] array.description.hasPrefix("Hello")
        [Not Evaluated] true
        [Not Evaluated] array.description.hasPrefix("Hello") == true

        #assert(array.description.hasPrefix("[") == false && array.description.hasPrefix("Hello") == true)
                │     │           │         │    │  │     │
                │     "[1, 2, 3]" true      "["  │  false false
                [1, 2, 3]                        false

        --- [Bool] array.description.hasPrefix("[")
        +++ [Bool] false
        –true
        +false

        [Bool] array.description.hasPrefix("[")
        => true
        [Bool] false
        => false
        [Bool] array.description.hasPrefix("[") == false
        => false
        [Not Evaluated] array.description.hasPrefix("Hello")
        [Not Evaluated] true
        [Not Evaluated] array.description.hasPrefix("Hello") == true

        #assert(array.description.hasPrefix("[") == false && array.description.hasPrefix("Hello") == true)
                │     │           │         │    │  │     │
                │     "[1, 2, 3]" true      "["  │  false false
                [1, 2, 3]                        false

        --- [Bool] array.description.hasPrefix("[")
        +++ [Bool] false
        –true
        +false

        [Bool] array.description.hasPrefix("[")
        => true
        [Bool] false
        => false
        [Bool] array.description.hasPrefix("[") == false
        => false
        [Not Evaluated] array.description.hasPrefix("Hello")
        [Not Evaluated] true
        [Not Evaluated] array.description.hasPrefix("Hello") == true

        #assert(array.description.hasPrefix("[") == false && array.description.hasPrefix("Hello") == true)
                │     │           │         │    │  │     │
                │     "[1, 2, 3]" true      "["  │  false false
                [1, 2, 3]                        false

        --- [Bool] array.description.hasPrefix("[")
        +++ [Bool] false
        –true
        +false

        [Bool] array.description.hasPrefix("[")
        => true
        [Bool] false
        => false
        [Bool] array.description.hasPrefix("[") == false
        => false
        [Not Evaluated] array.description.hasPrefix("Hello")
        [Not Evaluated] true
        [Not Evaluated] array.description.hasPrefix("Hello") == true

        #assert(array.description.hasPrefix("[") == false || array.description.hasPrefix("Hello") == true)
                │     │           │         │    │  │     │  │     │           │         │        │  │
                │     "[1, 2, 3]" true      "["  │  false │  │     "[1, 2, 3]" false     "Hello"  │  true
                [1, 2, 3]                        false    │  [1, 2, 3]                            false
                                                          false

        --- [Bool] array.description.hasPrefix("[")
        +++ [Bool] false
        –true
        +false

        --- [Bool] array.description.hasPrefix("Hello")
        +++ [Bool] true
        –false
        +true

        [Bool] array.description.hasPrefix("[")
        => true
        [Bool] false
        => false
        [Bool] array.description.hasPrefix("[") == false
        => false
        [Bool] array.description.hasPrefix("Hello")
        => false
        [Bool] true
        => true
        [Bool] array.description.hasPrefix("Hello") == true
        => false

        #assert(array.description.hasPrefix("[") == false || array.description.hasPrefix("Hello") == true)
                │     │           │         │    │  │     │  │     │           │         │        │  │
                │     "[1, 2, 3]" true      "["  │  false │  │     "[1, 2, 3]" false     "Hello"  │  true
                [1, 2, 3]                        false    │  [1, 2, 3]                            false
                                                          false

        --- [Bool] array.description.hasPrefix("[")
        +++ [Bool] false
        –true
        +false

        --- [Bool] array.description.hasPrefix("Hello")
        +++ [Bool] true
        –false
        +true

        [Bool] array.description.hasPrefix("[")
        => true
        [Bool] false
        => false
        [Bool] array.description.hasPrefix("[") == false
        => false
        [Bool] array.description.hasPrefix("Hello")
        => false
        [Bool] true
        => true
        [Bool] array.description.hasPrefix("Hello") == true
        => false

        #assert(array.description.hasPrefix("[") == false || array.description.hasPrefix("Hello") == true)
                │     │           │         │    │  │     │  │     │           │         │        │  │
                │     "[1, 2, 3]" true      "["  │  false │  │     "[1, 2, 3]" false     "Hello"  │  true
                [1, 2, 3]                        false    │  [1, 2, 3]                            false
                                                          false

        --- [Bool] array.description.hasPrefix("[")
        +++ [Bool] false
        –true
        +false

        --- [Bool] array.description.hasPrefix("Hello")
        +++ [Bool] true
        –false
        +true

        [Bool] array.description.hasPrefix("[")
        => true
        [Bool] false
        => false
        [Bool] array.description.hasPrefix("[") == false
        => false
        [Bool] array.description.hasPrefix("Hello")
        => false
        [Bool] true
        => true
        [Bool] array.description.hasPrefix("Hello") == true
        => false

        #assert(array.description.hasPrefix("[") == false || array.description.hasPrefix("Hello") == true)
                │     │           │         │    │  │     │  │     │           │         │        │  │
                │     "[1, 2, 3]" true      "["  │  false │  │     "[1, 2, 3]" false     "Hello"  │  true
                [1, 2, 3]                        false    │  [1, 2, 3]                            false
                                                          false

        --- [Bool] array.description.hasPrefix("[")
        +++ [Bool] false
        –true
        +false

        --- [Bool] array.description.hasPrefix("Hello")
        +++ [Bool] true
        –false
        +true

        [Bool] array.description.hasPrefix("[")
        => true
        [Bool] false
        => false
        [Bool] array.description.hasPrefix("[") == false
        => false
        [Bool] array.description.hasPrefix("Hello")
        => false
        [Bool] true
        => true
        [Bool] array.description.hasPrefix("Hello") == true
        => false


        """
      )
    }
  }

  func testStringContainsNewlines() {
    captureConsoleOutput {
      let loremIpsum = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
      #assert(
        loremIpsum == "Lorem ipsum dolor sit amet,\nconsectetur adipiscing elit,"
      )
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        #"""
        #assert(loremIpsum == "Lorem ipsum dolor sit amet,\nconsectetur adipiscing elit,")
                │          │  │
                │          │  "Lorem ipsum dolor sit amet,\nconsectetur adipiscing elit,"
                │          false
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."

        --- [String] loremIpsum
        +++ [String] "Lorem ipsum dolor sit amet,\nconsectetur adipiscing elit,"
        Lorem ipsum dolor sit amet,[- -]{+\n+}consectetur adipiscing elit,[- sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.-]

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
      #assert(lyric1 != "Feet, don't fail me now.")
      #assert(lyric1 != "Feet, don\'t fail me now.")

      let lyric2 = "Feet, don\'t fail me now."
      #assert(lyric2 != "Feet, don't fail me now.")
      #assert(lyric2 != "Feet, don\'t fail me now.")
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        #"""
        #assert(lyric1 != "Feet, don't fail me now.")
                │      │  │
                │      │  "Feet, don\'t fail me now."
                │      false
                "Feet, don\'t fail me now."

        [String] lyric1
        => "Feet, don\'t fail me now."
        [String] "Feet, don't fail me now."
        => "Feet, don\'t fail me now."

        #assert(lyric1 != "Feet, don\'t fail me now.")
                │      │  │
                │      │  "Feet, don\'t fail me now."
                │      false
                "Feet, don\'t fail me now."

        [String] lyric1
        => "Feet, don\'t fail me now."
        [String] "Feet, don\'t fail me now."
        => "Feet, don\'t fail me now."

        #assert(lyric2 != "Feet, don't fail me now.")
                │      │  │
                │      │  "Feet, don\'t fail me now."
                │      false
                "Feet, don\'t fail me now."

        [String] lyric2
        => "Feet, don\'t fail me now."
        [String] "Feet, don't fail me now."
        => "Feet, don\'t fail me now."

        #assert(lyric2 != "Feet, don\'t fail me now.")
                │      │  │
                │      │  "Feet, don\'t fail me now."
                │      false
                "Feet, don\'t fail me now."

        [String] lyric2
        => "Feet, don\'t fail me now."
        [String] "Feet, don\'t fail me now."
        => "Feet, don\'t fail me now."


        """#
      )
    }
  }

  func testStringContainsEscapeSequences2() {
    captureConsoleOutput {
      let nestedQuote1 = "My mother said, \"The baby started talking today. The baby said, 'Mama.'\""
      #assert(nestedQuote1 != "My mother said, \"The baby started talking today. The baby said, 'Mama.'\"")
      #assert(nestedQuote1 != "My mother said, \"The baby started talking today. The baby said, \'Mama.\'\"")

      let nestedQuote2 = "My mother said, \"The baby started talking today. The baby said, \'Mama.\'\""
      #assert(nestedQuote2 != "My mother said, \"The baby started talking today. The baby said, 'Mama.'\"")
      #assert(nestedQuote2 != "My mother said, \"The baby started talking today. The baby said, \'Mama.\'\"")
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        #"""
        #assert(nestedQuote1 != "My mother said, \"The baby started talking today. The baby said, 'Mama.'\"")
                │            │  │
                │            │  "My mother said, \"The baby started talking today. The baby said, \'Mama.\'\""
                │            false
                "My mother said, \"The baby started talking today. The baby said, \'Mama.\'\""

        [String] nestedQuote1
        => "My mother said, \"The baby started talking today. The baby said, \'Mama.\'\""
        [String] "My mother said, \"The baby started talking today. The baby said, 'Mama.'\""
        => "My mother said, \"The baby started talking today. The baby said, \'Mama.\'\""

        #assert(nestedQuote1 != "My mother said, \"The baby started talking today. The baby said, \'Mama.\'\"")
                │            │  │
                │            │  "My mother said, \"The baby started talking today. The baby said, \'Mama.\'\""
                │            false
                "My mother said, \"The baby started talking today. The baby said, \'Mama.\'\""

        [String] nestedQuote1
        => "My mother said, \"The baby started talking today. The baby said, \'Mama.\'\""
        [String] "My mother said, \"The baby started talking today. The baby said, \'Mama.\'\""
        => "My mother said, \"The baby started talking today. The baby said, \'Mama.\'\""

        #assert(nestedQuote2 != "My mother said, \"The baby started talking today. The baby said, 'Mama.'\"")
                │            │  │
                │            │  "My mother said, \"The baby started talking today. The baby said, \'Mama.\'\""
                │            false
                "My mother said, \"The baby started talking today. The baby said, \'Mama.\'\""

        [String] nestedQuote2
        => "My mother said, \"The baby started talking today. The baby said, \'Mama.\'\""
        [String] "My mother said, \"The baby started talking today. The baby said, 'Mama.'\""
        => "My mother said, \"The baby started talking today. The baby said, \'Mama.\'\""

        #assert(nestedQuote2 != "My mother said, \"The baby started talking today. The baby said, \'Mama.\'\"")
                │            │  │
                │            │  "My mother said, \"The baby started talking today. The baby said, \'Mama.\'\""
                │            false
                "My mother said, \"The baby started talking today. The baby said, \'Mama.\'\""

        [String] nestedQuote2
        => "My mother said, \"The baby started talking today. The baby said, \'Mama.\'\""
        [String] "My mother said, \"The baby started talking today. The baby said, \'Mama.\'\""
        => "My mother said, \"The baby started talking today. The baby said, \'Mama.\'\""


        """#
      )
    }
  }

  func testStringContainsEscapeSequences3() {
    captureConsoleOutput {
      let helpText = "OPTIONS:\n  --build-path\t\tSpecify build/cache directory [default: ./.build]"
      #assert(helpText != "OPTIONS:\n  --build-path\t\tSpecify build/cache directory [default: ./.build]")
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        #"""
        #assert(helpText != "OPTIONS:\n  --build-path\t\tSpecify build/cache directory [default: ./.build]")
                │        │  │
                │        │  "OPTIONS:\n  --build-path\t\tSpecify build/cache directory [default: ./.build]"
                │        false
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
      #assert(nullCharacter != "Null character\0Null character")

      let lineFeed = "Line feed\nLine feed"
      #assert(lineFeed != "Line feed\nLine feed")

      let carriageReturn = "Carriage Return\rCarriage Return"
      #assert(carriageReturn != "Carriage Return\rCarriage Return")

      let backslash = "Backslash\\Backslash"
      #assert(backslash != "Backslash\\Backslash")
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        #"""
        #assert(nullCharacter != "Null character\0Null character")
                │             │  │
                │             │  "Null character\0Null character"
                │             false
                "Null character\0Null character"

        [String] nullCharacter
        => "Null character\0Null character"
        [String] "Null character\0Null character"
        => "Null character\0Null character"

        #assert(lineFeed != "Line feed\nLine feed")
                │        │  │
                │        │  "Line feed\nLine feed"
                │        false
                "Line feed\nLine feed"

        [String] lineFeed
        => "Line feed\nLine feed"
        [String] "Line feed\nLine feed"
        => "Line feed\nLine feed"

        #assert(carriageReturn != "Carriage Return\rCarriage Return")
                │              │  │
                │              │  "Carriage Return\rCarriage Return"
                │              false
                "Carriage Return\rCarriage Return"

        [String] carriageReturn
        => "Carriage Return\rCarriage Return"
        [String] "Carriage Return\rCarriage Return"
        => "Carriage Return\rCarriage Return"

        #assert(backslash != "Backslash\\Backslash")
                │         │  │
                │         │  "Backslash\\Backslash"
                │         false
                "Backslash\\Backslash"

        [String] backslash
        => "Backslash\\Backslash"
        [String] "Backslash\\Backslash"
        => "Backslash\\Backslash"


        """#
      )
    }
  }

  func testStringContainsEscapeSequences5() {
    captureConsoleOutput {
      let wiseWords = "\"Imagination is more important than knowledge\" - Einstein"
      let dollarSign = "\u{0024}"        // $,  Unicode scalar U+0024
      let blackHeart = "\u{2665}"        // ♥,  Unicode scalar U+2665
      let sparklingHeart = "\u{1f496}"   // 💖, Unicode scalar U+1F496
      #assert(wiseWords != "\"Imagination is more important than knowledge\" - Einstein")
      #assert(dollarSign != "\u{0024}")
      #assert(blackHeart != "\u{2665}")
      #assert(sparklingHeart != "\u{1f496}")
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        #"""
        #assert(wiseWords != "\"Imagination is more important than knowledge\" - Einstein")
                │         │  │
                │         │  "\"Imagination is more important than knowledge\" - Einstein"
                │         false
                "\"Imagination is more important than knowledge\" - Einstein"

        [String] wiseWords
        => "\"Imagination is more important than knowledge\" - Einstein"
        [String] "\"Imagination is more important than knowledge\" - Einstein"
        => "\"Imagination is more important than knowledge\" - Einstein"

        #assert(dollarSign != "\u{0024}")
                │          │  │
                "$"        │  "$"
                           false

        [String] dollarSign
        => "$"
        [String] "\u{0024}"
        => "$"

        #assert(blackHeart != "\u{2665}")
                │          │  │
                │          │  "♥"
                │          false
                "♥"

        [String] blackHeart
        => "♥"
        [String] "\u{2665}"
        => "♥"

        #assert(sparklingHeart != "\u{1f496}")
                │              │  │
                │              │  "💖"
                │              false
                "💖"

        [String] sparklingHeart
        => "💖"
        [String] "\u{1f496}"
        => "💖"


        """#
      )
    }
  }

  func testStringContainsPoundSign() {
    captureConsoleOutput {
      let pound = "#"
      #assert(pound != "#")
      #assert("#" != pound)
      #assert(String("#") != pound)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        #"""
        #assert(pound != "#")
                │     │  │
                "#"   │  "#"
                      false

        [String] pound
        => "#"
        [String] "#"
        => "#"

        #assert("#" != pound)
                │   │  │
                "#" │  "#"
                    false

        [String] "#"
        => "#"
        [String] pound
        => "#"

        #assert(String("#") != pound)
                │      │    │  │
                "#"    "#"  │  "#"
                            false

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
        multilineLiteral != """
          Lorem ipsum dolor sit amet, consectetur adipiscing elit,
          sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
          """
      )
      #assert(multilineLiteral != multilineLiteral)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        #"""
        #assert(multilineLiteral != """ Lorem ipsum dolor sit amet, consectetur adipiscing elit,\nsed do eiusmod tempor incididunt ut labore et dolore magna aliqua. """)
                │                │  │
                │                │  "Lorem ipsum dolor sit amet, consectetur adipiscing elit,\nsed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
                │                false
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit,\nsed do eiusmod tempor incididunt ut labore et dolore magna aliqua."

        [String] multilineLiteral
        => "Lorem ipsum dolor sit amet, consectetur adipiscing elit,\nsed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
        [String] """ Lorem ipsum dolor sit amet, consectetur adipiscing elit,\nsed do eiusmod tempor incididunt ut labore et dolore magna aliqua. """
        => "Lorem ipsum dolor sit amet, consectetur adipiscing elit,\nsed do eiusmod tempor incididunt ut labore et dolore magna aliqua."

        #assert(multilineLiteral != multilineLiteral)
                │                │  │
                │                │  "Lorem ipsum dolor sit amet, consectetur adipiscing elit,\nsed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
                │                false
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
          """
      )
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        ##"""
        #assert(multilineLiteral != """ Escaping the first quotation mark \"""\nEscaping all three quotation marks \"\"\" """)
                │                │  │
                │                │  "Escaping the first quotation mark \"\"\"\nEscaping all three quotation marks \"\"\""
                │                false
                "Escaping the first quotation mark \"\"\"\nEscaping all three quotation marks \"\"\""

        [String] multilineLiteral
        => "Escaping the first quotation mark \"\"\"\nEscaping all three quotation marks \"\"\""
        [String] """ Escaping the first quotation mark \"""\nEscaping all three quotation marks \"\"\" """
        => "Escaping the first quotation mark \"\"\"\nEscaping all three quotation marks \"\"\""


        """##
      )
    }
  }

  func testMultilineStringLiterals3() {
    captureConsoleOutput {
      let multilineLiteral = """
        Lorem ipsum dolor sit amet, consectetur adipiscing elit,
        sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
        """
      let interpolate = "consectetur"
      #assert(
        multilineLiteral != """
          Lorem ipsum dolor sit amet, \(interpolate) adipiscing elit,
          sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
          """
      )
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        ##"""
        #assert(multilineLiteral != """ Lorem ipsum dolor sit amet, \(interpolate) adipiscing elit,\nsed do eiusmod tempor incididunt ut labore et dolore magna aliqua. """)
                │                │  │                                 │
                │                │  │                                 "consectetur"
                │                │  "Lorem ipsum dolor sit amet, consectetur adipiscing elit,\nsed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
                │                false
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit,\nsed do eiusmod tempor incididunt ut labore et dolore magna aliqua."

        [String] multilineLiteral
        => "Lorem ipsum dolor sit amet, consectetur adipiscing elit,\nsed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
        [String] """ Lorem ipsum dolor sit amet, \(interpolate) adipiscing elit,\nsed do eiusmod tempor incididunt ut labore et dolore magna aliqua. """
        => "Lorem ipsum dolor sit amet, consectetur adipiscing elit,\nsed do eiusmod tempor incididunt ut labore et dolore magna aliqua."


        """##
      )
    }
  }

  func testMultilineStringLiterals4() {
    captureConsoleOutput {
      #assert(
          """
          0123456789

          9876543210

          """
            .
          isEmpty
      )
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        ##"""
        #assert(""" 0123456789\n\n9876543210\n """ . isEmpty)
                │                                    │
                "0123456789\n\n9876543210\n"         false


        """##
      )
    }
  }

  func testMultilineStringLiterals5() async {
    await captureConsoleOutput {
      #assert(
        """
        Uploading...

        \(await upload(content: ""))

        Finished.

        """
          .isEmpty
      )
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        ##"""
        #assert(""" Uploading...\n\n\(await upload(content: ""))\n\nFinished.\n """ .isEmpty)
                │                           │               │                        │
                │                           "Success"       ""                       false
                "Uploading...\n\nSuccess\n\nFinished.\n"


        """##
      )
    }
  }

  func testCustomOperator() {
    captureConsoleOutput {
      let number1 = 100.0
      let number2 = 200.0
      #assert(number1 × number2 == 200.0)
      #assert(√number2 == 200.0)
      #assert(√√number2 == 200.0)
      #assert(200.0 == √√number2)
      #assert(√number2 == √√number2)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #assert(number1 × number2 == 200.0)
                │         │          │
                100.0     200.0      200.0

        #assert(√number2 == 200.0)
                ││       │  │
                │200.0   │  200.0
                │        false
                14.142135623730951

        --- [Double] √number2
        +++ [Double] 200.0
        –14.142135623730951
        +200.0

        [Double] √number2
        => 14.142135623730951
        [Double] 200.0
        => 200.0

        #assert(√√number2 == 200.0)
                │ │       │  │
                │ 200.0   │  200.0
                │         false
                3.760603093086394

        --- [Double] √√number2
        +++ [Double] 200.0
        –3.760603093086394
        +200.0

        [Double] √√number2
        => 3.760603093086394
        [Double] 200.0
        => 200.0

        #assert(200.0 == √√number2)
                │     │  │ │
                200.0 │  │ 200.0
                      │  3.760603093086394
                      false

        --- [Double] 200.0
        +++ [Double] √√number2
        –200.0
        +3.760603093086394

        [Double] 200.0
        => 200.0
        [Double] √√number2
        => 3.760603093086394

        #assert(√number2 == √√number2)
                ││       │    ││
                │200.0   │    │3.760603093086394
                │        │    200.0
                │        false
                14.142135623730951

        --- [Double] √number2
        +++ [Double] √√number2
        –14.142135623730951
        +3.760603093086394

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
      #assert(i2==4)
      #assert(b1==true&&i1>i2||true==b1&&i2==4)
      #assert(b1==true&&i1>i2||true==b1&&i2==4||d1×d2==1)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #assert(i2==4)
                │ │ │
                1 │ 4
                  false

        --- [Int] i2
        +++ [Int] 4
        –1
        +4

        [Int] i2
        => 1
        [Int] 4
        => 4

        #assert(b1==true&&i1>i2||true==b1&&i2==4)
                │ │ │   │      │ │   │ │ │     │
                │ │ │   false  │ │   │ │ false 4
                │ │ true       │ │   │ false
                │ false        │ │   false
                false          │ true
                               false

        --- [Bool] b1
        +++ [Bool] true
        –false
        +true

        --- [Bool] true
        +++ [Bool] b1
        –true
        +false

        [Bool] b1
        => false
        [Bool] true
        => true
        [Bool] b1==true
        => false
        [Bool] b1==true&&i1>i2
        => false
        [Bool] true
        => true
        [Bool] b1
        => false
        [Bool] true==b1
        => false
        [Int] 4
        => 4
        [Bool] true==b1&&i2==4
        => false
        [Not Evaluated] i1
        [Not Evaluated] i2
        [Not Evaluated] i1>i2
        [Not Evaluated] i2
        [Not Evaluated] i2==4

        #assert(b1==true&&i1>i2||true==b1&&i2==4||d1×d2==1)
                │   │            │     │       │  │  │   │
                │   true         true  false   4  │  6.0 1
                false                             4.0


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
      #assert(b1==false&&i1<i2&&false==b1&&i2==0)
      #assert(b1==false&&i1<i2&&false==b1&&i2==0||d1×d2==30.0)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #assert(b1==false&&i1<i2&&false==b1&&i2==0)
                │ │ │    │ │ ││ │ │    │ │ │ │ │ │
                │ │ │    │ 0 │1 │ │    │ │ │ 1 │ 0
                │ │ │    │   │  │ │    │ │ │   false
                │ │ │    │   │  │ │    │ │ false
                │ │ │    │   │  │ │    │ false
                │ │ │    │   │  │ │    true
                │ │ │    │   │  │ false
                │ │ │    │   │  true
                │ │ │    │   true
                │ │ │    true
                │ │ false
                │ true
                false

        --- [Int] i2
        +++ [Int] 0
        –1
        +0

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
        [Int] 0
        => 0
        [Bool] i2==0
        => false

        #assert(b1==false&&i1<i2&&false==b1&&i2==0||d1×d2==30.0)
                │   │      │  │   │      │   │   │  │  │   │
                │   false  0  1   false  │   1   0  │  6.0 30.0
                false                    false      4.0


        """
      )
    }
  }

  func testHigherOrderFunction() {
    captureConsoleOutput {
      func testA(_ i: Int) -> Int {
        i + 1
      }

      func testB(_ i: Int) -> Int {
        i + 1
      }

      let array = [0, 1, 2]
      #assert(array.map { testA($0) } == [3, 4])
      #assert(array.map(testB) == [3, 4])
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #assert(array.map { testA($0) } == [3, 4])
                │     │                 │  ││  │
                │     [1, 2, 3]         │  │3  4
                [0, 1, 2]               │  [3, 4]
                                        false

        --- [Array<Int>] array.map { testA($0) }
        +++ [Array<Int>] [3, 4]
        –[1, 2, 3]
        +[3, 4]

        [Array<Int>] array.map { testA($0) }
        => [1, 2, 3]
        [Array<Int>] [3, 4]
        => [3, 4]

        #assert(array.map(testB) == [3, 4])
                │     │   │      │  ││  │
                │     │   │      │  │3  4
                │     │   │      │  [3, 4]
                │     │   │      false
                │     │   (Function)
                │     [1, 2, 3]
                [0, 1, 2]

        --- [Array<Int>] array.map(testB)
        +++ [Array<Int>] [3, 4]
        –[1, 2, 3]
        +[3, 4]

        [Array<Int>] array.map(testB)
        => [1, 2, 3]
        [Array<Int>] [3, 4]
        => [3, 4]


        """
      )
    }
  }

  func testStringInterpolation1() {
    captureConsoleOutput {
      func testA(_ i: Int) -> Int {
        i + 1
      }

      let string = "World!"
      #assert("Hello \(string)" == "Hello Swift!")

      let i = 100
      #assert("value == \(testA(i))" == "value == 100")
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        #"""
        #assert("Hello \(string)" == "Hello Swift!")
                │        │        │  │
                │        "World!" │  "Hello Swift!"
                "Hello World!"    false

        --- [String] "Hello \(string)"
        +++ [String] "Hello Swift!"
        Hello [-World-]{+Swift+}!

        [String] "Hello \(string)"
        => "Hello World!"
        [String] "Hello Swift!"
        => "Hello Swift!"

        #assert("value == \(testA(i))" == "value == 100")
                │           │     │    │  │
                │           101   100  │  "value == 100"
                "value == 101"         false

        --- [String] "value == \(testA(i))"
        +++ [String] "value == 100"
        value == 10[-1-]{+0+}

        [String] "value == \(testA(i))"
        => "value == 101"
        [String] "value == 100"
        => "value == 100"


        """#
      )
    }
  }

  func testStringInterpolation2() {
    captureConsoleOutput {
      let multiplier = 3
      #assert("\(multiplier) times 2.5 is \(Double(multiplier) * 2.5)" != "3 times 2.5 is 7.5")

      #assert(#"Write an interpolated string in Swift using \(multiplier)."# != #"Write an interpolated string in Swift using \(multiplier)."#)

      #assert(#"6 times 7 is \#(6 * 7)."# != "6 times 7 is 42.")
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        ##"""
        #assert("\(multiplier) times 2.5 is \(Double(multiplier) * 2.5)" != "3 times 2.5 is 7.5")
                │  │                          │      │           │ │     │  │
                │  3                          3.0    3           │ 2.5   │  "3 times 2.5 is 7.5"
                "3 times 2.5 is 7.5"                             7.5     false

        [Double] Double(multiplier)
        => 3.0
        [Double] 2.5
        => 2.5
        [String] "\(multiplier) times 2.5 is \(Double(multiplier) * 2.5)"
        => "3 times 2.5 is 7.5"
        [String] "3 times 2.5 is 7.5"
        => "3 times 2.5 is 7.5"

        #assert(#"Write an interpolated string in Swift using \(multiplier)."# != #"Write an interpolated string in Swift using \(multiplier)."#)
                │                                                              │  │
                "Write an interpolated string in Swift using \\(multiplier)."  │  "Write an interpolated string in Swift using \\(multiplier)."
                                                                               false

        [String] #"Write an interpolated string in Swift using \(multiplier)."#
        => "Write an interpolated string in Swift using \\(multiplier)."
        [String] #"Write an interpolated string in Swift using \(multiplier)."#
        => "Write an interpolated string in Swift using \\(multiplier)."

        #assert(#"6 times 7 is \#(6 * 7)."# != "6 times 7 is 42.")
                │                 │ │ │     │  │
                │                 6 │ 7     │  "6 times 7 is 42."
                "6 times 7 is 42."  42      false

        [Int] 6
        => 6
        [Int] 7
        => 7
        [String] #"6 times 7 is \#(6 * 7)."#
        => "6 times 7 is 42."
        [String] "6 times 7 is 42."
        => "6 times 7 is 42."


        """##
      )
    }
  }

  @available(macOS 13.0, *)
  func testRegexLiteral() throws {
    try skip("Test fails on main branch")
    captureConsoleOutput {
      do {
        let regex = #/(CREDIT|DEBIT)\s+(\d{1,2}/\d{1,2}/\d{4})/#
        let result = try #/(CREDIT|DEBIT)\s+(\d{1,2}/\d{1,2}/\d{4})/#.firstMatch(in: "CREDIT    03/01/2022    Payroll from employer      $200.23")

        #assert(try regex.firstMatch(in: "CREDIT    03/01/2022    Payroll from employer      $200.23") == nil)
        #assert(
          try #/(CREDIT|DEBIT)\s+(\d{1,2}/\d{1,2}/\d{4})/#.firstMatch(in: "CREDIT    03/01/2022    Payroll from employer      $200.23")?.output.0 == result?.output.1
        )
        #assert(
          try #/(CREDIT|DEBIT)\s+(\d{1,2}/\d{1,2}/\d{4})/#.firstMatch(in: "CREDIT    03/01/2022    Payroll from employer      $200.23")?.output.1 == "03/01/2022"
        )
      } catch {
        XCTFail()
      }
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        #"""
        #assert(try regex.firstMatch(in: "CREDIT    03/01/2022    Payroll from employer      $200.23") == nil)
                    │     │              │                                                             │  │
                    │     │              "CREDIT    03/01/2022    Payroll from employer      $200.23"  │  _OptionalNilComparisonType()
                    │     │                                                                            false
                    │     Optional(_StringProcessing.Regex<(Swift.Substring, Swift.Substring, Swift.Substring)>.Match(anyRegexOutput: _StringProcessing.AnyRegexOutput(input: "CREDIT    03/01/2022    Payroll from employer      $200.23", _elements: [_StringProcessing.AnyRegexOutput.ElementRepresentation(optionalDepth: 0, content: Optional((range: Range(Swift.String.Index(_rawBits: 15)..<Swift.String.Index(_rawBits: 1310983)), value: nil)), name: nil, referenceID: nil), _StringProcessing.AnyRegexOutput.ElementRepresentation(optionalDepth: 0, content: Optional((range: Range(Swift.String.Index(_rawBits: 15)..<Swift.String.Index(_rawBits: 393221)), value: nil)), name: nil, referenceID: nil), _StringProcessing.AnyRegexOutput.ElementRepresentation(optionalDepth: 0, content: Optional((range: Range(Swift.String.Index(_rawBits: 655623)..<Swift.String.Index(_rawBits: 1310983)), value: nil)), name: nil, referenceID: nil)]), range: Range(Swift.String.Index(_rawBits: 15)..<Swift.String.Index(_rawBits: 1310983))))
                    Regex<(Substring, Substring, Substring)>(program: _StringProcessing.Regex<(Swift.Substring, Swift.Substring, Swift.Substring)>.Program)

        --- [Optional<Match>] regex.firstMatch(in: "CREDIT    03/01/2022    Payroll from employer      $200.23")
        +++ [_OptionalNilComparisonType] nil
        –Optional(_StringProcessing.Regex<(Swift.Substring, Swift.Substring, Swift.Substring)>.Match(anyRegexOutput: _StringProcessing.AnyRegexOutput(input: "CREDIT    03/01/2022    Payroll from employer      $200.23", _elements: [_StringProcessing.AnyRegexOutput.ElementRepresentation(optionalDepth: 0, content: Optional((range: Range(Swift.String.Index(_rawBits: 15)..<Swift.String.Index(_rawBits: 1310983)), value: nil)), name: nil, referenceID: nil), _StringProcessing.AnyRegexOutput.ElementRepresentation(optionalDepth: 0, content: Optional((range: Range(Swift.String.Index(_rawBits: 15)..<Swift.String.Index(_rawBits: 393221)), value: nil)), name: nil, referenceID: nil), _StringProcessing.AnyRegexOutput.ElementRepresentation(optionalDepth: 0, content: Optional((range: Range(Swift.String.Index(_rawBits: 655623)..<Swift.String.Index(_rawBits: 1310983)), value: nil)), name: nil, referenceID: nil)]), range: Range(Swift.String.Index(_rawBits: 15)..<Swift.String.Index(_rawBits: 1310983))))
        +_OptionalNilComparisonType()

        [Optional<Match>] regex.firstMatch(in: "CREDIT    03/01/2022    Payroll from employer      $200.23")
        => Optional(_StringProcessing.Regex<(Swift.Substring, Swift.Substring, Swift.Substring)>.Match(anyRegexOutput: _StringProcessing.AnyRegexOutput(input: "CREDIT    03/01/2022    Payroll from employer      $200.23", _elements: [_StringProcessing.AnyRegexOutput.ElementRepresentation(optionalDepth: 0, content: Optional((range: Range(Swift.String.Index(_rawBits: 15)..<Swift.String.Index(_rawBits: 1310983)), value: nil)), name: nil, referenceID: nil), _StringProcessing.AnyRegexOutput.ElementRepresentation(optionalDepth: 0, content: Optional((range: Range(Swift.String.Index(_rawBits: 15)..<Swift.String.Index(_rawBits: 393221)), value: nil)), name: nil, referenceID: nil), _StringProcessing.AnyRegexOutput.ElementRepresentation(optionalDepth: 0, content: Optional((range: Range(Swift.String.Index(_rawBits: 655623)..<Swift.String.Index(_rawBits: 1310983)), value: nil)), name: nil, referenceID: nil)]), range: Range(Swift.String.Index(_rawBits: 15)..<Swift.String.Index(_rawBits: 1310983))))
        [_OptionalNilComparisonType] nil
        => _OptionalNilComparisonType()

        #assert(try #/(CREDIT|DEBIT)\s+(\d{1,2}/\d{1,2}/\d{4})/#.firstMatch(in: "CREDIT    03/01/2022    Payroll from employer      $200.23")?.output.0 == result?.output.1)
                    │                                            │              │                                                              │      │ │  │       │      │
                    │                                            │              "CREDIT    03/01/2022    Payroll from employer      $200.23"   │      │ │  │       │      Optional("CREDIT")
                    │                                            │                                                                             │      │ │  │       Optional(("CREDIT    03/01/2022", "CREDIT", "03/01/2022"))
                    │                                            │                                                                             │      │ │  Optional(_StringProcessing.Regex<(Swift.Substring, Swift.Substring, Swift.Substring)>.Match(anyRegexOutput: _StringProcessing.AnyRegexOutput(input: "CREDIT    03/01/2022    Payroll from employer      $200.23", _elements: [_StringProcessing.AnyRegexOutput.ElementRepresentation(optionalDepth: 0, content: Optional((range: Range(Swift.String.Index(_rawBits: 15)..<Swift.String.Index(_rawBits: 1310983)), value: nil)), name: nil, referenceID: nil), _StringProcessing.AnyRegexOutput.ElementRepresentation(optionalDepth: 0, content: Optional((range: Range(Swift.String.Index(_rawBits: 15)..<Swift.String.Index(_rawBits: 393221)), value: nil)), name: nil, referenceID: nil), _StringProcessing.AnyRegexOutput.ElementRepresentation(optionalDepth: 0, content: Optional((range: Range(Swift.String.Index(_rawBits: 655623)..<Swift.String.Index(_rawBits: 1310983)), value: nil)), name: nil, referenceID: nil)]), range: Range(Swift.String.Index(_rawBits: 15)..<Swift.String.Index(_rawBits: 1310983))))
                    │                                            │                                                                             │      │ false
                    │                                            │                                                                             │      Optional("CREDIT    03/01/2022")
                    │                                            │                                                                             Optional(("CREDIT    03/01/2022", "CREDIT", "03/01/2022"))
                    │                                            Optional(_StringProcessing.Regex<(Swift.Substring, Swift.Substring, Swift.Substring)>.Match(anyRegexOutput: _StringProcessing.AnyRegexOutput(input: "CREDIT    03/01/2022    Payroll from employer      $200.23", _elements: [_StringProcessing.AnyRegexOutput.ElementRepresentation(optionalDepth: 0, content: Optional((range: Range(Swift.String.Index(_rawBits: 15)..<Swift.String.Index(_rawBits: 1310983)), value: nil)), name: nil, referenceID: nil), _StringProcessing.AnyRegexOutput.ElementRepresentation(optionalDepth: 0, content: Optional((range: Range(Swift.String.Index(_rawBits: 15)..<Swift.String.Index(_rawBits: 393221)), value: nil)), name: nil, referenceID: nil), _StringProcessing.AnyRegexOutput.ElementRepresentation(optionalDepth: 0, content: Optional((range: Range(Swift.String.Index(_rawBits: 655623)..<Swift.String.Index(_rawBits: 1310983)), value: nil)), name: nil, referenceID: nil)]), range: Range(Swift.String.Index(_rawBits: 15)..<Swift.String.Index(_rawBits: 1310983))))
                    Regex<(Substring, Substring, Substring)>(program: _StringProcessing.Regex<(Swift.Substring, Swift.Substring, Swift.Substring)>.Program)

        --- [Optional<Substring>] #/(CREDIT|DEBIT)\s+(\d{1,2}/\d{1,2}/\d{4})/#.firstMatch(in: "CREDIT    03/01/2022    Payroll from employer      $200.23")?.output.0
        +++ [Optional<Substring>] result?.output.1
        –Optional("CREDIT    03/01/2022")
        +Optional("CREDIT")

        [Optional<Substring>] #/(CREDIT|DEBIT)\s+(\d{1,2}/\d{1,2}/\d{4})/#.firstMatch(in: "CREDIT    03/01/2022    Payroll from employer      $200.23")?.output.0
        => Optional("CREDIT    03/01/2022")
        [Optional<Substring>] result?.output.1
        => Optional("CREDIT")

        #assert(try #/(CREDIT|DEBIT)\s+(\d{1,2}/\d{1,2}/\d{4})/#.firstMatch(in: "CREDIT    03/01/2022    Payroll from employer      $200.23")?.output.1 == "03/01/2022")
                    │                                            │              │                                                              │      │ │  │
                    │                                            │              "CREDIT    03/01/2022    Payroll from employer      $200.23"   │      │ │  Optional("03/01/2022")
                    │                                            │                                                                             │      │ false
                    │                                            │                                                                             │      Optional("CREDIT")
                    │                                            │                                                                             Optional(("CREDIT    03/01/2022", "CREDIT", "03/01/2022"))
                    │                                            Optional(_StringProcessing.Regex<(Swift.Substring, Swift.Substring, Swift.Substring)>.Match(anyRegexOutput: _StringProcessing.AnyRegexOutput(input: "CREDIT    03/01/2022    Payroll from employer      $200.23", _elements: [_StringProcessing.AnyRegexOutput.ElementRepresentation(optionalDepth: 0, content: Optional((range: Range(Swift.String.Index(_rawBits: 15)..<Swift.String.Index(_rawBits: 1310983)), value: nil)), name: nil, referenceID: nil), _StringProcessing.AnyRegexOutput.ElementRepresentation(optionalDepth: 0, content: Optional((range: Range(Swift.String.Index(_rawBits: 15)..<Swift.String.Index(_rawBits: 393221)), value: nil)), name: nil, referenceID: nil), _StringProcessing.AnyRegexOutput.ElementRepresentation(optionalDepth: 0, content: Optional((range: Range(Swift.String.Index(_rawBits: 655623)..<Swift.String.Index(_rawBits: 1310983)), value: nil)), name: nil, referenceID: nil)]), range: Range(Swift.String.Index(_rawBits: 15)..<Swift.String.Index(_rawBits: 1310983))))
                    Regex<(Substring, Substring, Substring)>(program: _StringProcessing.Regex<(Swift.Substring, Swift.Substring, Swift.Substring)>.Program)

        --- [Optional<Substring>] #/(CREDIT|DEBIT)\s+(\d{1,2}/\d{1,2}/\d{4})/#.firstMatch(in: "CREDIT    03/01/2022    Payroll from employer      $200.23")?.output.1
        +++ [Optional<Substring>] "03/01/2022"
        –Optional("CREDIT")
        +Optional("03/01/2022")

        [Optional<Substring>] #/(CREDIT|DEBIT)\s+(\d{1,2}/\d{1,2}/\d{4})/#.firstMatch(in: "CREDIT    03/01/2022    Payroll from employer      $200.23")?.output.1
        => Optional("CREDIT")
        [Optional<Substring>] "03/01/2022"
        => Optional("03/01/2022")


        """#
      )
    }
  }

  func testTypeIdentifier1() {
    captureConsoleOutput {
      #assert(String.Type.self == Int.Type.self)
      #assert(String.Type.self != String.Type.self)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #assert(String.Type.self == Int.Type.self)
                            │    │           │
                            │    false       Optional(Swift.Int.Type)
                            Optional(Swift.String.Type)

        --- [Optional<Any.Type>] String.Type.self
        +++ [Optional<Any.Type>] Int.Type.self
        –Optional(Swift.String.Type)
        +Optional(Swift.Int.Type)

        [Optional<Any.Type>] String.Type.self
        => Optional(Swift.String.Type)
        [Optional<Any.Type>] Int.Type.self
        => Optional(Swift.Int.Type)

        #assert(String.Type.self != String.Type.self)
                            │    │              │
                            │    false          Optional(Swift.String.Type)
                            Optional(Swift.String.Type)

        [Optional<Any.Type>] String.Type.self
        => Optional(Swift.String.Type)
        [Optional<Any.Type>] String.Type.self
        => Optional(Swift.String.Type)


        """
      )
    }
  }

  func testTypeIdentifier2() {
    captureConsoleOutput {
      #assert(String.Type.self ==== Int.Type.self)
      #assert(String.Type.self !=== String.Type.self)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #assert(String.Type.self ==== Int.Type.self)
                            │                  │
                            String.Type        Int.Type

        #assert(String.Type.self !=== String.Type.self)
                            │                     │
                            String.Type           String.Type


        """
      )
    }
  }

  func testTypeIdentifier3() {
    captureConsoleOutput {
      let s: Any = "string"
      #assert(s as? String.Type != nil)
      #assert(s as? String.Type == String.Type.self)
      #assert(s as? String.Type == String.self)
      #assert(String.Type.self == s as? String.Type)
      #assert(String.self == s as? String.Type)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #assert(s as? String.Type != nil)
                │ │               │  │
                │ nil             │  nil
                "string"          false

        [Optional<String.Type>] s as? String.Type
        => nil
        [Optional<Any.Type>] nil
        => nil

        #assert(s as? String.Type == String.Type.self)
                │ │               │              │
                │ nil             false          Optional(Swift.String.Type)
                "string"

        --- [Optional<String.Type>] s as? String.Type
        +++ [Optional<Any.Type>] String.Type.self
        –nil
        +Optional(Swift.String.Type)

        [Optional<String.Type>] s as? String.Type
        => nil
        [Optional<Any.Type>] String.Type.self
        => Optional(Swift.String.Type)

        #assert(s as? String.Type == String.self)
                │ │               │  │      │
                │ nil             │  │      Optional(Swift.String)
                "string"          │  Optional(Swift.String)
                                  false

        --- [Optional<String.Type>] s as? String.Type
        +++ [Optional<Any.Type>] String.self
        –nil
        +Optional(Swift.String)

        [Optional<String.Type>] s as? String.Type
        => nil
        [Optional<Any.Type>] String.self
        => Optional(Swift.String)

        #assert(String.Type.self == s as? String.Type)
                            │    │  │ │
                            │    │  │ nil
                            │    │  "string"
                            │    false
                            Optional(Swift.String.Type)

        --- [Optional<Any.Type>] String.Type.self
        +++ [Optional<String.Type>] s as? String.Type
        –Optional(Swift.String.Type)
        +nil

        [Optional<Any.Type>] String.Type.self
        => Optional(Swift.String.Type)
        [Optional<String.Type>] s as? String.Type
        => nil

        #assert(String.self == s as? String.Type)
                │      │    │  │ │
                │      │    │  │ nil
                │      │    │  "string"
                │      │    false
                │      Optional(Swift.String)
                Optional(Swift.String)

        --- [Optional<Any.Type>] String.self
        +++ [Optional<String.Type>] s as? String.Type
        –Optional(Swift.String)
        +nil

        [Optional<Any.Type>] String.self
        => Optional(Swift.String)
        [Optional<String.Type>] s as? String.Type
        => nil


        """
      )
    }
  }

  func testAsyncExpression1() async {
    await captureConsoleOutput(execute: {
      let status = "Failure"
      #assert(await upload(content: "example") == status)
    }, completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        #"""
        #assert(await upload(content: "example") == status)
                      │               │          │  │
                      "Success"       "example"  │  "Failure"
                                                 false

        --- [String] upload(content: "example")
        +++ [String] status
        [-S-]{+Fail+}u[-cc-]{+r+}e[-ss-]

        [String] upload(content: "example")
        => "Success"
        [String] status
        => "Failure"


        """#
      )
    })
  }

  func testAsyncExpression2() async {
    await captureConsoleOutput {
      let bar = Bar(foo: Foo(val: 2), val: 3)
      #assert(bar.val == bar.foo.val)

      let status = "Failure"
      #assert(await upload(content: "example") == status)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #assert(bar.val == bar.foo.val)
                │   │   │  │   │   │
                │   3   │  │   │   2
                │       │  │   Foo(val: 2)
                │       │  Bar(foo: PowerAssertTests.Foo(val: 2), val: 3)
                │       false
                Bar(foo: PowerAssertTests.Foo(val: 2), val: 3)

        --- [Int] bar.val
        +++ [Int] bar.foo.val
        –3
        +2

        [Int] bar.val
        => 3
        [Int] bar.foo.val
        => 2

        #assert(await upload(content: "example") == status)
                      │               │          │  │
                      "Success"       "example"  │  "Failure"
                                                 false

        --- [String] upload(content: "example")
        +++ [String] status
        [-S-]{+Fail+}u[-cc-]{+r+}e[-ss-]

        [String] upload(content: "example")
        => "Success"
        [String] status
        => "Failure"


        """
      )
    }
  }

  func testAsyncExpression3() async throws {
    await captureConsoleOutput {
      let bar = Bar(foo: Foo(val: 2), val: 3)
      #assert(bar.val == bar.foo.val)

      let status = "Failure"
      #assert(await upload(content: "example") == status)

      let request = URLRequest(url: URL(string: "https://example.com")!)
      let session = URLSession(configuration: .ephemeral)
      #assert(try await session.data(for: request).0.count > .max)
      #assert((try await session.data(for: request).1 as? HTTPURLResponse)?.statusCode == 500)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output.replacingOccurrences(
          of: "0x(?:[:xdigit:]{12}|[:xdigit:]{9})",
          with: "0x000000000",
          options: .regularExpression
        ),
        """
        #assert(bar.val == bar.foo.val)
                │   │   │  │   │   │
                │   3   │  │   │   2
                │       │  │   Foo(val: 2)
                │       │  Bar(foo: PowerAssertTests.Foo(val: 2), val: 3)
                │       false
                Bar(foo: PowerAssertTests.Foo(val: 2), val: 3)

        --- [Int] bar.val
        +++ [Int] bar.foo.val
        –3
        +2

        [Int] bar.val
        => 3
        [Int] bar.foo.val
        => 2

        #assert(await upload(content: "example") == status)
                      │               │          │  │
                      "Success"       "example"  │  "Failure"
                                                 false

        --- [String] upload(content: "example")
        +++ [String] status
        [-S-]{+Fail+}u[-cc-]{+r+}e[-ss-]

        [String] upload(content: "example")
        => "Success"
        [String] status
        => "Failure"

        #assert(try await session.data(for: request).0.count > .max)
                          │       │         │        │ │     │  │
                          │       │         │        │ 1256  │  9223372036854775807
                          │       │         │        │       false
                          │       │         │        1256 bytes
                          │       │         https://example.com
                          │       (1256 bytes, Status Code: 200 (no error), URL: https://example.com/)
                          <__NSURLSessionLocal: 0x000000000>

        [Int] session.data(for: request).0.count
        => 1256
        [Int] .max
        => 9223372036854775807

        #assert((try await session.data(for: request).1 as? HTTPURLResponse)?.statusCode == 500)
                │          │       │         │        │ │                     │          │  │
                │          │       │         │        │ │                     │          │  500
                │          │       │         │        │ │                     │          false
                │          │       │         │        │ │                     Optional(200)
                │          │       │         │        │ Optional(Status Code: 200 (no error), URL: https://example.com/)
                │          │       │         │        Status Code: 200 (no error), URL: https://example.com/
                │          │       │         https://example.com
                │          │       (1256 bytes, Status Code: 200 (no error), URL: https://example.com/)
                │          <__NSURLSessionLocal: 0x000000000>
                Optional(Status Code: 200 (no error), URL: https://example.com/)

        --- [Optional<Int>] (try await session.data(for: request).1 as? HTTPURLResponse)?.statusCode
        +++ [Int] 500
        –Optional(200)
        +500

        [Optional<Int>] (try await session.data(for: request).1 as? HTTPURLResponse)?.statusCode
        => Optional(200)
        [Int] 500
        => 500


        """
      )
    }
  }

  func testTypecheckTimeoutDueToOverloading() {
    captureConsoleOutput {
      let a = 2
      let b = 3
      let c = 4
      #assert((a + b) * c == 15)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #assert((a + b) * c == 15)
                ││ │ │  │ │ │  │
                │2 5 3  │ 4 │  15
                5       20  false

        --- [Int] (a + b) * c
        +++ [Int] 15
        –20
        +15

        [Int] a
        => 2
        [Int] b
        => 3
        [Int] (a + b)
        => 5
        [Int] c
        => 4
        [Int] (a + b) * c
        => 20
        [Int] 15
        => 15


        """
      )
    }
  }

  func testFloatLiteralExpression() {
    captureConsoleOutput {
      let a = 2.0
      let b = 3.0
      let c = 4.0
      #assert((a + b) * c == 15.0)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #assert((a + b) * c == 15.0)
                ││ │ │  │ │ │  │
                ││ │ │  │ │ │  15.0
                ││ │ │  │ │ false
                ││ │ │  │ 4.0
                ││ │ │  20.0
                ││ │ 3.0
                ││ 5.0
                │2.0
                5.0

        --- [Double] (a + b) * c
        +++ [Double] 15.0
        –20.0
        +15.0

        [Double] a
        => 2.0
        [Double] b
        => 3.0
        [Double] (a + b)
        => 5.0
        [Double] c
        => 4.0
        [Double] (a + b) * c
        => 20.0
        [Double] 15.0
        => 15.0


        """
      )
    }
  }

  func testIntegerLiteralExpression() {
    captureConsoleOutput {
      let a = 2.0
      let b = 3.0
      let c = 4.0
      #assert((a + b) * c == 15)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #assert((a + b) * c == 15)
                ││ │ │  │ │ │  │
                ││ │ │  │ │ │  15
                ││ │ │  │ │ false
                ││ │ │  │ 4.0
                ││ │ │  20.0
                ││ │ 3.0
                ││ 5.0
                │2.0
                5.0

        --- [Double] (a + b) * c
        +++ [Int] 15
        –20.0
        +15

        [Double] a
        => 2.0
        [Double] b
        => 3.0
        [Double] (a + b)
        => 5.0
        [Double] c
        => 4.0
        [Double] (a + b) * c
        => 20.0
        [Int] 15
        => 15


        """
      )
    }
  }
}

extension AssertTests {
  var stringValue: String { "string" }
  var intValue: Int { 100 }
  var doubleValue: Double { 999.9 }
}
