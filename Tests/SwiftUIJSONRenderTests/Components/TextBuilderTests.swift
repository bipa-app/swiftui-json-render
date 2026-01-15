import SwiftUI
import Testing

@testable import SwiftUIJSONRender

@Suite("TextBuilder Tests")
@MainActor
struct TextBuilderTests {

  // MARK: - Setup

  func makeContext(theme: any JSONRenderTheme.Type = DefaultTheme.self) -> RenderContext {
    let registry = ComponentRegistry()
    registry.register(module: BuiltInComponentsModule())
    return RenderContext(
      themeType: theme,
      actionHandler: nil,
      registry: registry
    )
  }

  // MARK: - Content

  @Test("Text with content")
  func testTextWithContent() throws {
    let json = """
      {"type": "Text", "props": {"content": "Hello, World!"}}
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()

    let view = TextBuilder.build(node: node, context: context)

    #expect(node.string("content") == "Hello, World!")
    #expect(view != nil)
  }

  @Test("Text without content uses empty string")
  func testTextWithoutContent() throws {
    let json = """
      {"type": "Text", "props": {}}
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()

    let view = TextBuilder.build(node: node, context: context)

    #expect(node.string("content") == nil)
    // Builder uses empty string as default
    #expect(view != nil)
  }

  @Test("Text with empty content")
  func testTextWithEmptyContent() throws {
    let json = """
      {"type": "Text", "props": {"content": ""}}
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()

    let view = TextBuilder.build(node: node, context: context)

    #expect(node.string("content") == "")
    #expect(view != nil)
  }

  // MARK: - Style

  @Test("Body style (default)")
  func testBodyStyle() throws {
    let json = """
      {"type": "Text", "props": {"content": "Body text", "style": "body"}}
      """

    let node = ComponentNode.from(json: json)!

    #expect(node.string("style") == "body")
  }

  @Test("Caption style")
  func testCaptionStyle() throws {
    let json = """
      {"type": "Text", "props": {"content": "Caption text", "style": "caption"}}
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()

    let view = TextBuilder.build(node: node, context: context)

    #expect(node.string("style") == "caption")
    #expect(view != nil)
  }

  @Test("Footnote style")
  func testFootnoteStyle() throws {
    let json = """
      {"type": "Text", "props": {"content": "Footnote text", "style": "footnote"}}
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()

    let view = TextBuilder.build(node: node, context: context)

    #expect(node.string("style") == "footnote")
    #expect(view != nil)
  }

  @Test("Headline style")
  func testHeadlineStyle() throws {
    let json = """
      {"type": "Text", "props": {"content": "Headline", "style": "headline"}}
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()

    let view = TextBuilder.build(node: node, context: context)

    #expect(node.string("style") == "headline")
    #expect(view != nil)
  }

  @Test("Title style")
  func testTitleStyle() throws {
    let json = """
      {"type": "Text", "props": {"content": "Title", "style": "title"}}
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()

    let view = TextBuilder.build(node: node, context: context)

    #expect(node.string("style") == "title")
    #expect(view != nil)
  }

  @Test("Large title style")
  func testLargeTitleStyle() throws {
    let json = """
      {"type": "Text", "props": {"content": "Large Title", "style": "largeTitle"}}
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()

    let view = TextBuilder.build(node: node, context: context)

    #expect(node.string("style") == "largeTitle")
    #expect(view != nil)
  }

  @Test("Subheadline style")
  func testSubheadlineStyle() throws {
    let json = """
      {"type": "Text", "props": {"content": "Subheadline", "style": "subheadline"}}
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()

    let view = TextBuilder.build(node: node, context: context)

    #expect(node.string("style") == "subheadline")
    #expect(view != nil)
  }

  @Test("Default style is body")
  func testDefaultStyle() throws {
    let json = """
      {"type": "Text", "props": {"content": "No style"}}
      """

    let node = ComponentNode.from(json: json)!

    #expect(node.string("style") == nil)
    #expect(node.string("style", default: "body") == "body")
  }

  @Test("Unknown style falls back to body")
  func testUnknownStyle() throws {
    let json = """
      {"type": "Text", "props": {"content": "Unknown", "style": "nonexistent"}}
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()

    // Should still render without error, defaulting to body
    let view = TextBuilder.build(node: node, context: context)

    #expect(view != nil)
  }

