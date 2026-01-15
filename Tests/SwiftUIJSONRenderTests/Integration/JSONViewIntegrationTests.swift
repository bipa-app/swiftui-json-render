import SwiftUI
import Testing

@testable import SwiftUIJSONRender

@Suite("JSONView Integration Tests")
@MainActor
struct JSONViewIntegrationTests {

  // MARK: - Setup

  init() {
    // Ensure built-in components are registered
    initializeJSONRender()
  }

  // MARK: - End-to-End Rendering

  @Test("Render simple text")
  func testRenderSimpleText() throws {
    let view = JSONView(TestJSON.simpleText)

    #expect(view != nil)
  }

  @Test("Render stack with children")
  func testRenderStackWithChildren() throws {
    let view = JSONView(TestJSON.stackWithChildren)

    #expect(view != nil)
  }

  @Test("Render complex tree")
  func testRenderComplexTree() throws {
    let view = JSONView(TestJSON.complexTree)

    #expect(view != nil)
  }

  @Test("Render card with content")
  func testRenderCardWithContent() throws {
    let view = JSONView(TestJSON.cardWithContent)

    #expect(view != nil)
  }

  @Test("Render alert")
  func testRenderAlert() throws {
    let view = JSONView(TestJSON.alertInfo)

    #expect(view != nil)
  }

  @Test("Render heading")
  func testRenderHeading() throws {
    let json = """
      {"type": "Heading", "props": {"text": "Section", "level": 2}}
      """

    let view = JSONView(json)

    #expect(view != nil)
  }

  @Test("Render icon")
  func testRenderIcon() throws {
    let json = """
      {"type": "Icon", "props": {"name": "star.fill", "size": 20}}
      """

    let view = JSONView(json)

    #expect(view != nil)
  }

  @Test("Render image")
  func testRenderImage() throws {
    let json = """
      {"type": "Image", "props": {"name": "local_asset", "contentMode": "fit"}}
      """

    let view = JSONView(json)

    #expect(view != nil)
  }

  @Test("Render divider")
  func testRenderDivider() throws {
    let json = """
      {"type": "Divider", "props": {"thickness": 2, "color": "#CCCCCC"}}
      """

    let view = JSONView(json)

    #expect(view != nil)
  }

  @Test("Render spacer")
  func testRenderSpacer() throws {
    let json = """
      {"type": "Spacer", "props": {"size": 12}}
      """

    let view = JSONView(json)

    #expect(view != nil)
  }

  @Test("Render button with action")
  func testRenderButtonWithAction() throws {
    let view = JSONView(TestJSON.buttonWithAction)

    #expect(view != nil)
  }

  // MARK: - Error Handling

  @Test("Invalid JSON shows error")
  func testInvalidJSONShowsError() throws {
    let view = JSONView("{ invalid json }")

    // View should still be created (showing ErrorView)
    #expect(view != nil)
  }

  @Test("Empty JSON shows error")
  func testEmptyJSONShowsError() throws {
    let view = JSONView("")

    #expect(view != nil)
  }

  @Test("Unknown component shows unknown view")
  func testUnknownComponentShowsUnknown() throws {
    let json = """
      {"type": "UnknownWidget", "props": {}}
      """

    let view = JSONView(json)

    #expect(view != nil)
  }

  // MARK: - Initialization from Data

  @Test("Initialize from Data")
  func testInitFromData() throws {
    let jsonString = """
      {"type": "Text", "props": {"content": "From Data"}}
      """
    let data = jsonString.data(using: .utf8)!

    let view = JSONView(data)

    #expect(view != nil)
  }

  @Test("Initialize from ComponentNode")
  func testInitFromNode() throws {
    let node = ComponentNode(
      type: "Text",
      props: ["content": "From Node"]
    )

    let view = JSONView(node)

    #expect(view != nil)
  }

  // MARK: - Action Handling

