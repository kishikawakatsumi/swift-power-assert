import Foundation
// #if canImport(XCTest)
// import XCTest
// #endif

public enum PowerAssert {
  public class Assertion {
    let assertion: String
    let lineNumber: UInt
    let verbose: Bool
    var result = true
    var originalMessage = ""
    var values = [Value]()
    var errors = [Swift.Error]()

    public init(_ assertion: String, line: UInt, verbose: Bool = false) {
      self.assertion = assertion
      self.lineNumber = line
      self.verbose = verbose
    }

    public func capture<T>(expression: @autoclosure () throws -> T?, column: Int) -> Assertion {
      do {
        values.append(Value(value: PowerAssert.valueToString(try expression()), column: column))
      } catch {
        errors.append(error)
      }
      return self
    }

    public func assert(_ expression: @autoclosure () throws -> Bool, _ message: @autoclosure () -> String = "", file: StaticString = #file, line: UInt = #line) -> Assertion {
      do {
        result = try expression()
      } catch {
        errors.append(error)
      }
      return self
    }

    public func render() {
      if !result || verbose {
        var message = ""
        message += "\(assertion)\n"
        values.sort()
        var current = 0
        for value in values {
          PowerAssert.align(&message, current: &current, column: value.column, string: "|")
        }
        message += "\n"
        while !values.isEmpty {
          var current = 0
          var index = 0
          while index < values.count {
            if index == values.count - 1 || ((values[index].column + values[index].value.count < values[index + 1].column) && values[index].value.unicodeScalars.filter({ !$0.isASCII }).isEmpty) {
              PowerAssert.align(&message, current: &current, column: values[index].column, string: values[index].value)
              values.remove(at: index)
            } else {
              PowerAssert.align(&message, current: &current, column: values[index].column, string: "|")
              index += 1
            }
          }
          message += "\n"
        }
        if !result {
// #if canImport(XCTest)
//           XCTFail("\(originalMessage)\n" + message, line: lineNumber)
// #else
          print(message, terminator: "")
// #endif
        } else if verbose {
          print(message, terminator: "")
        }
      }
    }
  }

  struct Value: Comparable {
    let value: String
    let column: Int

    static func <(lhs: Value, rhs: Value) -> Bool {
      return lhs.column < rhs.column
    }

    static func ==(lhs: Value, rhs: Value) -> Bool {
      return lhs.column == rhs.column
    }
  }

  static private func escapeString(_ s: String) -> String {
    return s
      .replacingOccurrences(of: "\"", with: "\\\"")
      .replacingOccurrences(of: "\t", with: "\\t")
      .replacingOccurrences(of: "\r", with: "\\r")
      .replacingOccurrences(of: "\n", with: "\\n")
      .replacingOccurrences(of: "\0", with: "\\0")
  }

  static private func valueToString<T>(_ value: T?) -> String {
#if os(macOS)
    switch value {
    case .some(let v) where v is String || v is Selector: return "\"\(escapeString("\(v)"))\""
    case .some(let v): return "\(v)".replacingOccurrences(of: "\n", with: " ")
    case .none: return "nil"
    }
#else
    switch value {
    case .some(let v) where v is String: return "\"\(escapeString("\(v)"))\""
    case .some(let v): return "\(v)".replacingOccurrences(of: "\n", with: " ")
    case .none: return "nil"
    }
#endif
  }

  static private func align(_ message: inout String, current: inout Int, column: Int, string: String) {
    while current < column {
      message += " "
      current += 1
    }
    message += string
    current += displayWidth(of: string)
  }

  static private func displayWidth(of s: String, inEastAsian: Bool = false) -> Int {
    return s.unicodeScalars.reduce(0) { $0 + displayWidth(of: $1, inEastAsian: inEastAsian) }
  }

