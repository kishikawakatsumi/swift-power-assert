import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import StringWidth

public struct PowerAssertMacro: ExpressionMacro {
  public static func expansion(
    of node: some FreestandingMacroExpansionSyntax,
    in context: some MacroExpansionContext
  ) -> ExprSyntax {
    let generator = CodeGenerator(macro: node, context: context)
    return generator.generate()
  }
}

private struct CodeGenerator {
  let macro: FreestandingMacroExpansionSyntax
  let context: MacroExpansionContext

  func generate() -> ExprSyntax {
    guard let expression = macro.argumentList.first else {
      if let leadingTrivia = macro.leadingTrivia {
        return ExprSyntax("()").with(\.leadingTrivia, leadingTrivia)
      }
      return "()"
    }

    let formatted = format(expression)
    let expanded = expand(expression: formatted)

    let assertSyntax = ExprSyntax(stringLiteral: expanded)
    if let leadingTrivia = macro.leadingTrivia {
      return assertSyntax.with(\.leadingTrivia, leadingTrivia)
    }
    return assertSyntax
  }

  private func format(_ expression: some SyntaxProtocol) -> SyntaxProtocol {
    SourceFileSyntax(stringLiteral: "\(expression.with(\.leadingTrivia, []).with(\.trailingTrivia, []))"
      .split(separator: "\n")
      .joined(separator: " ")
      .split(separator: " ")
      .joined(separator: " ")
    )
  }

  private func parseExpression(_ expression: SyntaxProtocol, storage: inout [Syntax]) {
    let children = expression.children(viewMode: .fixedUp)
    for child in children {
      if child.syntaxNodeType == TokenSyntax.self {
        continue
      }
      storage.append(child)
      parseExpression(child, storage: &storage)
    }
  }

  private func findInAncestor<T: SyntaxProtocol>(syntaxType: T.Type, node: Syntax) -> T? {
    let node = node.parent
    var cur: Syntax? = node
    while let node = cur {
      if node.syntaxNodeType == syntaxType {
        return node.as(syntaxType)
      }
      cur = node.parent
    }
    return nil
  }

