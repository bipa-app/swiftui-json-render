import SwiftUI
import Testing

@testable import SwiftUIJSONRender

@Suite("AssetPriceBuilder Tests")
@MainActor
struct AssetPriceBuilderTests {

  func makeContext() -> RenderContext {
    let registry = ComponentRegistry()
    registry.register(module: BuiltInComponentsModule())
    return RenderContext(registry: registry)
  }

  @Test("Asset price with required fields")
  func testAssetPriceRequired() throws {
    let json = """
      {"type": "AssetPrice", "props": {"symbol": "BTC", "price": 180000.23}}
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()
    let view = AssetPriceBuilder.build(node: node, context: context)

    #expect(node.string("symbol") == "BTC")
    #expect(node.double("price") == 180000.23)
    #expect(view != nil)
  }

  @Test("Asset price with change")
  func testAssetPriceChange() throws {
    let json = """
      {"type": "AssetPrice", "props": {"symbol": "BTC", "price": 180000.23, "change": 1200.5, "changePercent": 1.28}}
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()
    let view = AssetPriceBuilder.build(node: node, context: context)

    #expect(node.double("change") == 1200.5)
    #expect(node.double("changePercent") == 1.28)
    #expect(view != nil)
  }

  @Test("Builder has correct type name")
  func testTypeName() throws {
    #expect(AssetPriceBuilder.typeName == "AssetPrice")
  }
}
