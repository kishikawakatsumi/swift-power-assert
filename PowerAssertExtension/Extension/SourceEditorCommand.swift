import Foundation
import XcodeKit
import SwiftSyntax
import SwiftParser

private let nilLiteral = ExprSyntax(NilLiteralExprSyntax())
private let falseLiteral = ExprSyntax(BooleanLiteralExprSyntax(literal: .keyword(.false)))

class SourceEditorCommand: NSObject, XCSourceEditorCommand {
  func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {
    let selections = invocation.buffer.selections as? [XCSourceTextRange] ?? []

    let sourceFile = Parser.parse(source: invocation.buffer.completeBuffer)
    let locationConverter = SourceLocationConverter(fileName: "", tree: sourceFile)

    let rewriter = PowerAssertRewriter(
      selections: selections,
      locationConverter: locationConverter
    )
    invocation.buffer.completeBuffer = rewriter.rewrite(sourceFile).description

    completionHandler(nil)
  }
}

class PowerAssertRewriter: SyntaxRewriter {
  let selections: [XCSourceTextRange]
  let locationConverter: SourceLocationConverter

  init(selections: [XCSourceTextRange], locationConverter: SourceLocationConverter) {
    self.selections = selections
    self.locationConverter = locationConverter

    super.init()
  }

  override func visit(_ node: FunctionCallExprSyntax) -> ExprSyntax {
    guard node.isContainedIn(selections: selections, locationConverter: locationConverter) else {
      return super.visit(node)
    }

    if let calledExpression = node.calledExpression.as(DeclReferenceExprSyntax.self) {
      switch calledExpression.baseName.tokenKind {
      case .identifier("XCTAssert"):
        return super.visit(node.rewriteAssertTrue())
      case .identifier("XCTAssertEqual"):
        if node.arguments.dropFirst(2).first?.label?.tokenKind == .identifier("accuracy") {
          return super.visit(node)
        }
        return super.visit(node.rewriteComparisonExpression(op: "=="))
      case .identifier("XCTAssertFalse"):
        return super.visit(node.rewriteAssertWithExpression(falseLiteral))
      case .identifier("XCTAssertGreaterThan"):
        return super.visit(node.rewriteComparisonExpression(op: ">"))
      case .identifier("XCTAssertGreaterThanOrEqual"):
        return super.visit(node.rewriteComparisonExpression(op: ">="))
      case .identifier("XCTAssertIdentical"):
        return super.visit(node.rewriteComparisonExpression(op: "==="))
      case .identifier("XCTAssertLessThan"):
        return super.visit(node.rewriteComparisonExpression(op: "<"))
      case .identifier("XCTAssertLessThanOrEqual"):
        return super.visit(node.rewriteComparisonExpression(op: "<="))
      case .identifier("XCTAssertNil"):
        return super.visit(node.rewriteAssertWithExpression(nilLiteral))
      case .identifier("XCTAssertNotEqual"):
        if node.arguments.dropFirst(2).first?.label?.tokenKind == .identifier("accuracy") {
          return super.visit(node)
        }
        return super.visit(node.rewriteComparisonExpression(op: "!="))
      case .identifier("XCTAssertNotIdentical"):
        return super.visit(node.rewriteComparisonExpression(op: "!=="))
      case .identifier("XCTAssertTrue"):
        return super.visit(node.rewriteAssertTrue())
      default:
        break
      }
    }
    return super.visit(node)
  }
}

extension FunctionCallExprSyntax {
  func rewriteAssertTrue() -> Self {
    return with(
      \.calledExpression, ExprSyntax(DeclReferenceExprSyntax(baseName: .identifier("#assert")))
    )
    .with(\.leadingTrivia, leadingTrivia)
  }

  func rewriteAssertWithExpression(_ expression: ExprSyntax) -> Self {
    guard arguments.count >= 1 else {
      return self
    }

    let first = arguments[arguments.startIndex]
    let remaining = arguments.dropFirst(1)

    var arguments = LabeledExprListSyntax(
      arrayLiteral: LabeledExprSyntax(
        expression: InfixOperatorExprSyntax(
          leftOperand: TupleExprSyntax(elements: LabeledExprListSyntax(arrayLiteral: LabeledExprSyntax(expression: first.expression))),
          operator: BinaryOperatorExprSyntax(operator: .binaryOperator("=="))
            .with(\.leadingTrivia, .space)
            .with(\.trailingTrivia, .space),
          rightOperand: expression
        ),
        trailingComma: remaining.isEmpty ? .identifier("") : .commaToken(trailingTrivia: .space)
      )
    )

    for argument in remaining {
      arguments.insert(argument, at: arguments.endIndex)
    }

    return with(
      \.calledExpression, ExprSyntax(DeclReferenceExprSyntax(baseName: .identifier("#assert")))
    )
    .with(\.arguments, arguments)
    .with(\.leadingTrivia, leadingTrivia)
  }

  func rewriteComparisonExpression(op: String) -> Self {
    guard arguments.count >= 2 else {
      return self
    }

    let first = arguments[arguments.startIndex]
    let second = arguments[arguments.index(arguments.startIndex, offsetBy: 1)]

    let remainingArguments = arguments.dropFirst(2)

    var arguments = LabeledExprListSyntax(
      arrayLiteral: LabeledExprSyntax(
        expression: InfixOperatorExprSyntax(
          leftOperand: first.expression,
          operator: BinaryOperatorExprSyntax(operator: .binaryOperator(op))
            .with(\.leadingTrivia, .space)
            .with(\.trailingTrivia, .space),
          rightOperand: second.expression
        ),
        trailingComma: remainingArguments.isEmpty ? .identifier("") : .commaToken(trailingTrivia: .space)
      )
    )

    for argument in remainingArguments {
      arguments.insert(argument, at: arguments.endIndex)
    }

    return with(
      \.calledExpression, ExprSyntax(DeclReferenceExprSyntax(baseName: .identifier("#assert")))
    )
    .with(\.arguments, arguments)
    .with(\.leadingTrivia, leadingTrivia)
  }
}

extension SyntaxProtocol {
  func isContainedIn(selections: [XCSourceTextRange], locationConverter: SourceLocationConverter) -> Bool {
    if selections.allSatisfy({  $0.start.line == $0.end.line && $0.start.column == $0.end.column }) {
      return true
    }

    if !selections.isEmpty {
      for selection in selections {
        let startLocation = startLocation(converter: locationConverter)
        let endLocation = endLocation(converter: locationConverter)

        let startLine = startLocation.line - 1
        let endLine = endLocation.line - 1

        let startColumn = locationConverter.sourceLines[startLocation.line].prefix(startLocation.column).utf16.count
        let endColumn = locationConverter.sourceLines[endLocation.line].prefix(endLocation.column).utf16.count

        if startLine >= selection.start.line && endLine <= selection.end.line {
          if startLine == selection.start.line && startColumn < selection.start.column {
            continue
          }
          if endLine == selection.end.line && endColumn > selection.end.column {
            continue
          }
          return true
        } else {
          continue
        }
      }
    }

    return false
  }
}
