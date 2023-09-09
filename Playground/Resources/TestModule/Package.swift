// swift-tools-version: 5.8

import PackageDescription

let package = Package(
  name: "TestModule",
  platforms: [
    .macOS(.v13),
    .iOS(.v16),
  ],
  dependencies: [
    .package(
      url: "https://github.com/kishikawakatsumi/swift-power-assert.git",
      from: "0.12.0"
    ),
    .package(
      url: "https://github.com/apple/swift-syntax.git",
      from: "509.0.0-swift-DEVELOPMENT-SNAPSHOT-2023-09-05-a"
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
