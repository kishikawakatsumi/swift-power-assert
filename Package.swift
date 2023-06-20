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
      from: "509.0.0-swift-DEVELOPMENT-SNAPSHOT-2023-06-17-a"
    ),
  ],
  targets: [
    .macro(
      name: "PowerAssertPlugin",
      dependencies: [
        .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
        .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
        "StringWidth",
      ],
      swiftSettings: [
        .enableUpcomingFeature("ExistentialAny")
      ]
    ),
    .target(
      name: "PowerAssert",
      dependencies: [
        "PowerAssertPlugin",
        "StringWidth",
      ],
      swiftSettings: [
        .enableUpcomingFeature("ExistentialAny")
      ]
    ),
    .target(
      name: "StringWidth",
      dependencies: [],
      exclude: [
        "DerivedCoreProperties.swift",
        "DerivedGeneralCategory.swift",
        "EastAsianWidth.swift",
        "GenerateCodePointWidth.swift",
        "URLSession+Linux.swift",
      ],
      swiftSettings: [
        .enableUpcomingFeature("ExistentialAny")
      ]
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
