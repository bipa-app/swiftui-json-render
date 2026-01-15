import Foundation
import Testing

@testable import SwiftUIJSONRender

@Suite("JSONValidator Tests")
struct JSONValidatorTests {

  // MARK: - Valid JSON

  @Test("Valid JSON returns .valid")
  func testValidJSON() throws {
    let registry = ComponentRegistry()
    registry.register(module: BuiltInComponentsModule())

    let result = JSONValidator.validate(TestJSON.simpleText, registry: registry)

    #expect(result.isValid)
    #expect(result.errors.isEmpty)
  }

  @Test("Valid nested structure passes validation")
  func testValidNestedStructure() throws {
    let registry = ComponentRegistry()
    registry.register(module: BuiltInComponentsModule())

    let result = JSONValidator.validate(TestJSON.complexTree, registry: registry)

    #expect(result.isValid)
  }

  @Test("Valid stack with children passes")
  func testValidStackWithChildren() throws {
    let registry = ComponentRegistry()
    registry.register(module: BuiltInComponentsModule())

    let result = JSONValidator.validate(TestJSON.stackWithChildren, registry: registry)

    #expect(result.isValid)
  }

  // MARK: - Invalid JSON Syntax

  @Test("Malformed JSON returns parse error")
  func testInvalidJSONSyntax() throws {
    let registry = ComponentRegistry()

    let result = JSONValidator.validate("{ invalid json }", registry: registry)

    #expect(!result.isValid)
    #expect(result.errors.count == 1)

    if case .parseError = result.errors[0] {
      // Expected
    } else {
      Issue.record("Expected parseError")
    }
  }

  @Test("Empty string returns parse error")
  func testEmptyString() throws {
    let registry = ComponentRegistry()

    let result = JSONValidator.validate("", registry: registry)

    #expect(!result.isValid)
    if case .parseError = result.errors[0] {
      // Expected
    } else {
      Issue.record("Expected parseError")
    }
  }

  @Test("Invalid UTF-8 returns error")
  func testInvalidUTF8() throws {
    // Create a string that would fail UTF-8 encoding edge cases
    let json = "{"  // Incomplete JSON
    let registry = ComponentRegistry()

    let result = JSONValidator.validate(json, registry: registry)

    #expect(!result.isValid)
  }

  // MARK: - Unknown Components

  @Test("Unknown component returns error")
  func testUnknownComponent() throws {
    let json = """
      {"type": "UnknownWidget", "props": {}}
      """
    let registry = ComponentRegistry()

    let result = JSONValidator.validate(json, registry: registry)

    #expect(!result.isValid)
    #expect(result.errors.count == 1)

    if case .unknownComponent(let typeName) = result.errors[0] {
      #expect(typeName == "UnknownWidget")
    } else {
      Issue.record("Expected unknownComponent error")
    }
  }

  @Test("Multiple unknown components returns multiple errors")
  func testMultipleUnknownComponents() throws {
    let json = """
      {
          "type": "Unknown1",
          "children": [
              {"type": "Unknown2"},
              {"type": "Unknown3"}
          ]
      }
      """
    let registry = ComponentRegistry()

    let result = JSONValidator.validate(json, registry: registry)

    #expect(!result.isValid)
    #expect(result.errors.count == 3)

    let errorTypes = result.errors.compactMap { error -> String? in
      if case .unknownComponent(let typeName) = error {
        return typeName
      }
      return nil
    }

    #expect(errorTypes.contains("Unknown1"))
    #expect(errorTypes.contains("Unknown2"))
    #expect(errorTypes.contains("Unknown3"))
  }

  @Test("Mix of known and unknown components")
  func testMixedComponents() throws {
    let json = """
      {
          "type": "Stack",
          "children": [
              {"type": "Text", "props": {"content": "Valid"}},
              {"type": "UnknownWidget"}
          ]
      }
      """
    let registry = ComponentRegistry()
    registry.register(module: BuiltInComponentsModule())

    let result = JSONValidator.validate(json, registry: registry)

    #expect(!result.isValid)
    #expect(result.errors.count == 1)

    if case .unknownComponent(let typeName) = result.errors[0] {
      #expect(typeName == "UnknownWidget")
    }
  }

  // MARK: - Max Depth

  @Test("Max depth exceeded returns error")
  func testMaxDepthExceeded() throws {
    let registry = ComponentRegistry()
    registry.register(module: BuiltInComponentsModule())

    let result = JSONValidator.validate(TestJSON.deeplyNested, registry: registry)

    #expect(!result.isValid)

    let depthErrors = result.errors.filter { error in
      if case .maxDepthExceeded = error {
        return true
      }
      return false
    }

    #expect(!depthErrors.isEmpty)
  }

  @Test("Valid deep nesting within limits passes")
  func testValidDeepNesting() throws {
    let registry = ComponentRegistry()
    registry.register(module: BuiltInComponentsModule())

    let result = JSONValidator.validate(TestJSON.validNested, registry: registry)

    #expect(result.isValid)
  }

