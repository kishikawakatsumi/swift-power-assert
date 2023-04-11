import Foundation

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
  var optionalProperty: OtherClass?

  init() {}

  func performAction() -> Bool {
    return true
  }
}

class OtherClass {
  var property = AnotherClass()
  var optionalProperty: AnotherClass?

  init() {}

  func performAction() -> Bool {
    return true
  }
}

class AnotherClass {
  var property = TheClass()
  var optionalProperty: TheClass?

  init() {}

  func performAction() -> Bool {
    return true
  }
}

class TheClass {
  var optionalProperty: SomeClass?

  init() {}

  func performAction() -> Bool {
    return true
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