  static private func displayWidth(of s: UnicodeScalar, inEastAsian: Bool) -> Int {
    switch s.value {
    case 0x00A1: return inEastAsian ? 2 : 1
    case 0x00A4: return inEastAsian ? 2 : 1
    case 0x00A7: return inEastAsian ? 2 : 1
    case 0x00A8: return inEastAsian ? 2 : 1
    case 0x00AA: return inEastAsian ? 2 : 1
    case 0x00AD: return inEastAsian ? 2 : 1
    case 0x00AE: return inEastAsian ? 2 : 1
    case 0x00B0: return inEastAsian ? 2 : 1
    case 0x00B1: return inEastAsian ? 2 : 1
    case 0x00B2...0x00B3: return inEastAsian ? 2 : 1
    case 0x00B4: return inEastAsian ? 2 : 1
    case 0x00B6...0x00B7: return inEastAsian ? 2 : 1
    case 0x00B8: return inEastAsian ? 2 : 1
    case 0x00B9: return inEastAsian ? 2 : 1
    case 0x00BA: return inEastAsian ? 2 : 1
    case 0x00BC...0x00BE: return inEastAsian ? 2 : 1
    case 0x00BF: return inEastAsian ? 2 : 1
    case 0x00C6: return inEastAsian ? 2 : 1
    case 0x00D0: return inEastAsian ? 2 : 1
    case 0x00D7: return inEastAsian ? 2 : 1
    case 0x00D8: return inEastAsian ? 2 : 1
    case 0x00DE...0x00E1: return inEastAsian ? 2 : 1
    case 0x00E6: return inEastAsian ? 2 : 1
    case 0x00E8...0x00EA: return inEastAsian ? 2 : 1
    case 0x00EC...0x00ED: return inEastAsian ? 2 : 1
    case 0x00F0: return inEastAsian ? 2 : 1
    case 0x00F2...0x00F3: return inEastAsian ? 2 : 1
    case 0x00F7: return inEastAsian ? 2 : 1
    case 0x00F8...0x00FA: return inEastAsian ? 2 : 1
    case 0x00FC: return inEastAsian ? 2 : 1
    case 0x00FE: return inEastAsian ? 2 : 1
    case 0x0101: return inEastAsian ? 2 : 1
    case 0x0111: return inEastAsian ? 2 : 1
    case 0x0113: return inEastAsian ? 2 : 1
    case 0x011B: return inEastAsian ? 2 : 1
    case 0x0126...0x0127: return inEastAsian ? 2 : 1
    case 0x012B: return inEastAsian ? 2 : 1
    case 0x0131...0x0133: return inEastAsian ? 2 : 1
    case 0x0138: return inEastAsian ? 2 : 1
    case 0x013F...0x0142: return inEastAsian ? 2 : 1
    case 0x0144: return inEastAsian ? 2 : 1
    case 0x0148...0x014B: return inEastAsian ? 2 : 1
    case 0x014D: return inEastAsian ? 2 : 1
    case 0x0152...0x0153: return inEastAsian ? 2 : 1
    case 0x0166...0x0167: return inEastAsian ? 2 : 1
    case 0x016B: return inEastAsian ? 2 : 1
    case 0x01CE: return inEastAsian ? 2 : 1
    case 0x01D0: return inEastAsian ? 2 : 1
    case 0x01D2: return inEastAsian ? 2 : 1
    case 0x01D4: return inEastAsian ? 2 : 1
    case 0x01D6: return inEastAsian ? 2 : 1
    case 0x01D8: return inEastAsian ? 2 : 1
    case 0x01DA: return inEastAsian ? 2 : 1
    case 0x01DC: return inEastAsian ? 2 : 1
    case 0x0251: return inEastAsian ? 2 : 1
    case 0x0261: return inEastAsian ? 2 : 1
    case 0x02C4: return inEastAsian ? 2 : 1
    case 0x02C7: return inEastAsian ? 2 : 1
    case 0x02C9...0x02CB: return inEastAsian ? 2 : 1
    case 0x02CD: return inEastAsian ? 2 : 1
    case 0x02D0: return inEastAsian ? 2 : 1
    case 0x02D8...0x02DB: return inEastAsian ? 2 : 1
    case 0x02DD: return inEastAsian ? 2 : 1
    case 0x02DF: return inEastAsian ? 2 : 1
    case 0x0300...0x036F: return inEastAsian ? 2 : 1
    case 0x0391...0x03A1: return inEastAsian ? 2 : 1
    case 0x03A3...0x03A9: return inEastAsian ? 2 : 1
    case 0x03B1...0x03C1: return inEastAsian ? 2 : 1
    case 0x03C3...0x03C9: return inEastAsian ? 2 : 1
    case 0x0401: return inEastAsian ? 2 : 1
    case 0x0410...0x044F: return inEastAsian ? 2 : 1
    case 0x0451: return inEastAsian ? 2 : 1
    case 0x1100...0x115F: return 2
    case 0x2010: return inEastAsian ? 2 : 1
    case 0x2013...0x2015: return inEastAsian ? 2 : 1
    case 0x2016: return inEastAsian ? 2 : 1
    case 0x2018: return inEastAsian ? 2 : 1
    case 0x2019: return inEastAsian ? 2 : 1
    case 0x201C: return inEastAsian ? 2 : 1
    case 0x201D: return inEastAsian ? 2 : 1
    case 0x2020...0x2022: return inEastAsian ? 2 : 1
    case 0x2024...0x2027: return inEastAsian ? 2 : 1
    case 0x2030: return inEastAsian ? 2 : 1
    case 0x2032...0x2033: return inEastAsian ? 2 : 1
    case 0x2035: return inEastAsian ? 2 : 1
    case 0x203B: return inEastAsian ? 2 : 1
    case 0x203E: return inEastAsian ? 2 : 1
    case 0x2074: return inEastAsian ? 2 : 1
    case 0x207F: return inEastAsian ? 2 : 1
    case 0x2081...0x2084: return inEastAsian ? 2 : 1
    case 0x20AC: return inEastAsian ? 2 : 1
    case 0x2103: return inEastAsian ? 2 : 1
    case 0x2105: return inEastAsian ? 2 : 1
    case 0x2109: return inEastAsian ? 2 : 1
    case 0x2113: return inEastAsian ? 2 : 1
    case 0x2116: return inEastAsian ? 2 : 1
    case 0x2121...0x2122: return inEastAsian ? 2 : 1
    case 0x2126: return inEastAsian ? 2 : 1
    case 0x212B: return inEastAsian ? 2 : 1
    case 0x2153...0x2154: return inEastAsian ? 2 : 1
    case 0x215B...0x215E: return inEastAsian ? 2 : 1
    case 0x2160...0x216B: return inEastAsian ? 2 : 1
    case 0x2170...0x2179: return inEastAsian ? 2 : 1
    case 0x2189: return inEastAsian ? 2 : 1
    case 0x2190...0x2194: return inEastAsian ? 2 : 1
    case 0x2195...0x2199: return inEastAsian ? 2 : 1
    case 0x21B8...0x21B9: return inEastAsian ? 2 : 1
    case 0x21D2: return inEastAsian ? 2 : 1
    case 0x21D4: return inEastAsian ? 2 : 1
    case 0x21E7: return inEastAsian ? 2 : 1
    case 0x2200: return inEastAsian ? 2 : 1
    case 0x2202...0x2203: return inEastAsian ? 2 : 1
    case 0x2207...0x2208: return inEastAsian ? 2 : 1
    case 0x220B: return inEastAsian ? 2 : 1
    case 0x220F: return inEastAsian ? 2 : 1
    case 0x2211: return inEastAsian ? 2 : 1
    case 0x2215: return inEastAsian ? 2 : 1
    case 0x221A: return inEastAsian ? 2 : 1
    case 0x221D...0x2220: return inEastAsian ? 2 : 1
    case 0x2223: return inEastAsian ? 2 : 1
    case 0x2225: return inEastAsian ? 2 : 1
    case 0x2227...0x222C: return inEastAsian ? 2 : 1
    case 0x222E: return inEastAsian ? 2 : 1
    case 0x2234...0x2237: return inEastAsian ? 2 : 1
    case 0x223C...0x223D: return inEastAsian ? 2 : 1
    case 0x2248: return inEastAsian ? 2 : 1
    case 0x224C: return inEastAsian ? 2 : 1
    case 0x2252: return inEastAsian ? 2 : 1
    case 0x2260...0x2261: return inEastAsian ? 2 : 1
    case 0x2264...0x2267: return inEastAsian ? 2 : 1
    case 0x226A...0x226B: return inEastAsian ? 2 : 1
    case 0x226E...0x226F: return inEastAsian ? 2 : 1
    case 0x2282...0x2283: return inEastAsian ? 2 : 1
    case 0x2286...0x2287: return inEastAsian ? 2 : 1
    case 0x2295: return inEastAsian ? 2 : 1
    case 0x2299: return inEastAsian ? 2 : 1
    case 0x22A5: return inEastAsian ? 2 : 1
    case 0x22BF: return inEastAsian ? 2 : 1
    case 0x2312: return inEastAsian ? 2 : 1
    case 0x231A...0x231B: return 2
    case 0x2329: return 2
    case 0x232A: return 2
    case 0x23E9...0x23EC: return 2
    case 0x23F0: return 2
    case 0x23F3: return 2
    case 0x2460...0x249B: return inEastAsian ? 2 : 1
    case 0x249C...0x24E9: return inEastAsian ? 2 : 1
    case 0x24EB...0x24FF: return inEastAsian ? 2 : 1
    case 0x2500...0x254B: return inEastAsian ? 2 : 1
    case 0x2550...0x2573: return inEastAsian ? 2 : 1
    case 0x2580...0x258F: return inEastAsian ? 2 : 1
    case 0x2592...0x2595: return inEastAsian ? 2 : 1
    case 0x25A0...0x25A1: return inEastAsian ? 2 : 1
    case 0x25A3...0x25A9: return inEastAsian ? 2 : 1
    case 0x25B2...0x25B3: return inEastAsian ? 2 : 1
    case 0x25B6: return inEastAsian ? 2 : 1
    case 0x25B7: return inEastAsian ? 2 : 1
    case 0x25BC...0x25BD: return inEastAsian ? 2 : 1
    case 0x25C0: return inEastAsian ? 2 : 1
    case 0x25C1: return inEastAsian ? 2 : 1
    case 0x25C6...0x25C8: return inEastAsian ? 2 : 1
    case 0x25CB: return inEastAsian ? 2 : 1
    case 0x25CE...0x25D1: return inEastAsian ? 2 : 1
    case 0x25E2...0x25E5: return inEastAsian ? 2 : 1
    case 0x25EF: return inEastAsian ? 2 : 1
    case 0x25FD...0x25FE: return 2
    case 0x2605...0x2606: return inEastAsian ? 2 : 1
    case 0x2609: return inEastAsian ? 2 : 1
    case 0x260E...0x260F: return inEastAsian ? 2 : 1
    case 0x2614...0x2615: return 2
    case 0x261C: return inEastAsian ? 2 : 1
    case 0x261E: return inEastAsian ? 2 : 1
    case 0x2640: return inEastAsian ? 2 : 1
    case 0x2642: return inEastAsian ? 2 : 1
    case 0x2648...0x2653: return 2
    case 0x2660...0x2661: return inEastAsian ? 2 : 1
    case 0x2663...0x2665: return inEastAsian ? 2 : 1
    case 0x2667...0x266A: return inEastAsian ? 2 : 1
    case 0x266C...0x266D: return inEastAsian ? 2 : 1
    case 0x266F: return inEastAsian ? 2 : 1
    case 0x267F: return 2
    case 0x2693: return 2
    case 0x269E...0x269F: return inEastAsian ? 2 : 1
    case 0x26A1: return 2
    case 0x26AA...0x26AB: return 2
    case 0x26BD...0x26BE: return 2
    case 0x26BF: return inEastAsian ? 2 : 1
    case 0x26C4...0x26C5: return 2
    case 0x26C6...0x26CD: return inEastAsian ? 2 : 1
    case 0x26CE: return 2
    case 0x26CF...0x26D3: return inEastAsian ? 2 : 1
    case 0x26D4: return 2
    case 0x26D5...0x26E1: return inEastAsian ? 2 : 1
    case 0x26E3: return inEastAsian ? 2 : 1
    case 0x26E8...0x26E9: return inEastAsian ? 2 : 1
    case 0x26EA: return 2
    case 0x26EB...0x26F1: return inEastAsian ? 2 : 1
    case 0x26F2...0x26F3: return 2
    case 0x26F4: return inEastAsian ? 2 : 1
    case 0x26F5: return 2
    case 0x26F6...0x26F9: return inEastAsian ? 2 : 1
    case 0x26FA: return 2
    case 0x26FB...0x26FC: return inEastAsian ? 2 : 1
    case 0x26FD: return 2
    case 0x26FE...0x26FF: return inEastAsian ? 2 : 1
    case 0x2705: return 2
    case 0x270A...0x270B: return 2
    case 0x2728: return 2
    case 0x273D: return inEastAsian ? 2 : 1
    case 0x274C: return 2
    case 0x274E: return 2
    case 0x2753...0x2755: return 2
    case 0x2757: return 2
    case 0x2776...0x277F: return inEastAsian ? 2 : 1
    case 0x2795...0x2797: return 2
    case 0x27B0: return 2
    case 0x27BF: return 2
    case 0x2B1B...0x2B1C: return 2
    case 0x2B50: return 2
    case 0x2B55: return 2
    case 0x2B56...0x2B59: return inEastAsian ? 2 : 1
    case 0x2E80...0x2E99: return 2
    case 0x2E9B...0x2EF3: return 2
    case 0x2F00...0x2FD5: return 2
    case 0x2FF0...0x2FFB: return 2
    case 0x3000: return 2
    case 0x3001...0x3003: return 2
    case 0x3004: return 2
    case 0x3005: return 2
    case 0x3006: return 2
    case 0x3007: return 2
    case 0x3008: return 2
    case 0x3009: return 2
    case 0x300A: return 2
    case 0x300B: return 2
    case 0x300C: return 2
    case 0x300D: return 2
    case 0x300E: return 2
    case 0x300F: return 2
    case 0x3010: return 2
    case 0x3011: return 2
    case 0x3012...0x3013: return 2
    case 0x3014: return 2
    case 0x3015: return 2
    case 0x3016: return 2
    case 0x3017: return 2
    case 0x3018: return 2
    case 0x3019: return 2
    case 0x301A: return 2
    case 0x301B: return 2
    case 0x301C: return 2
    case 0x301D: return 2
    case 0x301E...0x301F: return 2
    case 0x3020: return 2
    case 0x3021...0x3029: return 2
    case 0x302A...0x302D: return 2
    case 0x302E...0x302F: return 2
    case 0x3030: return 2
    case 0x3031...0x3035: return 2
    case 0x3036...0x3037: return 2
    case 0x3038...0x303A: return 2
    case 0x303B: return 2
    case 0x303C: return 2
    case 0x303D: return 2
    case 0x303E: return 2
    case 0x3041...0x3096: return 2
    case 0x3099...0x309A: return 2
    case 0x309B...0x309C: return 2
    case 0x309D...0x309E: return 2
    case 0x309F: return 2
    case 0x30A0: return 2
    case 0x30A1...0x30FA: return 2
    case 0x30FB: return 2
    case 0x30FC...0x30FE: return 2
    case 0x30FF: return 2
    case 0x3105...0x312E: return 2
    case 0x3131...0x318E: return 2
    case 0x3190...0x3191: return 2
    case 0x3192...0x3195: return 2
    case 0x3196...0x319F: return 2
    case 0x31A0...0x31BA: return 2
    case 0x31C0...0x31E3: return 2
    case 0x31F0...0x31FF: return 2
    case 0x3200...0x321E: return 2
    case 0x3220...0x3229: return 2
    case 0x322A...0x3247: return 2
    case 0x3248...0x324F: return inEastAsian ? 2 : 1
    case 0x3250: return 2
    case 0x3251...0x325F: return 2
    case 0x3260...0x327F: return 2
    case 0x3280...0x3289: return 2
    case 0x328A...0x32B0: return 2
    case 0x32B1...0x32BF: return 2
    case 0x32C0...0x32FE: return 2
    case 0x3300...0x33FF: return 2
    case 0x3400...0x4DB5: return 2
    case 0x4DB6...0x4DBF: return 2
    case 0x4E00...0x9FEA: return 2
    case 0x9FEB...0x9FFF: return 2
    case 0xA000...0xA014: return 2
    case 0xA015: return 2
    case 0xA016...0xA48C: return 2
    case 0xA490...0xA4C6: return 2
    case 0xA960...0xA97C: return 2
    case 0xAC00...0xD7A3: return 2
    case 0xE000...0xF8FF: return inEastAsian ? 2 : 1
    case 0xF900...0xFA6D: return 2
    case 0xFA6E...0xFA6F: return 2
    case 0xFA70...0xFAD9: return 2
    case 0xFADA...0xFAFF: return 2
    case 0xFE00...0xFE0F: return inEastAsian ? 2 : 1
    case 0xFE10...0xFE16: return 2
    case 0xFE17: return 2
    case 0xFE18: return 2
    case 0xFE19: return 2
    case 0xFE30: return 2
    case 0xFE31...0xFE32: return 2
    case 0xFE33...0xFE34: return 2
    case 0xFE35: return 2
    case 0xFE36: return 2
    case 0xFE37: return 2
    case 0xFE38: return 2
    case 0xFE39: return 2
    case 0xFE3A: return 2
    case 0xFE3B: return 2
    case 0xFE3C: return 2
    case 0xFE3D: return 2
    case 0xFE3E: return 2
    case 0xFE3F: return 2
    case 0xFE40: return 2
    case 0xFE41: return 2
    case 0xFE42: return 2
    case 0xFE43: return 2
    case 0xFE44: return 2
    case 0xFE45...0xFE46: return 2
    case 0xFE47: return 2
    case 0xFE48: return 2
    case 0xFE49...0xFE4C: return 2
    case 0xFE4D...0xFE4F: return 2
    case 0xFE50...0xFE52: return 2
    case 0xFE54...0xFE57: return 2
    case 0xFE58: return 2
    case 0xFE59: return 2
    case 0xFE5A: return 2
    case 0xFE5B: return 2
    case 0xFE5C: return 2
    case 0xFE5D: return 2
    case 0xFE5E: return 2
    case 0xFE5F...0xFE61: return 2
    case 0xFE62: return 2
    case 0xFE63: return 2
    case 0xFE64...0xFE66: return 2
    case 0xFE68: return 2
    case 0xFE69: return 2
    case 0xFE6A...0xFE6B: return 2
    case 0xFF01...0xFF03: return 2
    case 0xFF04: return 2
    case 0xFF05...0xFF07: return 2
    case 0xFF08: return 2
    case 0xFF09: return 2
    case 0xFF0A: return 2
    case 0xFF0B: return 2
    case 0xFF0C: return 2
    case 0xFF0D: return 2
    case 0xFF0E...0xFF0F: return 2
    case 0xFF10...0xFF19: return 2
    case 0xFF1A...0xFF1B: return 2
    case 0xFF1C...0xFF1E: return 2
    case 0xFF1F...0xFF20: return 2
    case 0xFF21...0xFF3A: return 2
    case 0xFF3B: return 2
    case 0xFF3C: return 2
    case 0xFF3D: return 2
    case 0xFF3E: return 2
    case 0xFF3F: return 2
    case 0xFF40: return 2
    case 0xFF41...0xFF5A: return 2
    case 0xFF5B: return 2
    case 0xFF5C: return 2
    case 0xFF5D: return 2
    case 0xFF5E: return 2
    case 0xFF5F: return 2
    case 0xFF60: return 2
    case 0xFFE0...0xFFE1: return 2
    case 0xFFE2: return 2
    case 0xFFE3: return 2
    case 0xFFE4: return 2
    case 0xFFE5...0xFFE6: return 2
    case 0xFFFD: return inEastAsian ? 2 : 1
    case 0x16FE0...0x16FE1: return 2
    case 0x17000...0x187EC: return 2
    case 0x18800...0x18AF2: return 2
    case 0x1B000...0x1B0FF: return 2
    case 0x1B100...0x1B11E: return 2
    case 0x1B170...0x1B2FB: return 2
    case 0x1F004: return 2
    case 0x1F0CF: return 2
    case 0x1F100...0x1F10A: return inEastAsian ? 2 : 1
    case 0x1F110...0x1F12D: return inEastAsian ? 2 : 1
    case 0x1F130...0x1F169: return inEastAsian ? 2 : 1
    case 0x1F170...0x1F18D: return inEastAsian ? 2 : 1
    case 0x1F18E: return 2
    case 0x1F18F...0x1F190: return inEastAsian ? 2 : 1
    case 0x1F191...0x1F19A: return 2
    case 0x1F19B...0x1F1AC: return inEastAsian ? 2 : 1
    case 0x1F200...0x1F202: return 2
    case 0x1F210...0x1F23B: return 2
    case 0x1F240...0x1F248: return 2
    case 0x1F250...0x1F251: return 2
    case 0x1F260...0x1F265: return 2
    case 0x1F300...0x1F320: return 2
    case 0x1F32D...0x1F335: return 2
    case 0x1F337...0x1F37C: return 2
    case 0x1F37E...0x1F393: return 2
    case 0x1F3A0...0x1F3CA: return 2
    case 0x1F3CF...0x1F3D3: return 2
    case 0x1F3E0...0x1F3F0: return 2
    case 0x1F3F4: return 2
    case 0x1F3F8...0x1F3FA: return 2
    case 0x1F3FB...0x1F3FF: return 2
    case 0x1F400...0x1F43E: return 2
    case 0x1F440: return 2
    case 0x1F442...0x1F4FC: return 2
    case 0x1F4FF...0x1F53D: return 2
    case 0x1F54B...0x1F54E: return 2
    case 0x1F550...0x1F567: return 2
    case 0x1F57A: return 2
    case 0x1F595...0x1F596: return 2
    case 0x1F5A4: return 2
    case 0x1F5FB...0x1F5FF: return 2
    case 0x1F600...0x1F64F: return 2
    case 0x1F680...0x1F6C5: return 2
    case 0x1F6CC: return 2
    case 0x1F6D0...0x1F6D2: return 2
    case 0x1F6EB...0x1F6EC: return 2
    case 0x1F6F4...0x1F6F8: return 2
    case 0x1F910...0x1F93E: return 2
    case 0x1F940...0x1F94C: return 2
    case 0x1F950...0x1F96B: return 2
    case 0x1F980...0x1F997: return 2
    case 0x1F9C0: return 2
    case 0x1F9D0...0x1F9E6: return 2
    case 0x20000...0x2A6D6: return 2
    case 0x2A6D7...0x2A6FF: return 2
    case 0x2A700...0x2B734: return 2
    case 0x2B735...0x2B73F: return 2
    case 0x2B740...0x2B81D: return 2
    case 0x2B81E...0x2B81F: return 2
    case 0x2B820...0x2CEA1: return 2
    case 0x2CEA2...0x2CEAF: return 2
    case 0x2CEB0...0x2EBE0: return 2
    case 0x2EBE1...0x2F7FF: return 2
    case 0x2F800...0x2FA1D: return 2
    case 0x2FA1E...0x2FFFD: return 2
    case 0x30000...0x3FFFD: return 2
    case 0xE0100...0xE01EF: return inEastAsian ? 2 : 1
    case 0xF0000...0xFFFFD: return inEastAsian ? 2 : 1
    case 0x100000...0x10FFFD: return inEastAsian ? 2 : 1
    default: return 1
    }
  }
}
