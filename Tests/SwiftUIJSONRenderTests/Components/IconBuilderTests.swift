import SwiftUI
import Testing

@testable import SwiftUIJSONRender

@Suite("IconBuilder Tests")
@MainActor
struct IconBuilderTests {

  func makeContext() -> RenderContext {
    let registry = ComponentRegistry()
    registry.register(module: BuiltInComponentsModule())
    return RenderContext(registry: registry)
  }

  @Test("Icon with name")
  func testIconWithName() throws {
    let json = """
      {"type": "Icon", "props": {"name": "star.fill"}}
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()

    let view = IconBuilder.build(node: node, context: context)

    #expect(node.string("name") == "star.fill")
    #expect(view != nil)
  }

  @Test("Default icon name")
  func testDefaultIconName() throws {
    let json = """
      {"type": "Icon", "props": {}}
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()

    let view = IconBuilder.build(node: node, context: context)

    #expect(node.string("name") == nil)
    #expect(view != nil)
  }

  @Test("Custom size")
  func testCustomSize() throws {
    let json = """
      {"type": "Icon", "props": {"name": "heart.fill", "size": 24}}
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()

    let view = IconBuilder.build(node: node, context: context)

    #expect(node.double("size") == 24)
    #expect(view != nil)
  }

  @Test("Default size")
  func testDefaultSize() throws {
    let json = """
      {"type": "Icon", "props": {"name": "gear"}}
      """

    let node = ComponentNode.from(json: json)!

    #expect(node.double("size") == nil)
    #expect(node.double("size", default: 16) == 16)
  }

  @Test("Custom color")
  func testCustomColor() throws {
    let json = """
      {"type": "Icon", "props": {"name": "checkmark.circle", "color": "#00FF00"}}
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()

    let view = IconBuilder.build(node: node, context: context)

    #expect(node.string("color") == "#00FF00")
    #expect(view != nil)
  }

  @Test("Builder has correct type name")
  func testTypeName() throws {
    #expect(IconBuilder.typeName == "Icon")
  }
}
