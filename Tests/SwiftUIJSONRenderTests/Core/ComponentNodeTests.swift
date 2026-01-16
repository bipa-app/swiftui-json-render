import Foundation
import Testing

@testable import SwiftUIJSONRender

@Suite("ComponentNode Tests")
struct ComponentNodeTests {

  // MARK: - JSON Parsing

  @Test("Parse simple JSON with type and props")
  func testParseSimpleJSON() throws {
    let json = """
      {"type": "Text", "props": {"content": "Hello"}}
      """

    let node = ComponentNode.from(json: json)

    #expect(node != nil)
    #expect(node?.type == .text)
    #expect(node?.string("content") == "Hello")
    #expect(node?.children == nil)
  }

  @Test("Parse JSON with nested children")
  func testParseNestedChildren() throws {
    let json = """
      {
          "type": "Stack",
          "props": {"direction": "vertical"},
          "children": [
              {"type": "Text", "props": {"content": "Line 1"}},
              {"type": "Text", "props": {"content": "Line 2"}}
          ]
      }
      """

    let node = ComponentNode.from(json: json)

    #expect(node != nil)
    #expect(node?.type == .stack)
    #expect(node?.children?.count == 2)
    #expect(node?.children?[0].type == .text)
    #expect(node?.children?[0].string("content") == "Line 1")
    #expect(node?.children?[1].string("content") == "Line 2")
  }

  @Test("Parse JSON with empty children array")
  func testParseEmptyChildren() throws {
    let json = """
      {"type": "Stack", "children": []}
      """

    let node = ComponentNode.from(json: json)

    #expect(node != nil)
    #expect(node?.type == .stack)
    #expect(node?.children != nil)
    #expect(node?.children?.isEmpty == true)
  }

  @Test("Parse JSON with missing children (null)")
  func testParseNullChildren() throws {
    let json = """
      {"type": "Text", "props": {"content": "Hello"}}
      """

    let node = ComponentNode.from(json: json)

    #expect(node != nil)
    #expect(node?.children == nil)
  }

  @Test("Invalid JSON returns nil")
  func testInvalidJSONReturnsNil() throws {
    let invalidJSON = "{ invalid json }"

    let node = ComponentNode.from(json: invalidJSON)

    #expect(node == nil)
  }

  @Test("Parse from Data")
  func testParseFromData() throws {
    let json = """
      {"type": "Button", "props": {"label": "Click"}}
      """
    let data = json.data(using: .utf8)!

    let node = ComponentNode.from(data: data)

    #expect(node != nil)
    #expect(node?.type == .button)
    #expect(node?.string("label") == "Click")
  }

  // MARK: - Property Accessors

  @Test("String property accessor")
  func testStringPropertyAccessor() throws {
    let node = ComponentNode(
      type: "Text",
      props: ["content": "Hello World"]
    )

    #expect(node.string("content") == "Hello World")
    #expect(node.string("nonexistent") == nil)
  }

  @Test("Int property accessor")
  func testIntPropertyAccessor() throws {
    let node = ComponentNode(
      type: "Stack",
      props: ["spacing": 16]
    )

    #expect(node.int("spacing") == 16)
    #expect(node.int("nonexistent") == nil)
  }

  @Test("Double property accessor")
  func testDoublePropertyAccessor() throws {
    let node = ComponentNode(
      type: "Card",
      props: ["cornerRadius": 12.5]
    )

    #expect(node.double("cornerRadius") == 12.5)
    #expect(node.double("nonexistent") == nil)
  }

  @Test("Bool property accessor")
  func testBoolPropertyAccessor() throws {
    let node = ComponentNode(
      type: "Button",
      props: ["disabled": true]
    )

    #expect(node.bool("disabled") == true)
    #expect(node.bool("nonexistent") == nil)
  }

  @Test("Array property accessor")
  func testArrayPropertyAccessor() throws {
    let node = ComponentNode(
      type: "List",
      props: ["items": ["a", "b", "c"]]
    )

    let items = node.array("items")
    #expect(items != nil)
    #expect(items?.count == 3)
    #expect(items?[0] as? String == "a")
  }

  @Test("Dictionary property accessor")
  func testDictionaryPropertyAccessor() throws {
    let node = ComponentNode(
      type: "Button",
      props: ["action": ["name": "submit", "id": 123]]
    )

    let action = node.dictionary("action")
    #expect(action != nil)
    #expect(action?["name"] as? String == "submit")
    #expect(action?["id"] as? Int == 123)
  }

  // MARK: - Default Values

  @Test("String with default value")
  func testStringWithDefault() throws {
    let node = ComponentNode(type: "Stack", props: nil)

    #expect(node.string("direction", default: "vertical") == "vertical")
  }

