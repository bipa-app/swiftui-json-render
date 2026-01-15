import SwiftUI

// MARK: - On Action Modifier

private struct OnActionModifier: ViewModifier {
  let handler: ActionHandler

  func body(content: Content) -> some View {
    content
      .environment(\.actionHandler, handler)
  }
}

extension View {
  /// Handles actions triggered by interactive JSON-rendered components.
  ///
  /// ## Example
  /// ```swift
  /// JSONView(json)
  ///     .onAction { action in
  ///         switch action.name {
  ///         case "navigate":
  ///             // Handle navigation
  ///         case "submit":
  ///             // Handle form submission
  ///         default:
  ///             print("Unknown action: \(action.name)")
  ///         }
  ///     }
  /// ```
  ///
  /// - Parameter handler: The closure to call when an action is triggered.
  /// - Returns: A view with the action handler applied.
  public func onAction(_ handler: @escaping ActionHandler) -> some View {
    modifier(OnActionModifier(handler: handler))
  }
}
