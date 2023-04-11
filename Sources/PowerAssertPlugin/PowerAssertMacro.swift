import SwiftSyntax
import SwiftSyntaxMacros

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

    let expanded = expand(
      expression: format(assertion),
      parameters: Parameters(macro: macro, context: context)
    )

    let syntax = ExprSyntax(stringLiteral: expanded)
    return syntax.with(\.leadingTrivia, macro.leadingTrivia)
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
    return SourceFileSyntax(stringLiteral: "\(formatted)")
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

  private func expand(expression: SyntaxProtocol, parameters: Parameters) -> String {
    var expressions = [Syntax]()
    parseExpression(expression, storage: &expressions)
    expressions = Array(expressions.dropFirst(2))

    let assertion = StringLiteralExprSyntax(
      content: "\(macro.poundToken.with(\.leadingTrivia, []).with(\.trailingTrivia, []))\(macro.macro)(\(expression))"
    )
    let message = parameters.message
    let file = parameters.file
    let line = parameters.line
    let verbose = parameters.verbose

    let rewriter = PowerAssertRewriter(expression: expression, macro: macro)

    return """
      PowerAssert.Assertion(\(assertion), message: \(message), file: \(file), line: \(line), verbose: \(verbose)) {
        \(rewriter.rewrite())
      }
      .render()
      """
  }
}

private struct Parameters {
  var message = "\(StringLiteralExprSyntax(content: ""))"
  var file: String
  var line: String
  var verbose = "false"

  init(macro: FreestandingMacroExpansionSyntax, context: MacroExpansionContext) {
    let sourceLoccation: AbstractSourceLocation? = context.location(of: macro)

    let file = StringLiteralExprSyntax(content: "\(sourceLoccation!.file)")
    self.file = "\(file)"
    self.line = "\(sourceLoccation!.line)"

    for argument in macro.argumentList.dropFirst() {
      if argument.label == nil {
        let message = "\(argument.expression)"
        self.message = "\(StringLiteralExprSyntax(content: message))"
      }

      if argument.label?.text == "file" {
        let file = "\(argument.expression)"
        self.file = "\(StringLiteralExprSyntax(content: file))"
      }
      if argument.label?.text == "line" {
        self.line = "\(argument.expression)"
      }
      if argument.label?.text == "verbose" {
        self.verbose = "\(argument.expression)"
      }
    }
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
