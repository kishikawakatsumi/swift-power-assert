import XCTest
@testable import PowerAssert

final class WordDiffTests: XCTestCase {
  override func setUp() {
    setenv("NO_COLOR", "1", 1)
  }

  override func tearDown() {
    unsetenv("NO_COLOR")
  }

  func testIdenticalStrings() {
    #assert(wordDiff("Hello, World!", "Hello, World!") == "Hello, World!")
  }

  func testCompletelyDifferentStrings() {
    #assert(wordDiff("apple", "orange") == "{+or+}a[-ppl-]{+ng+}e")
  }

  func testPartiallyMatchingStrings() {
    #assert(wordDiff("The quick brown fox", "The slow brown fox") == "The [-quick-]{+slow+} brown fox")
  }

  func testCaseSensitiveStrings() {
    #assert(wordDiff("SwiftLanguage", "swiftlanguage") == "[-S-]{+s+}wift[-L-]{+l+}anguage")
  }

  func testEmptyAndNonEmptyStrings() {
    #assert(wordDiff("", "Hello, World!") == "{+Hello, World!+}")
  }

  func testSpecialCharacterStrings() {
    #assert(wordDiff("#$%^&*()", "!@#$%^&*()") == "{+!@+}#$%^&*()")
  }

  func testUnicodeCharacterStrings() {
    #assert(wordDiff("こんにちは世界", "こんばんは世界") == "こん[-にち-]{+ばん+}は世界")
  }

  func testInsertionAndDeletionInStrings() {
    #assert(wordDiff("Artificial Intelligence", "Artificially Intelligent") == "Artificial{+ly+} Intelligen[-ce-]{+t+}")
  }

  func testBothStringsAreEmpty() {
    #assert(wordDiff("", "") == "")
  }

  func testOneStringIsEmpty() {
    #assert(wordDiff("", "Hello") == "{+Hello+}")
    #assert(wordDiff("Hello", "") == "[-Hello-]")
  }

  func testBothStringsAreEqual() {
    #assert(wordDiff("Hello", "Hello") == "Hello")
  }

  func testDifferentLengthStrings() {
    #assert(wordDiff("Hello", "Hello World") == "Hello{+ World+}")
    #assert(wordDiff("Goodbye", "Bye") == "[-Goodb-]{+B+}ye")
  }

  func testDifferentStringsSameLength() {
    #assert(wordDiff("Hello", "Hullo") == "H[-e-]{+u+}llo")
    #assert(wordDiff("Hello", "Halal") == "H[-e-]{+a+}l{+a+}l[-o-]")
  }

  func testDifferentStringsInsertionOrRemoval() {
    #assert(wordDiff("Hello", "Hillo") == "H[-e-]{+i+}llo")
    #assert(wordDiff("Hello", "Helo") == "Hel[-l-]o")
    #assert(wordDiff("Hello", "Helol") == "Hel[-l-]o{+l+}")
  }

  func testRepeatedCharactersInStrings() {
    #assert(wordDiff("aaaaa", "aaabb") == "aaa[-aa-]{+bb+}")
  }
}
