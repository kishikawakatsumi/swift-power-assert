import XCTest
import SwiftParser
import SwiftSyntaxMacros
import SwiftSyntaxMacroExpansion
import PowerAssertPlugin
@testable import PowerAssert

private let testModuleName = "TestModule"
private let testFileName = "test.swift"

final class MacroExpansionTests: XCTestCase {
  func testExpandAssertMacro1() {
    let sourceFile = Parser.parse(
      source: """
        let numbers = [1, 2, 3, 4, 5]
        #assert(numbers[2] == 4)
        """
    )
    let macros: [String: any Macro.Type] = [
      "assert": PowerAssertMacro.self,
    ]
    let context = BasicMacroExpansionContext(
      sourceFiles: [sourceFile: .init(moduleName: testModuleName, fullFilePath: testFileName)]
    )

    let expanded = "\(sourceFile.expand(macros: macros, in: context))"
    XCTAssertTrue(
      expanded ==
      """
      let numbers = [1, 2, 3, 4, 5]
      PowerAssert.Assertion(
        "#assert(numbers[2] == 4)",
        message: "",
        file: "TestModule/test.swift",
        line: 2,
        verbose: false,
        equalityExpressions: [(5, 2, 4)],
        identicalExpressions: [],
        comparisonOperands: [2: "numbers[2]", 4: "4"],
        literalExpresions: [(1, 2, 9), (4, 4, 15)]
      ) {
        $0.captureSync($0.captureSync($0.captureSync(numbers.self, column: 1, id: 0)[2] , column: 10, id: 2) == 4, column: 12, id: 5)
      }
      .render()
      """
      ||
      expanded ==
      """
      let numbers = [1, 2, 3, 4, 5]
      PowerAssert.Assertion(
        "#assert(numbers[2] == 4)",
        message: "",
        file: "TestModule/test.swift",
        line: 2,
        verbose: false,
        equalityExpressions: [(5, 2, 4)],
        identicalExpressions: [],
        comparisonOperands: [4: "4", 2: "numbers[2]"],
        literalExpresions: [(1, 2, 9), (4, 4, 15)]
      ) {
        $0.captureSync($0.captureSync($0.captureSync(numbers.self, column: 1, id: 0)[2] , column: 10, id: 2) == 4, column: 12, id: 5)
      }
      .render()
      """
    )
  }

  func testExpandAssertMacro2() {
    let sourceFile = Parser.parse(
      source: """
        let numbers = [1, 2, 3, 4, 5]
        #assert(numbers.contains(6))
        """
    )
    let macros: [String: any Macro.Type] = [
      "assert": PowerAssertMacro.self,
    ]
    let context = BasicMacroExpansionContext(
      sourceFiles: [sourceFile: .init(moduleName: testModuleName, fullFilePath: testFileName)]
    )

    let expanded = "\(sourceFile.expand(macros: macros, in: context))"
    print(expanded)
    XCTAssertEqual(
      expanded,
      """
      let numbers = [1, 2, 3, 4, 5]
      PowerAssert.Assertion(
        "#assert(numbers.contains(6))",
        message: "",
        file: "TestModule/test.swift",
        line: 2,
        verbose: false,
        equalityExpressions: [],
        identicalExpressions: [],
        comparisonOperands: [:],
        literalExpresions: [(2, 6, 18)]
      ) {
        $0.captureSync($0.captureSync(numbers.self, column: 1, id: 0).contains(6), column: 9, id: 3)
      }
      .render()
      """
    )
  }

  func testExpandAssertMacro3() {
    let sourceFile = Parser.parse(
      source: """
        let string1 = "Hello, world!"
        let string2 = "Hello, Swift!"

        #assert(string1 == string2)
        """
    )
    let macros: [String: any Macro.Type] = [
      "assert": PowerAssertMacro.self,
    ]
    let context = BasicMacroExpansionContext(
      sourceFiles: [sourceFile: .init(moduleName: testModuleName, fullFilePath: testFileName)]
    )

    let expanded = "\(sourceFile.expand(macros: macros, in: context))"
    XCTAssertTrue(
      expanded ==
      """
      let string1 = "Hello, world!"
      let string2 = "Hello, Swift!"

      PowerAssert.Assertion(
        "#assert(string1 == string2)",
        message: "",
        file: "TestModule/test.swift",
        line: 4,
        verbose: false,
        equalityExpressions: [(3, 0, 2)],
        identicalExpressions: [],
        comparisonOperands: [0: "string1", 2: "string2"],
        literalExpresions: []
      ) {
        $0.captureSync($0.captureSync(string1.self , column: 1, id: 0) == $0.captureSync(string2.self, column: 12, id: 2), column: 9, id: 3)
      }
      .render()
      """
      ||
      expanded ==
      """
      let string1 = "Hello, world!"
      let string2 = "Hello, Swift!"

      PowerAssert.Assertion(
        "#assert(string1 == string2)",
        message: "",
        file: "TestModule/test.swift",
        line: 4,
        verbose: false,
        equalityExpressions: [(3, 0, 2)],
        identicalExpressions: [],
        comparisonOperands: [2: "string2", 0: "string1"],
        literalExpresions: []
      ) {
        $0.captureSync($0.captureSync(string1.self , column: 1, id: 0) == $0.captureSync(string2.self, column: 12, id: 2), column: 9, id: 3)
      }
      .render()
      """
    )
  }

