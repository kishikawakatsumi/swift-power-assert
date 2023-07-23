import XCTest
import SwiftSyntax
import SwiftSyntaxMacros
import SwiftParser
@testable import PowerAssert
@testable import PowerAssertPlugin

final class SyntaxTreeTests: XCTestCase {
  func testIdenticalStrings() {
    let a = """
      bar.val == bar.foo.val
      """
    let b = """
      bar
        .val ==
        bar.foo.val
      """

    var aa = [Syntax]()
    flatten(Parser.parse(source: a), storage: &aa)

    var ba = [Syntax]()
    flatten(Parser.parse(source: b), storage: &ba)

    var bba = [Syntax]()
    let bb = SingleLineFormatter(Parser.parse(source: b)).format()
    flatten(bb, storage: &bba)

    let assert = PowerAssertRewriter(Parser.parse(source: b), macro: MacroExpansionExprSyntax(macro: .poundToken(), argumentList: [])).rewrite()

    print(aa.count)
    print(ba.count)
    print(bba.count)
  }
}

func flatten(_ syntax: some SyntaxProtocol, storage: inout [Syntax]) {
  for child in syntax.children(viewMode: .fixedUp) {
    storage.append(child)
    let children = child.children(viewMode: .fixedUp)
    if !children.isEmpty {
      flatten(child, storage: &storage)
    }
  }
}
