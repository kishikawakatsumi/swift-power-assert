import SwiftSyntax

class SingleLineFormatter: SyntaxRewriter {
  private let expression: any SyntaxProtocol

  init(_ expression: some SyntaxProtocol) {
    self.expression = expression
  }

  func format() -> some SyntaxProtocol {
    let formatted = rewrite(Syntax(expression).with(\.leadingTrivia, []).with(\.trailingTrivia, []))
    return formatted
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
