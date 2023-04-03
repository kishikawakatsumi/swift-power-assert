// swift-tools-version: 999.0

import CompilerPluginSupport
import PackageDescription

let package = Package(
  name: "SwiftPowerAssert",
  platforms: [
    .iOS(.v16),
    .macOS(.v13)
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
        "StringWidth",
      ]
    ),
    .target(
      name: "SwiftPowerAssertLib",
      dependencies: [
        "SwiftPowerAssertPlugin",
        "StringWidth",
      ]
    ),
    .executableTarget(
      name: "SwiftPowerAssert",
      dependencies: [
        "SwiftPowerAssertLib",
      ]
    ),
    .target(
      name: "StringWidth",
      dependencies: []
    ),
    .testTarget(
      name: "PowerAssertTests",
      dependencies: ["SwiftPowerAssertLib"]
    ),
  ]
)

