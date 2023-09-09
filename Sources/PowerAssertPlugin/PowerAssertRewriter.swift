@_spi(RawSyntax) import SwiftSyntax
import SwiftOperators
import StringWidth

class PowerAssertRewriter: SyntaxRewriter {
  private let expression: any SyntaxProtocol
  private let sourceManager: SourceManager
  private let startColumn: Int
  private let isTryPresent: Bool
  let isAwaitPresent: Bool

  private var index = 0
  private let expressionStore = ExpressionStore()

  init(_ expression: some SyntaxProtocol, macro node: some FreestandingMacroExpansionSyntax) {
    if let folded = try? OperatorTable.standardOperators.foldAll(expression) {
      self.expression = folded
    } else {
      self.expression = expression
    }

    sourceManager = SourceManager(self.expression)

    startColumn = {
      let locationConverter = SourceLocationConverter(fileName: "", tree: node.detached)
      let startLocation = node.startLocation(converter: locationConverter)
      let endLocation = node.macro.endLocation(converter: locationConverter)
      return endLocation.column - startLocation.column
    }()

    let tokens = expression.tokens(viewMode: .sourceAccurate).map { $0 }
    isTryPresent = tokens.contains { $0.tokenKind == .keyword(.try) }
    isAwaitPresent = tokens.contains { $0.tokenKind == .keyword(.await) }
  }

  func rewrite() -> String {
    let rewritten = rewrite(Syntax(expression))
    let firstToken = rewritten.firstToken(viewMode: .sourceAccurate)
    let tryOrEmpty: String
    if isTryPresent {
      if firstToken?.tokenKind == .keyword(.try) {
        tryOrEmpty = ""
      } else {
        tryOrEmpty = "try "
      }
    } else {
      tryOrEmpty = ""
    }
    return "\(tryOrEmpty)\(rewritten)"
  }

  func equalityExpressions() -> String {
    expressionStore
      .filter {
        if case .equalityExpression = $0.type {
          return true
        } else {
          return false
        }
      }
      .reduce(into: [Syntax: (Int?, Int?, Int?)]()) {
        switch $1.type {
        case .equalityExpression(expression: let expression?, lhs: _, rhs: _):
          if let operands = $0[$1.node] {
            $0[$1.node] = (expression, operands.1, operands.2)
          } else {
            $0[$1.node] = (expression, nil, nil)
          }
        case .equalityExpression(expression: _, lhs: let lhs?, rhs: _):
          if let operands = $0[$1.node] {
            $0[$1.node] = (operands.0, lhs, operands.2)
          } else {
            $0[$1.node] = (nil, lhs, nil)
          }
        case .equalityExpression(expression: _, lhs: _, rhs: let rhs?):
          if let operands = $0[$1.node] {
            $0[$1.node] = (operands.0, operands.1, rhs)
          } else {
            $0[$1.node] = (nil, nil, rhs)
          }
        case .equalityExpression(expression: .none, lhs: .none, rhs: .none):
          break
        case .identicalExpression:
          break
        case .comparisonOperand:
          break
        case .literalExpression:
          break
        }
      }
      .compactMap { (key: Syntax, value: (Int?, Int?, Int?)) -> (Int, Int, Int)? in
        guard let expression = value.0, let lhs = value.1, let rhs = value.2 else { return nil }
        return (expression, lhs, rhs)
      }
      .sorted { $0.0 < $1.0 }
      .description
  }

