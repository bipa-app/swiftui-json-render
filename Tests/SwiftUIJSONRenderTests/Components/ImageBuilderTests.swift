import SwiftUI
import Testing

@testable import SwiftUIJSONRender

@Suite("ImageBuilder Tests")
@MainActor
struct ImageBuilderTests {

  func makeContext() -> RenderContext {
    let registry = ComponentRegistry()
    registry.register(module: BuiltInComponentsModule())
    return RenderContext(registry: registry)
  }

  @Test("Image with URL")
  func testImageWithURL() throws {
    let json = """
      {"type": "Image", "props": {"url": "https://example.com/image.png"}}
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()

    let view = ImageBuilder.build(node: node, context: context)

    #expect(node.string("url") == "https://example.com/image.png")
    #expect(view != nil)
  }

  @Test("Image with asset name")
  func testImageWithName() throws {
    let json = """
      {"type": "Image", "props": {"name": "local_asset"}}
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()

    let view = ImageBuilder.build(node: node, context: context)

    #expect(node.string("name") == "local_asset")
    #expect(view != nil)
  }

  @Test("Image with contentMode fit")
  func testContentModeFit() throws {
    let json = """
      {"type": "Image", "props": {"name": "local_asset", "contentMode": "fit"}}
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()

    let view = ImageBuilder.build(node: node, context: context)

    #expect(node.string("contentMode") == "fit")
    #expect(view != nil)
  }

  @Test("Image with contentMode fill")
  func testContentModeFill() throws {
    let json = """
      {"type": "Image", "props": {"name": "local_asset", "contentMode": "fill"}}
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()

    let view = ImageBuilder.build(node: node, context: context)

    #expect(node.string("contentMode") == "fill")
    #expect(view != nil)
  }

  @Test("Image with size")
  func testImageWithSize() throws {
    let json = """
      {"type": "Image", "props": {"name": "local_asset", "width": 120, "height": 80}}
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()

    let view = ImageBuilder.build(node: node, context: context)

    #expect(node.double("width") == 120)
    #expect(node.double("height") == 80)
    #expect(view != nil)
  }

  @Test("Image with missing props returns empty view")
  func testImageMissingProps() throws {
    let json = """
      {"type": "Image", "props": {}}
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()

    let view = ImageBuilder.build(node: node, context: context)

    #expect(view != nil)
  }

  @Test("Builder has correct type name")
  func testTypeName() throws {
    #expect(ImageBuilder.typeName == "Image")
  }
}
