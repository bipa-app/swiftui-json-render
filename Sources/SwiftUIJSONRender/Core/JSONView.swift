import SwiftUI

/// A SwiftUI view that renders UI from JSON.
///
/// `JSONView` is the primary entry point for rendering JSON-defined component trees
/// as native SwiftUI views. It supports theming, action handling, and custom components.
///
/// ## Basic Usage
/// ```swift
/// let json = """
/// {
///   "type": "Stack",
///   "props": { "direction": "vertical", "spacing": 16 },
///   "children": [
///     { "type": "Text", "props": { "content": "Hello, World!" } }
///   ]
/// }
/// """
///
/// JSONView(json)
/// ```
///
/// ## With Action Handling
/// ```swift
/// JSONView(json)
///     .onAction { action in
///         print("Action triggered: \(action.name)")
///     }
/// ```
///
/// ## With Custom Theme
/// ```swift
/// JSONView(json)
///     .theme(MyCustomTheme.self)
/// ```
public struct JSONView: View {
  @Environment(\.componentTheme) private var themeType
  @Environment(\.actionHandler) private var actionHandler
  @Environment(\.componentRegistry) private var registry

  private let node: ComponentNode?
  private let parseError: String?

  /// Creates a JSONView from a JSON string.
  /// - Parameter json: A JSON string representing a component tree.
  public init(_ json: String) {
    if let node = ComponentNode.from(json: json) {
      self.node = node
      self.parseError = nil
    } else {
      self.node = nil
      self.parseError = "Failed to parse JSON"
    }
  }

  /// Creates a JSONView from a ComponentNode.
  /// - Parameter node: A pre-parsed component node.
  public init(_ node: ComponentNode) {
    self.node = node
    self.parseError = nil
  }

  /// Creates a JSONView from JSON data.
  /// - Parameter data: JSON data representing a component tree.
  public init(_ data: Data) {
    if let node = ComponentNode.from(data: data) {
      self.node = node
      self.parseError = nil
    } else {
      self.node = nil
      self.parseError = "Failed to parse JSON data"
    }
  }

  public var body: some View {
    if let node = node {
      renderNode(node)
    } else if let error = parseError {
      ErrorView(message: error)
    }
  }

  @MainActor
  private func renderNode(_ node: ComponentNode) -> AnyView {
    let context = RenderContext(
      themeType: themeType,
      actionHandler: actionHandler,
      registry: registry
    )
    return context.render(node)
  }
}

// MARK: - Error View

/// A view displayed when JSON parsing fails.
private struct ErrorView: View {
  let message: String

  var body: some View {
    Image(systemName: "exclamationmark.triangle.fill")
      .font(.largeTitle)
      .foregroundColor(.orange)
    .padding()
    .frame(maxWidth: .infinity)
    .background(Color.orange.opacity(0.1))
    .cornerRadius(8)
  }
}

// MARK: - Preview Support

#if DEBUG
  struct JSONView_Previews: PreviewProvider {
    static var previews: some View {
      VStack(spacing: 20) {
        // Valid JSON
        JSONView(
          """
          {
              "type": "Text",
              "props": { "content": "Hello from JSON!" }
          }
          """)

        // Invalid JSON
        JSONView("{ invalid json }")
      }
      .padding()
    }
  }
#endif
