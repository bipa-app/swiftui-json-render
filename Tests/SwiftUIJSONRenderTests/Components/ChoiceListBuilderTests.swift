import SwiftUI
import Testing

@testable import SwiftUIJSONRender

@Suite("ChoiceListBuilder Tests")
@MainActor
struct ChoiceListBuilderTests {

  func makeContext() -> RenderContext {
    let registry = ComponentRegistry()
    registry.register(module: BuiltInComponentsModule())
    return RenderContext(registry: registry)
  }

  @Test("Choice list with options")
  func testChoiceListOptions() throws {
    let json = """
      {
        "type": "ChoiceList",
        "props": {
          "question": "Which PIX key?",
          "options": [
            { "id": "cpf", "label": "CPF: ***456", "description": "Tax ID" },
            { "id": "phone", "label": "Phone: +55 11 ****-5678" }
          ],
          "action": { "name": "select_pix_key", "paramKey": "key_id" }
        }
      }
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()
    let view = ChoiceListBuilder.build(node: node, context: context)

    #expect(node.string("question") == "Which PIX key?")
    #expect(node.array("options")?.count == 2)
    #expect(view != nil)
  }

  @Test("Choice list with no options")
  func testChoiceListEmpty() throws {
    let json = """
      { "type": "ChoiceList", "props": { "options": [] } }
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()
    let view = ChoiceListBuilder.build(node: node, context: context)

    #expect(node.array("options")?.isEmpty == true)
    #expect(view != nil)
  }

  @Test("Builder has correct type name")
  func testTypeName() throws {
    #expect(ChoiceListBuilder.typeName == "ChoiceList")
  }
}
