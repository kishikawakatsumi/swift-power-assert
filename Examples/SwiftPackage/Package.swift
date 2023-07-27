// swift-tools-version: 5.8

import PackageDescription

let package = Package(
  name: "swift-power-assert-example",
  platforms: [
    .iOS(.v13),
    .macOS(.v10_15),
  ],
  dependencies: [
    .package(
      url: "https://github.com/kishikawakatsumi/swift-power-assert.git",
      from: "0.11.1"
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