  @Test("Int with default value")
  func testIntWithDefault() throws {
    let node = ComponentNode(type: "Stack", props: nil)

    #expect(node.int("spacing", default: 8) == 8)
  }

  @Test("Double with default value")
  func testDoubleWithDefault() throws {
    let node = ComponentNode(type: "Card", props: nil)

    #expect(node.double("padding", default: 16.0) == 16.0)
  }

  @Test("Bool with default value")
  func testBoolWithDefault() throws {
    let node = ComponentNode(type: "Button", props: nil)

    #expect(node.bool("disabled", default: false) == false)
  }

  @Test("Default used when key exists but wrong type")
  func testDefaultUsedForWrongType() throws {
    let node = ComponentNode(
      type: "Stack",
      props: ["spacing": "not a number"]
    )

    #expect(node.int("spacing", default: 8) == 8)
  }

  // MARK: - Equatable

  @Test("ComponentNode equatable")
  func testEquatable() throws {
    let node1 = ComponentNode(
      type: "Text",
      props: ["content": "Hello"]
    )
    let node2 = ComponentNode(
      type: "Text",
      props: ["content": "Hello"]
    )
    let node3 = ComponentNode(
      type: "Text",
      props: ["content": "World"]
    )

    #expect(node1 == node2)
    #expect(node1 != node3)
  }

  // MARK: - Complex Parsing

  @Test("Parse deeply nested structure")
  func testParseDeepStructure() throws {
    let json = """
      {
          "type": "Stack",
          "children": [
              {
                  "type": "Card",
                  "props": {"title": "Nested"},
                  "children": [
                      {"type": "Text", "props": {"content": "Deep"}}
                  ]
              }
          ]
      }
      """

    let node = ComponentNode.from(json: json)

    #expect(node != nil)
    #expect(node?.type == .stack)
    #expect(node?.children?[0].type == .card)
    #expect(node?.children?[0].string("title") == "Nested")
    #expect(node?.children?[0].children?[0].type == .text)
    #expect(node?.children?[0].children?[0].string("content") == "Deep")
  }

  @Test("Parse mixed prop types")
  func testParseMixedPropTypes() throws {
    let json = """
      {
          "type": "Custom",
          "props": {
              "stringProp": "hello",
              "intProp": 42,
              "doubleProp": 3.14,
              "boolProp": true,
              "arrayProp": [1, 2, 3],
              "objectProp": {"key": "value"}
          }
      }
      """

    let node = ComponentNode.from(json: json)

    #expect(node != nil)
    #expect(node?.string("stringProp") == "hello")
    #expect(node?.int("intProp") == 42)
    #expect(node?.double("doubleProp") == 3.14)
    #expect(node?.bool("boolProp") == true)
    #expect(node?.array("arrayProp")?.count == 3)
    #expect(node?.dictionary("objectProp")?["key"] as? String == "value")
  }

  // MARK: - Schema Version

  @Test("Parse JSON with schema version")
  func testParseWithSchemaVersion() throws {
    let json = """
      {
          "schemaVersion": "1.0.0",
          "type": "Text",
          "props": {"content": "Hello"}
      }
      """

    let node = ComponentNode.from(json: json)

    #expect(node != nil)
    #expect(node?.schemaVersion != nil)
    #expect(node?.schemaVersion == SchemaVersion(1, 0, 0))
    #expect(node?.type == .text)
  }

  @Test("Parse JSON without schema version")
  func testParseWithoutSchemaVersion() throws {
    let json = """
      {"type": "Text", "props": {"content": "Hello"}}
      """

    let node = ComponentNode.from(json: json)

    #expect(node != nil)
    #expect(node?.schemaVersion == nil)
    #expect(node?.type == .text)
  }

  @Test("Parse JSON with minor version only")
  func testParseWithMinorVersion() throws {
    let json = """
      {
          "schemaVersion": "1.2",
          "type": "Stack",
          "children": []
      }
      """

    let node = ComponentNode.from(json: json)

    #expect(node != nil)
    #expect(node?.schemaVersion == SchemaVersion(1, 2, 0))
  }

  @Test("ComponentNode with schema version is equatable")
  func testSchemaVersionEquatable() throws {
    let node1 = ComponentNode(
      type: "Text",
      props: ["content": "Hello"],
      schemaVersion: SchemaVersion(1, 0, 0)
    )
    let node2 = ComponentNode(
      type: "Text",
      props: ["content": "Hello"],
      schemaVersion: SchemaVersion(1, 0, 0)
    )
    let node3 = ComponentNode(
      type: "Text",
      props: ["content": "Hello"],
      schemaVersion: SchemaVersion(2, 0, 0)
    )

    #expect(node1 == node2)
    #expect(node1 != node3)
  }
}
