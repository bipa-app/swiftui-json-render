import Foundation

/// Represents a node in the component tree parsed from JSON.
///
/// A `ComponentNode` describes a UI component with its type, properties, and optional children.
/// This is the primary data structure used for JSON-to-SwiftUI rendering.
///
/// ## Example JSON
/// ```json
/// {
///   "type": "Stack",
///   "props": { "direction": "vertical", "spacing": 16 },
///   "children": [
///     { "type": "Text", "props": { "content": "Hello" } }
///   ]
/// }
/// ```
public struct ComponentNode: Codable, Sendable, Equatable {
  /// The component type identifier (e.g., "Stack", "Text", "Button").
  public let type: String

  /// Optional properties for the component.
  public let props: [String: AnyCodable]?

  /// Optional child components.
  public let children: [ComponentNode]?

  /// Creates a new component node.
  /// - Parameters:
  ///   - type: The component type identifier.
  ///   - props: Optional properties dictionary.
  ///   - children: Optional array of child nodes.
  public init(
    type: String,
    props: [String: AnyCodable]? = nil,
    children: [ComponentNode]? = nil
  ) {
    self.type = type
    self.props = props
    self.children = children
  }
}

// MARK: - Convenience Initializers

extension ComponentNode {
  /// Creates a `ComponentNode` from a JSON string.
  /// - Parameter json: A JSON string representing a component node.
  /// - Returns: A decoded `ComponentNode`, or `nil` if parsing fails.
  public static func from(json: String) -> ComponentNode? {
    guard let data = json.data(using: .utf8) else { return nil }
    return try? JSONDecoder().decode(ComponentNode.self, from: data)
  }

  /// Creates a `ComponentNode` from JSON data.
  /// - Parameter data: JSON data representing a component node.
  /// - Returns: A decoded `ComponentNode`, or `nil` if parsing fails.
  public static func from(data: Data) -> ComponentNode? {
    try? JSONDecoder().decode(ComponentNode.self, from: data)
  }
}

// MARK: - Property Accessors

extension ComponentNode {
  /// Retrieves a string property by key.
  /// - Parameter key: The property key.
  /// - Returns: The string value, or `nil` if not found or not a string.
  public func string(_ key: String) -> String? {
    props?[key]?.stringValue
  }

  /// Retrieves an integer property by key.
  /// - Parameter key: The property key.
  /// - Returns: The integer value, or `nil` if not found or not an integer.
  public func int(_ key: String) -> Int? {
    props?[key]?.intValue
  }

  /// Retrieves a double property by key.
  /// - Parameter key: The property key.
  /// - Returns: The double value, or `nil` if not found or not a double.
  public func double(_ key: String) -> Double? {
    props?[key]?.doubleValue
  }

  /// Retrieves a boolean property by key.
  /// - Parameter key: The property key.
  /// - Returns: The boolean value, or `nil` if not found or not a boolean.
  public func bool(_ key: String) -> Bool? {
    props?[key]?.boolValue
  }

  /// Retrieves an array property by key.
  /// - Parameter key: The property key.
  /// - Returns: The array value, or `nil` if not found or not an array.
  public func array(_ key: String) -> [Any]? {
    props?[key]?.arrayValue
  }

  /// Retrieves a dictionary property by key.
  /// - Parameter key: The property key.
  /// - Returns: The dictionary value, or `nil` if not found or not a dictionary.
  public func dictionary(_ key: String) -> [String: Any]? {
    props?[key]?.dictionaryValue
  }

  /// Retrieves a string property with a default value.
  /// - Parameters:
  ///   - key: The property key.
  ///   - defaultValue: The default value to return if the property is not found.
  /// - Returns: The string value or the default.
  public func string(_ key: String, default defaultValue: String) -> String {
    string(key) ?? defaultValue
  }

  /// Retrieves an integer property with a default value.
  /// - Parameters:
  ///   - key: The property key.
  ///   - defaultValue: The default value to return if the property is not found.
  /// - Returns: The integer value or the default.
  public func int(_ key: String, default defaultValue: Int) -> Int {
    int(key) ?? defaultValue
  }

  /// Retrieves a double property with a default value.
  /// - Parameters:
  ///   - key: The property key.
  ///   - defaultValue: The default value to return if the property is not found.
  /// - Returns: The double value or the default.
  public func double(_ key: String, default defaultValue: Double) -> Double {
    double(key) ?? defaultValue
  }

  /// Retrieves a boolean property with a default value.
  /// - Parameters:
  ///   - key: The property key.
  ///   - defaultValue: The default value to return if the property is not found.
  /// - Returns: The boolean value or the default.
  public func bool(_ key: String, default defaultValue: Bool) -> Bool {
    bool(key) ?? defaultValue
  }
}
