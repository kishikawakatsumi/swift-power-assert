import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftOperators
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

private class PowerAssertRewriter: SyntaxRewriter {
  private let expression: SyntaxProtocol
  private let sourceLocationConverter: SourceLocationConverter
  private let startColumn: Int

  init(macro: FreestandingMacroExpansionSyntax, expression: SyntaxProtocol) {
    let startLocation = macro.startLocation(converter: SourceLocationConverter(file: "", tree: macro))
    let endLocation = macro.macro.endLocation(converter: SourceLocationConverter(file: "", tree: macro))
    startColumn = endLocation.column! - startLocation.column!

    if let folded = try? OperatorTable.standardOperators.foldAll(expression) {
      self.expression = folded
    } else {
      self.expression = expression
    }

    self.sourceLocationConverter = SourceLocationConverter(file: "", tree: expression)
  }

  func rewrite() -> SyntaxProtocol {
    visit(expression.cast(SourceFileSyntax.self))
  }

  override func visit(_ node: ArrayExprSyntax) -> ExprSyntax {
    let startLocation = node.startLocation(converter: sourceLocationConverter)
    let visitedNode = super.visit(node)
    return apply(ExprSyntax(visitedNode), column: startLocation.column!)
  }

  override func visit(_ node: BooleanLiteralExprSyntax) -> ExprSyntax {
    let startLocation = node.startLocation(converter: sourceLocationConverter)
    let visitedNode = super.visit(node)
    return apply(ExprSyntax(visitedNode), column: startLocation.column!)
  }

  override func visit(_ node: DictionaryExprSyntax) -> ExprSyntax {
    let startLocation = node.startLocation(converter: sourceLocationConverter)
    let visitedNode = super.visit(node)
    return apply(ExprSyntax(visitedNode), column: startLocation.column!)
  }

  override func visit(_ node: FloatLiteralExprSyntax) -> ExprSyntax {
    let startLocation = node.startLocation(converter: sourceLocationConverter)
    let visitedNode = super.visit(node)
    return apply(ExprSyntax(visitedNode), column: startLocation.column!)
  }

  override func visit(_ node: ForcedValueExprSyntax) -> ExprSyntax {
    let startLocation = node.startLocation(converter: sourceLocationConverter)
    let visitedNode = super.visit(node)
    return apply(ExprSyntax(visitedNode), column: startLocation.column!)
  }

  override func visit(_ node: FunctionCallExprSyntax) -> ExprSyntax {
    let startLocation: SourceLocation
    if let function = node.calledExpression.children(viewMode: .fixedUp).last {
      startLocation = function.startLocation(converter: sourceLocationConverter)
    } else {
      startLocation = node.startLocation(converter: sourceLocationConverter)
    }
    let visitedNode = super.visit(node)
    return apply(ExprSyntax(visitedNode), column: startLocation.column!)
  }

  override func visit(_ node: IdentifierExprSyntax) -> ExprSyntax {
    if case .binaryOperator = node.identifier.tokenKind {
      return super.visit(node)
    }
    guard let parent = node.parent, parent.syntaxNodeType != FunctionCallExprSyntax.self else {
      return super.visit(node)
    }
    let startLocation = node.startLocation(converter: sourceLocationConverter)
    let visitedNode = super.visit(node)
    return apply(ExprSyntax("\(visitedNode).self").with(\.leadingTrivia, visitedNode.leadingTrivia).with(\.trailingTrivia, visitedNode.trailingTrivia), column: startLocation.column!)
  }

  override func visit(_ node: InfixOperatorExprSyntax) -> ExprSyntax {
    let startLocation = node.operatorOperand.startLocation(converter: sourceLocationConverter)
    let visitedNode = super.visit(node)
    return apply(ExprSyntax(visitedNode), column: startLocation.column!)
  }

  override func visit(_ node: IntegerLiteralExprSyntax) -> ExprSyntax {
    let startLocation = node.startLocation(converter: sourceLocationConverter)
    let visitedNode = super.visit(node)
    return apply(ExprSyntax(visitedNode), column: startLocation.column!)
  }

  override func visit(_ node: KeyPathExprSyntax) -> ExprSyntax {
    let startLocation = node.startLocation(converter: sourceLocationConverter)
    let visitedNode = super.visit(node)
    return apply(ExprSyntax(visitedNode), column: startLocation.column!)
  }

  override func visit(_ node: MacroExpansionExprSyntax) -> ExprSyntax {
    let startLocation = node.startLocation(converter: sourceLocationConverter)
    let visitedNode = super.visit(node)
    return apply(ExprSyntax(visitedNode), column: startLocation.column!)
  }