  private func expand(expression: SyntaxProtocol) -> String {
    var expressions = [Syntax]()
    parseExpression(expression, storage: &expressions)
    expressions = Array(expressions.dropFirst(2))

    let startLocation = macro.startLocation(converter: SourceLocationConverter(file: "", tree: macro))
    let endLocation = macro.macro.endLocation(converter: SourceLocationConverter(file: "", tree: macro))

    let converter = SourceLocationConverter(file: "", tree: expression)
    let startColumn = endLocation.column! - startLocation.column!

    return """
    PowerAssert.Assertion(##"\(macro.poundToken.with(\.leadingTrivia, []).with(\.trailingTrivia, []))\(macro.macro)(\(expression))"##, line: \(startLocation.line!))
    .assert(\(expressions.first!))
    \(
      expressions
        .reduce("") { (result, syntax) in
          let column = graphemeColumn(syntax: syntax, expression: expression, converter: converter) + startColumn
          let syntaxType = syntax.syntaxNodeType
          if syntaxType == ArrayElementListSyntax.self
            || syntaxType == ArrayElementSyntax.self
            || syntaxType == AsExprSyntax.self
            || syntaxType == DeclNameArgumentListSyntax.self
            || syntaxType == DeclNameArgumentsSyntax.self
            || syntaxType == DeclNameArgumentSyntax.self
            || syntaxType == DictionaryElementListSyntax.self
            || syntaxType == DictionaryElementSyntax.self
            || syntaxType == ExprListSyntax.self
            || syntaxType == KeyPathComponentListSyntax.self
            || syntaxType == KeyPathComponentSyntax.self
            || syntaxType == KeyPathOptionalComponentSyntax.self
            || syntaxType == KeyPathPropertyComponentSyntax.self
            || syntaxType == NilLiteralExprSyntax.self
            || syntaxType == OptionalChainingExprSyntax.self
            || syntaxType == SequenceExprSyntax.self
            || syntaxType == SimpleTypeIdentifierSyntax.self
            || syntaxType == StringLiteralSegmentsSyntax.self
            || syntaxType == StringSegmentSyntax.self
            || syntaxType == SuperRefExprSyntax.self
            || syntaxType == TryExprSyntax.self
            || syntaxType == TupleExprElementListSyntax.self
            || syntaxType == TupleExprElementSyntax.self
            || syntaxType == TypeExprSyntax.self
            || syntaxType == UnresolvedAsExprSyntax.self
            || syntaxType == UnresolvedTernaryExprSyntax.self
          {
            return result
          }
          if let parent = syntax.parent, parent.syntaxNodeType == MacroExpansionExprSyntax.self {
            return result
          }
          if syntaxType == FunctionCallExprSyntax.self,
            let child = syntax.children(viewMode: .fixedUp).first,
            child.syntaxNodeType == MemberAccessExprSyntax.self
          {
            return result
          }
          if syntaxType == IdentifierExprSyntax.self && syntax.parent?.syntaxNodeType == FunctionCallExprSyntax.self {
            return result
          }
          if syntaxType == KeyPathExprSyntax.self, let keyPathExpr = syntax.as(KeyPathExprSyntax.self) {
            guard let _ = keyPathExpr.root else {
              return result
            }
          }
          if syntaxType == ArrayTypeSyntax.self {
            return result + ".capture(expression: \(syntax.with(\.leadingTrivia, []).with(\.trailingTrivia, [])).self, column: \(column))"
          }
          if syntaxType == BinaryOperatorExprSyntax.self, let binaryOperatorExpr = syntax.as(BinaryOperatorExprSyntax.self) {
            let op = binaryOperatorExpr.operatorToken.text
            if op == "==" || op == "!=" || op == ">" || op == "<" || op == "=>" || op == "=<" || op == "&&" || op == "||" {
              return result + ".capture(expression: \(syntax.parent!.with(\.leadingTrivia, []).with(\.trailingTrivia, [])), column: \(column))"
            } else {
              return result
            }
          }
          if syntaxType == DictionaryTypeSyntax.self {
            return result + ".capture(expression: \(syntax.with(\.leadingTrivia, []).with(\.trailingTrivia, [])).self, column: \(column))"
          }
          if syntaxType == FunctionCallExprSyntax.self, let tryExpr = findInAncestor(syntaxType: TryExprSyntax.self, node: syntax) {
            let tryOperator = "\(tryExpr.tryKeyword)\(tryExpr.questionOrExclamationMark?.description ?? "")"
            return result + ".capture(expression:  \(tryOperator)\(syntax.with(\.leadingTrivia, []).with(\.trailingTrivia, [])), column: \(column))"
          }
          if syntaxType == IdentifierExprSyntax.self {
            return result + ".capture(expression: \(syntax.with(\.leadingTrivia, []).with(\.trailingTrivia, [])).self, column: \(column))"
          }
          if syntaxType == MemberAccessExprSyntax.self, let memberAccessExpr = syntax.as(MemberAccessExprSyntax.self) {
            guard let _ = memberAccessExpr.base else {
              return result
            }
            let column = graphemeColumn(syntax: memberAccessExpr.name, expression: expression, converter: converter) + startColumn
            if let parent = syntax.parent, parent.syntaxNodeType == FunctionCallExprSyntax.self {
              if let tryExpr = findInAncestor(syntaxType: TryExprSyntax.self, node: parent) {
                let tryOperator = "\(tryExpr.tryKeyword)\(tryExpr.questionOrExclamationMark?.description ?? "")"
                return result + ".capture(expression: \(tryOperator)\(parent.with(\.leadingTrivia, []).with(\.trailingTrivia, [])), column: \(column))"
              }
              return result + ".capture(expression: \(parent.with(\.leadingTrivia, []).with(\.trailingTrivia, [])), column: \(column))"
            }
            return result + ".capture(expression: \(syntax.with(\.leadingTrivia, []).with(\.trailingTrivia, [])).self, column: \(column))"
          }
          if syntaxType == SubscriptExprSyntax.self, let subscriptExpr = syntax.as(SubscriptExprSyntax.self) {
            let column = graphemeColumn(syntax: subscriptExpr.rightBracket, expression: expression, converter: converter) + startColumn
            return result + ".capture(expression: \(syntax.with(\.leadingTrivia, []).with(\.trailingTrivia, [])), column: \(column))"
          }
          return result + ".capture(expression: \(syntax.with(\.leadingTrivia, []).with(\.trailingTrivia, [])), column: \(column))"
        }
    )
    .render()
    """
      .split(separator: "\n")
      .joined()
  }

  private func graphemeColumn(syntax: SyntaxProtocol, expression: SyntaxProtocol, converter: SourceLocationConverter) -> Int {
    let startLocation = syntax.startLocation(converter: converter)
    let column: Int
    if let graphemeClusters = String("\(expression)".utf8.prefix(startLocation.column!)) {
      column = stringWidth(graphemeClusters)
    } else {
      column = startLocation.column!
    }
    return column
  }
}
