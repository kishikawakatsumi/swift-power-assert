import Foundation

public func stringWidth(_ string: String) -> Int {
  return stripANSIEscapes(string)
    .precomposedStringWithCanonicalMapping
    .reduce(0) { (partialResult, character) in
      let first = character.unicodeScalars.first!
      return partialResult + codePointWidth(first)
    }
}

func stripANSIEscapes(_ string: String) -> String {
  let pattern = #"[\u001B\u009B][\[\]()#;?]*(?:(?:(?:(?:;[-a-zA-Z\d\/#&.:=?%@~_]+)*|[a-zA-Z\d]+(?:;[-a-zA-Z\d\/#&.:=?%@~_]*)*)?\u0007)|(?:(?:\d{1,4}(?:;\d{0,4})*)?[\dA-PR-TZcf-nq-uy=><~]))"#
  return string.replacingOccurrences(of: pattern, with: "", options: .regularExpression)
}
