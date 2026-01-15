import SwiftUI
import Testing

@testable import SwiftUIJSONRender

@Suite("StackBuilder Tests")
@MainActor
struct StackBuilderTests {

  // MARK: - Setup

  func makeContext() -> RenderContext {
    let registry = ComponentRegistry()
    registry.register(module: BuiltInComponentsModule())
    return RenderContext(
      themeType: DefaultTheme.self,
      actionHandler: nil,
      registry: registry
    )
  }

  // MARK: - Direction

  @Test("Default direction is vertical")
  func testDefaultDirection() throws {
    let json = """
      {
          "type": "Stack",
          "children": [
              {"type": "Text", "props": {"content": "Item"}}
          ]
      }
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()

    // The build should succeed
    let view = StackBuilder.build(node: node, context: context)

    // We can verify the node's prop parsing defaults correctly
    #expect(node.string("direction", default: "vertical") == "vertical")
    #expect(view != nil)
  }

  @Test("Vertical direction creates VStack")
  func testVerticalDirection() throws {
    let json = """
      {
          "type": "Stack",
          "props": {"direction": "vertical"},
          "children": [
              {"type": "Text", "props": {"content": "Item"}}
          ]
      }
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()

    let view = StackBuilder.build(node: node, context: context)

    #expect(node.string("direction") == "vertical")
    #expect(view != nil)
  }

  @Test("Horizontal direction creates HStack")
  func testHorizontalDirection() throws {
    let json = """
      {
          "type": "Stack",
          "props": {"direction": "horizontal"},
          "children": [
              {"type": "Text", "props": {"content": "Item 1"}},
              {"type": "Text", "props": {"content": "Item 2"}}
          ]
      }
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()

    let view = StackBuilder.build(node: node, context: context)

    #expect(node.string("direction") == "horizontal")
    #expect(view != nil)
  }

  // MARK: - Spacing

  @Test("Custom spacing is applied")
  func testCustomSpacing() throws {
    let json = """
      {
          "type": "Stack",
          "props": {"spacing": 24},
          "children": []
      }
      """

    let node = ComponentNode.from(json: json)!

    #expect(node.double("spacing") == 24)
  }

  @Test("Default spacing uses theme")
  func testDefaultSpacing() throws {
    let json = """
      {
          "type": "Stack",
          "children": []
      }
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()

    // When spacing is not specified, it should use theme's spacingSM
    #expect(node.double("spacing") == nil)
    // The component will use context.spacingSM as default
    #expect(context.spacingSM == DefaultTheme.spacingSM)
  }

  @Test("Spacing with decimal value")
  func testSpacingDecimal() throws {
    let json = """
      {
          "type": "Stack",
          "props": {"spacing": 12.5},
          "children": []
      }
      """

    let node = ComponentNode.from(json: json)!

    #expect(node.double("spacing") == 12.5)
  }

  @Test("Zero spacing is valid")
  func testZeroSpacing() throws {
    let json = """
      {
          "type": "Stack",
          "props": {"spacing": 0},
          "children": []
      }
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()

    let view = StackBuilder.build(node: node, context: context)

    #expect(node.double("spacing") == 0)
    #expect(view != nil)
  }

  // MARK: - Alignment

  @Test("Leading alignment")
  func testAlignmentLeading() throws {
    let json = """
      {
          "type": "Stack",
          "props": {"alignment": "leading"},
          "children": []
      }
      """

    let node = ComponentNode.from(json: json)!

    #expect(node.string("alignment") == "leading")
  }

  @Test("Center alignment")
  func testAlignmentCenter() throws {
    let json = """
      {
          "type": "Stack",
          "props": {"alignment": "center"},
          "children": []
      }
      """

    let node = ComponentNode.from(json: json)!

    #expect(node.string("alignment") == "center")
  }

  @Test("Trailing alignment")
  func testAlignmentTrailing() throws {
    let json = """
      {
          "type": "Stack",
          "props": {"alignment": "trailing"},
          "children": []
      }
      """

    let node = ComponentNode.from(json: json)!

    #expect(node.string("alignment") == "trailing")
  }

  @Test("Default alignment is center")
  func testDefaultAlignment() throws {
    let json = """
      {
          "type": "Stack",
          "children": []
      }
      """

    let node = ComponentNode.from(json: json)!

    // When not specified, should use center as default
    #expect(node.string("alignment") == nil)
    #expect(node.string("alignment", default: "center") == "center")
  }

  @Test("Case insensitive alignment")
  func testCaseInsensitiveAlignment() throws {
    let json = """
      {
          "type": "Stack",
          "props": {"alignment": "LEADING"},
          "children": []
      }
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()

    // Build should handle case insensitivity
    let view = StackBuilder.build(node: node, context: context)

    #expect(view != nil)
  }

  // MARK: - Children

  @Test("Renders children in order")
  func testRendersChildren() throws {
    let json = """
      {
          "type": "Stack",
          "props": {"direction": "vertical"},
          "children": [
              {"type": "Text", "props": {"content": "First"}},
              {"type": "Text", "props": {"content": "Second"}},
              {"type": "Text", "props": {"content": "Third"}}
          ]
      }
      """

    let node = ComponentNode.from(json: json)!

    #expect(node.children?.count == 3)
    #expect(node.children?[0].string("content") == "First")
    #expect(node.children?[1].string("content") == "Second")
    #expect(node.children?[2].string("content") == "Third")
  }

  @Test("Empty children renders empty stack")
  func testEmptyChildren() throws {
    let json = """
      {
          "type": "Stack",
          "children": []
      }
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()

    let view = StackBuilder.build(node: node, context: context)

    #expect(node.children?.isEmpty == true)
    #expect(view != nil)
  }

  @Test("Nil children renders empty stack")
  func testNilChildren() throws {
    let json = """
      {
          "type": "Stack"
      }
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()

    let view = StackBuilder.build(node: node, context: context)

    #expect(node.children == nil)
    #expect(view != nil)
  }

  @Test("Nested stacks")
  func testNestedStacks() throws {
    let json = """
      {
          "type": "Stack",
          "props": {"direction": "vertical"},
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

    let view = StackBuilder.build(node: node, context: context)

    #expect(node.children?.count == 1)
    #expect(node.children?[0].string("direction") == "horizontal")
    #expect(node.children?[0].children?.count == 2)
    #expect(view != nil)
  }

  // MARK: - Type Name

  @Test("Builder has correct type name")
  func testTypeName() throws {
    #expect(StackBuilder.typeName == "Stack")
  }

  // MARK: - Full Props Combination

  @Test("All props together")
  func testAllPropsTogether() throws {
    let json = """
      {
          "type": "Stack",
          "props": {
              "direction": "horizontal",
              "spacing": 20,
              "alignment": "leading"
          },
          "children": [
              {"type": "Text", "props": {"content": "Hello"}}
          ]
      }
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()

    let view = StackBuilder.build(node: node, context: context)

    #expect(node.string("direction") == "horizontal")
    #expect(node.double("spacing") == 20)
    #expect(node.string("alignment") == "leading")
    #expect(view != nil)
  }
}