  func identicalExpressions() -> String {
    expressionStore
      .filter {
        if case .identicalExpression = $0.type {
          return true
        } else {
          return false
        }
      }
      .reduce(into: [Syntax: (Int?, Int?, Int?)]()) {
        switch $1.type {
        case .equalityExpression:
          break
        case .identicalExpression(expression: let expression?, lhs: _, rhs: _):
          if let operands = $0[$1.node] {
            $0[$1.node] = (expression, operands.1, operands.2)
          } else {
            $0[$1.node] = (expression, nil, nil)
          }
        case .identicalExpression(expression: _, lhs: let lhs?, rhs: _):
          if let operands = $0[$1.node] {
            $0[$1.node] = (operands.0, lhs, operands.2)
          } else {
            $0[$1.node] = (nil, lhs, nil)
          }
        case .identicalExpression(expression: _, lhs: _, rhs: let rhs?):
          if let operands = $0[$1.node] {
            $0[$1.node] = (operands.0, operands.1, rhs)
          } else {
            $0[$1.node] = (nil, nil, rhs)
          }
        case .identicalExpression(expression: .none, lhs: .none, rhs: .none):
          break
        case .comparisonOperand:
          break
        case .literalExpression:
          break
        }
      }
      .compactMap { (key: Syntax, value: (Int?, Int?, Int?)) -> (Int, Int, Int)? in
        guard let expression = value.0, let lhs = value.1, let rhs = value.2 else { return nil }
        return (expression, lhs, rhs)
      }
      .sorted { $0.0 < $1.0 }
      .description
  }

  func comparisonOperands() -> String {
    expressionStore
      .filter {
        if case .comparisonOperand = $0.type {
          return true
        }
        return false
      }
      .reduce(into: [Int: String]()) {
        if case .comparisonOperand = $1.type {
          $0[$1.id] = "\($1.node.trimmed)"
        }
      }
      .description
  }

  func literalExpressions() -> String {
    let expressions = expressionStore
      .filter {
        if case .literalExpression = $0.type {
          return true
        }
        return false
      }
      .compactMap {
        if case .literalExpression(let column) = $0.type {
          return "(\($0.id), \($0.node.trimmed), \(column))"
        }
        return nil
      }
    return "[\(expressions.joined(separator: ", "))]"
  }

  override func visit(_ node: ArrayExprSyntax) -> ExprSyntax {
    let column = graphemeColumn(node)
    return apply(ExprSyntax(super.visit(node)), column: column)
  }

  override func visit(_ node: ArrowExprSyntax) -> ExprSyntax {
    super.visit(node)
  }

  override func visit(_ node: AsExprSyntax) -> ExprSyntax {
    let column = graphemeColumn(node.asKeyword)
    return apply(ExprSyntax(super.visit(node)), column: column)
  }

  override func visit(_ node: AssignmentExprSyntax) -> ExprSyntax {
    super.visit(node)
  }

  override func visit(_ node: AwaitExprSyntax) -> ExprSyntax {
    super.visit(
      node.with(\.awaitKeyword, "")
    )
  }

  override func visit(_ node: BinaryOperatorExprSyntax) -> ExprSyntax {
    super.visit(node)
  }

  override func visit(_ node: BooleanLiteralExprSyntax) -> ExprSyntax {
    let column = graphemeColumn(node)
    return apply(ExprSyntax(super.visit(node)), column: column)
  }

  override func visit(_ node: BorrowExprSyntax) -> ExprSyntax {
    super.visit(node)
  }

  override func visit(_ node: CanImportExprSyntax) -> ExprSyntax {
    super.visit(node)
  }

  override func visit(_ node: CanImportVersionInfoSyntax) -> ExprSyntax {
    super.visit(node)
  }

  override func visit(_ node: ClosureExprSyntax) -> ExprSyntax {
    ExprSyntax(node)
  }

  override func visit(_ node: ConsumeExprSyntax) -> ExprSyntax {
    super.visit(node)
  }

  override func visit(_ node: CopyExprSyntax) -> ExprSyntax {
    super.visit(node)
  }

  override func visit(_ node: DeclReferenceExprSyntax) -> ExprSyntax {
    if case .binaryOperator = node.baseName.tokenKind {
      return super.visit(node)
    }
    guard let parent = node.parent, parent.syntaxNodeType != FunctionCallExprSyntax.self else {
      return super.visit(node)
    }
    if let memberAccess = parent.as(MemberAccessExprSyntax.self), memberAccess.declName == node {
      return super.visit(node)
    }
    if parent.syntaxNodeType == KeyPathPropertyComponentSyntax.self {
      return super.visit(node)
    }
    let column = graphemeColumn(node)
    return apply(ExprSyntax(super.visit(node)), column: column)
  }

  override func visit(_ node: DictionaryExprSyntax) -> ExprSyntax {
    let column = graphemeColumn(node)
    return apply(ExprSyntax(super.visit(node)), column: column)
  }

