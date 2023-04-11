import SwiftSyntax

class SingleLineFormatter: SyntaxRewriter {
  private let expression: SyntaxProtocol

  init(expression: SyntaxProtocol) {
    self.expression = expression
  }

  func format() -> SyntaxProtocol {
    let formatted = visit(Syntax(expression).with(\.leadingTrivia, []).with(\.trailingTrivia, []))
    return SourceFileSyntax(stringLiteral: "\(formatted)")
  }

  override func visit(_ node: StringLiteralExprSyntax) -> ExprSyntax {
    guard node.openQuote.tokenKind == .multilineStringQuote && node.closeQuote.tokenKind == .multilineStringQuote else {
      return super.visit(node)
    }
    let visitedNode = super.visit(node).cast(StringLiteralExprSyntax.self)
    let segments = visitedNode
      .segments
      .map { $0.with(\.leadingTrivia, []).with(\.trailingTrivia, []) }
    return ExprSyntax(
      StringLiteralExprSyntax(content: "\(StringLiteralSegmentsSyntax(segments))")
        .with(\.leadingTrivia, visitedNode.leadingTrivia)
        .with(\.trailingTrivia, visitedNode.trailingTrivia)
    )
  }

  override func visit(_ token: TokenSyntax) -> TokenSyntax {
    let visitedToken = super.visit(token)
    let filtered = visitedToken.trailingTrivia.pieces
      .filter {
        if case .spaces = $0, case .tabs = $0, case .newlines = $0 {
          return true
        }
        return false
      }
    return visitedToken
      .with(\.leadingTrivia, visitedToken.leadingTrivia.isEmpty ? [] : .space)
      .with(\.trailingTrivia, visitedToken.trailingTrivia.isEmpty ? [] : .space)
  }
}

extension Trivia {
  var isEmpty: Bool {
    return pieces
    .filter {
      switch $0 {
      case .spaces, .tabs, .newlines:
        return true
      default:
        return false
      }
    }
    .isEmpty
  }
}
