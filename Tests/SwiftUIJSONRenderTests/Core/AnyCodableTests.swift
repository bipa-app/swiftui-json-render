import Testing

@testable import SwiftUIJSONRender

@Suite("AnyCodable Tests")
struct AnyCodableTests {

  @Test("Decodes string values")
  func decodesStringValues() throws {
    let json = #"{"value": "hello"}"#
    let data = json.data(using: .utf8)!
    let decoded = try JSONDecoder().decode([String: AnyCodable].self, from: data)

    #expect(decoded["value"]?.stringValue == "hello")
  }

  @Test("Decodes integer values")
  func decodesIntegerValues() throws {
    let json = #"{"value": 42}"#
    let data = json.data(using: .utf8)!
    let decoded = try JSONDecoder().decode([String: AnyCodable].self, from: data)

    #expect(decoded["value"]?.intValue == 42)
  }

  @Test("Decodes double values")
  func decodesDoubleValues() throws {
    let json = #"{"value": 3.14}"#
    let data = json.data(using: .utf8)!
    let decoded = try JSONDecoder().decode([String: AnyCodable].self, from: data)

    #expect(decoded["value"]?.doubleValue == 3.14)
  }

  @Test("Decodes boolean values")
  func decodesBooleanValues() throws {
    let json = #"{"value": true}"#
    let data = json.data(using: .utf8)!
    let decoded = try JSONDecoder().decode([String: AnyCodable].self, from: data)

    #expect(decoded["value"]?.boolValue == true)
  }

  @Test("Decodes array values")
  func decodesArrayValues() throws {
    let json = #"{"value": [1, 2, 3]}"#
    let data = json.data(using: .utf8)!
    let decoded = try JSONDecoder().decode([String: AnyCodable].self, from: data)

    let array = decoded["value"]?.arrayValue as? [Int]
    #expect(array == [1, 2, 3])
  }

  @Test("Decodes nested dictionary values")
  func decodesNestedDictionary() throws {
    let json = #"{"outer": {"inner": "value"}}"#
    let data = json.data(using: .utf8)!
    let decoded = try JSONDecoder().decode([String: AnyCodable].self, from: data)

    let nested = decoded["outer"]?.dictionaryValue
    #expect(nested?["inner"] as? String == "value")
  }

  @Test("Decodes null values")
  func decodesNullValues() throws {
    let json = #"{"value": null}"#
    let data = json.data(using: .utf8)!
    let decoded = try JSONDecoder().decode([String: AnyCodable].self, from: data)

    #expect(decoded["value"]?.stringValue == nil)
    #expect(decoded["value"]?.intValue == nil)
  }

  @Test("Encodes and decodes round trip")
  func encodesAndDecodesRoundTrip() throws {
    let original: [String: AnyCodable] = [
      "string": "hello",
      "int": 42,
      "double": 3.14,
      "bool": true,
      "array": [1, 2, 3],
      "nested": ["key": "value"],
    ]

    let data = try JSONEncoder().encode(original)
    let decoded = try JSONDecoder().decode([String: AnyCodable].self, from: data)

    #expect(decoded["string"]?.stringValue == "hello")
    #expect(decoded["int"]?.intValue == 42)
    #expect(decoded["bool"]?.boolValue == true)
  }

  @Test("Equality check works")
  func equalityWorks() {
    let a: AnyCodable = "hello"
    let b: AnyCodable = "hello"
    let c: AnyCodable = "world"

    #expect(a == b)
    #expect(a != c)
  }

  @Test("Literal initialization works")
  func literalInitialization() {
    let string: AnyCodable = "test"
    let int: AnyCodable = 42
    let double: AnyCodable = 3.14
    let bool: AnyCodable = true
    let array: AnyCodable = [1, 2, 3]
    let dict: AnyCodable = ["key": "value"]

    #expect(string.stringValue == "test")
    #expect(int.intValue == 42)
    #expect(double.doubleValue == 3.14)
    #expect(bool.boolValue == true)
    #expect(array.arrayValue != nil)
    #expect(dict.dictionaryValue != nil)
  }
}
