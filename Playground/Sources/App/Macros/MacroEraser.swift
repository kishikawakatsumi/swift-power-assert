import SwiftSyntax

class MacroEraser: SyntaxRewriter {
  override func visit(_ node: MacroExpansionExprSyntax) -> ExprSyntax {
    ExprSyntax(
      node
        .with(\.poundToken, .identifier(""))
        .with(\.leadingTrivia, node.leadingTrivia)
    )
  }
}
