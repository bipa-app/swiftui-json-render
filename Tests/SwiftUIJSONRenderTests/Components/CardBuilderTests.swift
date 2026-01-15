import SwiftUI
import Testing

@testable import SwiftUIJSONRender

@Suite("CardBuilder Tests")
@MainActor
struct CardBuilderTests {

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

  // MARK: - Title

  @Test("Card with title")
  func testCardWithTitle() throws {
    let json = """
      {
          "type": "Card",
          "props": {"title": "My Card Title"},
          "children": [
              {"type": "Text", "props": {"content": "Content"}}
          ]
      }
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()

    let view = CardBuilder.build(node: node, context: context)

    #expect(node.string("title") == "My Card Title")
    #expect(view != nil)
  }

  @Test("Card without title")
  func testCardWithoutTitle() throws {
    let json = """
      {
          "type": "Card",
          "children": [
              {"type": "Text", "props": {"content": "Content"}}
          ]
      }
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()

    let view = CardBuilder.build(node: node, context: context)

    #expect(node.string("title") == nil)
    #expect(view != nil)
  }

  @Test("Card with empty title")
  func testCardWithEmptyTitle() throws {
    let json = """
      {
          "type": "Card",
          "props": {"title": ""},
          "children": []
      }
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()

    let view = CardBuilder.build(node: node, context: context)

    #expect(node.string("title") == "")
    #expect(view != nil)
  }

  // MARK: - Padding

  @Test("Custom padding")
  func testCustomPadding() throws {
    let json = """
      {
          "type": "Card",
          "props": {"padding": 24},
          "children": []
      }
      """

    let node = ComponentNode.from(json: json)!

    #expect(node.double("padding") == 24)
  }

  @Test("Default padding from theme")
  func testDefaultPadding() throws {
    let json = """
      {
          "type": "Card",
          "children": []
      }
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()

    #expect(node.double("padding") == nil)
    // Default should be spacingMD from theme
    #expect(context.spacingMD == DefaultTheme.spacingMD)
  }

  @Test("Zero padding")
  func testZeroPadding() throws {
    let json = """
      {
          "type": "Card",
          "props": {"padding": 0},
          "children": []
      }
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()

    let view = CardBuilder.build(node: node, context: context)

    #expect(node.double("padding") == 0)
    #expect(view != nil)
  }

  @Test("Decimal padding")
  func testDecimalPadding() throws {
    let json = """
      {
          "type": "Card",
          "props": {"padding": 12.5},
          "children": []
      }
      """

    let node = ComponentNode.from(json: json)!

    #expect(node.double("padding") == 12.5)
  }

  // MARK: - Corner Radius

  @Test("Custom corner radius")
  func testCustomCornerRadius() throws {
    let json = """
      {
          "type": "Card",
          "props": {"cornerRadius": 20},
          "children": []
      }
      """

    let node = ComponentNode.from(json: json)!

    #expect(node.double("cornerRadius") == 20)
  }

  @Test("Default corner radius from theme")
  func testDefaultCornerRadius() throws {
    let json = """
      {
          "type": "Card",
          "children": []
      }
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()

    #expect(node.double("cornerRadius") == nil)
    // Default should be radiusMD from theme
    #expect(context.radiusMD == DefaultTheme.radiusMD)
  }

  @Test("Zero corner radius")
  func testZeroCornerRadius() throws {
    let json = """
      {
          "type": "Card",
          "props": {"cornerRadius": 0},
          "children": []
      }
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()

    let view = CardBuilder.build(node: node, context: context)

    #expect(node.double("cornerRadius") == 0)
    #expect(view != nil)
  }

  // MARK: - Children

  @Test("Card renders children")
  func testRendersChildren() throws {
    let json = """
      {
          "type": "Card",
          "props": {"title": "Card"},
          "children": [
              {"type": "Text", "props": {"content": "Line 1"}},
              {"type": "Text", "props": {"content": "Line 2"}}
          ]
      }
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()

    let view = CardBuilder.build(node: node, context: context)

    #expect(node.children?.count == 2)
    #expect(view != nil)
  }

  @Test("Card with empty children")
  func testEmptyChildren() throws {
    let json = """
      {
          "type": "Card",
          "children": []
      }
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()

    let view = CardBuilder.build(node: node, context: context)

    #expect(node.children?.isEmpty == true)
    #expect(view != nil)
  }

  @Test("Card with nil children")
  func testNilChildren() throws {
    let json = """
      {
          "type": "Card"
      }
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()

    let view = CardBuilder.build(node: node, context: context)

    #expect(node.children == nil)
    #expect(view != nil)
  }

  @Test("Card with nested content")
  func testNestedContent() throws {
    let json = """
      {
          "type": "Card",
          "props": {"title": "Nested"},
          "children": [
              {
                  "type": "Stack",
                  "props": {"direction": "horizontal"},
                  "children": [
                      {"type": "Text", "props": {"content": "A"}},
                      {"type": "Text", "props": {"content": "B"}}
                  ]
              }
          ]
      }
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()

    let view = CardBuilder.build(node: node, context: context)

    #expect(node.children?.count == 1)
    #expect(node.children?[0].type == "Stack")
    #expect(view != nil)
  }

  // MARK: - Theme Integration

  @Test("Card uses custom theme")
  func testCustomTheme() throws {
    let json = """
      {
          "type": "Card",
          "children": []
      }
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext(theme: TestTheme.self)

    // Verify context has custom theme values
    #expect(context.spacingMD == TestTheme.spacingMD)
    #expect(context.radiusMD == TestTheme.radiusMD)

    let view = CardBuilder.build(node: node, context: context)
    #expect(view != nil)
  }

  // MARK: - Type Name

  @Test("Builder has correct type name")
  func testTypeName() throws {
    #expect(CardBuilder.typeName == "Card")
  }

  // MARK: - Full Props Combination

  @Test("All props together")
  func testAllPropsTogether() throws {
    let json = """
      {
          "type": "Card",
          "props": {
              "title": "Complete Card",
              "padding": 32,
              "cornerRadius": 16
          },
          "children": [
              {"type": "Text", "props": {"content": "Content"}}
          ]
      }
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()

    let view = CardBuilder.build(node: node, context: context)

    #expect(node.string("title") == "Complete Card")
    #expect(node.double("padding") == 32)
    #expect(node.double("cornerRadius") == 16)
    #expect(view != nil)
  }

  // MARK: - Card with Interactive Content

  @Test("Card with button")
  func testCardWithButton() throws {
    let json = """
      {
          "type": "Card",
          "props": {"title": "Action Card"},
          "children": [
              {"type": "Text", "props": {"content": "Click below"}},
              {
                  "type": "Button",
                  "props": {
                      "label": "Action",
                      "action": {"name": "do_action"}
                  }
              }
          ]
      }
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()

    let view = CardBuilder.build(node: node, context: context)

    #expect(node.children?.count == 2)
    #expect(node.children?[1].type == "Button")
    #expect(view != nil)
  }
}
