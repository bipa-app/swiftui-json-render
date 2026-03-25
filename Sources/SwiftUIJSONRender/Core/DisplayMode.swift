import Foundation

/// How the rendered component tree should be displayed in the host app.
///
/// - `inline`: Rendered directly in the content flow (e.g., chat timeline).
/// - `document`: Shows a compact preview; tapping opens a full-screen sheet
///   with the complete component tree.
public enum DisplayMode: String, Codable, Sendable {
  /// Rendered directly in the content flow. Max height ~400pt recommended.
  case inline

  /// Preview card in flow, full view in an expandable sheet.
  /// Requires `title` and optionally `preview` in the root JSON.
  case document
}

/// Metadata for document display mode.
public struct DocumentMetadata: Codable, Sendable, Equatable {
  /// Title shown in the preview card and the sheet navigation bar.
  public let title: String

  /// Optional summary text shown in the preview card.
  public let preview: String?

  public init(title: String, preview: String? = nil) {
    self.title = title
    self.preview = preview
  }
}

/// A parsed render request from the agent, containing display mode and component tree.
public struct RenderRequest: Sendable, Equatable {
  /// How to display the content.
  public let display: DisplayMode

  /// Document metadata (only for `.document` display mode).
  public let document: DocumentMetadata?

  /// The root component tree.
  public let root: ComponentNode

  /// Parses a render request from a JSON string.
  ///
  /// Expected shape:
  /// ```json
  /// {
  ///   "display": "inline",
  ///   "root": { "type": "card", "children": [...] }
  /// }
  /// ```
  /// or for documents:
  /// ```json
  /// {
  ///   "display": "document",
  ///   "title": "Report Title",
  ///   "preview": "Summary text",
  ///   "root": { ... }
  /// }
  /// ```
  public static func from(json: String) -> RenderRequest? {
    guard let data = json.data(using: .utf8) else { return nil }

    if let obj = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
      return from(dictionary: obj)
    }

    // Fallback: sanitize the outer JSON and retry
    let sanitized = JSONSanitizer.sanitize(json)
    guard sanitized != json,
          let sanitizedData = sanitized.data(using: .utf8),
          let obj = try? JSONSerialization.jsonObject(with: sanitizedData) as? [String: Any]
    else { return nil }
    return from(dictionary: obj)
  }

  /// Parses a render request from a dictionary.
  public static func from(dictionary obj: [String: Any]) -> RenderRequest? {
    let displayStr = obj["display"] as? String ?? "inline"
    let display = DisplayMode(rawValue: displayStr) ?? .inline

    // Parse root component node
    let root: ComponentNode
    if let rootObj = obj["root"] {
      if let rootString = rootObj as? String {
        // root is a double-encoded JSON string — parse it
        guard let node = ComponentNode.from(json: rootString) else { return nil }
        root = node
      } else if JSONSerialization.isValidJSONObject(rootObj),
                let rootData = try? JSONSerialization.data(withJSONObject: rootObj),
                let node = ComponentNode.from(data: rootData) {
        // root is a JSON object
        root = node
      } else {
        return nil
      }
    } else {
      // Fallback: treat the entire object as a component node (backward compat)
      guard JSONSerialization.isValidJSONObject(obj),
            let data = try? JSONSerialization.data(withJSONObject: obj),
            let node = ComponentNode.from(data: data)
      else { return nil }
      return RenderRequest(display: .inline, document: nil, root: node)
    }

    let document: DocumentMetadata?
    if display == .document, let title = obj["title"] as? String {
      document = DocumentMetadata(
        title: title,
        preview: obj["preview"] as? String
      )
    } else {
      document = nil
    }

    return RenderRequest(display: display, document: document, root: root)
  }
}
