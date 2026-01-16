import Foundation

/// The supported component types in the JSON schema.
public enum ComponentType: Hashable, Sendable, Codable {
  case stack
  case card
  case divider
  case spacer
  case text
  case heading
  case image
  case icon
  case balanceCard
  case transactionRow
  case transactionList
  case assetPrice
  case pieChart
  case lineChart
  case button
  case amountInput
  case confirmDialog
  case choiceList
  case alert
  case custom(String)

  public init(rawValue: String) {
    switch rawValue {
    case "Stack":
      self = .stack
    case "Card":
      self = .card
    case "Divider":
      self = .divider
    case "Spacer":
      self = .spacer
    case "Text":
      self = .text
    case "Heading":
      self = .heading
    case "Image":
      self = .image
    case "Icon":
      self = .icon
    case "BalanceCard":
      self = .balanceCard
    case "TransactionRow":
      self = .transactionRow
    case "TransactionList":
      self = .transactionList
    case "AssetPrice":
      self = .assetPrice
    case "PieChart":
      self = .pieChart
    case "LineChart":
      self = .lineChart
    case "Button":
      self = .button
    case "AmountInput":
      self = .amountInput
    case "ConfirmDialog":
      self = .confirmDialog
    case "ChoiceList":
      self = .choiceList
    case "Alert":
      self = .alert
    default:
      self = .custom(rawValue)
    }
  }

  public var rawValue: String {
    switch self {
    case .stack:
      return "Stack"
    case .card:
      return "Card"
    case .divider:
      return "Divider"
    case .spacer:
      return "Spacer"
    case .text:
      return "Text"
    case .heading:
      return "Heading"
    case .image:
      return "Image"
    case .icon:
      return "Icon"
    case .balanceCard:
      return "BalanceCard"
    case .transactionRow:
      return "TransactionRow"
    case .transactionList:
      return "TransactionList"
    case .assetPrice:
      return "AssetPrice"
    case .pieChart:
      return "PieChart"
    case .lineChart:
      return "LineChart"
    case .button:
      return "Button"
    case .amountInput:
      return "AmountInput"
    case .confirmDialog:
      return "ConfirmDialog"
    case .choiceList:
      return "ChoiceList"
    case .alert:
      return "Alert"
    case .custom(let value):
      return value
    }
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    let value = try container.decode(String.self)
    self = ComponentType(rawValue: value)
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(rawValue)
  }
}

/// Represents a node in the component tree parsed from JSON.
///
/// A `ComponentNode` describes a UI component with its type, properties, and optional children.
/// This is the primary data structure used for JSON-to-SwiftUI rendering.
///
/// ## Example JSON (without version)
/// ```json
/// {
///   "type": "Stack",
///   "props": { "direction": "vertical", "spacing": 16 },
///   "children": [
///     { "type": "Text", "props": { "content": "Hello" } }
///   ]
/// }
/// ```
///
/// ## Example JSON (with version)
/// ```json
/// {
///   "schemaVersion": "1.0",
///   "type": "Stack",
///   "props": { "direction": "vertical", "spacing": 16 },
///   "children": [
///     { "type": "Text", "props": { "content": "Hello" } }
///   ]
/// }
/// ```
public struct ComponentNode: Codable, Sendable, Equatable {
  /// The component type identifier (e.g., "Stack", "Text", "Button").
  public let type: ComponentType

  /// Optional properties for the component.
  public let props: [String: AnyCodable]?

  /// Optional child components.
  public let children: [ComponentNode]?

  /// Optional schema version (only present at root level).
  public let schemaVersion: SchemaVersion?

  /// The string type name for this component.
  public var typeName: String { type.rawValue }

  /// Creates a new component node.
  /// - Parameters:
  ///   - type: The component type identifier.
  ///   - props: Optional properties dictionary.
  ///   - children: Optional array of child nodes.
  ///   - schemaVersion: Optional schema version (typically only at root).
  public init(
    type: ComponentType,
    props: [String: AnyCodable]? = nil,
    children: [ComponentNode]? = nil,
    schemaVersion: SchemaVersion? = nil
  ) {
    self.type = type
    self.props = props
    self.children = children
    self.schemaVersion = schemaVersion
  }

  public init(
    type: String,
    props: [String: AnyCodable]? = nil,
    children: [ComponentNode]? = nil,
    schemaVersion: SchemaVersion? = nil
  ) {
    self.init(
      type: ComponentType(rawValue: type),
      props: props,
      children: children,
      schemaVersion: schemaVersion
    )
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

  /// Retrieves an enum-backed string property by key.
  /// - Parameter key: The property key.
  /// - Returns: The enum value, or `nil` if not found or not a valid case.
  public func enumValue<T: RawRepresentable>(_ key: String) -> T? where T.RawValue == String {
    guard let value = string(key) else { return nil }
    return T(rawValue: value)
  }

  /// Retrieves an enum-backed string property with a default value.
  /// - Parameters:
  ///   - key: The property key.
  ///   - defaultValue: The default value to return if the property is not found.
  /// - Returns: The enum value or the default.
  public func enumValue<T: RawRepresentable>(
    _ key: String,
    default defaultValue: T
  ) -> T where T.RawValue == String {
    enumValue(key) ?? defaultValue
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