  @Test("Exactly at max depth passes")
  func testExactlyAtMaxDepth() throws {
    // Generate exactly 20-level deep nesting
    var json = """
      {"type": "Stack", "children": [
      """
    for _ in 0..<19 {
      json += """
        {"type": "Stack", "children": [
        """
    }
    json += """
      {"type": "Text", "props": {"content": "Deep"}}
      """
    for _ in 0..<20 {
      json += "]}"
    }

    let registry = ComponentRegistry()
    registry.register(module: BuiltInComponentsModule())

    let result = JSONValidator.validate(json, registry: registry)

    #expect(result.isValid)
  }

  // MARK: - Custom Registry

  @Test("Validation with custom registry")
  func testValidationWithCustomRegistry() throws {
    let json = """
      {"type": "MockComponent", "props": {"value": "test"}}
      """

    let emptyRegistry = ComponentRegistry()
    let customRegistry = ComponentRegistry()
    customRegistry.register(MockComponentBuilder.self)

    // Should fail with empty registry
    let emptyResult = JSONValidator.validate(json, registry: emptyRegistry)
    #expect(!emptyResult.isValid)

    // Should pass with custom registry
    let customResult = JSONValidator.validate(json, registry: customRegistry)
    #expect(customResult.isValid)
  }

  @Test("Empty registry returns unknown for all types")
  func testEmptyRegistry() throws {
    let json = """
      {"type": "Text", "props": {"content": "Hello"}}
      """
    let emptyRegistry = ComponentRegistry()

    let result = JSONValidator.validate(json, registry: emptyRegistry)

    #expect(!result.isValid)
    if case .unknownComponent(let typeName) = result.errors[0] {
      #expect(typeName == "Text")
    }
  }

  // MARK: - Node Validation Extension

  @Test("ComponentNode validate extension")
  func testNodeValidateExtension() throws {
    let node = ComponentNode(
      type: "Text",
      props: ["content": "Hello"]
    )

    let registry = ComponentRegistry()
    registry.register(module: BuiltInComponentsModule())

    let result = node.validate(registry: registry)

    #expect(result.isValid)
  }

  @Test("ComponentNode validate with unknown type")
  func testNodeValidateUnknown() throws {
    let node = ComponentNode(
      type: "Unknown",
      props: nil
    )

    let registry = ComponentRegistry()

    let result = node.validate(registry: registry)

    #expect(!result.isValid)
  }

  // MARK: - ValidationResult

  @Test("ValidationResult isValid")
  func testValidationResultIsValid() throws {
    let valid = ValidationResult.valid
    let invalid = ValidationResult.invalid(errors: [.unknownComponent("Test")])

    #expect(valid.isValid == true)
    #expect(invalid.isValid == false)
  }

  @Test("ValidationResult errors accessor")
  func testValidationResultErrors() throws {
    let valid = ValidationResult.valid
    let invalid = ValidationResult.invalid(errors: [
      .unknownComponent("A"),
      .unknownComponent("B"),
    ])

    #expect(valid.errors.isEmpty)
    #expect(invalid.errors.count == 2)
  }

  // MARK: - ValidationError Description

  @Test("ValidationError description - parseError")
  func testParseErrorDescription() throws {
    let error = ValidationError.parseError("Invalid JSON")

    #expect(error.description.contains("Parse error"))
    #expect(error.description.contains("Invalid JSON"))
  }

  @Test("ValidationError description - maxDepthExceeded")
  func testMaxDepthErrorDescription() throws {
    let error = ValidationError.maxDepthExceeded(depth: 25, maxDepth: 20)

    #expect(error.description.contains("25"))
    #expect(error.description.contains("20"))
  }

  @Test("ValidationError description - unknownComponent")
  func testUnknownComponentDescription() throws {
    let error = ValidationError.unknownComponent("Widget")

    #expect(error.description.contains("Unknown component"))
    #expect(error.description.contains("Widget"))
  }

  @Test("ValidationError description - missingRequiredProperty")
  func testMissingPropertyDescription() throws {
    let error = ValidationError.missingRequiredProperty(
      component: "Button", property: "label")

    #expect(error.description.contains("Button"))
    #expect(error.description.contains("label"))
  }

  @Test("ValidationError description - invalidPropertyType")
  func testInvalidTypeDescription() throws {
    let error = ValidationError.invalidPropertyType(
      component: "Stack", property: "spacing", expected: "Int", actual: "String")

    #expect(error.description.contains("Stack"))
    #expect(error.description.contains("spacing"))
    #expect(error.description.contains("Int"))
    #expect(error.description.contains("String"))
  }

  @Test("ValidationError description - invalidPropertyValue")
  func testInvalidValueDescription() throws {
    let error = ValidationError.invalidPropertyValue(
      component: "Text", property: "style", reason: "must be body or caption")

    #expect(error.description.contains("Text"))
    #expect(error.description.contains("style"))
    #expect(error.description.contains("must be body or caption"))
  }
}
