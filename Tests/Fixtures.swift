import Foundation

extension AssertTests {
  var stringValue: String { "string" }
  var intValue: Int { 100 }
  var doubleValue: Double { 999.9 }
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
    self[keyPath: keyPath]
  }
}

struct OuterStructure {
  var outer: SomeStructure

  init(someValue: Int) {
    self.outer = SomeStructure(someValue: someValue)
  }

  func getValue(keyPath: KeyPath<OuterStructure, Int>) -> Int {
    self[keyPath: keyPath]
  }
}

class SomeClass {
  var property = OtherClass()
  var optionalProperty: OtherClass?

  init() {}

  func performAction() -> Bool {
    true
  }
}

class OtherClass {
  var property = AnotherClass()
  var optionalProperty: AnotherClass?

  init() {}

  func performAction() -> Bool {
    false
  }
}

class AnotherClass {
  var property = TheClass()
  var optionalProperty: TheClass?

  init() {}

  func performAction() -> Bool {
    true
  }
}

class TheClass {
  var optionalProperty: SomeClass?

  init() {}

  func performAction() -> Bool {
    true
  }
}

class MediaItem {
  var name: String

  init(name: String) {
    self.name = name
  }
}

class Movie: MediaItem {
  var director: String

  init(name: String, director: String) {
    self.director = director
    super.init(name: name)
  }
}

class Song: MediaItem {
  var artist: String

  init(name: String, artist: String) {
    self.artist = artist
    super.init(name: name)
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

infix operator ====
func ====<T, U>(lhs: T.Type, rhs: U.Type) -> Bool {
  lhs == rhs
}

infix operator !===
func !===<T, U>(lhs: T.Type, rhs: U.Type) -> Bool {
  lhs != rhs
}

infix operator ×: MultiplicationPrecedence
func ×(left: Double, right: Double) -> Double {
  left * right
}

prefix operator √
prefix func √(number: Double) -> Double {
  sqrt(number)
}

prefix operator √√
prefix func √√(number: Double) -> Double {
  sqrt(sqrt(number))
}

func upload(content: String) async -> String {
  "Success"
}

extension HTTPURLResponse {
  open override var description: String {
    let statusCodeDescription = HTTPURLResponse.localizedString(forStatusCode: statusCode)
    return "Status Code: \(statusCode) (\(statusCodeDescription)), URL: \(url?.absoluteString ?? "nil")"
  }
}

class IntegerRef: Equatable {
  let value: Int
  init(_ value: Int) {
    self.value = value
  }
}

func == (lhs: IntegerRef, rhs: IntegerRef) -> Bool {
  lhs.value == rhs.value
}

enum MyError: Error {
  case recoverableError(String)
  case unrecoverableError(String)
}

func throwRecoverableError() throws -> String {
  throw MyError.recoverableError("Recoverable error")
}

func throwUnrecoverableError() throws -> Bool {
  throw MyError.unrecoverableError("Unrecoverable error")
}
