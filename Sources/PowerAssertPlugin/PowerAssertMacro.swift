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
    guard let assertion = macro.argumentList.first?.expression else {
      return ExprSyntax("()").with(\.leadingTrivia, macro.leadingTrivia)
    }

    let formatted = format(assertion)
    let expanded = expand(expression: formatted)

    let assertSyntax = ExprSyntax(stringLiteral: expanded)
    return assertSyntax.with(\.leadingTrivia, macro.leadingTrivia)
  }

  private func format(_ expression: some SyntaxProtocol) -> SyntaxProtocol {
    let formatted = expression.tokens(viewMode: .fixedUp)
      .map {
        "\($0.leadingTrivia)"
          .split(separator: "\n")
          .joined(separator: " ")
          .removingExtraWhitespaces()
        + "\($0.text)"
        + "\($0.trailingTrivia)"
          .split(separator: "\n")
          .joined(separator: " ")
          .removingExtraWhitespaces()
      }
      .joined()
      .trimmingCharacters(in: .whitespacesAndNewlines)
    return SourceFileSyntax(stringLiteral: "\(formatted)"
    )
  }

  private func parseExpression(_ expression: SyntaxProtocol, storage: inout [Syntax]) {
    let children = expression.children(viewMode: .fixedUp)
    for child in children {
      if child.syntaxNodeType == TokenSyntax.self {
        continue
      }
      if child.syntaxNodeType == ClosureExprSyntax.self {
        continue
      }
      storage.append(child)
      parseExpression(child, storage: &storage)
    }
  }

  private func expand(expression: SyntaxProtocol) -> String {
    var message = ""
    var file: String?
    var line: String?
    var verbose: String? = "false"

    for argument in macro.argumentList.dropFirst() {
      if argument.label == nil {
        message = "\(argument.expression)"
      }
      if argument.label?.text == "file" {
        file = "\(argument.expression)"
      }
      if argument.label?.text == "line" {
        line = "\(argument.expression)"
      }
      if argument.label?.text == "verbose" {
        verbose = "\(argument.expression)"
      }
    }

    var expressions = [Syntax]()
    parseExpression(expression, storage: &expressions)
    expressions = Array(expressions.dropFirst(2))

    let sourceLoccation: AbstractSourceLocation? = context.location(of: macro)

    let startLocation = macro.startLocation(converter: SourceLocationConverter(file: "", tree: macro))
    let endLocation = macro.macro.endLocation(converter: SourceLocationConverter(file: "", tree: macro))

    let converter = SourceLocationConverter(file: "", tree: expression)
    let startColumn = endLocation.column! - startLocation.column!

    let assertionLiteral = StringLiteralExprSyntax(
      content: "\(macro.poundToken.with(\.leadingTrivia, []).with(\.trailingTrivia, []))\(macro.macro)(\(expression))"
    )

    let messageLiteral = StringLiteralExprSyntax(content: message)

    let filePath: StringLiteralExprSyntax
    if let file {
      filePath = StringLiteralExprSyntax(content: file)
    } else {
      filePath = StringLiteralExprSyntax(content: "\(sourceLoccation!.file)")
    }

    let lineNumber: String
    if let line {
      lineNumber = line
    } else {
      lineNumber = "\(sourceLoccation!.line)"
    }

    return """
    PowerAssert.Assertion(\(assertionLiteral), message: \(messageLiteral), file: \(filePath), line: \(lineNumber), verbose: \(verbose!))
    .assert(\(expressions.first!))
    \(
      expressions
        .enumerated()
        .reduce("") { (result, enumerated) in
          let index = enumerated.offset
          let syntax = enumerated.element

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
          if syntaxType == IdentifierExprSyntax.self {
            if syntax.parent?.syntaxNodeType == FunctionCallExprSyntax.self {
              return result
            }
            let tokens = syntax.tokens(viewMode: .fixedUp).map { $0 }
            if tokens.count == 1 {
                if case .binaryOperator = tokens[0].tokenKind {
                  return result
                }
            }
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
          if syntaxType == FunctionCallExprSyntax.self, let tryExpr = findLeft(syntaxType: TryExprSyntax.self, start: index, in: expressions) {
            let tryOperator = "\(tryExpr.tryKeyword)\(tryExpr.questionOrExclamationMark?.description ?? "")"
            return result + ".capture(expression: \(tryOperator)\(syntax.with(\.leadingTrivia, []).with(\.trailingTrivia, [])), column: \(column))"
          }
          if syntaxType == IdentifierExprSyntax.self {
            return result + ".capture(expression: \(syntax.with(\.leadingTrivia, []).with(\.trailingTrivia, [])).self, column: \(column))"
          }
          if syntaxType == MemberAccessExprSyntax.self, let memberAccessExpr = syntax.as(MemberAccessExprSyntax.self) {
            guard let _ = memberAccessExpr.base else {
              return result
            }
            if let _ = findAncestors(syntaxType: MacroExpansionExprSyntax.self, node: syntax) {
              return result
            }
            let column = graphemeColumn(syntax: memberAccessExpr.name, expression: expression, converter: converter) + startColumn
            if let parent = syntax.parent, parent.syntaxNodeType == FunctionCallExprSyntax.self {
              if let tryExpr = findLeft(syntaxType: TryExprSyntax.self, start: index, in: expressions) {
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
          if let memberAccessExpr = findDescendants(syntaxType: MemberAccessExprSyntax.self, node: syntax) {
            guard let _ = memberAccessExpr.base else {
              return result
            }
          }

          return result + ".capture(expression: \(syntax.with(\.leadingTrivia, []).with(\.trailingTrivia, [])), column: \(column))"
        }
    )
    .render()
    """
      .split(separator: "\n")
      .joined()
  }

  private func findLeft<T: SyntaxProtocol>(syntaxType: T.Type, start: Int, in expressions: [Syntax]) -> T? {
    for index in (0..<start).reversed() {
      if expressions[index].syntaxNodeType == syntaxType {
        return expressions[index].as(T.self)
      }
    }
    return nil
  }

  private func findAncestors<T: SyntaxProtocol>(syntaxType: T.Type, node: Syntax) -> T? {
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

  private func findDescendants<T: SyntaxProtocol>(syntaxType: T.Type, node: Syntax) -> T? {
    let children = node.children(viewMode: .fixedUp)
    for child in children {
      if child.syntaxNodeType == TokenSyntax.self {
        continue
      }
      if child.syntaxNodeType == syntaxType.self {
        return child.as(syntaxType)
      }
      if let found = findDescendants(syntaxType: syntaxType, node: child) {
        return found.as(syntaxType)
      }
    }
    return nil
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

private extension String {
  func removingExtraWhitespaces() -> String {
    var result = ""
    var previousCharIsSpace = false

    for char in self {
      if char == " " {
        if !previousCharIsSpace {
          result.append(char)
        }
        previousCharIsSpace = true
      } else {
        result.append(char)
        previousCharIsSpace = false
      }
    }

    return result
  }
}
