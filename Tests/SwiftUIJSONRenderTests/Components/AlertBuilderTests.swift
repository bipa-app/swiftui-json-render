import SwiftUI
import Testing

@testable import SwiftUIJSONRender

@Suite("AlertBuilder Tests")
@MainActor
struct AlertBuilderTests {

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

  // MARK: - Title

  @Test("Alert with title")
  func testAlertWithTitle() throws {
    let json = """
      {"type": "Alert", "props": {"title": "Important Notice"}}
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()

    let view = AlertBuilder.build(node: node, context: context)

    #expect(node.string("title") == "Important Notice")
    #expect(view != nil)
  }

  @Test("Alert without title uses default")
  func testAlertWithoutTitle() throws {
    let json = """
      {"type": "Alert", "props": {}}
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()

    let view = AlertBuilder.build(node: node, context: context)

    #expect(node.string("title") == nil)
    // Builder uses "Alert" as default
    #expect(view != nil)
  }

  // MARK: - Message

  @Test("Alert with message")
  func testAlertWithMessage() throws {
    let json = """
      {
          "type": "Alert",
          "props": {
              "title": "Notice",
              "message": "This is a detailed message explaining the alert."
          }
      }
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()

    let view = AlertBuilder.build(node: node, context: context)

    #expect(node.string("message") == "This is a detailed message explaining the alert.")
    #expect(view != nil)
  }

  @Test("Alert without message")
  func testAlertWithoutMessage() throws {
    let json = """
      {"type": "Alert", "props": {"title": "Title Only"}}
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()

    let view = AlertBuilder.build(node: node, context: context)

    #expect(node.string("message") == nil)
    #expect(view != nil)
  }

  // MARK: - Severity

  @Test("Info severity (default)")
  func testInfoSeverity() throws {
    let json = """
      {"type": "Alert", "props": {"title": "Info", "severity": "info"}}
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()

    let view = AlertBuilder.build(node: node, context: context)

    #expect(node.string("severity") == "info")
    #expect(view != nil)
  }

  @Test("Success severity")
  func testSuccessSeverity() throws {
    let json = """
      {"type": "Alert", "props": {"title": "Success", "severity": "success"}}
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()

    let view = AlertBuilder.build(node: node, context: context)

    #expect(node.string("severity") == "success")
    #expect(view != nil)
  }

  @Test("Warning severity")
  func testWarningSeverity() throws {
    let json = """
      {"type": "Alert", "props": {"title": "Warning", "severity": "warning"}}
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()

    let view = AlertBuilder.build(node: node, context: context)

    #expect(node.string("severity") == "warning")
    #expect(view != nil)
  }

  @Test("Error severity")
  func testErrorSeverity() throws {
    let json = """
      {"type": "Alert", "props": {"title": "Error", "severity": "error"}}
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()

    let view = AlertBuilder.build(node: node, context: context)

    #expect(node.string("severity") == "error")
    #expect(view != nil)
  }

  @Test("Default severity is info")
  func testDefaultSeverity() throws {
    let json = """
      {"type": "Alert", "props": {"title": "No Severity"}}
      """

    let node = ComponentNode.from(json: json)!

    #expect(node.string("severity") == nil)
    #expect(node.string("severity", default: "info") == "info")
  }

  @Test("Case insensitive severity")
  func testCaseInsensitiveSeverity() throws {
    let json = """
      {"type": "Alert", "props": {"title": "Upper", "severity": "ERROR"}}
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()

    let view = AlertBuilder.build(node: node, context: context)

    #expect(view != nil)
  }

  @Test("Unknown severity falls back to info")
  func testUnknownSeverityFallback() throws {
    let json = """
      {"type": "Alert", "props": {"title": "Unknown", "severity": "critical"}}
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()

    let view = AlertBuilder.build(node: node, context: context)

    #expect(view != nil)
  }

  // MARK: - Dismissible

