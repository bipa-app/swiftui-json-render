import Foundation

/// A type-erased `Codable` value that can hold any JSON-compatible type.
///
/// Use `AnyCodable` when you need to decode or encode JSON with dynamic or unknown types,
/// such as the `props` dictionary in component nodes.
public struct AnyCodable: Codable, Sendable, Equatable {
  public let value: Any

  public init(_ value: Any) {
    self.value = value
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()

    if container.decodeNil() {
      self.value = NSNull()
    } else if let bool = try? container.decode(Bool.self) {
      self.value = bool
    } else if let int = try? container.decode(Int.self) {
      self.value = int
    } else if let double = try? container.decode(Double.self) {
      self.value = double
    } else if let string = try? container.decode(String.self) {
      self.value = string
    } else if let array = try? container.decode([AnyCodable].self) {
      self.value = array.map { $0.value }
    } else if let dictionary = try? container.decode([String: AnyCodable].self) {
      self.value = dictionary.mapValues { $0.value }
    } else {
      throw DecodingError.dataCorruptedError(
        in: container,
        debugDescription: "Unable to decode AnyCodable value"
      )
    }
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()

    switch value {
    case is NSNull:
      try container.encodeNil()
    case let bool as Bool:
      try container.encode(bool)
    case let int as Int:
      try container.encode(int)
    case let double as Double:
      try container.encode(double)
    case let string as String:
      try container.encode(string)
    case let array as [Any]:
      try container.encode(array.map { AnyCodable($0) })
    case let dictionary as [String: Any]:
      try container.encode(dictionary.mapValues { AnyCodable($0) })
    default:
      throw EncodingError.invalidValue(
        value,
        EncodingError.Context(
          codingPath: container.codingPath,
          debugDescription: "Unable to encode AnyCodable value"
        )
      )
    }
  }

  public static func == (lhs: AnyCodable, rhs: AnyCodable) -> Bool {
    switch (lhs.value, rhs.value) {
    case is (NSNull, NSNull):
      return true
    case (let lhs as Bool, let rhs as Bool):
      return lhs == rhs
    case (let lhs as Int, let rhs as Int):
      return lhs == rhs
    case (let lhs as Double, let rhs as Double):
      return lhs == rhs
    case (let lhs as String, let rhs as String):
      return lhs == rhs
    case (let lhs as [Any], let rhs as [Any]):
      return lhs.map { AnyCodable($0) } == rhs.map { AnyCodable($0) }
    case (let lhs as [String: Any], let rhs as [String: Any]):
      return lhs.mapValues { AnyCodable($0) } == rhs.mapValues { AnyCodable($0) }
    default:
      return false
    }
  }
}

// MARK: - Convenience Accessors

extension AnyCodable {
  /// Returns the value as a `String`, or `nil` if it cannot be converted.
  public var stringValue: String? {
    value as? String
  }

  /// Returns the value as an `Int`, or `nil` if it cannot be converted.
  public var intValue: Int? {
    if let int = value as? Int {
      return int
    }
    if let double = value as? Double {
      return Int(double)
    }
    return nil
  }

  /// Returns the value as a `Double`, or `nil` if it cannot be converted.
  public var doubleValue: Double? {
    if let double = value as? Double {
      return double
    }
    if let int = value as? Int {
      return Double(int)
    }
    return nil
  }

  /// Returns the value as a `Bool`, or `nil` if it cannot be converted.
  public var boolValue: Bool? {
    value as? Bool
  }

  /// Returns the value as an array, or `nil` if it cannot be converted.
  public var arrayValue: [Any]? {
    value as? [Any]
  }

  /// Returns the value as a dictionary, or `nil` if it cannot be converted.
  public var dictionaryValue: [String: Any]? {
    value as? [String: Any]
  }

  /// Returns the value as an array of `AnyCodable`, or `nil` if it cannot be converted.
  public var anyCodableArray: [AnyCodable]? {
    guard let array = value as? [Any] else { return nil }
    return array.map { AnyCodable($0) }
  }

  /// Returns the value as a dictionary of `AnyCodable`, or `nil` if it cannot be converted.
  public var anyCodableDictionary: [String: AnyCodable]? {
    guard let dict = value as? [String: Any] else { return nil }
    return dict.mapValues { AnyCodable($0) }
  }
}

// MARK: - ExpressibleBy Literals

extension AnyCodable: ExpressibleByNilLiteral {
  public init(nilLiteral: ()) {
    self.value = NSNull()
  }
}

extension AnyCodable: ExpressibleByBooleanLiteral {
  public init(booleanLiteral value: Bool) {
    self.value = value
  }
}

extension AnyCodable: ExpressibleByIntegerLiteral {
  public init(integerLiteral value: Int) {
    self.value = value
  }
}

extension AnyCodable: ExpressibleByFloatLiteral {
  public init(floatLiteral value: Double) {
    self.value = value
  }
}

extension AnyCodable: ExpressibleByStringLiteral {
  public init(stringLiteral value: String) {
    self.value = value
  }
}

extension AnyCodable: ExpressibleByArrayLiteral {
  public init(arrayLiteral elements: Any...) {
    self.value = elements
  }
}

extension AnyCodable: ExpressibleByDictionaryLiteral {
  public init(dictionaryLiteral elements: (String, Any)...) {
    self.value = Dictionary(uniqueKeysWithValues: elements)
  }
}
