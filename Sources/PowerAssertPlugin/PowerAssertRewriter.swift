import SwiftSyntax
import SwiftOperators
import StringWidth

class PowerAssertRewriter: SyntaxRewriter {
  private let expression: SyntaxProtocol
  private let sourceLocationConverter: SourceLocationConverter
  private let startColumn: Int
  private let isTryPresent: Bool
  let isAwaitPresent: Bool

  private var index = 0
  private let expressionStore = ExpressionStore()

  init(_ expression: SyntaxProtocol, macro: FreestandingMacroExpansionSyntax) {
    if let folded = try? OperatorTable.standardOperators.foldAll(expression) {
      self.expression = folded
    } else {
      self.expression = expression
    }

    self.sourceLocationConverter = SourceLocationConverter(file: "", tree: expression)

    let startLocation = macro.startLocation(converter: SourceLocationConverter(file: "", tree: macro))
    let endLocation = macro.macro.endLocation(converter: SourceLocationConverter(file: "", tree: macro))
    startColumn = endLocation.column - startLocation.column

    let tokens = expression.tokens(viewMode: .fixedUp).map { $0 }
    isTryPresent = tokens.contains { $0.tokenKind == .keyword(.try) }
    isAwaitPresent = tokens.contains { $0.tokenKind == .keyword(.await) }
  }

  func rewrite() -> String {
    "\(isTryPresent ? "try " : "")\(visit(expression.cast(SourceFileSyntax.self)))"
  }

  func comparisons() -> String {
    expressionStore
      .expressions(of: .comparison)
      .reduce(into: [Int: String]()) {
        $0[$1.id] = "\($1.node.with(\.leadingTrivia, []).with(\.trailingTrivia, []))"
      }
      .description
  }

  override func visit(_ node: ArrowExprSyntax) -> ExprSyntax {
    return super.visit(node)
  }

  override func visit(_ node: ArrayExprSyntax) -> ExprSyntax {
    let column = graphemeColumn(node)
    return apply(ExprSyntax(super.visit(node)), column: column)
  }

  override func visit(_ node: AsExprSyntax) -> ExprSyntax {
    let column = graphemeColumn(node.asTok)
    return apply(ExprSyntax(super.visit(node)), column: column)
  }

  override func visit(_ node: AssignmentExprSyntax) -> ExprSyntax {
    return super.visit(node)
  }

  override func visit(_ node: AwaitExprSyntax) -> ExprSyntax {
    return super.visit(node)
  }

  override func visit(_ node: BinaryOperatorExprSyntax) -> ExprSyntax {
    return super.visit(node)
  }

  override func visit(_ node: BooleanLiteralExprSyntax) -> ExprSyntax {
    let column = graphemeColumn(node)
    return apply(ExprSyntax(super.visit(node)), column: column)
  }

  override func visit(_ node: BorrowExprSyntax) -> ExprSyntax {
    return super.visit(node)
  }

  override func visit(_ node: ClosureExprSyntax) -> ExprSyntax {
    return ExprSyntax(node)
  }

  override func visit(_ node: DictionaryExprSyntax) -> ExprSyntax {
    let column = graphemeColumn(node)
    return apply(ExprSyntax(super.visit(node)), column: column)
  }

  override func visit(_ node: DiscardAssignmentExprSyntax) -> ExprSyntax {
    return super.visit(node)
  }

  override func visit(_ node: EditorPlaceholderExprSyntax) -> ExprSyntax {
    return super.visit(node)
  }

  override func visit(_ node: FloatLiteralExprSyntax) -> ExprSyntax {
    let column = graphemeColumn(node)
    return apply(ExprSyntax(super.visit(node)), column: column)
  }

  override func visit(_ node: ForcedValueExprSyntax) -> ExprSyntax {
    let column = graphemeColumn(node)
    return apply(ExprSyntax(super.visit(node)), column: column)
  }

  override func visit(_ node: FunctionCallExprSyntax) -> ExprSyntax {
    let column: Int
    if let function = node.calledExpression.children(viewMode: .fixedUp).last {
      column = graphemeColumn(function)
    } else {
      column = graphemeColumn(node)
    }
    return apply(ExprSyntax(super.visit(node)), column: column)
  }

  override func visit(_ node: IdentifierExprSyntax) -> ExprSyntax {
    if case .binaryOperator = node.identifier.tokenKind {
      return super.visit(node)
    }
    guard let parent = node.parent, parent.syntaxNodeType != FunctionCallExprSyntax.self else {
      return super.visit(node)
    }
    let column = graphemeColumn(node)
    return apply(ExprSyntax(super.visit(node)), column: column)
  }

  override func visit(_ node: IfExprSyntax) -> ExprSyntax {
    return super.visit(node)
  }

  override func visit(_ node: InOutExprSyntax) -> ExprSyntax {
    return super.visit(node)
  }

