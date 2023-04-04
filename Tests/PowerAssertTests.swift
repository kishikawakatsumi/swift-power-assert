import XCTest
@testable import PowerAssert

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

final class PowerAssertTests: XCTestCase {
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
