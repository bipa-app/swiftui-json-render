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
  @Environment(\.renderStrings) private var stringsType
  @Environment(\.actionHandler) private var actionHandler
  @Environment(\.componentRegistry) private var registry
  @Environment(\.unknownComponentBehavior) private var unknownComponentBehavior

  private let node: ComponentNode?
  private let parseError: String?
  private let versionError: VersionError?

  /// Creates a JSONView from a JSON string.
  /// - Parameter json: A JSON string representing a component tree.
  public init(_ json: String) {
    if let node = ComponentNode.from(json: json) {
      self.node = node
      self.parseError = nil
      self.versionError = Self.checkVersion(of: node)
    } else {
      self.node = nil
      self.parseError = "Failed to parse JSON"
      self.versionError = nil
    }
  }

  /// Creates a JSONView from a ComponentNode.
  /// - Parameter node: A pre-parsed component node.
  public init(_ node: ComponentNode) {
    self.node = node
    self.parseError = nil
    self.versionError = Self.checkVersion(of: node)
  }

  /// Creates a JSONView from JSON data.
  /// - Parameter data: JSON data representing a component tree.
  public init(_ data: Data) {
    if let node = ComponentNode.from(data: data) {
      self.node = node
      self.parseError = nil
      self.versionError = Self.checkVersion(of: node)
    } else {
      self.node = nil
      self.parseError = "Failed to parse JSON data"
      self.versionError = nil
    }
  }

  public var body: some View {
    if let error = parseError {
      ErrorView(
        message: error,
        warningColor: themeType.warningColor,
        alertBackgroundOpacity: themeType.alertBackgroundOpacity,
        radiusMD: themeType.radiusMD
      )
    } else if let versionError = versionError {
      VersionErrorView(
        error: versionError,
        primaryColor: themeType.primaryColor,
        textSecondary: themeType.textSecondary,
        alertBackgroundOpacity: themeType.alertBackgroundOpacity,
        radiusMD: themeType.radiusMD
      )
    } else if let node = node {
      renderNode(node)
    }
  }

  @MainActor
  private func renderNode(_ node: ComponentNode) -> AnyView {
    let context = RenderContext(
      themeType: themeType,
      stringsType: stringsType,
      actionHandler: actionHandler,
      registry: registry,
      unknownComponentBehavior: unknownComponentBehavior
    )
    return context.render(node)
  }

  /// Checks if the node's schema version is compatible.
  private static func checkVersion(of node: ComponentNode) -> VersionError? {
    guard let version = node.schemaVersion else {
      // No version specified - assume compatible (for backwards compatibility)
      return nil
    }

    let result = SchemaVersion.checkCompatibility(of: version)
    guard SchemaVersion.shouldRender(for: result) else {
      return VersionError(jsonVersion: version, result: result)
    }

    return nil
  }
}

// MARK: - Version Error

/// Represents a version compatibility error.
struct VersionError {
  let jsonVersion: SchemaVersion
  let result: SchemaVersion.CompatibilityResult

  var message: String {
    switch result {
    case .tooOld:
      return
        "Schema version \(jsonVersion) is no longer supported. Minimum: \(SchemaVersion.minimumSupported)"
    case .tooNew:
      return
        "Schema version \(jsonVersion) requires a newer library. Current: \(SchemaVersion.current)"
    case .compatible, .newerMinor, .olderSupported:
      return ""  // Should not happen
    }
  }
}

// MARK: - Error Views

/// A view displayed when JSON parsing fails.
private struct ErrorView: View {
  let message: String
  let warningColor: Color
  let alertBackgroundOpacity: Double
  let radiusMD: CGFloat

  var body: some View {
    Image(systemName: "exclamationmark.triangle.fill")
      .font(.largeTitle)
      .foregroundStyle(warningColor)
      .padding()
      .frame(maxWidth: .infinity)
      .background(warningColor.opacity(alertBackgroundOpacity))
      .clipShape(.rect(cornerRadius: radiusMD))
  }
}

/// A view displayed when schema version is incompatible.
private struct VersionErrorView: View {
  let error: VersionError
  let primaryColor: Color
  let textSecondary: Color
  let alertBackgroundOpacity: Double
  let radiusMD: CGFloat

  var body: some View {
    VStack(spacing: 8) {
      Image(systemName: "arrow.triangle.2.circlepath.circle.fill")
        .font(.largeTitle)
        .foregroundStyle(primaryColor)
      Text("Version Incompatible")
        .font(.headline)
      Text(error.message)
        .font(.caption)
        .foregroundStyle(textSecondary)
        .multilineTextAlignment(.center)
    }
    .padding()
    .frame(maxWidth: .infinity)
    .background(primaryColor.opacity(alertBackgroundOpacity))
    .clipShape(.rect(cornerRadius: radiusMD))
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
