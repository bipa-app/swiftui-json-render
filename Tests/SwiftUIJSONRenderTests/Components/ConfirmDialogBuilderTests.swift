import SwiftUI
import Testing

@testable import SwiftUIJSONRender

@Suite("ConfirmDialogBuilder Tests")
@MainActor
struct ConfirmDialogBuilderTests {

  func makeContext() -> RenderContext {
    let registry = ComponentRegistry()
    registry.register(module: BuiltInComponentsModule())
    return RenderContext(registry: registry)
  }

  @Test("Confirm dialog with labels")
  func testConfirmDialogLabels() throws {
    let json = """
      {
        "type": "ConfirmDialog",
        "props": {
          "title": "Confirm Transfer",
          "message": "Send R$ 10.00?",
          "confirmLabel": "Confirm",
          "cancelLabel": "Cancel",
          "triggerLabel": "Send"
        }
      }
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()
    let view = ConfirmDialogBuilder.build(node: node, context: context)

    #expect(node.string("title") == "Confirm Transfer")
    #expect(node.string("confirmLabel") == "Confirm")
    #expect(node.string("cancelLabel") == "Cancel")
    #expect(node.string("triggerLabel") == "Send")
    #expect(view != nil)
  }

  @Test("Confirm dialog defaults")
  func testConfirmDialogDefaults() throws {
    let json = """
      { "type": "ConfirmDialog", "props": {} }
      """

    let node = ComponentNode.from(json: json)!
    #expect(node.string("title", default: "Confirm") == "Confirm")
  }

  @Test("Builder has correct type name")
  func testTypeName() throws {
    #expect(ConfirmDialogBuilder.typeName == "ConfirmDialog")
  }
}
