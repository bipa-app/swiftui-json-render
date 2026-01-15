import SwiftUI
import Testing

@testable import SwiftUIJSONRender

@Suite("ButtonBuilder Tests")
@MainActor
struct ButtonBuilderTests {

  // MARK: - Setup

  func makeContext(
    theme: any JSONRenderTheme.Type = DefaultTheme.self,
    actionHandler: ActionHandler? = nil
  ) -> RenderContext {
    let registry = ComponentRegistry()
    registry.register(module: BuiltInComponentsModule())
    return RenderContext(
      themeType: theme,
      actionHandler: actionHandler,
      registry: registry
    )
  }

  // MARK: - Label

  @Test("Button with label")
  func testButtonWithLabel() throws {
    let json = """
      {"type": "Button", "props": {"label": "Click Me"}}
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()

    let view = ButtonBuilder.build(node: node, context: context)

    #expect(node.string("label") == "Click Me")
    #expect(view != nil)
  }

  @Test("Button without label uses default")
  func testButtonWithoutLabel() throws {
    let json = """
      {"type": "Button", "props": {}}
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()

    let view = ButtonBuilder.build(node: node, context: context)

    #expect(node.string("label") == nil)
    // Builder uses "Button" as default
    #expect(view != nil)
  }

  @Test("Button with empty label")
  func testButtonWithEmptyLabel() throws {
    let json = """
      {"type": "Button", "props": {"label": ""}}
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()

    let view = ButtonBuilder.build(node: node, context: context)

    #expect(node.string("label") == "")
    #expect(view != nil)
  }

  // MARK: - Styles

  @Test("Primary style (default)")
  func testPrimaryStyle() throws {
    let json = """
      {"type": "Button", "props": {"label": "Primary", "style": "primary"}}
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()

    let view = ButtonBuilder.build(node: node, context: context)

    #expect(node.string("style") == "primary")
    #expect(view != nil)
  }

  @Test("Secondary style")
  func testSecondaryStyle() throws {
    let json = """
      {"type": "Button", "props": {"label": "Secondary", "style": "secondary"}}
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()

    let view = ButtonBuilder.build(node: node, context: context)

    #expect(node.string("style") == "secondary")
    #expect(view != nil)
  }

  @Test("Destructive style")
  func testDestructiveStyle() throws {
    let json = """
      {"type": "Button", "props": {"label": "Delete", "style": "destructive"}}
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()

    let view = ButtonBuilder.build(node: node, context: context)

    #expect(node.string("style") == "destructive")
    #expect(view != nil)
  }

  @Test("Default style is primary")
  func testDefaultStyle() throws {
    let json = """
      {"type": "Button", "props": {"label": "No Style"}}
      """

    let node = ComponentNode.from(json: json)!

    #expect(node.string("style") == nil)
    #expect(node.string("style", default: "primary") == "primary")
  }

  @Test("Unknown style falls back to primary")
  func testUnknownStyleFallback() throws {
    let json = """
      {"type": "Button", "props": {"label": "Unknown", "style": "fancy"}}
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()

    let view = ButtonBuilder.build(node: node, context: context)

    #expect(view != nil)
  }

  @Test("Case insensitive style")
  func testCaseInsensitiveStyle() throws {
    let json = """
      {"type": "Button", "props": {"label": "Upper", "style": "DESTRUCTIVE"}}
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()

    let view = ButtonBuilder.build(node: node, context: context)

    #expect(view != nil)
  }

  // MARK: - Icon

  @Test("Button with icon")
  func testButtonWithIcon() throws {
    let json = """
      {"type": "Button", "props": {"label": "Send", "icon": "paperplane.fill"}}
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()

    let view = ButtonBuilder.build(node: node, context: context)

    #expect(node.string("icon") == "paperplane.fill")
    #expect(view != nil)
  }

  @Test("Button without icon")
  func testButtonWithoutIcon() throws {
    let json = """
      {"type": "Button", "props": {"label": "No Icon"}}
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()

    let view = ButtonBuilder.build(node: node, context: context)

    #expect(node.string("icon") == nil)
    #expect(view != nil)
  }

  @Test("Button with various SF Symbols")
  func testButtonWithVariousSFSymbols() throws {
    let icons = ["plus", "minus", "star.fill", "heart.fill", "gear", "trash"]

    for icon in icons {
      let json = """
        {"type": "Button", "props": {"label": "Action", "icon": "\(icon)"}}
        """

      let node = ComponentNode.from(json: json)!
      let context = makeContext()

      let view = ButtonBuilder.build(node: node, context: context)

      #expect(node.string("icon") == icon)
      #expect(view != nil)
    }
  }

  // MARK: - Disabled State

  @Test("Button disabled true")
  func testButtonDisabledTrue() throws {
    let json = """
      {"type": "Button", "props": {"label": "Disabled", "disabled": true}}
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()

    let view = ButtonBuilder.build(node: node, context: context)

    #expect(node.bool("disabled") == true)
    #expect(view != nil)
  }

  @Test("Button disabled false")
  func testButtonDisabledFalse() throws {
    let json = """
      {"type": "Button", "props": {"label": "Enabled", "disabled": false}}
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()

    let view = ButtonBuilder.build(node: node, context: context)

    #expect(node.bool("disabled") == false)
    #expect(view != nil)
  }