  override func visit(_ node: MemberAccessExprSyntax) -> ExprSyntax {
    guard let parent = node.parent, parent.syntaxNodeType != FunctionCallExprSyntax.self  else {
      return super.visit(node)
    }
    let startLocation = node.name.startLocation(converter: sourceLocationConverter)
    let visitedNode = super.visit(node)
    if let optionalChainingExpr = findDescendants(syntaxType: OptionalChainingExprSyntax.self, node: node) {
      return ExprSyntax("\(apply(ExprSyntax(visitedNode), column: startLocation.column!))\(optionalChainingExpr.questionMark)")
    } else {
      return apply(ExprSyntax(visitedNode), column: startLocation.column!)
    }
  }

  override func visit(_ node: NilLiteralExprSyntax) -> ExprSyntax {
    let startLocation = node.startLocation(converter: sourceLocationConverter)
    let visitedNode = super.visit(node)
    return apply(ExprSyntax(visitedNode), column: startLocation.column!)
  }

  override func visit(_ node: OptionalChainingExprSyntax) -> ExprSyntax {
    let visitedNode = super.visit(node)
    return visitedNode
  }

  override func visit(_ node: PrefixOperatorExprSyntax) -> ExprSyntax {
    let startLocation = node.startLocation(converter: sourceLocationConverter)
    let visitedNode = super.visit(node)
    return apply(ExprSyntax(visitedNode), column: startLocation.column!)
  }

  override func visit(_ node: SequenceExprSyntax) -> ExprSyntax {
    guard let binaryOperatorExpr = findDescendants(syntaxType: BinaryOperatorExprSyntax.self, node: Syntax(node)) else  {
      return super.visit(node)
    }
    let startLocation = binaryOperatorExpr.startLocation(converter: sourceLocationConverter)
    let visitedNode = super.visit(node)
    return apply(ExprSyntax(visitedNode), column: startLocation.column!)
  }

  override func visit(_ node: StringLiteralExprSyntax) -> ExprSyntax {
    let startLocation = node.startLocation(converter: sourceLocationConverter)
    let visitedNode = super.visit(node)
    return apply(ExprSyntax(visitedNode), column: startLocation.column!)
  }

  override func visit(_ node: SubscriptExprSyntax) -> ExprSyntax {
    let startLocation = node.rightBracket.startLocation(converter: sourceLocationConverter)
    let visitedNode = super.visit(node)
    return apply(ExprSyntax(visitedNode), column: startLocation.column!)
  }

  override func visit(_ node: TernaryExprSyntax) -> ExprSyntax {
    let startLocation = node.startLocation(converter: sourceLocationConverter)
    let visitedNode = super.visit(node)
    return apply(ExprSyntax(visitedNode), column: startLocation.column!)
  }

  override func visit(_ node: TupleExprSyntax) -> ExprSyntax {
    let startLocation = node.startLocation(converter: sourceLocationConverter)
    let visitedNode = super.visit(node)
    return apply(ExprSyntax(visitedNode), column: startLocation.column!)
  }

  private func apply(_ node: ExprSyntax, column: Int) -> ExprSyntax {
    return FunctionCallExprSyntax(
      leadingTrivia: node.leadingTrivia,
      calledExpression: IdentifierExprSyntax(identifier: TokenSyntax(.identifier("$0.capture"), presence: .present)),
      leftParen: TokenSyntax.leftParenToken(),
      argumentList: TupleExprElementListSyntax([
        TupleExprElementSyntax(
          expression: node.with(\.leadingTrivia, []).with(\.trailingTrivia, []),
          trailingComma: TokenSyntax.commaToken(),
          trailingTrivia: Trivia.space
        ),
        TupleExprElementSyntax(
          label: TokenSyntax.identifier("column"),
          colon: TokenSyntax.colonToken().with(\.trailingTrivia, .space),
          expression: IntegerLiteralExprSyntax(digits: TokenSyntax.integerLiteral("\(column + startColumn)"))
        ),
      ]),
      rightParen: TokenSyntax.rightParenToken(),
      trailingTrivia: node.trailingTrivia
    )
    .cast(ExprSyntax.self)
  }

  private func findAncestors<T: SyntaxProtocol>(syntaxType: T.Type, node: SyntaxProtocol) -> T? {
    let node = node.parent
    var cur: Syntax? = node
    while let node = cur {
      if node.syntaxNodeType == syntaxType.self {
        return node.as(syntaxType)
      }
      cur = node.parent
    }
    return nil
  }

  private func findDescendants<T: SyntaxProtocol>(syntaxType: T.Type, node: SyntaxProtocol) -> T? {
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

    let rewriter = PowerAssertRewriter(macro: macro, expression: expression)

    return """
      PowerAssert.Assertion(\(assertion), message: \(message), file: \(file), line: \(line), verbose: \(verbose)) {
        \(rewriter.rewrite())
      }
      .render()
      """
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
