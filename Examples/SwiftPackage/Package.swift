// swift-tools-version: 5.8

import PackageDescription

#if !os(Linux)
let package = Package(
  name: "swift-power-assert-example",
  platforms: [
    .iOS(.v13),
    .macOS(.v10_15),
  ],
  dependencies: [
    .package(
      url: "https://github.com/kishikawakatsumi/swift-power-assert.git",
      from: "0.12.0"
    ),
  ],
  targets: [
    .testTarget(
      name: "ExampleTests",
      dependencies: [
        .product(name: "PowerAssert", package: "swift-power-assert"),
      ]
    ),
  ]
)
#else
let package = Package(
  name: "swift-power-assert-example",
  platforms: [
    .iOS(.v13),
    .macOS(.v10_15),
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
      name: "ExampleTests",
      dependencies: [
        .product(name: "PowerAssert", package: "swift-power-assert"),
        .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
        .product(name: "SwiftOperators", package: "swift-syntax"),
        .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
      ]
    ),
  ]
)
#endif
