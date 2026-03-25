import Foundation

/// Attempts to repair common JSON malformations produced by LLMs.
///
/// Applied as a fallback when standard JSON parsing fails. Handles:
/// - Smart/curly quotes → straight ASCII quotes
/// - Trailing commas before `}` or `]`
/// - Unescaped double quotes inside string values
enum JSONSanitizer {

  /// Applies all sanitization passes and returns the repaired string.
  static func sanitize(_ json: String) -> String {
    var result = json
    result = replaceSmartQuotes(result)
    result = removeTrailingCommas(result)
    result = fixUnescapedQuotes(result)
    return result
  }

  // MARK: - Smart Quotes

  static func replaceSmartQuotes(_ json: String) -> String {
    json
      .replacingOccurrences(of: "\u{201C}", with: "\"")  // left double "
      .replacingOccurrences(of: "\u{201D}", with: "\"")  // right double "
      .replacingOccurrences(of: "\u{2018}", with: "'")   // left single '
      .replacingOccurrences(of: "\u{2019}", with: "'")   // right single '
  }

  // MARK: - Trailing Commas

  static func removeTrailingCommas(_ json: String) -> String {
    var result: [Character] = []
    let chars = Array(json)
    var inString = false
    var escaped = false

    for i in 0..<chars.count {
      let ch = chars[i]

      if inString {
        if escaped {
          escaped = false
        } else if ch == "\\" {
          escaped = true
        } else if ch == "\"" {
          inString = false
        }
        result.append(ch)
      } else {
        if ch == "\"" {
          inString = true
          result.append(ch)
        } else if ch == "," {
          // Look ahead past whitespace for } or ]
          var j = i + 1
          while j < chars.count && chars[j].isWhitespace { j += 1 }
          if j < chars.count && (chars[j] == "}" || chars[j] == "]") {
            continue  // skip trailing comma
          }
          result.append(ch)
        } else {
          result.append(ch)
        }
      }
    }

    return String(result)
  }

  // MARK: - Unescaped Quotes

  static func fixUnescapedQuotes(_ json: String) -> String {
    var result: [Character] = []
    let chars = Array(json)
    var i = 0
    var inString = false
    var escaped = false

    while i < chars.count {
      let ch = chars[i]

      if inString {
        if escaped {
          escaped = false
          result.append(ch)
        } else if ch == "\\" {
          escaped = true
          result.append(ch)
        } else if ch == "\"" {
          if isStringTerminator(chars: chars, quoteIndex: i) {
            inString = false
            result.append(ch)
          } else {
            // Unescaped internal quote — escape it
            result.append("\\")
            result.append("\"")
          }
        } else {
          result.append(ch)
        }
      } else {
        if ch == "\"" {
          inString = true
        }
        result.append(ch)
      }

      i += 1
    }

    return String(result)
  }

  /// A quote is a string terminator if the next non-whitespace character
  /// is a JSON structural character (`,`, `}`, `]`, `:`) or end-of-input.
  private static func isStringTerminator(chars: [Character], quoteIndex: Int) -> Bool {
    var j = quoteIndex + 1
    while j < chars.count && chars[j].isWhitespace { j += 1 }
    guard j < chars.count else { return true }
    let next = chars[j]
    return next == "," || next == "}" || next == "]" || next == ":"
  }
}
