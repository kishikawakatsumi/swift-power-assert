import Foundation
import SwiftSyntax
import SwiftSyntaxMacros
import SwiftDiagnostics

class SimpleMacroExpansionContext: MacroExpansionContext {
  let moduleName: String
  let fullFilePath: String
  let sourceFile: SourceFileSyntax

  init(moduleName: String, fullFilePath: String, sourceFile: SourceFileSyntax) {
    self.moduleName = moduleName
    self.fullFilePath = fullFilePath
    self.sourceFile = sourceFile
  }

  func location<Node>(
    of node: Node,
    at position: SwiftSyntaxMacros.PositionInSyntaxNode,
    filePathMode: SwiftSyntaxMacros.SourceLocationFilePathMode
  ) -> SwiftSyntaxMacros.AbstractSourceLocation? where Node : SwiftSyntax.SyntaxProtocol {
    let fileName = fullFilePath
    let offsetAdjustment = 0

    let rawPosition: AbsolutePosition
    switch position {
    case .beforeLeadingTrivia:
      rawPosition = node.position
    case .afterLeadingTrivia:
      rawPosition = node.positionAfterSkippingLeadingTrivia
    case .beforeTrailingTrivia:
      rawPosition = node.endPositionBeforeTrailingTrivia
    case .afterTrailingTrivia:
      rawPosition = node.endPosition
    }

    let converter = SourceLocationConverter(fileName: fileName, tree: sourceFile)
    return AbstractSourceLocation(converter.location(for: rawPosition.advanced(by: offsetAdjustment)))
  }

  func makeUniqueName(_ name: String) -> TokenSyntax {
    TokenSyntax(
      .identifier("__local\(UUID().uuidString.replacingOccurrences(of: "-", with: ""))"), presence: .present
    )
  }

  func diagnose(_ diagnostic: Diagnostic) {}
}
