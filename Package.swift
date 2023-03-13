// swift-tools-version: 999.0

import CompilerPluginSupport
import PackageDescription

let package = Package(
  name: "SwiftPowerAssert",
  platforms: [
    .iOS("13.0"),
    .macOS("10.15")
  ],
  products: [
    .executable(
      name: "SwiftPowerAssert",
      targets: ["SwiftPowerAssert"]
    ),
    .library(
      name: "SwiftPowerAssertLib",
      targets: ["SwiftPowerAssertLib"]
    ),
  ],
  dependencies: [
    .package(
      url: "https://github.com/apple/swift-syntax.git",
      branch: "main"
    ),
  ],
  targets: [
    .macro(name: "SwiftPowerAssertPlugin",
      dependencies: [
        .product(name: "SwiftSyntax", package: "swift-syntax"),
        .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
        .product(name: "SwiftOperators", package: "swift-syntax"),
        .product(name: "SwiftParser", package: "swift-syntax"),
        .product(name: "SwiftParserDiagnostics", package: "swift-syntax"),
        .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
      ]
    ),
    .target(name: "SwiftPowerAssertLib",
      dependencies: ["SwiftPowerAssertPlugin"] 
    ),
    .executableTarget(name: "SwiftPowerAssert",
      dependencies: [
        "SwiftPowerAssertLib"
      ]
    )
  ]
)

