import SwiftSyntax

class SingleLineFormatter: SyntaxRewriter {
  func format(_ expression: some SyntaxProtocol) -> Syntax {
    rewrite(Syntax(expression).with(\.leadingTrivia, []).with(\.trailingTrivia, []))
  }

  override func visit(_ node: StringSegmentSyntax) -> StringSegmentSyntax {
    let visitedNode = super.visit(node)
    return visitedNode.with(\.content, .stringSegment(visitedNode.content.text.replacingOccurrences(of: "\n", with: "\\n")))
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
