import SwiftUI

/// A view modifier that attaches an input handler to the view.
///
/// Use this to receive structured input from `input` components
/// rendered by `JSONView`.
///
/// ```swift
/// JSONView(json)
///     .onInput { response in
///         print("Input \(response.inputId) = \(response.value)")
///     }
/// ```
struct OnInputModifier: ViewModifier {
  let handler: InputHandler

  func body(content: Content) -> some View {
    content.environment(\.inputHandler, handler)
  }
}

public extension View {
  /// Attaches an input handler to receive structured input from `input` components.
  /// - Parameter handler: A closure called when the user completes an input.
  /// - Returns: The modified view.
  func onInput(_ handler: @escaping InputHandler) -> some View {
    modifier(OnInputModifier(handler: handler))
  }
}
