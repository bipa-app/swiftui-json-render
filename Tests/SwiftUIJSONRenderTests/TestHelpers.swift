import SwiftUI

@testable import SwiftUIJSONRender

/// Helper to create RenderContext for tests
@MainActor
func makeTestContext(
  theme: any JSONRenderTheme.Type = DefaultTheme.self,
  actionHandler: ActionHandler? = nil,
  registry: ComponentRegistry? = nil
) -> RenderContext {
  let reg =
    registry
    ?? {
      let r = ComponentRegistry()
      r.register(module: BuiltInComponentsModule())
      return r
    }()
  return RenderContext(
    themeType: theme,
    actionHandler: actionHandler,
    registry: reg
  )
}

/// Sample JSON strings for tests
enum TestJSON {
  static let simpleText = """
    {"type": "Text", "props": {"content": "Hello"}}
    """

  static let stackWithChildren = """
    {
        "type": "Stack",
        "props": {"direction": "vertical", "spacing": 16},
        "children": [
            {"type": "Text", "props": {"content": "Line 1"}},
            {"type": "Text", "props": {"content": "Line 2"}}
        ]
    }
    """

  static let buttonWithAction = """
    {
        "type": "Button",
        "props": {
            "label": "Submit",
            "action": {"name": "submit", "params": {"id": 123}}
        }
    }
    """

  static let cardWithContent = """
    {
        "type": "Card",
        "props": {"title": "My Card", "padding": 20},
        "children": [
            {"type": "Text", "props": {"content": "Card content"}}
        ]
    }
    """

  static let alertInfo = """
    {
        "type": "Alert",
        "props": {
            "title": "Information",
            "message": "This is an info alert",
            "severity": "info"
        }
    }
    """

  static let complexTree = """
    {
        "type": "Stack",
        "props": {"direction": "vertical", "spacing": 16},
        "children": [
            {
                "type": "Card",
                "props": {"title": "Welcome"},
                "children": [
                    {"type": "Text", "props": {"content": "Hello, World!"}},
                    {
                        "type": "Button",
                        "props": {
                            "label": "Get Started",
                            "style": "primary",
                            "action": {"name": "get_started"}
                        }
                    }
                ]
            },
            {
                "type": "Alert",
                "props": {
                    "title": "Tip",
                    "message": "Click the button above",
                    "severity": "info"
                }
            }
        ]
    }
    """

  static let deeplyNested: String = {
    // Generate 25-level deep nesting (exceeds max depth of 20)
    var json = """
      {"type": "Stack", "children": [
      """
    for _ in 0..<24 {
      json += """
        {"type": "Stack", "children": [
        """
    }
    json += """
      {"type": "Text", "props": {"content": "Deep"}}
      """
    for _ in 0..<25 {
      json += "]}"
    }
    return json
  }()

  static let validNested: String = {
    // Generate 10-level deep nesting (within max depth)
    var json = """
      {"type": "Stack", "children": [
      """
    for _ in 0..<9 {
      json += """
        {"type": "Stack", "children": [
        """
    }
    json += """
      {"type": "Text", "props": {"content": "Nested"}}
      """
    for _ in 0..<10 {
      json += "]}"
    }
    return json
  }()
}

/// A custom theme for testing
struct TestTheme: JSONRenderTheme {
  static var primaryColor: Color { .purple }
  static var secondaryColor: Color { .pink }
  static var backgroundColor: Color { .white }
  static var surfaceColor: Color { .gray.opacity(0.1) }
  static var textPrimary: Color { .black }
  static var textSecondary: Color { .gray }
  static var errorColor: Color { .red }
  static var successColor: Color { .green }
  static var warningColor: Color { .orange }

  static var headingFont: Font { .title2 }
  static var bodyFont: Font { .body }
  static var captionFont: Font { .caption2 }

  static var spacingXS: CGFloat { 2 }
  static var spacingSM: CGFloat { 4 }
  static var spacingMD: CGFloat { 12 }
  static var spacingLG: CGFloat { 20 }
  static var spacingXL: CGFloat { 28 }

  static var radiusSM: CGFloat { 2 }
  static var radiusMD: CGFloat { 6 }
  static var radiusLG: CGFloat { 12 }
}

/// A mock component builder for testing custom registration
struct MockComponentBuilder: ComponentBuilder {
  static var typeName: String { "MockComponent" }

  static func build(node: ComponentNode, context: RenderContext) -> AnyView {
    AnyView(Text("Mock: \(node.string("value") ?? "none")"))
  }
}

/// A test module with a single mock component
struct TestModule: ComponentModule {
  var builders: [AnyComponentBuilder] {
    [AnyComponentBuilder(MockComponentBuilder.self)]
  }
}
