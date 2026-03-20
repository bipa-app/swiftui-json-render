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
    guard let data = json.data(using: .utf8),
          let obj = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
    else { return nil }

    return from(dictionary: obj)
  }

  /// Parses a render request from a dictionary.
  public static func from(dictionary obj: [String: Any]) -> RenderRequest? {
    let displayStr = obj["display"] as? String ?? "inline"
    let display = DisplayMode(rawValue: displayStr) ?? .inline

    // Parse root component node
    guard let rootObj = obj["root"],
          let rootData = try? JSONSerialization.data(withJSONObject: rootObj),
          let root = ComponentNode.from(data: rootData)
    else {
      // Fallback: treat the entire object as a component node (backward compat)
      guard let data = try? JSONSerialization.data(withJSONObject: obj),
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
