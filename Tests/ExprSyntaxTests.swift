import XCTest
@testable import PowerAssert

final class ExprSyntaxTests: XCTestCase {
  func testArrayExprSyntax() {

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

//    for thing in things {
//      switch thing {
//      case 0 as Int:
//        print("zero as an Int")
//      case 0 as Double:
//        print("zero as a Double")
//      case let someInt as Int:
//        print("an integer value of \(someInt)")
//      case let someDouble as Double where someDouble > 0:
//        print("a positive double value of \(someDouble)")
//      case is Double:
//        print("some other double value that I don't want to print")
//      case let someString as String:
//        print("a string value of \"\(someString)\"")
//      case let (x, y) as (Double, Double):
//        print("an (x, y) point at \(x), \(y)")
//      case let movie as Movie:
//        print("a movie called \(movie.name), dir. \(movie.director)")
//      case let stringConverter as (String) -> String:
//        print(stringConverter("Michael"))
//      default:
//        print("something else")
//      }
//    }

    captureConsoleOutput {
      #expect(things[0] as? Int == 0, verbose: true)
    } completion: { (output) in
      print(output)
      XCTAssertEqual(
        output,
        """
        #expect(things[0] as? Int == 0)
                ||     ||         |  |
                ||     |0         |  Optional(0)
                ||     0          true
                |Optional(0)
                [0, 0.0, 42, 3.14159, "hello", (3.0, 5.0), PowerAssertTests.Movie, (Function)]

        """
      )
    }
  }
}
