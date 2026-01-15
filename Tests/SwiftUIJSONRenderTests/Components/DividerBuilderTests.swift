import SwiftUI
import Testing

@testable import SwiftUIJSONRender

@Suite("DividerBuilder Tests")
@MainActor
struct DividerBuilderTests {

  func makeContext() -> RenderContext {
    let registry = ComponentRegistry()
    registry.register(module: BuiltInComponentsModule())
    return RenderContext(registry: registry)
  }

  @Test("Default orientation is horizontal")
  func testDefaultOrientation() throws {
    let json = """
      {"type": "Divider", "props": {}}
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()

    let view = DividerBuilder.build(node: node, context: context)

    #expect(node.string("orientation") == nil)
    #expect(view != nil)
  }

  @Test("Vertical orientation")
  func testVerticalOrientation() throws {
    let json = """
      {"type": "Divider", "props": {"orientation": "vertical"}}
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()

    let view = DividerBuilder.build(node: node, context: context)

    #expect(node.string("orientation") == "vertical")
    #expect(view != nil)
  }

  @Test("Custom thickness")
  func testCustomThickness() throws {
    let json = """
      {"type": "Divider", "props": {"thickness": 3}}
      """

    let node = ComponentNode.from(json: json)!

    #expect(node.double("thickness") == 3)
  }

  @Test("Default thickness is 1")
  func testDefaultThickness() throws {
    let json = """
      {"type": "Divider", "props": {}}
      """

    let node = ComponentNode.from(json: json)!

    #expect(node.double("thickness") == nil)
    #expect(node.double("thickness", default: 1) == 1)
  }

  @Test("Custom color")
  func testCustomColor() throws {
    let json = """
      {"type": "Divider", "props": {"color": "#FF0000"}}
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()

    let view = DividerBuilder.build(node: node, context: context)

    #expect(node.string("color") == "#FF0000")
    #expect(view != nil)
  }

  @Test("Padding applied")
  func testPadding() throws {
    let json = """
      {"type": "Divider", "props": {"padding": 8}}
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()

    let view = DividerBuilder.build(node: node, context: context)

    #expect(node.double("padding") == 8)
    #expect(view != nil)
  }

  @Test("Length applied")
  func testLength() throws {
    let json = """
      {"type": "Divider", "props": {"length": 120}}
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()

    let view = DividerBuilder.build(node: node, context: context)

    #expect(node.double("length") == 120)
    #expect(view != nil)
  }

  @Test("Builder has correct type name")
  func testTypeName() throws {
    #expect(DividerBuilder.typeName == "Divider")
  }
}
