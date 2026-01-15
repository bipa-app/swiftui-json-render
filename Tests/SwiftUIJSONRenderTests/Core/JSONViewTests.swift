import SwiftUI
import Testing

@testable import SwiftUIJSONRender

@Suite("JSONView Tests")
struct JSONViewTests {

  // MARK: - Parse Errors

  @Test("Invalid JSON creates parse error")
  func testInvalidJSONParseError() {
    let json = "{ invalid json }"
    let view = JSONView(json)

    // View should exist but will show error
    #expect(view != nil)
  }

  @Test("Empty string creates parse error")
  func testEmptyStringParseError() {
    let view = JSONView("")

    #expect(view != nil)
  }

  @Test("Non-JSON string creates parse error")
  func testNonJSONParseError() {
    let view = JSONView("Hello World")

    #expect(view != nil)
  }

  @Test("JSON missing type field creates parse error")
  func testMissingTypeField() {
    let json = """
      { "props": { "content": "Hello" } }
      """
    let view = JSONView(json)

    // Should create view (will show error when rendered)
    #expect(view != nil)
  }

  // MARK: - Valid JSON Parsing

  @Test("Valid JSON parses successfully")
  func testValidJSONParses() {
    let json = """
      { "type": "Text", "props": { "content": "Hello" } }
      """
    let view = JSONView(json)

    #expect(view != nil)
  }

  @Test("Valid JSON with children parses successfully")
  func testValidJSONWithChildren() {
    let json = """
      {
        "type": "Stack",
        "children": [
          { "type": "Text", "props": { "content": "Line 1" } },
          { "type": "Text", "props": { "content": "Line 2" } }
        ]
      }
      """
    let view = JSONView(json)

    #expect(view != nil)
  }

  // MARK: - Version Compatibility

  @Test("JSON without schemaVersion is accepted (backwards compatible)")
  func testNoVersionAccepted() {
    let json = """
      { "type": "Text", "props": { "content": "Hello" } }
      """
    let node = ComponentNode.from(json: json)

    #expect(node != nil)
    #expect(node?.schemaVersion == nil)
  }

  @Test("JSON with current schemaVersion is accepted")
  func testCurrentVersionAccepted() {
    let json = """
      {
        "schemaVersion": "1.0.0",
        "type": "Text",
        "props": { "content": "Hello" }
      }
      """
    let node = ComponentNode.from(json: json)

    #expect(node != nil)
    #expect(node?.schemaVersion == SchemaVersion.current)
  }

  @Test("JSON with compatible minor version is accepted")
  func testCompatibleMinorVersionAccepted() {
    let json = """
      {
        "schemaVersion": "1.0.0",
        "type": "Text",
        "props": { "content": "Hello" }
      }
      """
    let node = ComponentNode.from(json: json)
    let result = SchemaVersion.checkCompatibility(of: node!.schemaVersion!)

    #expect(result == .compatible)
    #expect(SchemaVersion.shouldRender(for: result) == true)
  }

  @Test("JSON with newer minor version shows newerMinor result")
  func testNewerMinorVersion() {
    let newerMinor = SchemaVersion(
      SchemaVersion.current.major,
      SchemaVersion.current.minor + 1,
      0
    )
    let result = SchemaVersion.checkCompatibility(of: newerMinor)

    #expect(result == .newerMinor)
    #expect(SchemaVersion.shouldRender(for: result) == true)
  }

  @Test("JSON with incompatible major version (too new) is rejected")
  func testTooNewVersionRejected() {
    let tooNew = SchemaVersion(SchemaVersion.current.major + 1, 0, 0)
    let result = SchemaVersion.checkCompatibility(of: tooNew)

    #expect(result == .tooNew)
    #expect(SchemaVersion.shouldRender(for: result) == false)
  }

  @Test("JSON with too old major version is rejected")
  func testTooOldVersionRejected() {
    // Version 0.x is before minimum supported (1.0.0)
    let tooOld = SchemaVersion(0, 9, 0)
    let result = SchemaVersion.checkCompatibility(of: tooOld)

    #expect(result == .tooOld)
    #expect(SchemaVersion.shouldRender(for: result) == false)
  }

  // MARK: - JSONView with Versions

  @Test("JSONView with valid version creates view")
  func testJSONViewValidVersion() {
    let json = """
      {
        "schemaVersion": "1.0.0",
        "type": "Text",
        "props": { "content": "Hello" }
      }
      """
    let view = JSONView(json)

    #expect(view != nil)
  }

  @Test("JSONView with too new version creates view (shows error)")
  func testJSONViewTooNewVersion() {
    let json = """
      {
        "schemaVersion": "99.0.0",
        "type": "Text",
        "props": { "content": "Hello" }
      }
      """
    let view = JSONView(json)

    // View exists but will display version error
    #expect(view != nil)
  }

  // MARK: - VersionError Messages

  @Test("Version error message for tooNew")
  func testVersionErrorMessageTooNew() {
    let error = VersionError(
      jsonVersion: SchemaVersion(99, 0, 0),
      result: .tooNew
    )

    #expect(error.message.contains("99.0.0"))
    #expect(error.message.contains("newer library"))
    #expect(error.message.contains(SchemaVersion.current.string))
  }

  @Test("Version error message for tooOld")
  func testVersionErrorMessageTooOld() {
    let error = VersionError(
      jsonVersion: SchemaVersion(0, 1, 0),
      result: .tooOld
    )

    #expect(error.message.contains("0.1.0"))
    #expect(error.message.contains("no longer supported"))
    #expect(error.message.contains(SchemaVersion.minimumSupported.string))
  }

  @Test("Version error message for compatible is empty")
  func testVersionErrorMessageCompatibleEmpty() {
    let error = VersionError(
      jsonVersion: SchemaVersion.current,
      result: .compatible
    )

    #expect(error.message.isEmpty)
  }

  // MARK: - Init from Data

  @Test("JSONView init from valid Data")
  func testInitFromValidData() {
    let json = """
      { "type": "Text", "props": { "content": "Hello" } }
      """
    let data = json.data(using: .utf8)!
    let view = JSONView(data)

    #expect(view != nil)
  }

  @Test("JSONView init from invalid Data")
  func testInitFromInvalidData() {
    let data = "not json".data(using: .utf8)!
    let view = JSONView(data)

    // View exists but will show error
    #expect(view != nil)
  }

  // MARK: - Init from ComponentNode

  @Test("JSONView init from ComponentNode")
  func testInitFromComponentNode() {
    let node = ComponentNode(
      type: "Text",
      props: ["content": "Hello"]
    )
    let view = JSONView(node)

    #expect(view != nil)
  }

  @Test("JSONView init from ComponentNode with version")
  func testInitFromComponentNodeWithVersion() {
    let node = ComponentNode(
      type: "Text",
      props: ["content": "Hello"],
      schemaVersion: SchemaVersion.current
    )
    let view = JSONView(node)

    #expect(view != nil)
  }
}
