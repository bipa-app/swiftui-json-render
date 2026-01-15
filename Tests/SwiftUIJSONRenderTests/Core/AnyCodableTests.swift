import Foundation
import Testing

@testable import SwiftUIJSONRender

@Suite("AnyCodable Tests")
struct AnyCodableTests {

  // MARK: - Decoding

  @Test("Decode null value")
  func testDecodeNull() throws {
    let json = """
      {"value": null}
      """
    let data = json.data(using: .utf8)!

    struct Container: Codable {
      let value: AnyCodable
    }

    let container = try JSONDecoder().decode(Container.self, from: data)

    #expect(container.value.value is NSNull)
  }

  @Test("Decode bool values")
  func testDecodeBool() throws {
    let jsonTrue = """
      {"value": true}
      """
    let jsonFalse = """
      {"value": false}
      """

    struct Container: Codable {
      let value: AnyCodable
    }

    let trueContainer = try JSONDecoder().decode(
      Container.self, from: jsonTrue.data(using: .utf8)!)
    let falseContainer = try JSONDecoder().decode(
      Container.self, from: jsonFalse.data(using: .utf8)!)

    #expect(trueContainer.value.boolValue == true)
    #expect(falseContainer.value.boolValue == false)
  }

  @Test("Decode int value")
  func testDecodeInt() throws {
    let json = """
      {"value": 42}
      """
    let data = json.data(using: .utf8)!

    struct Container: Codable {
      let value: AnyCodable
    }

    let container = try JSONDecoder().decode(Container.self, from: data)

    #expect(container.value.intValue == 42)
  }

  @Test("Decode double value")
  func testDecodeDouble() throws {
    let json = """
      {"value": 3.14159}
      """
    let data = json.data(using: .utf8)!

    struct Container: Codable {
      let value: AnyCodable
    }

    let container = try JSONDecoder().decode(Container.self, from: data)

    #expect(container.value.doubleValue == 3.14159)
  }

  @Test("Decode string value")
  func testDecodeString() throws {
    let json = """
      {"value": "Hello, World!"}
      """
    let data = json.data(using: .utf8)!

    struct Container: Codable {
      let value: AnyCodable
    }

    let container = try JSONDecoder().decode(Container.self, from: data)

    #expect(container.value.stringValue == "Hello, World!")
  }

  @Test("Decode array of mixed types")
  func testDecodeArray() throws {
    let json = """
      {"value": [1, "two", true, 3.14]}
      """
    let data = json.data(using: .utf8)!

    struct Container: Codable {
      let value: AnyCodable
    }

    let container = try JSONDecoder().decode(Container.self, from: data)
    let array = container.value.arrayValue

    #expect(array != nil)
    #expect(array?.count == 4)
    #expect(array?[0] as? Int == 1)
    #expect(array?[1] as? String == "two")
    #expect(array?[2] as? Bool == true)
  }

  @Test("Decode nested dictionary")
  func testDecodeDictionary() throws {
    let json = """
      {"value": {"name": "John", "age": 30, "active": true}}
      """
    let data = json.data(using: .utf8)!

    struct Container: Codable {
      let value: AnyCodable
    }

    let container = try JSONDecoder().decode(Container.self, from: data)
    let dict = container.value.dictionaryValue

    #expect(dict != nil)
    #expect(dict?["name"] as? String == "John")
    #expect(dict?["age"] as? Int == 30)
    #expect(dict?["active"] as? Bool == true)
  }

  // MARK: - Type Coercion

  @Test("Int value from double (truncates)")
  func testIntToDoubleCoercion() throws {
    let anyCodable = AnyCodable(3.7)

    #expect(anyCodable.intValue == 3)
  }

  @Test("Double value from int (promotes)")
  func testDoubleToIntCoercion() throws {
    let anyCodable = AnyCodable(42)

    #expect(anyCodable.doubleValue == 42.0)
  }

  @Test("String value returns nil for non-string")
  func testStringValueForNonString() throws {
    let anyCodable = AnyCodable(42)

    #expect(anyCodable.stringValue == nil)
  }

  @Test("Bool value returns nil for non-bool")
  func testBoolValueForNonBool() throws {
    let anyCodable = AnyCodable("true")

    #expect(anyCodable.boolValue == nil)
  }

  // MARK: - Equatable

  @Test("Equal values are equal")
  func testEquatable() throws {
    let a = AnyCodable("hello")
    let b = AnyCodable("hello")
    let c = AnyCodable("world")

    #expect(a == b)
    #expect(a != c)
  }

  @Test("Equal ints are equal")
  func testEquatableInts() throws {
    let a = AnyCodable(42)
    let b = AnyCodable(42)
    let c = AnyCodable(43)

    #expect(a == b)
    #expect(a != c)
  }

