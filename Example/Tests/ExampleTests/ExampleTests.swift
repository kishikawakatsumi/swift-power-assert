import XCTest
import PowerAssert

final class PowerAssertTests: XCTestCase {
  func testExample() {
    let a = 10
    let b = 9
    #assert(a * b == 91)

    let xs = [1, 2, 3]
    #assert(xs.contains(4))

    #assert("hello".hasPrefix("h") && "goodbye".hasSuffix("y"))

    let d = 4
    let e = 7
    let f = 12
    #assert(max(d, e) == f)
    #assert(d + e > f)

    let john = Person(name: "John", age: 42)
    let mike = Person(name: "Mike", age: 13)
    #assert(john.isTeenager)
    #assert(mike.isTeenager && john.age < mike.age)
  }

  func testConcurrency() async {
    let ok = "OK"
    #assert(await upload(content: "example") == ok)
  }
}

struct Person {
  let name: String
  let age: Int

  var isTeenager: Bool {
    return age <= 12 && age >= 20
  }
}

func upload(content: String) async -> String {
  "Fail"
}