  override func visit(_ node: DiscardAssignmentExprSyntax) -> ExprSyntax {
    super.visit(node)
  }

  override func visit(_ node: EditorPlaceholderExprSyntax) -> ExprSyntax {
    super.visit(node)
  }

  override func visit(_ node: FloatLiteralExprSyntax) -> ExprSyntax {
    // Literals should not be evaluated at runtime to avoid type inference timeouts.
    let column = graphemeColumn(node)
    expressionStore.append(
      Syntax(node), id: index, type: .literalExpression(column: column + startColumn)
    )
    return super.visit(node)
  }

  override func visit(_ node: ForceUnwrapExprSyntax) -> ExprSyntax {
    let column = graphemeColumn(node)
    return apply(ExprSyntax(super.visit(node)), column: column)
  }

  override func visit(_ node: FunctionCallExprSyntax) -> ExprSyntax {
    let column: Int
    if let function = node.calledExpression.children(viewMode: .sourceAccurate).last {
      column = graphemeColumn(function)
    } else {
      column = graphemeColumn(node)
    }
    return apply(ExprSyntax(super.visit(node)), column: column)
  }

  override func visit(_ node: GenericSpecializationExprSyntax) -> ExprSyntax {
    super.visit(node)
  }

  override func visit(_ node: IfExprSyntax) -> ExprSyntax {
    super.visit(node)
  }

  override func visit(_ node: InOutExprSyntax) -> ExprSyntax {
    super.visit(node)
  }

  override func visit(_ node: InfixOperatorExprSyntax) -> ExprSyntax {
    let column = graphemeColumn(node.operator)
    return apply(ExprSyntax(super.visit(node)), column: column)
  }

  override func visit(_ node: IntegerLiteralExprSyntax) -> ExprSyntax {
    // Literals should not be evaluated at runtime to avoid type inference timeouts.
    let column = graphemeColumn(node)
    expressionStore.append(
      Syntax(node), id: index, type: .literalExpression(column: column + startColumn)
    )
    return super.visit(node)
  }

  override func visit(_ node: IsExprSyntax) -> ExprSyntax {
    super.visit(node)
  }

  override func visit(_ node: KeyPathExprSyntax) -> ExprSyntax {
    let column = graphemeColumn(node)
    return apply(ExprSyntax(super.visit(node)), column: column)
  }

  override func visit(_ node: MacroExpansionExprSyntax) -> ExprSyntax {
    let column = graphemeColumn(node)
    guard node.macroName.tokenKind != .identifier("selector") else {
      return apply(ExprSyntax(node), column: column)
    }
    return apply(ExprSyntax(super.visit(node)), column: column)
  }

  override func visit(_ node: MemberAccessExprSyntax) -> ExprSyntax {
    guard let parent = node.parent, parent.syntaxNodeType != FunctionCallExprSyntax.self  else {
      return super.visit(node)
    }
    guard node.declName.baseName.tokenKind != .identifier("Type") else {
      return ExprSyntax(node)
    }

    let column = graphemeColumn(node.declName.baseName)
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
    super.visit(node)
  }

  override func visit(_ node: NilLiteralExprSyntax) -> ExprSyntax {
    let column = graphemeColumn(node)
    return apply(ExprSyntax(super.visit(node)), column: column)
  }

  override func visit(_ node: OptionalChainingExprSyntax) -> ExprSyntax {
    super.visit(node)
  }

  override func visit(_ node: PackElementExprSyntax) -> ExprSyntax {
    super.visit(node)
  }

  override func visit(_ node: PackExpansionExprSyntax) -> ExprSyntax {
    super.visit(node)
  }

  override func visit(_ node: PatternExprSyntax) -> ExprSyntax {
    super.visit(node)
  }

  override func visit(_ node: PostfixIfConfigExprSyntax) -> ExprSyntax {
    super.visit(node)
  }

  override func visit(_ node: PostfixOperatorExprSyntax) -> ExprSyntax {
    super.visit(node)
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
    super.visit(node)
  }

  override func visit(_ node: StringLiteralExprSyntax) -> ExprSyntax {
    let column = graphemeColumn(node)
    return apply(ExprSyntax(super.visit(node)), column: column)
  }

