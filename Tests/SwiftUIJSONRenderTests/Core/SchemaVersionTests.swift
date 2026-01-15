import Foundation
import Testing

@testable import SwiftUIJSONRender

@Suite("SchemaVersion Tests")
struct SchemaVersionTests {

  // MARK: - Initialization

  @Test("Initialize with components")
  func testInitWithComponents() throws {
    let version = SchemaVersion(1, 2, 3)

    #expect(version.major == 1)
    #expect(version.minor == 2)
    #expect(version.patch == 3)
  }

  @Test("Initialize from valid string")
  func testInitFromValidString() throws {
    let version = SchemaVersion(string: "1.2.3")

    #expect(version != nil)
    #expect(version?.major == 1)
    #expect(version?.minor == 2)
    #expect(version?.patch == 3)
  }

  @Test("Initialize from string without patch")
  func testInitFromStringWithoutPatch() throws {
    let version = SchemaVersion(string: "2.5")

    #expect(version != nil)
    #expect(version?.major == 2)
    #expect(version?.minor == 5)
    #expect(version?.patch == 0)
  }

  @Test("Initialize from invalid string returns nil")
  func testInitFromInvalidString() throws {
    #expect(SchemaVersion(string: "invalid") == nil)
    #expect(SchemaVersion(string: "1") == nil)
    #expect(SchemaVersion(string: "") == nil)
    #expect(SchemaVersion(string: "a.b.c") == nil)
  }

  // MARK: - String Representation

  @Test("String representation")
  func testStringRepresentation() throws {
    let version = SchemaVersion(1, 2, 3)

    #expect(version.string == "1.2.3")
    #expect(version.description == "1.2.3")
  }

  // MARK: - Comparison

  @Test("Version comparison - less than")
  func testComparisonLessThan() throws {
    #expect(SchemaVersion(1, 0, 0) < SchemaVersion(2, 0, 0))
    #expect(SchemaVersion(1, 0, 0) < SchemaVersion(1, 1, 0))
    #expect(SchemaVersion(1, 0, 0) < SchemaVersion(1, 0, 1))
    #expect(SchemaVersion(1, 2, 3) < SchemaVersion(1, 2, 4))
  }

  @Test("Version comparison - greater than")
  func testComparisonGreaterThan() throws {
    #expect(SchemaVersion(2, 0, 0) > SchemaVersion(1, 0, 0))
    #expect(SchemaVersion(1, 1, 0) > SchemaVersion(1, 0, 0))
    #expect(SchemaVersion(1, 0, 1) > SchemaVersion(1, 0, 0))
  }

  @Test("Version comparison - equality")
  func testComparisonEquality() throws {
    #expect(SchemaVersion(1, 2, 3) == SchemaVersion(1, 2, 3))
    #expect(SchemaVersion(1, 0, 0) != SchemaVersion(2, 0, 0))
  }

  // MARK: - Compatibility Checking

  @Test("Compatible version - same version")
  func testCompatibleSameVersion() throws {
    let result = SchemaVersion.checkCompatibility(of: SchemaVersion.current)

    #expect(result == .compatible)
    #expect(SchemaVersion.shouldRender(for: result) == true)
  }

  @Test("Compatible version - older minor")
  func testCompatibleOlderMinor() throws {
    // Assuming current is 1.0.0, an older minor version should be compatible
    let olderMinor = SchemaVersion(
      SchemaVersion.current.major,
      0,
      0
    )
    let result = SchemaVersion.checkCompatibility(of: olderMinor)

    #expect(result == .compatible)
    #expect(SchemaVersion.shouldRender(for: result) == true)
  }

  @Test("Newer minor version")
  func testNewerMinorVersion() throws {
    let newerMinor = SchemaVersion(
      SchemaVersion.current.major,
      SchemaVersion.current.minor + 1,
      0
    )
    let result = SchemaVersion.checkCompatibility(of: newerMinor)

    #expect(result == .newerMinor)
    #expect(SchemaVersion.shouldRender(for: result) == true)
  }

  @Test("Too new major version")
  func testTooNewMajorVersion() throws {
    let tooNew = SchemaVersion(SchemaVersion.current.major + 1, 0, 0)
    let result = SchemaVersion.checkCompatibility(of: tooNew)

    #expect(result == .tooNew)
    #expect(SchemaVersion.shouldRender(for: result) == false)
  }

  @Test("Too old version")
  func testTooOldVersion() throws {
    // Create a version older than minimum supported
    let tooOld = SchemaVersion(0, 1, 0)
    let result = SchemaVersion.checkCompatibility(of: tooOld)

    // Should be tooOld if it's below minimumSupported
    if tooOld < SchemaVersion.minimumSupported {
      #expect(result == .tooOld)
      #expect(SchemaVersion.shouldRender(for: result) == false)
    }
  }

  // MARK: - Codable

  @Test("Encode and decode version")
  func testCodable() throws {
    let version = SchemaVersion(1, 2, 3)
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()

    let data = try encoder.encode(version)
    let decoded = try decoder.decode(SchemaVersion.self, from: data)

    #expect(decoded == version)
  }

  @Test("Decode from JSON string")
  func testDecodeFromJSONString() throws {
    let json = "\"1.2.3\""
    let data = json.data(using: .utf8)!
    let decoder = JSONDecoder()

    let version = try decoder.decode(SchemaVersion.self, from: data)

    #expect(version == SchemaVersion(1, 2, 3))
  }

  @Test("Decode invalid version string throws")
  func testDecodeInvalidThrows() throws {
    let json = "\"invalid\""
    let data = json.data(using: .utf8)!
    let decoder = JSONDecoder()

    #expect(throws: DecodingError.self) {
      _ = try decoder.decode(SchemaVersion.self, from: data)
    }
  }

  // MARK: - Hashable

  @Test("Version is hashable")
  func testHashable() throws {
    let version1 = SchemaVersion(1, 0, 0)
    let version2 = SchemaVersion(1, 0, 0)

    var set = Set<SchemaVersion>()
    set.insert(version1)
    set.insert(version2)

    #expect(set.count == 1)
  }
}
