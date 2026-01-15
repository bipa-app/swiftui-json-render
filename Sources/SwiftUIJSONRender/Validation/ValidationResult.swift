import Foundation

/// The result of validating a JSON component tree.
public enum ValidationResult: Equatable, Sendable {
  /// The JSON is valid and can be rendered.
  case valid

  /// The JSON is invalid with the specified errors.
  case invalid(errors: [ValidationError])

  /// Returns `true` if the result is valid.
  public var isValid: Bool {
    if case .valid = self {
      return true
    }
    return false
  }

  /// Returns the validation errors, or an empty array if valid.
  public var errors: [ValidationError] {
    if case .invalid(let errors) = self {
      return errors
    }
    return []
  }
}

/// An error encountered during JSON validation.
public enum ValidationError: Error, Equatable, Sendable, CustomStringConvertible {
  /// The JSON could not be parsed.
  case parseError(String)

  /// The component tree exceeds the maximum allowed depth.
  case maxDepthExceeded(depth: Int, maxDepth: Int)

  /// An unknown component type was encountered.
  case unknownComponent(String)

  /// A required property is missing.
  case missingRequiredProperty(component: String, property: String)

  /// A property has an invalid type.
  case invalidPropertyType(component: String, property: String, expected: String, actual: String)

  /// A property has an invalid value.
  case invalidPropertyValue(component: String, property: String, reason: String)

  public var description: String {
    switch self {
    case .parseError(let message):
      return "Parse error: \(message)"
    case .maxDepthExceeded(let depth, let maxDepth):
      return "Max depth exceeded: \(depth) > \(maxDepth)"
    case .unknownComponent(let type):
      return "Unknown component: \(type)"
    case .missingRequiredProperty(let component, let property):
      return "\(component): missing required property '\(property)'"
    case .invalidPropertyType(let component, let property, let expected, let actual):
      return "\(component).\(property): expected \(expected), got \(actual)"
    case .invalidPropertyValue(let component, let property, let reason):
      return "\(component).\(property): \(reason)"
    }
  }
}