  @Test("Action handler receives action")
  func testActionHandlerReceivesAction() throws {
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

    // Create context with handler
    let registry = ComponentRegistry()
    registry.register(module: BuiltInComponentsModule())

    let context = RenderContext(
      themeType: DefaultTheme.self,
      actionHandler: { action in
        receivedAction = action
      },
      registry: registry
    )

    // Manually trigger action handling
    let actionValue = node.props?["action"]
    context.handleAction(actionValue)

    #expect(receivedAction != nil)
    #expect(receivedAction?.name == "test_action")
    #expect(receivedAction?.string("key") == "value")
  }

  @Test("Action params are passed correctly")
  func testActionParamsPassedCorrectly() throws {
    var receivedParams: [String: AnyCodable]?

    let json = """
      {
          "type": "Button",
          "props": {
              "label": "Submit",
              "action": {
                  "name": "submit",
                  "params": {
                      "id": 123,
                      "name": "test",
                      "active": true
                  }
              }
          }
      }
      """

    let node = ComponentNode.from(json: json)!

    let registry = ComponentRegistry()
    registry.register(module: BuiltInComponentsModule())

    let context = RenderContext(
      themeType: DefaultTheme.self,
      actionHandler: { action in
        receivedParams = action.params
      },
      registry: registry
    )

    let actionValue = node.props?["action"]
    context.handleAction(actionValue)

    #expect(receivedParams?["id"]?.intValue == 123)
    #expect(receivedParams?["name"]?.stringValue == "test")
    #expect(receivedParams?["active"]?.boolValue == true)
  }

  @Test("Nested action bubbles up")
  func testNestedActionBubblesUp() throws {
    var receivedAction: Action?

    let json = """
      {
          "type": "Card",
          "props": {"title": "Card"},
          "children": [
              {
                  "type": "Stack",
                  "children": [
                      {
                          "type": "Button",
                          "props": {
                              "label": "Nested",
                              "action": {"name": "nested_action"}
                          }
                      }
                  ]
              }
          ]
      }
      """

    let node = ComponentNode.from(json: json)!

    let registry = ComponentRegistry()
    registry.register(module: BuiltInComponentsModule())

    let context = RenderContext(
      themeType: DefaultTheme.self,
      actionHandler: { action in
        receivedAction = action
      },
      registry: registry
    )

    // Navigate to nested button and trigger action
    let cardChildren = node.children
    let stackChildren = cardChildren?[0].children
    let buttonNode = stackChildren?[0]
    let actionValue = buttonNode?.props?["action"]

    context.handleAction(actionValue)

    #expect(receivedAction?.name == "nested_action")
  }

  // MARK: - Custom Theme

  @Test("Custom theme is applied")
  func testCustomThemeApplied() throws {
    let registry = ComponentRegistry()
    registry.register(module: BuiltInComponentsModule())

    let context = RenderContext(
      themeType: TestTheme.self,
      actionHandler: nil,
      registry: registry
    )

    #expect(context.primaryColor == TestTheme.primaryColor)
    #expect(context.spacingMD == TestTheme.spacingMD)
    #expect(context.radiusMD == TestTheme.radiusMD)
  }

  @Test("Default theme is used when none specified")
  func testDefaultThemeUsed() throws {
    let registry = ComponentRegistry()
    registry.register(module: BuiltInComponentsModule())

    let context = RenderContext(registry: registry)

    #expect(context.primaryColor == DefaultTheme.primaryColor)
    #expect(context.spacingMD == DefaultTheme.spacingMD)
  }

  @Test("Theme colors are accessible")
  func testThemeColorsAccessible() throws {
    let context = RenderContext()

    #expect(context.primaryColor == DefaultTheme.primaryColor)
    #expect(context.secondaryColor == DefaultTheme.secondaryColor)
    #expect(context.backgroundColor == DefaultTheme.backgroundColor)
    #expect(context.surfaceColor == DefaultTheme.surfaceColor)
    #expect(context.textPrimary == DefaultTheme.textPrimary)
    #expect(context.textSecondary == DefaultTheme.textSecondary)
    #expect(context.errorColor == DefaultTheme.errorColor)
    #expect(context.successColor == DefaultTheme.successColor)
    #expect(context.warningColor == DefaultTheme.warningColor)
  }

