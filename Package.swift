// swift-tools-version: 5.9

import CompilerPluginSupport
import PackageDescription

let package = Package(
  name: "SwiftPowerAssert",
  platforms: [
    .iOS(.v16),
    .macOS(.v13),
  ],
  products: [
    .library(
      name: "PowerAssert",
      targets: ["PowerAssert"]
    ),
  ],
  dependencies: [
    .package(
      url: "https://github.com/apple/swift-syntax.git",
      branch: "main"
    ),
  ],
  targets: [
    .macro(
      name: "PowerAssertPlugin",
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
      name: "PowerAssert",
      dependencies: [
        "PowerAssertPlugin",
        "StringWidth",
      ]
    ),
    .target(
      name: "StringWidth",
      dependencies: []
    ),
    .testTarget(
      name: "PowerAssertTests",
      dependencies: ["PowerAssert"]
    ),
  ]
)