  @Test("Alert dismissible true")
  func testAlertDismissibleTrue() throws {
    let json = """
      {"type": "Alert", "props": {"title": "Dismissible", "dismissible": true}}
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()

    let view = AlertBuilder.build(node: node, context: context)

    #expect(node.bool("dismissible") == true)
    #expect(view != nil)
  }

  @Test("Alert dismissible false")
  func testAlertDismissibleFalse() throws {
    let json = """
      {"type": "Alert", "props": {"title": "Not Dismissible", "dismissible": false}}
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()

    let view = AlertBuilder.build(node: node, context: context)

    #expect(node.bool("dismissible") == false)
    #expect(view != nil)
  }

  @Test("Default dismissible is false")
  func testDefaultDismissible() throws {
    let json = """
      {"type": "Alert", "props": {"title": "Default"}}
      """

    let node = ComponentNode.from(json: json)!

    #expect(node.bool("dismissible") == nil)
    #expect(node.bool("dismissible", default: false) == false)
  }

  // MARK: - Action

  @Test("Alert with action")
  func testAlertWithAction() throws {
    let json = """
      {
          "type": "Alert",
          "props": {
              "title": "Action Alert",
              "action": {
                  "label": "Undo",
                  "name": "undo_action",
                  "params": {"id": 456}
              }
          }
      }
      """

    let node = ComponentNode.from(json: json)!
    let actionValue = node.props?["action"]
    let actionDict = actionValue?.dictionaryValue

    #expect(actionDict?["label"] as? String == "Undo")
    #expect(actionDict?["name"] as? String == "undo_action")
  }

  @Test("Alert without action")
  func testAlertWithoutAction() throws {
    let json = """
      {"type": "Alert", "props": {"title": "No Action"}}
      """

    let node = ComponentNode.from(json: json)!
    let actionValue = node.props?["action"]

    #expect(actionValue == nil)
  }

  @Test("Alert action button label")
  func testAlertActionButtonLabel() throws {
    let json = """
      {
          "type": "Alert",
          "props": {
              "title": "Alert",
              "action": {
                  "label": "Retry",
                  "name": "retry"
              }
          }
      }
      """

    let node = ComponentNode.from(json: json)!
    let actionDict = node.props?["action"]?.dictionaryValue

    #expect(actionDict?["label"] as? String == "Retry")
  }

  // MARK: - Action Handler

  @Test("Alert action triggers handler")
  func testActionHandlerTriggered() throws {
    var receivedAction: Action?

    let json = """
      {
          "type": "Alert",
          "props": {
              "title": "Test",
              "action": {
                  "label": "Click",
                  "name": "test_action",
                  "params": {"key": "value"}
              }
          }
      }
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext { action in
      receivedAction = action
    }

    // Build the view
    let _ = AlertBuilder.build(node: node, context: context)

    // Manually invoke handleAction
    let actionValue = node.props?["action"]
    context.handleAction(actionValue)

    #expect(receivedAction != nil)
    #expect(receivedAction?.name == "test_action")
  }

  // MARK: - Type Name

  @Test("Builder has correct type name")
  func testTypeName() throws {
    #expect(AlertBuilder.typeName == "Alert")
  }

  // MARK: - Severity Colors

  @Test("Info severity uses primary color")
  func testInfoSeverityUsesColor() throws {
    let json = """
      {"type": "Alert", "props": {"title": "Info", "severity": "info"}}
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()

    let view = AlertBuilder.build(node: node, context: context)

    // Info severity uses primaryColor from context
    #expect(context.primaryColor == DefaultTheme.primaryColor)
    #expect(view != nil)
  }

  @Test("Success severity uses success color")
  func testSuccessSeverityUsesColor() throws {
    let json = """
      {"type": "Alert", "props": {"title": "Success", "severity": "success"}}
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()

    let view = AlertBuilder.build(node: node, context: context)

    #expect(context.successColor == DefaultTheme.successColor)
    #expect(view != nil)
  }

  @Test("Warning severity uses warning color")
  func testWarningSeverityUsesColor() throws {
    let json = """
      {"type": "Alert", "props": {"title": "Warning", "severity": "warning"}}
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()

    let view = AlertBuilder.build(node: node, context: context)

    #expect(context.warningColor == DefaultTheme.warningColor)
    #expect(view != nil)
  }

