import SwiftUI
import Testing

@testable import SwiftUIJSONRender

@Suite("SpacerBuilder Tests")
@MainActor
struct SpacerBuilderTests {

  func makeContext() -> RenderContext {
    let registry = ComponentRegistry()
    registry.register(module: BuiltInComponentsModule())
    return RenderContext(registry: registry)
  }

  @Test("Default size")
  func testDefaultSize() throws {
    let json = """
      {"type": "Spacer", "props": {}}
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()

    let view = SpacerBuilder.build(node: node, context: context)

    #expect(node.double("size") == nil)
    #expect(view != nil)
  }

  @Test("Custom size")
  func testCustomSize() throws {
    let json = """
      {"type": "Spacer", "props": {"size": 24}}
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()

    let view = SpacerBuilder.build(node: node, context: context)

    #expect(node.double("size") == 24)
    #expect(view != nil)
  }

  @Test("Zero size")
  func testZeroSize() throws {
    let json = """
      {"type": "Spacer", "props": {"size": 0}}
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()

    let view = SpacerBuilder.build(node: node, context: context)

    #expect(node.double("size") == 0)
    #expect(view != nil)
  }

  @Test("Builder has correct type name")
  func testTypeName() throws {
    #expect(SpacerBuilder.typeName == "Spacer")
  }
}
