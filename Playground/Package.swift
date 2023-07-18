// swift-tools-version:5.8
import PackageDescription

let package = Package(
  name: "power-assert-playground",
  platforms: [
    .macOS(.v13)
  ],
  dependencies: [
    .package(url: "https://github.com/vapor/vapor.git", from: "4.77.2"),
    .package(url: "https://github.com/vapor/leaf.git", from: "4.2.4"),
    .package(
      url: "https://github.com/apple/swift-syntax.git",
      from: "509.0.0-swift-DEVELOPMENT-SNAPSHOT-2023-07-10-a"
    ),
    .package(url: "https://github.com/apple/swift-tools-support-core", from: "0.5.2"),
  ],
  targets: [
    .target(
      name: "PowerAssertPlugin",
      dependencies: [
        .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
        .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
        "StringWidth",
      ],
      exclude: ["PowerAssertPlugin.swift"],
      swiftSettings: [
        .define("SWIFTPOWERASSERT_PLAYGROUND"),
      ]
    ),
    .target(
      name: "StringWidth",
      dependencies: []
    ),
    .executableTarget(
      name: "App",
      dependencies: [
        .product(name: "Vapor", package: "vapor"),
        .product(name: "Leaf", package: "leaf"),
        .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
        .product(name: "SwiftParser", package: "swift-syntax"),
        .product(name: "TSCBasic", package: "swift-tools-support-core"),
        "PowerAssertPlugin",
      ],
      swiftSettings: [
        .unsafeFlags(["-cross-module-optimization"], .when(configuration: .release)),
      ]
    ),
  ]
)