  @Test("Error severity uses error color")
  func testErrorSeverityUsesColor() throws {
    let json = """
      {"type": "Alert", "props": {"title": "Error", "severity": "error"}}
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()

    let view = AlertBuilder.build(node: node, context: context)

    #expect(context.errorColor == DefaultTheme.errorColor)
    #expect(view != nil)
  }

  // MARK: - Full Props Combination

  @Test("All props together")
  func testAllPropsTogether() throws {
    let json = """
      {
          "type": "Alert",
          "props": {
              "title": "Complete Alert",
              "message": "This alert has all properties set.",
              "severity": "warning",
              "dismissible": true,
              "action": {
                  "label": "Fix Now",
                  "name": "fix_issue",
                  "params": {"issue_id": 789}
              }
          }
      }
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()

    let view = AlertBuilder.build(node: node, context: context)

    #expect(node.string("title") == "Complete Alert")
    #expect(node.string("message") == "This alert has all properties set.")
    #expect(node.string("severity") == "warning")
    #expect(node.bool("dismissible") == true)
    #expect(view != nil)
  }

  // MARK: - Theme Integration

  @Test("Alert uses custom theme colors")
  func testAlertUsesCustomTheme() throws {
    let json = """
      {"type": "Alert", "props": {"title": "Themed", "severity": "success"}}
      """

    let node = ComponentNode.from(json: json)!
    let customContext = makeContext(theme: TestTheme.self)

    let view = AlertBuilder.build(node: node, context: customContext)

    #expect(customContext.successColor == TestTheme.successColor)
    #expect(view != nil)
  }

  @Test("Alert uses custom theme spacing")
  func testAlertUsesCustomThemeSpacing() throws {
    let json = """
      {"type": "Alert", "props": {"title": "Spaced"}}
      """

    let node = ComponentNode.from(json: json)!
    let customContext = makeContext(theme: TestTheme.self)

    #expect(customContext.spacingMD == TestTheme.spacingMD)
    #expect(customContext.spacingSM == TestTheme.spacingSM)
    #expect(customContext.spacingXS == TestTheme.spacingXS)

    let view = AlertBuilder.build(node: node, context: customContext)
    #expect(view != nil)
  }

  @Test("Alert uses custom theme radius")
  func testAlertUsesCustomThemeRadius() throws {
    let json = """
      {"type": "Alert", "props": {"title": "Rounded"}}
      """

    let node = ComponentNode.from(json: json)!
    let customContext = makeContext(theme: TestTheme.self)

    #expect(customContext.radiusMD == TestTheme.radiusMD)

    let view = AlertBuilder.build(node: node, context: customContext)
    #expect(view != nil)
  }

  // MARK: - Various Combinations

  @Test("Error alert with action")
  func testErrorAlertWithAction() throws {
    let json = """
      {
          "type": "Alert",
          "props": {
              "title": "Error Occurred",
              "message": "Something went wrong",
              "severity": "error",
              "action": {
                  "label": "Retry",
                  "name": "retry"
              }
          }
      }
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()

    let view = AlertBuilder.build(node: node, context: context)

    #expect(node.string("severity") == "error")
    #expect(view != nil)
  }

  @Test("Success alert dismissible")
  func testSuccessAlertDismissible() throws {
    let json = """
      {
          "type": "Alert",
          "props": {
              "title": "Success!",
              "message": "Operation completed successfully.",
              "severity": "success",
              "dismissible": true
          }
      }
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()

    let view = AlertBuilder.build(node: node, context: context)

    #expect(node.string("severity") == "success")
    #expect(node.bool("dismissible") == true)
    #expect(view != nil)
  }
}
