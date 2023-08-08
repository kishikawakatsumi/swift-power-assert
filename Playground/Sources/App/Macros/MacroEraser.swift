import SwiftSyntax

class MacroEraser: SyntaxRewriter {
  override func visit(_ node: MacroExpansionExprSyntax) -> ExprSyntax {
    let tokens = node.tokens(viewMode: .fixedUp).map { $0 }
    let isAwaitPresent = tokens.contains { $0.tokenKind == .keyword(.await) }
    if isAwaitPresent {
      return ExprSyntax(
        AwaitExprSyntax(
          expression: node
            .with(\.pound, .identifier(""))
            .with(\.macroName, .identifier("xassert"))
            .with(\.leadingTrivia, .space)
            .with(\.trailingTrivia, [])
        )
        .with(\.leadingTrivia, node.leadingTrivia)
        .with(\.trailingTrivia, node.trailingTrivia)
      )
    } else {
      return ExprSyntax(
        node
          .with(\.pound, .identifier(""))
          .with(\.macroName, .identifier("vassert"))
          .with(\.leadingTrivia, node.leadingTrivia)
          .with(\.trailingTrivia, node.trailingTrivia)
      )
    }
  }
}

