import Foundation

class Console {
  enum Style {
    case bold, italic, underline, color(_ color: Color)
  }

  enum Color: String {
    case black = "30"
    case red = "31"
    case green = "32"
    case yellow = "33"
    case blue = "34"
    case magenta = "35"
    case cyan = "36"
    case white = "37"
  }

  static func decorate(_ style: Style, on text: String) -> String {
    decorate([style], on: text)
  }

  static func decorate(_ styles: [Style], on text: String) -> String {
    guard isTTY() else { return text }

    return styles.reduce(text) { (result, style) in
      switch style {
      case .bold:
        return "\u{001b}[1m\(result)\u{001b}[22m"
      case .italic:
        return "\u{001b}[3m\(result)\u{001b}[23m"
      case .underline:
        return "\u{001b}[4m\(result)\u{001b}[24m"
      case .color(let color):
        return "\u{001b}[\(color.rawValue)m\(result)\u{001b}[0m"
      }
    }
  }

  private static func isTTY() -> Bool {
    let environment = ProcessInfo.processInfo.environment
    guard environment["NO_COLOR"] == nil else { return false }
    guard let term = environment["TERM"] else { return false }
    guard term.lowercased() != "dumb" else { return false }
    // https://github.com/apple/swift-package-manager/issues/6081
    // guard isatty(fileno(stdout)) != 0 else { return false }
    return true
  }
}

extension String {
  var bold: String {
    decorated(with: .bold)
  }

  var red: String {
    decorated(with: .color(.red))
  }

  var green: String {
    decorated(with: .color(.green))
  }

  func decorated(with style: Console.Style) -> String {
    self.decorated(with: [style])
  }

  func decorated(with styles: [Console.Style]) -> String {
    Console.decorate(styles, on: self)
  }
}