  @Test("Theme fonts are accessible")
  func testThemeFontsAccessible() throws {
    let context = RenderContext()

    #expect(context.headingFont == DefaultTheme.headingFont)
    #expect(context.bodyFont == DefaultTheme.bodyFont)
    #expect(context.captionFont == DefaultTheme.captionFont)
  }

  @Test("Theme spacing is accessible")
  func testThemeSpacingAccessible() throws {
    let context = RenderContext()

    #expect(context.spacingXS == DefaultTheme.spacingXS)
    #expect(context.spacingSM == DefaultTheme.spacingSM)
    #expect(context.spacingMD == DefaultTheme.spacingMD)
    #expect(context.spacingLG == DefaultTheme.spacingLG)
    #expect(context.spacingXL == DefaultTheme.spacingXL)
  }

  @Test("Theme radii are accessible")
  func testThemeRadiiAccessible() throws {
    let context = RenderContext()

    #expect(context.radiusSM == DefaultTheme.radiusSM)
    #expect(context.radiusMD == DefaultTheme.radiusMD)
    #expect(context.radiusLG == DefaultTheme.radiusLG)
  }

  // MARK: - Custom Registry

  @Test("Custom registry with subset of components")
  func testCustomRegistrySubset() throws {
    let customRegistry = ComponentRegistry()
    customRegistry.register(TextBuilder.self)
    customRegistry.register(StackBuilder.self)

    #expect(customRegistry.hasBuilder(for: "Text") == true)
    #expect(customRegistry.hasBuilder(for: "Stack") == true)
    #expect(customRegistry.hasBuilder(for: "Button") == false)
    #expect(customRegistry.hasBuilder(for: "Card") == false)
  }

  @Test("Empty registry shows unknown for all types")
  func testEmptyRegistryShowsUnknown() throws {
    let emptyRegistry = ComponentRegistry()

    #expect(emptyRegistry.hasBuilder(for: "Text") == false)
    #expect(emptyRegistry.hasBuilder(for: "Stack") == false)
    #expect(emptyRegistry.hasBuilder(for: "Button") == false)
    #expect(emptyRegistry.registeredTypes.isEmpty == true)
  }

  @Test("Custom registry with mock component")
  func testCustomRegistryWithMock() throws {
    let customRegistry = ComponentRegistry()
    customRegistry.register(MockComponentBuilder.self)

    #expect(customRegistry.hasBuilder(for: "MockComponent") == true)

    let json = """
      {"type": "MockComponent", "props": {"value": "test"}}
      """

    let node = ComponentNode.from(json: json)!
    let context = RenderContext(registry: customRegistry)

    let view = context.render(node)
    #expect(view != nil)
  }

  // MARK: - RenderContext

  @Test("RenderContext renders children")
  func testRenderContextRendersChildren() throws {
    let registry = ComponentRegistry()
    registry.register(module: BuiltInComponentsModule())

    let context = RenderContext(registry: registry)

    let children = [
      ComponentNode(type: "Text", props: ["content": "A"]),
      ComponentNode(type: "Text", props: ["content": "B"]),
    ]

    let rendered = context.renderChildren(children)

    #expect(rendered.count == 2)
  }

  @Test("RenderContext renders nil children as empty")
  func testRenderContextNilChildren() throws {
    let context = RenderContext()

    let rendered = context.renderChildren(nil)

    #expect(rendered.isEmpty)
  }

  @Test("RenderContext with updated theme")
  func testContextWithUpdatedTheme() throws {
    let original = RenderContext()
    let updated = original.with(themeType: TestTheme.self)

    #expect(original.primaryColor == DefaultTheme.primaryColor)
    #expect(updated.primaryColor == TestTheme.primaryColor)
  }

