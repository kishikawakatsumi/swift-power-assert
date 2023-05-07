// swift-tools-version: 5.8

import PackageDescription

let package = Package(
  name: "TestModule",
  platforms: [
    .macOS(.v13),
    .iOS(.v16),
  ],
  dependencies: [],
  targets: [
    .target(
      name: "PowerAssert",
      dependencies: ["StringWidth"]
    ),
    .target(
      name: "StringWidth",
      dependencies: []
    ),
    .testTarget(
      name: "TestTarget",
      dependencies: ["PowerAssert"]
    ),
  ]
)
