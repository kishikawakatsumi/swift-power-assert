import Foundation

public func stringWidth(_ string: String) -> Int {
  return stripANCIEscapes(string)
    .precomposedStringWithCanonicalMapping
    .reduce(0) { (partialResult, character) in
      let first = character.unicodeScalars.first!
      return partialResult + codePointWidth(first)
    }
}

func stripANCIEscapes(_ string: String) -> String {
  let regex = #/[\u001B\u009B][\[\]()#;?]*(?:(?:(?:(?:;[-a-zA-Z\d\/#&.:=?%@~_]+)*|[a-zA-Z\d]+(?:;[-a-zA-Z\d\/#&.:=?%@~_]*)*)?\u0007)|(?:(?:\d{1,4}(?:;\d{0,4})*)?[\dA-PR-TZcf-nq-uy=><~]))/#
  return string.replacing(regex, with: "")
}
