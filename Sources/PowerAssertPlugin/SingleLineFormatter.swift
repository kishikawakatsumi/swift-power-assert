import SwiftSyntax

class SingleLineFormatter: SyntaxRewriter {
  private let expression: any SyntaxProtocol

  init(_ expression: some SyntaxProtocol) {
    self.expression = expression
  }

  func format() -> some SyntaxProtocol {
    let formatted = rewrite(Syntax(expression).with(\.leadingTrivia, []).with(\.trailingTrivia, []))
    return SourceFileSyntax(stringLiteral: "\(formatted)")
  }

  override func visit(_ node: StringLiteralExprSyntax) -> ExprSyntax {
    guard node.openQuote.tokenKind == .multilineStringQuote && node.closeQuote.tokenKind == .multilineStringQuote else {
      return super.visit(node)
    }
    let visitedNode = super.visit(node).cast(StringLiteralExprSyntax.self)
    if let content = visitedNode.representedLiteralValue {
      return ExprSyntax(
        StringLiteralExprSyntax(content: content)
          .with(\.leadingTrivia, visitedNode.leadingTrivia)
          .with(\.trailingTrivia, visitedNode.trailingTrivia)
      )
    } else {
      let segments = visitedNode
        .segments
        .map { $0.with(\.leadingTrivia, []).with(\.trailingTrivia, []) }
      return ExprSyntax(
        StringLiteralExprSyntax(content: "\(StringLiteralSegmentsSyntax(segments))")
          .with(\.leadingTrivia, visitedNode.leadingTrivia)
          .with(\.trailingTrivia, visitedNode.trailingTrivia)
      )
    }
  }

  override func visit(_ token: TokenSyntax) -> TokenSyntax {
    let visitedToken = super.visit(token)
    let leadingTrivia = visitedToken.leadingTrivia
    let trailingTrivia = visitedToken.trailingTrivia
    return visitedToken
      .with(\.leadingTrivia, leadingTrivia.pieces.isEmpty ? [] : .space)
      .with(\.trailingTrivia, trailingTrivia.pieces.isEmpty ? [] : .space)
  }
}
