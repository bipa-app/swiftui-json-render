import SwiftUI
import Testing

@testable import SwiftUIJSONRender

@Suite("HeadingBuilder Tests")
@MainActor
struct HeadingBuilderTests {

  func makeContext() -> RenderContext {
    let registry = ComponentRegistry()
    registry.register(module: BuiltInComponentsModule())
    return RenderContext(registry: registry)
  }

  @Test("Heading with text")
  func testHeadingWithText() throws {
    let json = """
      {"type": "Heading", "props": {"text": "Section Title", "level": 1}}
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()

    let view = HeadingBuilder.build(node: node, context: context)

    #expect(node.string("text") == "Section Title")
    #expect(node.int("level") == 1)
    #expect(view != nil)
  }

  @Test("Default level is 1")
  func testDefaultLevel() throws {
    let json = """
      {"type": "Heading", "props": {"text": "Title"}}
      """

    let node = ComponentNode.from(json: json)!

    #expect(node.int("level") == nil)
    #expect(node.int("level", default: 1) == 1)
  }

  @Test("Level 2 heading")
  func testLevel2() throws {
    let json = """
      {"type": "Heading", "props": {"text": "Subsection", "level": 2}}
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()

    let view = HeadingBuilder.build(node: node, context: context)

    #expect(node.int("level") == 2)
    #expect(view != nil)
  }

  @Test("Level 3 heading")
  func testLevel3() throws {
    let json = """
      {"type": "Heading", "props": {"text": "Sub-subsection", "level": 3}}
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()

    let view = HeadingBuilder.build(node: node, context: context)

    #expect(node.int("level") == 3)
    #expect(view != nil)
  }

  @Test("Builder has correct type name")
  func testTypeName() throws {
    #expect(HeadingBuilder.typeName == "Heading")
  }
}
