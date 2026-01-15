import Foundation

/// Incremental parser that extracts the latest valid component JSON object
/// from a stream of partial JSON text.
public struct PartialJSONParser {
  private var buffer: String

  public init() {
    self.buffer = ""
  }

  /// Appends a JSON chunk to the internal buffer.
  /// - Parameter chunk: A partial JSON string from the stream.
  public mutating func append(_ chunk: String) {
    buffer.append(chunk)
  }

  /// Clears the internal buffer.
  public mutating func reset() {
    buffer.removeAll(keepingCapacity: false)
  }

  /// Returns the latest complete JSON object string found in the buffer.
  public func latestJSONString() -> String? {
    guard let range = lastCompleteObjectRange(in: buffer) else { return nil }
    return String(buffer[range])
  }

  /// Attempts to decode the latest complete JSON object as a ComponentNode.
  public func latestComponentNode() -> ComponentNode? {
    guard let json = latestJSONString() else { return nil }
    return ComponentNode.from(json: json)
  }

  private func lastCompleteObjectRange(in text: String) -> Range<String.Index>? {
    var depth = 0
    var startIndex: String.Index?
    var lastRange: Range<String.Index>?
    var inString = false
    var escaped = false

    var index = text.startIndex
    while index < text.endIndex {
      let character = text[index]

      if inString {
        if escaped {
          escaped = false
        } else if character == "\\" {
          escaped = true
        } else if character == "\"" {
          inString = false
        }
      } else {
        if character == "\"" {
          inString = true
        } else if character == "{" {
          if depth == 0 {
            startIndex = index
          }
          depth += 1
        } else if character == "}" {
          if depth > 0 {
            depth -= 1
            if depth == 0, let start = startIndex {
              let end = text.index(after: index)
              lastRange = start..<end
            }
          }
        }
      }

      index = text.index(after: index)
    }

    return lastRange
  }
}
