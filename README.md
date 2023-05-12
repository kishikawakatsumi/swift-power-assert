<p align="center">
  <img width="640px" src="https://user-images.githubusercontent.com/40610/235353186-552ae826-c981-422d-8e75-e6b487a00bbd.png" />
</p>

# Swift Power Assert

![test workflow](https://github.com/kishikawakatsumi/swift-power-assert/actions/workflows/test.yml/badge.svg)
[![Build Status](https://app.bitrise.io/app/4018c2f1-9f94-4913-8a4c-deb1a8e1410a/status.svg?token=weITzhYlOhv2XfaNU41GkQ&branch=main)](https://app.bitrise.io/app/4018c2f1-9f94-4913-8a4c-deb1a8e1410a)
[![codecov](https://codecov.io/gh/kishikawakatsumi/swift-power-assert/branch/main/graph/badge.svg?token=rPTZiZLsmo)](https://codecov.io/gh/kishikawakatsumi/swift-power-assert)

Power asserts (also known as diagrammed assertions) augment your assertion failures with information about the values produced during evaluation of a condition, and present it in an easily digestible form. Power asserts are a popular feature of [Spock](https://github.com/spockframework/spock) (and later the entire [Groovy](https://github.com/apache/groovy) language independent of Spock), [ScalaTest](http://www.scalatest.org/) and [Expecty](https://github.com/pniederw/expecty).

Power asserts provide descriptive assertion messages for your tests, like the following examples:

```
#assert(numbers[2] == 4)
        │       ││ │  │
        │       │3 │  4
        │       2  false
        [1, 2, 3, 4, 5]

- expected + actual

--- [Int] numbers[2]
+++ [Int] 4
–3
+4

[Int] numbers[2]
=> 3
[Int] 4
=> 4

#assert(numbers.contains(6))
        │       │        │
        │       false    6
        [1, 2, 3, 4, 5]

#assert(string1 == string2)
        │       │  │
        │       │  "Hello, Swift!"
        │       false
        "Hello, world!"

- expected + actual

--- [String] string1
+++ [String] string2
Hello, {+S+}w[-orld-]{+ift+}!

[String] string1
=> "Hello, world!"
[String] string2
=> "Hello, Swift!"
```

## Online Playground

[:sparkles: **Experience the library in action with our online playground!** :sparkles: Click here to access the interactive demo.](https://power-assert.swiftfiddle.com/)

## Why Power Assert?

When writing tests, we need to use different assertion functions. With Power Assert you only use the `#assert()` function. There are many
Assertion APIs, no need to remember them. Just create an expression that returns a boolean value and Power Assert will automatically display rich error information.

## Getting Started

Swift Power Assert is implemented using [macros](https://github.com/apple/swift-evolution/blob/main/proposals/0382-expression-macros.md), an experimental feature of Swift. Therefore, you must use the pre-release version of the Swift toolchain to use this library.

1. Download and install the toolchain from [the development snapshot on Swift.org](https://www.swift.org/download/) after May 7, 2023.
2. Set the toolchain identifier in the `TOOLCHAINS` environment variable to use the pre-release toolchain.
   For example:

   ```shell
   export TOOLCHAINS=org.swift.59202305071a
   ```

   Note: To find out the toolchain identifier, check the Info.plist in the toolchain. Toolchains are usually installed in `/Library/Developer/Toolchains/'. Right-click on the toolchain icon and select "Show Package Contents" to find the Info.plist; the value of the Bundle Identifier key in the Info.plist is the toolchain identifier.
   For more information, see Sarun's excellent article.
   https://sarunw.com/posts/how-to-use-pre-release-swift-version-with-command-line-tools/

## Check it out

To see PowerAssert in action, go to the Examples directory and run `swift test`.

```
$ cd Example
$ swift test
```

See the following results?

```
...
Test Suite 'All tests' started at 2023-04-05 07:17:58.800
Test Suite 'swift-power-assert-examplePackageTests.xctest' started at 2023-04-05 07:17:58.801
Test Suite 'PowerAssertTests' started at 2023-04-05 07:17:58.801
Test Case '-[ExampleTests.PowerAssertTests testExample]' started.
/swift-power-assert/Example/"ExampleTests/ExampleTests.swift":8: error: -[ExampleTests.PowerAssertTests testExample] : failed -
#assert(a * b == 91)
        │ │ │ │  │
        │ │ 9 │  91
        │ 90  false
        10

[Int] a
=> 10
[Int] b
=> 9
[Int] a * b
=> 90
[Int] 91
=> 91
/swift-power-assert/Example/"ExampleTests/ExampleTests.swift":11: error: -[ExampleTests.PowerAssertTests testExample] : failed -
#assert(xs.contains(4))
        │  │        │
        │  false    4
        [1, 2, 3]
...
```

Modify the code in `Example/Tests/ExampleTests.swift` to try different patterns you like.

## Usage

To use Swift Power Assert in your library or application, first add SwiftPowerAssert to the Swift package manager.

```swift
// swift-tools-version:5.8
import PackageDescription

let package = Package(
  name: "MyLibrary",
  dependencies: [
    ...,
    .package(
        url: "https://github.com/kishikawakatsumi/swift-power-assert.git",
        branch: "main"
    ),
  ],
  targets: [
    ...,
    .testTarget(
      name: "MyLibraryTests",
      dependencies: [
        ...,
        .product(name: "PowerAssert", package: "swift-power-assert"),
      ]
    ),
  ]
)
```

Next, you can use Power Assert in your tests with the `#assert()` macro.

```swift
// MyLibraryTests.swift
import XCTest
import PowerAssert
@testable import MyLibrary

final class MyLibraryTests: XCTestCase {
  func testExample() {
    let a = 7
    let b = 4
    let c = 12

    #assert(max(a, b) == c)
  }
}
```

### Concurrency (async/await) support

Swift Power Assert library allows you to write assertions with `async/await` expressions directly. Here's a sample code demonstrating its seamless support for `async/await`:

```swift
func testConcurrency() async {
  let ok = "OK"
  #assert(await upload(content: "example") == ok)
}
```

## Testing assistance requested

Swift Power Assert is still in the early stages of development. If you could help us with testing, we would greatly appreciate it! Please try different code patterns using this library and report any problems you encounter. We welcome your feedback and improvement suggestions. Thank you very much!

## Frequently Asked Questions

**Q: I want to display the result even if the test is successful (i.e. the expression in the `#assert()` function evaluates to `true`).**

A: By default, the `#assert()` function does not display the result if the expression evaluates to `true`, because the test was successful. To always print the result, set the `verbose` argument to true.

For example:

```swift
#assert(x == y, verbose: true)
```

**Q: I want to know how the compiler actually expanded the macro.**

A: You can use the `-dump-macro-expansions` option to dump the macro expansion.

For example:

```
$ cd Example
$ swift test -Xswiftc -Xfrontend -Xswiftc -dump-macro-expansions
```

If you run the above with the `-dump-macro-expansions` option, you will get the following output.

```
...
@__swiftmacro_12ExampleTests011PowerAssertB0C04testA0yyF6assertfMf_.swift as ()
------------------------------
PowerAssert.Assertion("#assert(a * b == 91)", message: "", file: #""ExampleTests/ExampleTests.swift""#, line: 8, verbose: false, binaryExpressions: [0: "a", 2: "a * b", 3: "91", 1: "b"]) {
    $0.capture($0.capture($0.capture(a .self, column: 8, id: 0) * $0.capture(b .self, column: 12, id: 1), column: 10, id: 2) == $0.capture(91, column: 17, id: 3), column: 14, id: 4)
}
.render()
------------------------------
...
```

## Supporters & Sponsors

Open source projects thrive on the generosity and support of people like you. If you find this project valuable, please consider extending your support. Contributing to the project not only sustains its growth, but also helps drive innovation and improve its features.

To support this project, you can become a sponsor through [GitHub Sponsors](https://github.com/sponsors/kishikawakatsumi). Your contribution will be greatly appreciated and will help keep the project alive and thriving. Thanks for your consideration! :heart:

## Author

[Kishikawa Katsumi](https://github.com/kishikawakatsumi)

## License

The project is released under the [MIT License](https://github.com/kishikawakatsumi/swift-power-assert/blob/main/LICENSE)
