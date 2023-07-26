import SwiftSyntax
import SwiftSyntaxMacros

public struct PowerAssertMacro: ExpressionMacro {
  public static var formatMode: FormatMode = .disabled
  
  public static func expansion(
    of node: some FreestandingMacroExpansionSyntax,
    in context: some MacroExpansionContext
  ) -> ExprSyntax {
    let generator = CodeGenerator(macro: node, context: context)
    return generator.generate()
  }
}

private struct CodeGenerator {
  let macro: any FreestandingMacroExpansionSyntax
  let context: any MacroExpansionContext

  func generate() -> ExprSyntax {
    guard let assertion = macro.argumentList.first?.expression else {
      return ExprSyntax("()").with(\.leadingTrivia, macro.leadingTrivia)
    }

    let expanded = expand(
      expression: assertion,
      parameters: Parameters(macro: macro, context: context)
    )

    let syntax = ExprSyntax(stringLiteral: expanded)
    return syntax.with(\.leadingTrivia, macro.leadingTrivia)
  }

  private func expand(expression: some SyntaxProtocol, parameters: Parameters) -> String {
    let assertion = StringLiteralExprSyntax(
      content: "\(macro.poundToken.trimmed)\(macro.macro.trimmed)(\(SingleLineFormatter().format(expression)))"
    )
    let message = parameters.message
    let file = parameters.file
    let line = parameters.line
    let verbose = parameters.verbose

    let rewriter = PowerAssertRewriter(SourceFileSyntax("\(expression)"), macro: macro)
    let captures = rewriter.rewrite()

    return """
      \(rewriter.isAwaitPresent ? "await " : "")PowerAssert.Assertion(
        \(assertion),
        message: \(message),
        file: \(file),
        line: \(line),
        verbose: \(verbose),
        equalityExpressions: \(rewriter.equalityExpressions()),
        identicalExpressions: \(rewriter.identicalExpressions()),
        comparisonOperands: \(rewriter.comparisonOperands()),
        literalExpresions: \(rewriter.literalExpressions())
      ) {
      \(captures)
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

  init(macro: some FreestandingMacroExpansionSyntax, context: some MacroExpansionContext) {
    let sourceLocation: AbstractSourceLocation? = context.location(of: macro)

    let file = "\(sourceLocation!.file)"
    self.file = "\(file)"
    self.line = "\(sourceLocation!.line)"

    for argument in macro.argumentList.dropFirst() {
      if argument.label == nil {
        let message = "\(argument.expression)"
        self.message = "\(StringLiteralExprSyntax(content: message))"
      }

      if argument.label?.text == "file" {
        self.file = "\(argument.expression)"
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