  override func visit(_ node: SubscriptCallExprSyntax) -> ExprSyntax {
    let column = graphemeColumn(node.rightSquare)
    return apply(ExprSyntax(super.visit(node)), column: column)
  }

  override func visit(_ node: SuperExprSyntax) -> ExprSyntax {
    let column = graphemeColumn(node)
    return apply(ExprSyntax(super.visit(node)), column: column)
  }

  override func visit(_ node: SwitchExprSyntax) -> ExprSyntax {
    super.visit(node)
  }

  override func visit(_ node: TernaryExprSyntax) -> ExprSyntax {
    let column = graphemeColumn(node)
    return apply(ExprSyntax(super.visit(node)), column: column)
  }

  override func visit(_ node: TryExprSyntax) -> ExprSyntax {
    super.visit(node)
  }

  override func visit(_ node: TupleExprSyntax) -> ExprSyntax {
    let column = graphemeColumn(node)
    return apply(ExprSyntax(super.visit(node)), column: column)
  }

  override func visit(_ node: TypeExprSyntax) -> ExprSyntax {
    super.visit(node)
  }

  override func visit(_ node: UnresolvedAsExprSyntax) -> ExprSyntax {
    super.visit(node)
  }

  override func visit(_ node: UnresolvedIsExprSyntax) -> ExprSyntax {
    super.visit(node)
  }

  override func visit(_ node: UnresolvedTernaryExprSyntax) -> ExprSyntax {
    super.visit(node)
  }

  override func visitPost(_ node: Syntax) {
    let node = Syntax(sourceManager.singleLineNode(from: node))
    if let expr = node.as(ExprSyntax.self) {
      let id = index
      index += 1

      if let infixOperator = node.as(InfixOperatorExprSyntax.self),
         let binaryOperator = infixOperator.operator.as(BinaryOperatorExprSyntax.self) {
        if binaryOperator.operator.tokenKind == .binaryOperator("==") {
          expressionStore.append(
            node, id: id, type: .equalityExpression(expression: id, lhs: nil, rhs: nil)
          )
        }
        if binaryOperator.operator.tokenKind == .binaryOperator("===") {
          expressionStore.append(
            node, id: id, type: .identicalExpression(expression: id, lhs: nil, rhs: nil)
          )
        }
      }

      if let parent = expr.parent {
        if let infixOperator = parent.as(InfixOperatorExprSyntax.self), node.syntaxNodeType != BinaryOperatorExprSyntax.self {
          if let binaryOperator = infixOperator.operator.as(BinaryOperatorExprSyntax.self) {
            let tokenKind = binaryOperator.operator.tokenKind
            if tokenKind == .binaryOperator("==") {
              if infixOperator.leftOperand == expr {
                expressionStore.append(
                  parent, id: id, type: .equalityExpression(expression: nil, lhs: id, rhs: nil)
                )
              }
              if infixOperator.rightOperand == expr {
                expressionStore.append(
                  parent, id: id, type: .equalityExpression(expression: nil, lhs: nil, rhs: id)
                )
              }
            }
            if tokenKind == .binaryOperator("===") {
              if infixOperator.leftOperand == expr {
                expressionStore.append(
                  parent, id: id, type: .identicalExpression(expression: nil, lhs: id, rhs: nil)
                )
              }
              if infixOperator.rightOperand == expr {
                expressionStore.append(
                  parent, id: id, type: .identicalExpression(expression: nil, lhs: nil, rhs: id)
                )
              }
            }
          }
          expressionStore.append(node, id: id, type: .comparisonOperand)
        }
        if let _ = parent.as(TernaryExprSyntax.self) {
          expressionStore.append(node, id: id, type: .comparisonOperand)
        }
      }
    }
  }

