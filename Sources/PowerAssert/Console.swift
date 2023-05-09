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

  static func output(_ text: String = "", _ styles: Style...) {
    print(apply(styles, to: text))
  }

  static func apply(_ styles: [Style], to text: String) -> String {
    guard isTTY() else { return text }

    var result = text
    for style in styles {
      switch style {
      case .bold:
        result = "\u{001b}[1m\(result)\u{001b}[22m"
      case .italic:
        result = "\u{001b}[3m\(result)\u{001b}[23m"
      case .underline:
        result = "\u{001b}[4m\(result)\u{001b}[24m"
      case .color(let color):
        result = "\u{001b}[\(color.rawValue)m\(result)\u{001b}[0m"
      }
    }
    return result
  }

  private static func isTTY() -> Bool {
    let environment = ProcessInfo.processInfo.environment
    guard environment["NO_COLOR"] == nil else { return false }
    guard let term = environment["TERM"] else { return false }
    guard term.lowercased() != "dumb" else { return false }
    // https://github.com/apple/swift-package-manager/issues/6081
//    guard isatty(fileno(stdout)) != 0 else { return false }
    return true
  }
}