  override func visit(_ node: InfixOperatorExprSyntax) -> ExprSyntax {
    let column = graphemeColumn(node.operatorOperand)
    return apply(ExprSyntax(super.visit(node)), column: column)
  }

  override func visit(_ node: IntegerLiteralExprSyntax) -> ExprSyntax {
    let column = graphemeColumn(node)
    return apply(ExprSyntax(super.visit(node)), column: column)
  }

  override func visit(_ node: IsExprSyntax) -> ExprSyntax {
    return super.visit(node)
  }

  override func visit(_ node: KeyPathExprSyntax) -> ExprSyntax {
    let column = graphemeColumn(node)
    return apply(ExprSyntax(super.visit(node)), column: column)
  }

  override func visit(_ node: MacroExpansionExprSyntax) -> ExprSyntax {
    let column = graphemeColumn(node)
    guard node.macro.tokenKind != .identifier("selector") else {
      return apply(ExprSyntax(node), column: column)
    }
    return apply(ExprSyntax(super.visit(node)), column: column)
  }

  override func visit(_ node: MemberAccessExprSyntax) -> ExprSyntax {
    guard let parent = node.parent, parent.syntaxNodeType != FunctionCallExprSyntax.self  else {
      return super.visit(node)
    }
    let column = graphemeColumn(node.name)
    let visitedNode = super.visit(node)
    if let optionalChainingExpr = findDescendants(syntaxType: OptionalChainingExprSyntax.self, node: node) {
      if let _ = findAncestors(syntaxType: MemberAccessExprSyntax.self, node: node) {
        return ExprSyntax(
          "\(apply(ExprSyntax(visitedNode), column: column))\(optionalChainingExpr.questionMark)"
        )
      } else {
        return apply(ExprSyntax(visitedNode), column: column)
      }
    } else {
      return apply(ExprSyntax(visitedNode), column: column)
    }
  }

  override func visit(_ node: MissingExprSyntax) -> ExprSyntax {
    return super.visit(node)
  }

  override func visit(_ node: MoveExprSyntax) -> ExprSyntax {
    return super.visit(node)
  }

  override func visit(_ node: NilLiteralExprSyntax) -> ExprSyntax {
    let column = graphemeColumn(node)
    return apply(ExprSyntax(super.visit(node)), column: column)
  }

  override func visit(_ node: OptionalChainingExprSyntax) -> ExprSyntax {
    return super.visit(node)
  }

  override func visit(_ node: PackExpansionExprSyntax) -> ExprSyntax {
    return super.visit(node)
  }

  override func visit(_ node: PostfixIfConfigExprSyntax) -> ExprSyntax {
    return super.visit(node)
  }

  override func visit(_ node: PostfixUnaryExprSyntax) -> ExprSyntax {
    return super.visit(node)
  }

  override func visit(_ node: PrefixOperatorExprSyntax) -> ExprSyntax {
    let column = graphemeColumn(node)
    return apply(ExprSyntax(super.visit(node)), column: column)
  }

  override func visit(_ node: RegexLiteralExprSyntax) -> ExprSyntax {
    let column = graphemeColumn(node)
    return apply(ExprSyntax(super.visit(node)), column: column)
  }

  override func visit(_ node: SequenceExprSyntax) -> ExprSyntax {
    guard let binaryOperatorExpr = findDescendants(syntaxType: BinaryOperatorExprSyntax.self, node: Syntax(node)) else  {
      return super.visit(node)
    }
    let column = graphemeColumn(binaryOperatorExpr)
    return apply(ExprSyntax(super.visit(node)), column: column)
  }

  override func visit(_ node: SpecializeExprSyntax) -> ExprSyntax {
    return super.visit(node)
  }

  override func visit(_ node: StringLiteralExprSyntax) -> ExprSyntax {
    let column = graphemeColumn(node)
    return apply(ExprSyntax(super.visit(node)), column: column)
  }

  override func visit(_ node: SubscriptExprSyntax) -> ExprSyntax {
    let column = graphemeColumn(node.rightBracket)
    return apply(ExprSyntax(super.visit(node)), column: column)
  }

  override func visit(_ node: SuperRefExprSyntax) -> ExprSyntax {
    let column = graphemeColumn(node)
    return apply(ExprSyntax(super.visit(node)), column: column)
  }

  override func visit(_ node: SwitchExprSyntax) -> ExprSyntax {
    return super.visit(node)
  }

  override func visit(_ node: TernaryExprSyntax) -> ExprSyntax {
    let column = graphemeColumn(node)
    return apply(ExprSyntax(super.visit(node)), column: column)
  }

  override func visit(_ node: TryExprSyntax) -> ExprSyntax {
    return super.visit(node)
  }

  override func visit(_ node: TupleExprSyntax) -> ExprSyntax {
    let column = graphemeColumn(node)
    return apply(ExprSyntax(super.visit(node)), column: column)
  }

  override func visit(_ node: TypeExprSyntax) -> ExprSyntax {
    return super.visit(node)
  }

