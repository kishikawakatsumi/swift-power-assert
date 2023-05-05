// swift-tools-version: 5.8

import PackageDescription

let package = Package(
  name: "TestModule",
  platforms: [
    .iOS(.v16),
    .macOS(.v13),
  ],
  dependencies: [],
  targets: [
    .target(
      name: "PowerAssert")
    ,
    .testTarget(
      name: "TestTarget",
      dependencies: ["PowerAssert"]
    ),
  ]
)
