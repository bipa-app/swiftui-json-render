import Foundation

/// Validates JSON component trees before rendering.
///
/// Use `JSONValidator` to check if a JSON string or component node is valid
/// before attempting to render it. This can help catch errors early and
/// provide better error messages.
///
/// ## Example
/// ```swift
/// let result = JSONValidator.validate(json)
/// switch result {
/// case .valid:
///     // Safe to render
/// case .invalid(let errors):
///     // Handle errors
///     for error in errors {
///         print(error.description)
///     }
/// }
/// ```
public enum JSONValidator {
  /// The maximum allowed depth for nested components.
  /// This prevents stack overflow from deeply nested or circular structures.
  public static let maxDepth = 20

  /// Validates a JSON string.
  /// - Parameters:
  ///   - json: The JSON string to validate.
  ///   - registry: The component registry to check types against. Defaults to shared.
  /// - Returns: A validation result indicating success or errors.
  public static func validate(
    _ json: String,
    registry: ComponentRegistry = .shared
  ) -> ValidationResult {
    guard let data = json.data(using: .utf8) else {
      return .invalid(errors: [.parseError("Invalid UTF-8 string")])
    }

    do {
      let node = try JSONDecoder().decode(ComponentNode.self, from: data)
      return validate(node: node, registry: registry)
    } catch {
      return .invalid(errors: [.parseError(error.localizedDescription)])
    }
  }

  /// Validates a component node tree.
  /// - Parameters:
  ///   - node: The root component node to validate.
  ///   - registry: The component registry to check types against. Defaults to shared.
  /// - Returns: A validation result indicating success or errors.
  public static func validate(
    node: ComponentNode,
    registry: ComponentRegistry = .shared
  ) -> ValidationResult {
    var errors: [ValidationError] = []
    validateNode(node, depth: 0, registry: registry, errors: &errors)

    if errors.isEmpty {
      return .valid
    } else {
      return .invalid(errors: errors)
    }
  }

  // MARK: - Private

  private static func validateNode(
    _ node: ComponentNode,
    depth: Int,
    registry: ComponentRegistry,
    errors: inout [ValidationError]
  ) {
    // Check depth
    if depth > maxDepth {
      errors.append(.maxDepthExceeded(depth: depth, maxDepth: maxDepth))
      return  // Don't continue validating deeper
    }

    // Check component type
    if !registry.hasBuilder(for: node.type) {
      errors.append(.unknownComponent(node.type.rawValue))
    }

    // Validate children recursively
    if let children = node.children {
      for child in children {
        validateNode(child, depth: depth + 1, registry: registry, errors: &errors)
      }
    }
  }
}

// MARK: - Convenience Extensions

extension ComponentNode {
  /// Validates this node tree.
  /// - Parameter registry: The component registry to check types against.
  /// - Returns: A validation result indicating success or errors.
  public func validate(registry: ComponentRegistry = .shared) -> ValidationResult {
    JSONValidator.validate(node: self, registry: registry)
  }
}