  @Test("RenderContext with updated action handler")
  func testContextWithUpdatedHandler() throws {
    var called = false
    let original = RenderContext()
    let updated = original.with(actionHandler: { _ in called = true })

    #expect(original.actionHandler == nil)
    #expect(updated.actionHandler != nil)

    updated.actionHandler?(Action(name: "test"))
    #expect(called == true)
  }

  @Test("RenderContext with updated registry")
  func testContextWithUpdatedRegistry() throws {
    let original = RenderContext()
    let newRegistry = ComponentRegistry()
    newRegistry.register(MockComponentBuilder.self)

    let updated = original.with(registry: newRegistry)

    #expect(updated.registry.hasBuilder(for: "MockComponent") == true)
  }

  // MARK: - Validation Integration

  @Test("Validation before rendering")
  func testValidationBeforeRendering() throws {
    let registry = ComponentRegistry()
    registry.register(module: BuiltInComponentsModule())

    // Valid JSON should pass
    let validResult = JSONValidator.validate(TestJSON.complexTree, registry: registry)
    #expect(validResult.isValid)

    // Then render
    let view = JSONView(TestJSON.complexTree)
    #expect(view != nil)
  }

  @Test("Validation catches unknown components")
  func testValidationCatchesUnknown() throws {
    let registry = ComponentRegistry()
    registry.register(module: BuiltInComponentsModule())

    let json = """
      {
          "type": "Stack",
          "children": [
              {"type": "Text", "props": {"content": "Valid"}},
              {"type": "FancyWidget", "props": {}}
          ]
      }
      """

    let result = JSONValidator.validate(json, registry: registry)

    #expect(!result.isValid)
    #expect(result.errors.count == 1)
  }

  // MARK: - Built-in Module

  @Test("BuiltInComponentsModule has all Phase 2 components")
  func testBuiltInModuleComponents() throws {
    let module = BuiltInComponentsModule()
    let builders = module.builders

    let typeNames = builders.map { $0.typeName }

    #expect(typeNames.contains("Stack"))
    #expect(typeNames.contains("Card"))
    #expect(typeNames.contains("Divider"))
    #expect(typeNames.contains("Spacer"))
    #expect(typeNames.contains("Text"))
    #expect(typeNames.contains("Heading"))
    #expect(typeNames.contains("Image"))
    #expect(typeNames.contains("Icon"))
    #expect(typeNames.contains("Button"))
    #expect(typeNames.contains("Alert"))
    #expect(builders.count == 10)
  }

  // MARK: - Complete Workflow

  @Test("Complete workflow: validate, render, handle action")
  func testCompleteWorkflow() throws {
    var actionReceived: Action?

    let json = """
      {
          "type": "Card",
          "props": {"title": "Workflow Test"},
          "children": [
              {"type": "Text", "props": {"content": "Content"}},
              {
                  "type": "Button",
                  "props": {
                      "label": "Action",
                      "action": {"name": "workflow_action", "params": {"step": 1}}
                  }
              }
          ]
      }
      """

    let registry = ComponentRegistry()
    registry.register(module: BuiltInComponentsModule())

    // Step 1: Validate
    let validationResult = JSONValidator.validate(json, registry: registry)
    #expect(validationResult.isValid)

    // Step 2: Parse
    let node = ComponentNode.from(json: json)
    #expect(node != nil)

    // Step 3: Create context with handler
    let context = RenderContext(
      themeType: DefaultTheme.self,
      actionHandler: { action in
        actionReceived = action
      },
      registry: registry
    )

    // Step 4: Render
    let view = context.render(node!)
    #expect(view != nil)

    // Step 5: Simulate action
    let buttonNode = node!.children?[1]
    let actionValue = buttonNode?.props?["action"]
    context.handleAction(actionValue)

    // Step 6: Verify action received
    #expect(actionReceived != nil)
    #expect(actionReceived?.name == "workflow_action")
    #expect(actionReceived?.int("step") == 1)
  }
}