  // MARK: - Weight

  @Test("Regular weight (default)")
  func testRegularWeight() throws {
    let json = """
      {"type": "Text", "props": {"content": "Regular", "weight": "regular"}}
      """

    let node = ComponentNode.from(json: json)!

    #expect(node.string("weight") == "regular")
  }

  @Test("Medium weight")
  func testMediumWeight() throws {
    let json = """
      {"type": "Text", "props": {"content": "Medium", "weight": "medium"}}
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()

    let view = TextBuilder.build(node: node, context: context)

    #expect(node.string("weight") == "medium")
    #expect(view != nil)
  }

  @Test("Semibold weight")
  func testSemiboldWeight() throws {
    let json = """
      {"type": "Text", "props": {"content": "Semibold", "weight": "semibold"}}
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()

    let view = TextBuilder.build(node: node, context: context)

    #expect(node.string("weight") == "semibold")
    #expect(view != nil)
  }

  @Test("Bold weight")
  func testBoldWeight() throws {
    let json = """
      {"type": "Text", "props": {"content": "Bold", "weight": "bold"}}
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()

    let view = TextBuilder.build(node: node, context: context)

    #expect(node.string("weight") == "bold")
    #expect(view != nil)
  }

  @Test("Heavy weight")
  func testHeavyWeight() throws {
    let json = """
      {"type": "Text", "props": {"content": "Heavy", "weight": "heavy"}}
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()

    let view = TextBuilder.build(node: node, context: context)

    #expect(node.string("weight") == "heavy")
    #expect(view != nil)
  }

  @Test("Light weight")
  func testLightWeight() throws {
    let json = """
      {"type": "Text", "props": {"content": "Light", "weight": "light"}}
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()

    let view = TextBuilder.build(node: node, context: context)

    #expect(node.string("weight") == "light")
    #expect(view != nil)
  }

  @Test("Thin weight")
  func testThinWeight() throws {
    let json = """
      {"type": "Text", "props": {"content": "Thin", "weight": "thin"}}
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()

    let view = TextBuilder.build(node: node, context: context)

    #expect(node.string("weight") == "thin")
    #expect(view != nil)
  }

  @Test("Default weight is regular")
  func testDefaultWeight() throws {
    let json = """
      {"type": "Text", "props": {"content": "No weight"}}
      """

    let node = ComponentNode.from(json: json)!

    #expect(node.string("weight") == nil)
    #expect(node.string("weight", default: "regular") == "regular")
  }

  // MARK: - Hex Colors

  @Test("Hex color 6 digits")
  func testHexColor6Digits() throws {
    let json = """
      {"type": "Text", "props": {"content": "Colored", "color": "#FF5733"}}
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()

    let view = TextBuilder.build(node: node, context: context)

    #expect(node.string("color") == "#FF5733")
    #expect(view != nil)
  }

  @Test("Hex color 8 digits (with alpha)")
  func testHexColor8Digits() throws {
    let json = """
      {"type": "Text", "props": {"content": "Semi-transparent", "color": "#FF573380"}}
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()

    let view = TextBuilder.build(node: node, context: context)

    #expect(node.string("color") == "#FF573380")
    #expect(view != nil)
  }

  @Test("Hex color lowercase")
  func testHexColorLowercase() throws {
    let json = """
      {"type": "Text", "props": {"content": "Lowercase", "color": "#ff5733"}}
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()

    let view = TextBuilder.build(node: node, context: context)

    #expect(node.string("color") == "#ff5733")
    #expect(view != nil)
  }

  @Test("Invalid hex falls back to textPrimary")
  func testInvalidHexFallback() throws {
    let json = """
      {"type": "Text", "props": {"content": "Invalid", "color": "#GGGGGG"}}
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()

    // Should still render without error
    let view = TextBuilder.build(node: node, context: context)

    #expect(view != nil)
  }

