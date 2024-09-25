// swift-tools-version: 5.9

import PackageDescription

let package = Package(
  name: "TestModule",
  dependencies: [
    .package(
      url: "https://github.com/kishikawakatsumi/swift-power-assert.git",
      from: "0.12.0"
    ),
    .package(
      url: "https://github.com/apple/swift-syntax.git",
      from: "600.0.1"
    ),
  ],
  targets: [
    .testTarget(
      name: "TestTarget",
      dependencies: [
        .product(name: "PowerAssert", package: "swift-power-assert"),
        .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
        .product(name: "SwiftOperators", package: "swift-syntax"),
        .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
      ]
    ),
  ]
)
