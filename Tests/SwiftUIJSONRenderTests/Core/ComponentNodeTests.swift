import Testing

@testable import SwiftUIJSONRender

@Suite("ComponentNode Tests")
struct ComponentNodeTests {

  @Test("Parses simple component from JSON")
  func parsesSimpleComponent() throws {
    let json = """
      {
          "type": "Text",
          "props": { "content": "Hello" }
      }
      """

    let node = ComponentNode.from(json: json)

    #expect(node != nil)
    #expect(node?.type == "Text")
    #expect(node?.string("content") == "Hello")
  }

  @Test("Parses component with children")
  func parsesComponentWithChildren() throws {
    let json = """
      {
          "type": "Stack",
          "props": { "direction": "vertical" },
          "children": [
              { "type": "Text", "props": { "content": "First" } },
              { "type": "Text", "props": { "content": "Second" } }
          ]
      }
      """

    let node = ComponentNode.from(json: json)

    #expect(node != nil)
    #expect(node?.type == "Stack")
    #expect(node?.children?.count == 2)
    #expect(node?.children?[0].type == "Text")
    #expect(node?.children?[0].string("content") == "First")
  }

  @Test("Returns nil for invalid JSON")
  func returnsNilForInvalidJSON() {
    let json = "{ invalid json }"
    let node = ComponentNode.from(json: json)

    #expect(node == nil)
  }

  @Test("Parses component without props")
  func parsesComponentWithoutProps() {
    let json = """
      { "type": "Spacer" }
      """

    let node = ComponentNode.from(json: json)

    #expect(node != nil)
    #expect(node?.type == "Spacer")
    #expect(node?.props == nil)
  }

  @Test("Property accessors work correctly")
  func propertyAccessorsWork() {
    let json = """
      {
          "type": "Test",
          "props": {
              "stringProp": "hello",
              "intProp": 42,
              "doubleProp": 3.14,
              "boolProp": true
          }
      }
      """

    let node = ComponentNode.from(json: json)!

    #expect(node.string("stringProp") == "hello")
    #expect(node.int("intProp") == 42)
    #expect(node.double("doubleProp") == 3.14)
    #expect(node.bool("boolProp") == true)
  }

  @Test("Default values work correctly")
  func defaultValuesWork() {
    let json = """
      { "type": "Test", "props": {} }
      """

    let node = ComponentNode.from(json: json)!

    #expect(node.string("missing", default: "default") == "default")
    #expect(node.int("missing", default: 10) == 10)
    #expect(node.double("missing", default: 1.5) == 1.5)
    #expect(node.bool("missing", default: false) == false)
  }

  @Test("Deeply nested structure parses correctly")
  func deeplyNestedStructure() {
    let json = """
      {
          "type": "Stack",
          "children": [
              {
                  "type": "Card",
                  "children": [
                      {
                          "type": "Stack",
                          "children": [
                              { "type": "Text", "props": { "content": "Deep" } }
                          ]
                      }
                  ]
              }
          ]
      }
      """

    let node = ComponentNode.from(json: json)

    #expect(node != nil)
    let deepText = node?.children?[0].children?[0].children?[0]
    #expect(deepText?.type == "Text")
    #expect(deepText?.string("content") == "Deep")
  }

  @Test("Equatable conformance works")
  func equatableConformance() {
    let node1 = ComponentNode(type: "Text", props: ["content": "hello"])
    let node2 = ComponentNode(type: "Text", props: ["content": "hello"])
    let node3 = ComponentNode(type: "Text", props: ["content": "world"])

    #expect(node1 == node2)
    #expect(node1 != node3)
  }
}