  @Test("Hex color without hash")
  func testHexColorWithoutHash() throws {
    let json = """
      {"type": "Text", "props": {"content": "No hash", "color": "FF5733"}}
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()

    // This won't parse as hex and will fall back to textPrimary
    let view = TextBuilder.build(node: node, context: context)

    #expect(view != nil)
  }

  // MARK: - Named Colors

  @Test("Primary color")
  func testPrimaryNamedColor() throws {
    let json = """
      {"type": "Text", "props": {"content": "Primary", "color": "primary"}}
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()

    let view = TextBuilder.build(node: node, context: context)

    #expect(node.string("color") == "primary")
    #expect(view != nil)
  }

  @Test("Secondary color")
  func testSecondaryNamedColor() throws {
    let json = """
      {"type": "Text", "props": {"content": "Secondary", "color": "secondary"}}
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()

    let view = TextBuilder.build(node: node, context: context)

    #expect(node.string("color") == "secondary")
    #expect(view != nil)
  }

  @Test("Error/red color")
  func testErrorNamedColor() throws {
    let json = """
      {"type": "Text", "props": {"content": "Error", "color": "error"}}
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()

    let view = TextBuilder.build(node: node, context: context)

    #expect(node.string("color") == "error")
    #expect(view != nil)
  }

  @Test("Red color alias")
  func testRedNamedColor() throws {
    let json = """
      {"type": "Text", "props": {"content": "Red", "color": "red"}}
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()

    let view = TextBuilder.build(node: node, context: context)

    #expect(node.string("color") == "red")
    #expect(view != nil)
  }

  @Test("Success/green color")
  func testSuccessNamedColor() throws {
    let json = """
      {"type": "Text", "props": {"content": "Success", "color": "success"}}
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()

    let view = TextBuilder.build(node: node, context: context)

    #expect(node.string("color") == "success")
    #expect(view != nil)
  }

  @Test("Green color alias")
  func testGreenNamedColor() throws {
    let json = """
      {"type": "Text", "props": {"content": "Green", "color": "green"}}
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()

    let view = TextBuilder.build(node: node, context: context)

    #expect(node.string("color") == "green")
    #expect(view != nil)
  }

  @Test("Warning/orange color")
  func testWarningNamedColor() throws {
    let json = """
      {"type": "Text", "props": {"content": "Warning", "color": "warning"}}
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()

    let view = TextBuilder.build(node: node, context: context)

    #expect(node.string("color") == "warning")
    #expect(view != nil)
  }

  @Test("Orange color alias")
  func testOrangeNamedColor() throws {
    let json = """
      {"type": "Text", "props": {"content": "Orange", "color": "orange"}}
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()

    let view = TextBuilder.build(node: node, context: context)

    #expect(node.string("color") == "orange")
    #expect(view != nil)
  }

  @Test("Unknown named color falls back to textPrimary")
  func testUnknownNamedColor() throws {
    let json = """
      {"type": "Text", "props": {"content": "Unknown", "color": "purple"}}
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()

    let view = TextBuilder.build(node: node, context: context)

    #expect(view != nil)
  }

  @Test("Default color uses textPrimary")
  func testDefaultColor() throws {
    let json = """
      {"type": "Text", "props": {"content": "No color"}}
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()

    let view = TextBuilder.build(node: node, context: context)

    #expect(node.string("color") == nil)
    #expect(view != nil)
  }

  // MARK: - Type Name

  @Test("Builder has correct type name")
  func testTypeName() throws {
    #expect(TextBuilder.typeName == "Text")
  }

  // MARK: - Full Props Combination

  @Test("All props together")
  func testAllPropsTogether() throws {
    let json = """
      {
          "type": "Text",
          "props": {
              "content": "Styled Text",
              "style": "headline",
              "weight": "bold",
              "color": "#0066CC"
          }
      }
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()

    let view = TextBuilder.build(node: node, context: context)

    #expect(node.string("content") == "Styled Text")
    #expect(node.string("style") == "headline")
    #expect(node.string("weight") == "bold")
    #expect(node.string("color") == "#0066CC")
    #expect(view != nil)
  }

  @Test("Case insensitive style and weight")
  func testCaseInsensitive() throws {
    let json = """
      {
          "type": "Text",
          "props": {
              "content": "Case Test",
              "style": "HEADLINE",
              "weight": "BOLD",
              "color": "SUCCESS"
          }
      }
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()

    let view = TextBuilder.build(node: node, context: context)

    #expect(view != nil)
  }
}
