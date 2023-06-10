// swift-tools-version: 5.9

import CompilerPluginSupport
import PackageDescription

let package = Package(
  name: "SwiftPowerAssert",
  platforms: [
    .macOS(.v10_15),
    .iOS(.v13),
    .tvOS(.v13),
    .watchOS(.v6),
    .macCatalyst(.v13)
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
      from: "509.0.0-swift-5.9-DEVELOPMENT-SNAPSHOT-2023-04-25-b"
    ),
  ],
  targets: [
    .macro(
      name: "PowerAssertPlugin",
      dependencies: [
        .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
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
      dependencies: [
        "PowerAssert",
        .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
      ]
    ),
  ]
)