  override func visit(_ node: UnresolvedAsExprSyntax) -> ExprSyntax {
    return super.visit(node)
  }

  override func visit(_ node: UnresolvedIsExprSyntax) -> ExprSyntax {
    return super.visit(node)
  }

  override func visit(_ node: UnresolvedPatternExprSyntax) -> ExprSyntax {
    return super.visit(node)
  }

  override func visit(_ node: UnresolvedTernaryExprSyntax) -> ExprSyntax {
    return super.visit(node)
  }

  override func visitPost(_ node: Syntax) {
    if let expr = node.as(ExprSyntax.self) {
      let id = index
      index += 1

      if let parent = expr.parent,
         let _ = parent.as(InfixOperatorExprSyntax.self),
         node.syntaxNodeType != BinaryOperatorExprSyntax.self
      {
        expressionStore.append(node, id: id, type: .comparison)
      }
    }
  }

  private func apply(_ node: ExprSyntax, column: Int) -> ExprSyntax {
    let nonAssignOpToLeft = findLeftSiblingOperator(node)

    let exprNode: ExprSyntax
    if node.syntaxNodeType == IdentifierExprSyntax.self {
      exprNode = ExprSyntax("\(node).self")
        .with(\.leadingTrivia, node.leadingTrivia).with(\.trailingTrivia, node.trailingTrivia)
    } else if node.syntaxNodeType == SuperRefExprSyntax.self {
      exprNode = ExprSyntax("\(node).self")
        .with(\.leadingTrivia, node.leadingTrivia).with(\.trailingTrivia, node.trailingTrivia)
    } else {
      exprNode = node
    }

    let expression: ExprSyntax
    if isAwaitPresent && !nonAssignOpToLeft && node.syntaxNodeType == FunctionCallExprSyntax.self {
      expression = ExprSyntax(
        AwaitExprSyntax(
          expression: exprNode.with(\.leadingTrivia, .space).with(\.trailingTrivia, [])
        )
      )
    } else {
      expression = exprNode.with(\.leadingTrivia, []).with(\.trailingTrivia, [])
    }

    let functionCallExpr = FunctionCallExprSyntax(
      leadingTrivia: node.leadingTrivia,
      calledExpression: IdentifierExprSyntax(
        identifier: TokenSyntax(
          .identifier(isAwaitPresent ? "$0.captureAsync" : "$0.captureSync"), presence: .present
        )
      ),
      leftParen: .leftParenToken(),
      argumentList: TupleExprElementListSyntax([
        TupleExprElementSyntax(
          expression: expression,
          trailingComma: .commaToken(),
          trailingTrivia: .space
        ),
        TupleExprElementSyntax(
          label: .identifier("column"),
          colon: .colonToken().with(\.trailingTrivia, .space),
          expression: IntegerLiteralExprSyntax(
            digits: .integerLiteral("\(column + startColumn)")
          ),
          trailingComma: .commaToken(),
          trailingTrivia: .space
        ),
        TupleExprElementSyntax(
          label: .identifier("id"),
          colon: .colonToken().with(\.trailingTrivia, .space),
          expression: IntegerLiteralExprSyntax(
            digits: .integerLiteral("\(index)")
          )
        ),
      ]),
      rightParen: .rightParenToken(),
      trailingTrivia: node.trailingTrivia
    )

    let exprSyntax: ExprSyntax
    if isAwaitPresent && !nonAssignOpToLeft {
      exprSyntax = ExprSyntax(AwaitExprSyntax(expression: functionCallExpr.with(\.leadingTrivia, .space)))
    } else {
      exprSyntax = ExprSyntax(functionCallExpr)
    }

    return exprSyntax
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

  private func findLeftSiblingOperator(_ node: SyntaxProtocol) -> Bool {
    guard let parent = node.parent else {
      return false
    }

    for token in parent.tokens(viewMode: .fixedUp) {
      if token.position >= node.position {
        return false
      }
      if case .binaryOperator = token.tokenKind {
        return true
      }
    }

    return false
  }

  private func graphemeColumn(_ node: SyntaxProtocol) -> Int {
    let startLocation = node.startLocation(converter: sourceLocationConverter)
    let column: Int
    if let graphemeClusters = String("\(expression)".utf8.prefix(startLocation.column)) {
      column = stringWidth(graphemeClusters)
    } else {
      column = startLocation.column
    }
    return column
  }
}

private class ExpressionStore {
  private var expressions = [Expression]()

  func append(_ node: Syntax, id: Int, type: Expression.ExpressionType) {
    expressions.append(Expression(node: node, id: id, type: type))
  }

  func expressions(of type: Expression.ExpressionType) -> [Expression] {
    return expressions.filter { $0.type == type }
  }
}

private struct Expression {
  enum ExpressionType {
    case comparison
  }

  let node: Syntax
  let id: Int
  let type: ExpressionType
}
