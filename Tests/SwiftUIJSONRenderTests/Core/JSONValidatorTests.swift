import Testing

@testable import SwiftUIJSONRender

@Suite("JSONValidator Tests")
struct JSONValidatorTests {

  @Test("Validates correct JSON")
  func validatesCorrectJSON() {
    // Ensure built-in components are registered
    registerBuiltInComponents()

    let json = """
      {
          "type": "Stack",
          "children": [
              { "type": "Text", "props": { "content": "Hello" } }
          ]
      }
      """

    let result = JSONValidator.validate(json)

    #expect(result.isValid)
    #expect(result.errors.isEmpty)
  }

  @Test("Detects parse errors")
  func detectsParseErrors() {
    let json = "{ invalid json }"

    let result = JSONValidator.validate(json)

    #expect(!result.isValid)
    #expect(result.errors.count == 1)

    if case .parseError = result.errors[0] {
      // Expected
    } else {
      Issue.record("Expected parse error")
    }
  }

  @Test("Detects unknown component types")
  func detectsUnknownComponents() {
    let registry = ComponentRegistry()
    // Empty registry - no components registered

    let json = """
      { "type": "UnknownComponent" }
      """

    let result = JSONValidator.validate(json, registry: registry)

    #expect(!result.isValid)
    #expect(result.errors.contains(.unknownComponent("UnknownComponent")))
  }

  @Test("Validates nested children")
  func validatesNestedChildren() {
    let registry = ComponentRegistry()
    registry.register(module: BuiltInComponentsModule())

    let json = """
      {
          "type": "Stack",
          "children": [
              {
                  "type": "Card",
                  "children": [
                      { "type": "UnknownChild" }
                  ]
              }
          ]
      }
      """

    let result = JSONValidator.validate(json, registry: registry)

    #expect(!result.isValid)
    #expect(result.errors.contains(.unknownComponent("UnknownChild")))
  }

  @Test("Detects max depth exceeded")
  func detectsMaxDepthExceeded() {
    // Build deeply nested JSON
    var json = """
      { "type": "Text", "props": { "content": "Deep" } }
      """

    for _ in 0..<(JSONValidator.maxDepth + 5) {
      json = """
        { "type": "Stack", "children": [\(json)] }
        """
    }

    let registry = ComponentRegistry()
    registry.register(module: BuiltInComponentsModule())

    let result = JSONValidator.validate(json, registry: registry)

    #expect(!result.isValid)

    let hasDepthError = result.errors.contains { error in
      if case .maxDepthExceeded = error {
        return true
      }
      return false
    }
    #expect(hasDepthError)
  }

  @Test("ComponentNode validate extension works")
  func componentNodeValidateExtension() {
    registerBuiltInComponents()

    let node = ComponentNode(
      type: "Stack",
      children: [
        ComponentNode(type: "Text", props: ["content": "Hello"])
      ]
    )

    let result = node.validate()

    #expect(result.isValid)
  }

  @Test("ValidationError descriptions are readable")
  func errorDescriptionsReadable() {
    let errors: [ValidationError] = [
      .parseError("Invalid syntax"),
      .maxDepthExceeded(depth: 25, maxDepth: 20),
      .unknownComponent("FooBar"),
      .missingRequiredProperty(component: "Button", property: "label"),
      .invalidPropertyType(
        component: "Text", property: "size", expected: "number", actual: "string"),
      .invalidPropertyValue(
        component: "Alert", property: "severity",
        reason: "must be one of: info, success, warning, error"),
    ]

    for error in errors {
      #expect(!error.description.isEmpty)
    }
  }
}
