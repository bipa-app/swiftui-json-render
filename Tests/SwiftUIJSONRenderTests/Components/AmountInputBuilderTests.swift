import SwiftUI
import Testing

@testable import SwiftUIJSONRender

@Suite("AmountInputBuilder Tests")
@MainActor
struct AmountInputBuilderTests {

  func makeContext() -> RenderContext {
    let registry = ComponentRegistry()
    registry.register(module: BuiltInComponentsModule())
    return RenderContext(registry: registry)
  }

  @Test("Amount input with label and currency")
  func testAmountInputBasic() throws {
    let json = """
      {"type": "AmountInput", "props": {"label": "Amount", "placeholder": "0,00", "currency": "BRL"}}
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()
    let view = AmountInputBuilder.build(node: node, context: context)

    #expect(node.string("label") == "Amount")
    #expect(node.string("placeholder") == "0,00")
    #expect(node.string("currency") == "BRL")
    #expect(view != nil)
  }

  @Test("Amount input default currency")
  func testAmountInputDefaultCurrency() throws {
    let json = """
      {"type": "AmountInput", "props": {"label": "Amount"}}
      """

    let node = ComponentNode.from(json: json)!
    #expect(node.string("currency", default: "BRL") == "BRL")
  }

  @Test("Builder has correct type name")
  func testTypeName() throws {
    #expect(AmountInputBuilder.typeName == "AmountInput")
  }
}
