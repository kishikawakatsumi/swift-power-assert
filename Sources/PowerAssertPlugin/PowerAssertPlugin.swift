#if canImport(SwiftCompilerPlugin)
import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct PowerAssertPlugin: CompilerPlugin {
  let providingMacros: [any Macro.Type] = [
    PowerAssertMacro.self,
  ]
}
#endif