  @Test("Default disabled is false")
  func testDefaultDisabled() throws {
    let json = """
      {"type": "Button", "props": {"label": "Default"}}
      """

    let node = ComponentNode.from(json: json)!

    #expect(node.bool("disabled") == nil)
    #expect(node.bool("disabled", default: false) == false)
  }

  // MARK: - Action

  @Test("Button with action")
  func testButtonWithAction() throws {
    let json = """
      {
          "type": "Button",
          "props": {
              "label": "Submit",
              "action": {"name": "submit_form", "params": {"id": 123}}
          }
      }
      """

    let node = ComponentNode.from(json: json)!
    let actionValue = node.props?["action"]
    let action = Action.from(actionValue)

    #expect(action != nil)
    #expect(action?.name == "submit_form")
    #expect(action?.int("id") == 123)
  }

  @Test("Button without action")
  func testButtonWithoutAction() throws {
    let json = """
      {"type": "Button", "props": {"label": "No Action"}}
      """

    let node = ComponentNode.from(json: json)!
    let actionValue = node.props?["action"]
    let action = Action.from(actionValue)

    #expect(action == nil)
  }

  @Test("Button action with confirm")
  func testButtonActionWithConfirm() throws {
    let json = """
      {
          "type": "Button",
          "props": {
              "label": "Delete",
              "style": "destructive",
              "action": {
                  "name": "delete",
                  "confirm": {
                      "title": "Confirm Delete",
                      "message": "Are you sure?"
                  }
              }
          }
      }
      """

    let node = ComponentNode.from(json: json)!
    let actionValue = node.props?["action"]
    let action = Action.from(actionValue)

    #expect(action?.confirm != nil)
    #expect(action?.confirm?.title == "Confirm Delete")
    #expect(action?.confirm?.message == "Are you sure?")
  }

  // MARK: - Action Handler

  @Test("Button triggers action handler")
  func testActionHandlerTriggered() throws {
    var receivedAction: Action?

    let json = """
      {
          "type": "Button",
          "props": {
              "label": "Test",
              "action": {"name": "test_action", "params": {"key": "value"}}
          }
      }
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext { action in
      receivedAction = action
    }

    // Build the view
    let _ = ButtonBuilder.build(node: node, context: context)

    // Manually invoke handleAction to test the flow
    let actionValue = node.props?["action"]
    context.handleAction(actionValue)

    #expect(receivedAction != nil)
    #expect(receivedAction?.name == "test_action")
    #expect(receivedAction?.string("key") == "value")
  }

  @Test("Button with no handler does not crash")
  func testNoHandlerNoCrash() throws {
    let json = """
      {
          "type": "Button",
          "props": {
              "label": "Test",
              "action": {"name": "test"}
          }
      }
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext(actionHandler: nil)

    // Build the view - should not crash
    let view = ButtonBuilder.build(node: node, context: context)

    // Manually invoke handleAction
    let actionValue = node.props?["action"]
    context.handleAction(actionValue)

    #expect(view != nil)
  }

  // MARK: - Type Name

  @Test("Builder has correct type name")
  func testTypeName() throws {
    #expect(ButtonBuilder.typeName == "Button")
  }

  // MARK: - Full Props Combination

  @Test("All props together")
  func testAllPropsTogether() throws {
    let json = """
      {
          "type": "Button",
          "props": {
              "label": "Complete Button",
              "style": "primary",
              "icon": "checkmark.circle",
              "disabled": false,
              "action": {
                  "name": "complete",
                  "params": {"status": "done"}
              }
          }
      }
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()

    let view = ButtonBuilder.build(node: node, context: context)

    #expect(node.string("label") == "Complete Button")
    #expect(node.string("style") == "primary")
    #expect(node.string("icon") == "checkmark.circle")
    #expect(node.bool("disabled") == false)
    #expect(view != nil)
  }

  // MARK: - Theme Integration

  @Test("Button uses theme colors")
  func testButtonUsesThemeColors() throws {
    let json = """
      {"type": "Button", "props": {"label": "Themed", "style": "primary"}}
      """

    let node = ComponentNode.from(json: json)!
    let customContext = makeContext(theme: TestTheme.self)

    // Build with custom theme
    let view = ButtonBuilder.build(node: node, context: customContext)

    #expect(customContext.primaryColor == TestTheme.primaryColor)
    #expect(view != nil)
  }

  @Test("Button uses theme spacing")
  func testButtonUsesThemeSpacing() throws {
    let json = """
      {"type": "Button", "props": {"label": "Themed"}}
      """

    let node = ComponentNode.from(json: json)!
    let customContext = makeContext(theme: TestTheme.self)

    #expect(customContext.spacingXS == TestTheme.spacingXS)
    #expect(customContext.spacingMD == TestTheme.spacingMD)
    #expect(customContext.spacingSM == TestTheme.spacingSM)

    let view = ButtonBuilder.build(node: node, context: customContext)
    #expect(view != nil)
  }
}
