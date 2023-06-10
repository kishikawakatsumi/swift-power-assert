import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

@available(macOS 13.0, *)
struct DerivedGeneralCategory {
  struct Raw: Comparable {
    let start: String
    let end: String
    let property: String
    let comments: String

    static func < (lhs: Self, rhs: Self) -> Bool {
      Int(lhs.start, radix: 16)! < Int(rhs.start, radix: 16)!
    }

    static func parse() async throws -> [Self] {
      let (data, _) = try await URLSession(configuration: .ephemeral)
        .data(from: URL(string: "https://www.unicode.org/Public/UNIDATA/extracted/DerivedGeneralCategory.txt")!)
      let result = String(decoding: data, as: UTF8.self)
        .split(separator: "\n")
        .filter { !$0.starts(with: "#") }
        .compactMap { line -> Self? in
          let parts = line.split(separator: ";")
          guard parts.count == 2 else { return nil }
          let rangeParts = parts[0].split(separator: "..")
          guard rangeParts.count == 1 || rangeParts.count == 2 else { return nil }
          let start = rangeParts[0].trimmingCharacters(in: .whitespacesAndNewlines)
          let end = rangeParts.count == 2 ? rangeParts[1].trimmingCharacters(in: .whitespacesAndNewlines) : start
          let property = parts[1].trimmingCharacters(in: .whitespacesAndNewlines).prefix(2).trimmingCharacters(in: .whitespacesAndNewlines)
          let comments = parts[1].split(separator: "# ")[1].trimmingCharacters(in: .whitespacesAndNewlines)
          return Raw(start: start, end: end, property: property, comments: comments)
        }
      return result
    }
  }

  let range: ClosedRange<UInt32>
  let property: String
  var width = 0
}
