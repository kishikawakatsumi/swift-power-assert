
import Foundation
import XCTest
@testable import PowerAssert

final class BugFixTests: XCTestCase {

  /// Baseline behavior for comparison with Optional(Int)
  func testOptionalIntRendering() {
    func test<T>(_ item: T?) -> String {
      PowerAssert.TestOnlyAccess.stringify(item)
    }
    let i: Int = 1
    let oiOne: Int? = i
    let ooiOptOne: (Int?)? = oiOne
    let oiNil: Int? = nil
    let ooiNil: (Int?)? = oiNil
    let ooiOptNil: (Int?)? = ooiNil
    XCTAssertEqual("1", test(i))
    XCTAssertEqual("1", test(oiOne))
    XCTAssertEqual(#"Optional(1)"#, test(ooiOptOne)) // current, correct

    // Wrappers all reduced to nil?
    XCTAssertEqual("nil", test(oiNil))
    XCTAssertEqual("nil", test(ooiNil))
    XCTAssertEqual("nil", test(ooiOptNil))
  }

  /// Optional(String) gets quoted?
  func testOptionalStringRendering() {
    func test<T>(_ item: T?) -> String {
      PowerAssert.TestOnlyAccess.stringify(item)
    }
    let s: String = "s"
    let osStr: String? = s
    let oosOptStr: (String?)? = osStr
    let osNil: String? = nil
    let oosNil: (String?)? = osNil
    let oosOptNil: (String?)? = oosNil
    XCTAssertEqual(#""s""#, test(s))
    XCTAssertEqual(#""s""#, test(osStr))
    XCTAssertEqual(#""Optional(\"s\")""#, test(oosOptStr)) // current
    //XCTAssertEqual("Optional(\"s\")", test(oosOptStr)) // correct?

    // Wrappers all reduced to nil?
    XCTAssertEqual("nil", test(osNil))
    XCTAssertEqual("nil", test(oosNil))
    XCTAssertEqual("nil", test(oosOptNil))
  }
}
