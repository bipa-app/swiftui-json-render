import SwiftUI

/// Defines how unknown components (not found in the registry) should be handled.
public enum UnknownComponentBehavior: Sendable {
  /// Show a placeholder view indicating an unknown component (default).
  case placeholder

  /// Skip unknown components entirely (render nothing).
  case skip

  /// Show an error view with the component type name.
  case error
}

// MARK: - Environment Key

private struct UnknownComponentBehaviorKey: EnvironmentKey {
  static let defaultValue: UnknownComponentBehavior = .placeholder
}

extension EnvironmentValues {
  /// The behavior for handling unknown components.
  public var unknownComponentBehavior: UnknownComponentBehavior {
    get { self[UnknownComponentBehaviorKey.self] }
    set { self[UnknownComponentBehaviorKey.self] = newValue }
  }
}

// MARK: - View Modifier

extension View {
  /// Sets the behavior for unknown components in this view hierarchy.
  /// - Parameter behavior: How to handle components not found in the registry.
  /// - Returns: A view with the specified unknown component behavior.
  public func unknownComponentBehavior(_ behavior: UnknownComponentBehavior) -> some View {
    environment(\.unknownComponentBehavior, behavior)
  }
}