  private func apply(_ node: ExprSyntax, column: Int) -> ExprSyntax {
    let nonAssignOpToLeft = findLeftSiblingOperator(node)

    let exprNode: ExprSyntax
    if node.syntaxNodeType == DeclReferenceExprSyntax.self {
      exprNode = ExprSyntax("\(node.trimmed).self")
        .with(\.leadingTrivia, node.leadingTrivia).with(\.trailingTrivia, node.trailingTrivia)
    } else if node.syntaxNodeType == SuperExprSyntax.self {
      exprNode = ExprSyntax("\(node.trimmed).self")
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
      expression = exprNode.trimmed
    }

    let functionCallExpr = FunctionCallExprSyntax(
      leadingTrivia: node.leadingTrivia,
      calledExpression: DeclReferenceExprSyntax(
        baseName: TokenSyntax(
          .identifier(isAwaitPresent ? "$0.captureAsync" : "$0.captureSync"), presence: .present
        )
      ),
      leftParen: .leftParenToken(),
      arguments: LabeledExprListSyntax([
        LabeledExprSyntax(
          expression: expression,
          trailingComma: .commaToken(),
          trailingTrivia: .space
        ),
        LabeledExprSyntax(
          label: .identifier("column"),
          colon: .colonToken().with(\.trailingTrivia, .space),
          expression: IntegerLiteralExprSyntax(
            literal: .integerLiteral("\(column + startColumn)")
          ),
          trailingComma: .commaToken(),
          trailingTrivia: .space
        ),
        LabeledExprSyntax(
          label: .identifier("id"),
          colon: .colonToken().with(\.trailingTrivia, .space),
          expression: IntegerLiteralExprSyntax(
            literal: .integerLiteral("\(index)")
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

  private func findAncestors<T: SyntaxProtocol>(syntaxType: T.Type, node: some SyntaxProtocol) -> T? {
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

  private func findDescendants<T: SyntaxProtocol>(syntaxType: T.Type, node: some SyntaxProtocol) -> T? {
    let children = node.children(viewMode: .sourceAccurate)
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

  private func findLeftSiblingOperator(_ node: some SyntaxProtocol) -> Bool {
    guard let parent = node.parent else {
      return false
    }

    for token in parent.tokens(viewMode: .sourceAccurate) {
      if token.position >= node.position {
        return false
      }
      if case .binaryOperator = token.tokenKind {
        return true
      }
    }

    return false
  }

  private func graphemeColumn(_ node: some SyntaxProtocol) -> Int {
    let node = sourceManager.singleLineNode(from: node)
    let startLocation = node.startLocation(converter: sourceManager.locationConverter)
    let column: Int
    if let graphemeClusters = String("\(sourceManager.singleLine)".utf8.prefix(startLocation.column)) {
      column = stringWidth(graphemeClusters)
    } else {
      column = startLocation.column
    }
    return column
  }
}

private func flatten(_ syntax: some SyntaxProtocol, storage: inout [Syntax]) {
  for child in syntax.children(viewMode: .sourceAccurate) {
    storage.append(child)
    let children = child.children(viewMode: .sourceAccurate)
    if !children.isEmpty {
      flatten(child, storage: &storage)
    }
  }
}

private class SourceManager {
  let original: any SyntaxProtocol
  let singleLine: any SyntaxProtocol

  var originalTree = [Syntax]()
  var singleLineTree = [Syntax]()

  let locationConverter: SourceLocationConverter

  init(_ expression: any SyntaxProtocol) {
    original = expression
    singleLine = SingleLineFormatter().format(expression)

    flatten(original, storage: &originalTree)
    flatten(singleLine, storage: &singleLineTree)

    locationConverter = SourceLocationConverter(fileName: "", tree: singleLine)
  }

  func singleLineNode(from node: some SyntaxProtocol) -> any SyntaxProtocol {
    singleLineTree.first { $0.id.indexInTree == node.id.indexInTree } ?? node
  }
}

private class ExpressionStore {
  private var expressions = [Expression]()

  func append(_ node: Syntax, id: Int, type: Expression.ExpressionType) {
    expressions.append(Expression(node: node, id: id, type: type))
  }

  func filter(_ isIncluded: (Expression) -> Bool) -> [Expression] {
    expressions.filter { isIncluded($0) }
  }
}

private struct Expression {
  enum ExpressionType: Equatable {
    case equalityExpression(expression: Int?, lhs: Int?, rhs: Int?)
    case identicalExpression(expression: Int?, lhs: Int?, rhs: Int?)
    case comparisonOperand
    case literalExpression(column: Int)
  }

  let node: Syntax
  let id: Int
  let type: ExpressionType
}
