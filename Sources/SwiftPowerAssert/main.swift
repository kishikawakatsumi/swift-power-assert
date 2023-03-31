import Foundation
import SwiftPowerAssertLib

let a = 10
let b = 9
#powerAssert(a * b == 91)

let xs = [1, 2, 3]
#powerAssert(xs.contains(4))

#powerAssert("hello".hasPrefix("h") && "goodbye".hasSuffix("y"))

let d = 4
let e = 7
let f = 12
#powerAssert(max(d, e) == f)
#powerAssert(d + e > f)

let john = Person(name: "John", age: 42)
let mike = Person(name: "Mike", age: 13)
#powerAssert(john.isTeenager)
#powerAssert(mike.isTeenager && john.age < mike.age)

#powerAssert("12345678901234567890".count == 0)
#powerAssert("⌚⭐⺎⽋豈Ａ🚀".count == 0)

struct Person {
  let name: String
  let age: Int

  var isTeenager: Bool {
    return age <= 12 && age >= 20
  }
}