  @Test("Equal bools are equal")
  func testEquatableBools() throws {
    let a = AnyCodable(true)
    let b = AnyCodable(true)
    let c = AnyCodable(false)

    #expect(a == b)
    #expect(a != c)
  }

  @Test("Equal arrays are equal")
  func testEquatableArrays() throws {
    let a = AnyCodable([1, 2, 3])
    let b = AnyCodable([1, 2, 3])
    let c = AnyCodable([1, 2, 4])

    #expect(a == b)
    #expect(a != c)
  }

  @Test("Equal dictionaries are equal")
  func testEquatableDictionaries() throws {
    let a = AnyCodable(["key": "value"])
    let b = AnyCodable(["key": "value"])
    let c = AnyCodable(["key": "other"])

    #expect(a == b)
    #expect(a != c)
  }

  @Test("Different types are not equal")
  func testNotEqualDifferentTypes() throws {
    let string = AnyCodable("42")
    let int = AnyCodable(42)

    #expect(string != int)
  }

  // MARK: - Encoding

  @Test("Round-trip encode/decode preserves string")
  func testEncodeDecodeString() throws {
    let original = AnyCodable("hello")
    let data = try JSONEncoder().encode(original)
    let decoded = try JSONDecoder().decode(AnyCodable.self, from: data)

    #expect(decoded.stringValue == "hello")
  }

  @Test("Round-trip encode/decode preserves int")
  func testEncodeDecodeInt() throws {
    let original = AnyCodable(42)
    let data = try JSONEncoder().encode(original)
    let decoded = try JSONDecoder().decode(AnyCodable.self, from: data)

    #expect(decoded.intValue == 42)
  }

  @Test("Round-trip encode/decode preserves array")
  func testEncodeDecodeArray() throws {
    let original = AnyCodable([1, 2, 3])
    let data = try JSONEncoder().encode(original)
    let decoded = try JSONDecoder().decode(AnyCodable.self, from: data)

    let array = decoded.arrayValue
    #expect(array?.count == 3)
  }

  @Test("Round-trip encode/decode preserves dictionary")
  func testEncodeDecodeDictionary() throws {
    let original = AnyCodable(["name": "John", "age": 30])
    let data = try JSONEncoder().encode(original)
    let decoded = try JSONDecoder().decode(AnyCodable.self, from: data)

    let dict = decoded.dictionaryValue
    #expect(dict?["name"] as? String == "John")
    #expect(dict?["age"] as? Int == 30)
  }

  // MARK: - Literal Expressible

  @Test("ExpressibleByNilLiteral")
  func testNilLiteral() throws {
    let value: AnyCodable = nil

    #expect(value.value is NSNull)
  }

  @Test("ExpressibleByBooleanLiteral")
  func testBoolLiteral() throws {
    let value: AnyCodable = true

    #expect(value.boolValue == true)
  }

  @Test("ExpressibleByIntegerLiteral")
  func testIntLiteral() throws {
    let value: AnyCodable = 42

    #expect(value.intValue == 42)
  }

  @Test("ExpressibleByFloatLiteral")
  func testFloatLiteral() throws {
    let value: AnyCodable = 3.14

    #expect(value.doubleValue == 3.14)
  }

  @Test("ExpressibleByStringLiteral")
  func testStringLiteral() throws {
    let value: AnyCodable = "hello"

    #expect(value.stringValue == "hello")
  }

  @Test("ExpressibleByArrayLiteral")
  func testArrayLiteral() throws {
    let value: AnyCodable = [1, 2, 3]

    #expect(value.arrayValue?.count == 3)
  }

  @Test("ExpressibleByDictionaryLiteral")
  func testDictionaryLiteral() throws {
    let value: AnyCodable = ["key": "value"]

    #expect(value.dictionaryValue?["key"] as? String == "value")
  }

  // MARK: - AnyCodable Array/Dictionary Accessors

  @Test("anyCodableArray accessor")
  func testAnyCodableArray() throws {
    let value = AnyCodable([1, "two", true])
    let array = value.anyCodableArray

    #expect(array != nil)
    #expect(array?.count == 3)
    #expect(array?[0].intValue == 1)
    #expect(array?[1].stringValue == "two")
    #expect(array?[2].boolValue == true)
  }

  @Test("anyCodableDictionary accessor")
  func testAnyCodableDictionary() throws {
    let value = AnyCodable(["name": "John", "count": 5])
    let dict = value.anyCodableDictionary

    #expect(dict != nil)
    #expect(dict?["name"]?.stringValue == "John")
    #expect(dict?["count"]?.intValue == 5)
  }
}