  func testExpandAssertMacro4() {
    let sourceFile = Parser.parse(
      source: """
        #assert   (
          numbers
          .

        contains (
          6
        )
          )
        """
    )
    let macros: [String: any Macro.Type] = [
      "assert": PowerAssertMacro.self,
    ]
    let context = BasicMacroExpansionContext(
      sourceFiles: [sourceFile: .init(moduleName: testModuleName, fullFilePath: testFileName)]
    )

    let expanded = "\(sourceFile.expand(macros: macros, in: context))"
    XCTAssertEqual(
      expanded,
      """
      PowerAssert.Assertion(
        "#assert   (numbers . contains ( 6 ))",
        message: "",
        file: "TestModule/test.swift",
        line: 1,
        verbose: false,
        equalityExpressions: [],
        identicalExpressions: [],
        comparisonOperands: [:],
        literalExpresions: [(2,
        6, 29)]
      ) {

        $0.captureSync(
        $0.captureSync(
        numbers.self, column: 8, id: 0)
        .

      contains (
        6
      ), column: 18, id: 3)
      }
      .render()
      """
    )
  }

  func testExpandAssertMacro5() {
    let sourceFile = Parser.parse(
      source: #"""
        #assert(
          """
          0123456789

          9876543210

          """
            .
          isEmpty
        )
        """#
    )
    let macros: [String: any Macro.Type] = [
      "assert": PowerAssertMacro.self,
    ]
    let context = BasicMacroExpansionContext(
      sourceFiles: [sourceFile: .init(moduleName: testModuleName, fullFilePath: testFileName)]
    )

    let expanded = "\(sourceFile.expand(macros: macros, in: context))"
    print(expanded)
    XCTAssertEqual(
      expanded,
      #"""
      PowerAssert.Assertion(
        #"#assert(""" 0123456789\n\n9876543210\n """ . isEmpty)"#,
        message: "",
        file: "TestModule/test.swift",
        line: 1,
        verbose: false,
        equalityExpressions: [],
        identicalExpressions: [],
        comparisonOperands: [:],
        literalExpresions: []
      ) {

        $0.captureSync($0.captureSync("""
        0123456789

        9876543210

        """, column: 8, id: 0)
          .
        isEmpty, column: 45, id: 1)
      }
      .render()
      """#
    )
  }

  func testExpandAssertMacro6() {
    let sourceFile = Parser.parse(
      source: #"""
        let string = "Swift 5.9"

        #assert(
          string
          .
            starts(
              with: "Swift"
                )
          &&
            """
            Swift 5.9
            """
              .contains("Swift")
        )
        """#
    )
    let macros: [String: any Macro.Type] = [
      "assert": PowerAssertMacro.self,
    ]
    let context = BasicMacroExpansionContext(
      sourceFiles: [sourceFile: .init(moduleName: testModuleName, fullFilePath: testFileName)]
    )

    let expanded = "\(sourceFile.expand(macros: macros, in: context))"
    #assert(
      expanded ==
      ##"""
      let string = "Swift 5.9"

      PowerAssert.Assertion(
        #"#assert(string . starts( with: "Swift" ) && """ Swift 5.9 """ .contains("Swift"))"#,
        message: "",
        file: "TestModule/test.swift",
        line: 3,
        verbose: false,
        equalityExpressions: [],
        identicalExpressions: [],
        comparisonOperands: [3: "string . starts( with: \"Swift\" )", 8: "\"\"\" Swift 5.9 \"\"\" .contains(\"Swift\")"],
        literalExpresions: []
      ) {

        $0.captureSync($0.captureSync($0.captureSync(string.self, column: 8, id: 0)
        .
          starts(
            with: $0.captureSync("Swift", column: 31, id: 2)
              ), column: 17, id: 3)
        &&
          $0.captureSync($0.captureSync("""
          Swift 5.9
          """, column: 44, id: 5)
            .contains($0.captureSync("Swift", column: 72, id: 7)), column: 63, id: 8), column: 41, id: 9)
      }
      .render()
      """## ||
      expanded ==
      ##"""
      let string = "Swift 5.9"

      PowerAssert.Assertion(
        #"#assert(string . starts( with: "Swift" ) && """ Swift 5.9 """ .contains("Swift"))"#,
        message: "",
        file: "TestModule/test.swift",
        line: 3,
        verbose: false,
        equalityExpressions: [],
        identicalExpressions: [],
        comparisonOperands: [8: "\"\"\" Swift 5.9 \"\"\" .contains(\"Swift\")", 3: "string . starts( with: \"Swift\" )"],
        literalExpresions: []
      ) {

        $0.captureSync($0.captureSync($0.captureSync(string.self, column: 8, id: 0)
        .
          starts(
            with: $0.captureSync("Swift", column: 31, id: 2)
              ), column: 17, id: 3)
        &&
          $0.captureSync($0.captureSync("""
          Swift 5.9
          """, column: 44, id: 5)
            .contains($0.captureSync("Swift", column: 72, id: 7)), column: 63, id: 8), column: 41, id: 9)
      }
      .render()
      """##
    )
  }
}
