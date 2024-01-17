import Foundation

@available(macOS 13.0, *)
func generate() async throws {
  print("import Foundation")
  print("")
  print("func codePointWidth(_ scalar: UnicodeScalar) -> Int {")
  print("  switch scalar.value {")

  do {
    var result = [DerivedGeneralCategory]()
    try await DerivedGeneralCategory.Raw.parse()
      .filter { ["Mn", "Me", "Cc"].contains($0.property) }
      .sorted()
      .forEach {
        let start = UInt32($0.start, radix: 16)!
        let end = UInt32($0.end, radix: 16)!
        if let last = result.last, last.range.upperBound + 1 == start && last.property == $0.property {
          let merged = DerivedGeneralCategory(range: last.range.lowerBound...end, property: last.property)
          result = result.dropLast()
          result.append(merged)
        } else {
          result.append(DerivedGeneralCategory(range: start...end, property: $0.property))
        }
      }

    result.forEach {
      print("  case \($0.range.lowerBound)...\($0.range.upperBound): return \($0.width)")
    }
  }

  do {
    var result = [DerivedCoreProperties]()
    try await DerivedCoreProperties.Raw.parse()
      .filter { $0.property == "Default_Ignorable_Code_Point" }
      .sorted()
      .forEach {
        let start = UInt32($0.start, radix: 16)!
        let end = UInt32($0.end, radix: 16)!
        if let last = result.last, last.range.upperBound + 1 == start && last.property == $0.property {
          let merged = DerivedCoreProperties(range: last.range.lowerBound...end, property: last.property)
          result = result.dropLast()
          result.append(merged)
        } else {
          result.append(DerivedCoreProperties(range: start...end, property: $0.property))
        }
      }

    result.forEach {
      print("  case \($0.range.lowerBound)...\($0.range.upperBound): return \($0.width)")
    }
  }

  do {
    var result = [EastAsianWidth]()
    try await EastAsianWidth.Raw.parse()
      .sorted()
      .forEach {
        let start = UInt32($0.start, radix: 16)!
        let end = UInt32($0.end, radix: 16)!
        if let last = result.last, last.range.upperBound + 1 == start && last.property == $0.property {
          let merged = EastAsianWidth(range: last.range.lowerBound...end, property: last.property)
          result = result.dropLast()
          result.append(merged)
        } else {
          result.append(EastAsianWidth(range: start...end, property: $0.property))
        }
      }

    result.forEach {
      print("  case \($0.range.lowerBound)...\($0.range.upperBound): return \($0.width)")
    }
  }

  print("  default: return 1")
  print("  }")
  print("}")
}
