import SwiftSyntax
import SwiftSyntaxMacros

class NestedFunctionCallSplitter: SyntaxRewriter {
  private let expression: SyntaxProtocol
  private let context: MacroExpansionContext
  private var variableDecls = [String]()

  init(expression: SyntaxProtocol, context: MacroExpansionContext) {
    self.expression = expression
    self.context = context
  }

  func rewrite() -> SyntaxProtocol {
    visit(expression.cast(SourceFileSyntax.self))
  }

  func localVariables() -> String {
    variableDecls.joined(separator: "\n")
  }

  override func visit(_ node: FunctionCallExprSyntax) -> ExprSyntax {
    if let parent = node.parent, parent.syntaxNodeType == CodeBlockItemSyntax.self {
      return super.visit(node)
    }

    let visitedNode = super.visit(node).cast(FunctionCallExprSyntax.self)

    let localVar = "\(context.makeUniqueName(""))".dropFirst()
    let argumentList = visitedNode.argumentList.replacing(
      childAt: 0,
      with: TupleExprElementSyntax(
        expression: IdentifierExprSyntax(
          identifier: TokenSyntax(.identifier("\(localVar)"), presence: .present)
        ),
        trailingComma: .commaToken(),
        trailingTrivia: .space
      )
    )
    
    let variableDecl = """
      let \(localVar) = \(visitedNode.argumentList.first!.with(\.trailingComma, "").with(\.leadingTrivia, []).with(\.trailingTrivia, []))
      """
    variableDecls.append(variableDecl)

    return ExprSyntax(visitedNode.with(\.argumentList, argumentList))
  }
}
