import SwiftUI
import Testing

@testable import SwiftUIJSONRender

@Suite("BalanceCardBuilder Tests")
@MainActor
struct BalanceCardBuilderTests {

  func makeContext() -> RenderContext {
    let registry = ComponentRegistry()
    registry.register(module: BuiltInComponentsModule())
    return RenderContext(registry: registry)
  }

  @Test("Balance card with required values")
  func testBalanceCardRequiredValues() throws {
    let json = """
      {"type": "BalanceCard", "props": {"brl": 1245032, "btc": 234000}}
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()
    let view = BalanceCardBuilder.build(node: node, context: context)

    #expect(node.int("brl") == 1_245_032)
    #expect(node.int("btc") == 234000)
    #expect(view != nil)
  }

  @Test("Balance card with optional usdt")
  func testBalanceCardOptionalUsdt() throws {
    let json = """
      {"type": "BalanceCard", "props": {"brl": 100, "btc": 200, "usdt": 50000000}}
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()
    let view = BalanceCardBuilder.build(node: node, context: context)

    #expect(node.int("usdt") == 50_000_000)
    #expect(view != nil)
  }

  @Test("Balance card with change")
  func testBalanceCardChange() throws {
    let json = """
      {"type": "BalanceCard", "props": {"brl": 100, "btc": 200, "showChange": true, "brlChange": -1.2}}
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()
    let view = BalanceCardBuilder.build(node: node, context: context)

    #expect(node.bool("showChange") == true)
    #expect(node.double("brlChange") == -1.2)
    #expect(view != nil)
  }

  @Test("Builder has correct type name")
  func testTypeName() throws {
    #expect(BalanceCardBuilder.typeName == "BalanceCard")
  }
}
