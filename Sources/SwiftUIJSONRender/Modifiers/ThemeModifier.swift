import SwiftUI

// MARK: - Theme Modifier

private struct ThemeModifier: ViewModifier {
  let themeType: any JSONRenderTheme.Type

  func body(content: Content) -> some View {
    content
      .environment(\.componentTheme, themeType)
  }
}

extension View {
  /// Applies a custom theme to JSON-rendered components.
  ///
  /// ## Example
  /// ```swift
  /// JSONView(json)
  ///     .theme(MyCustomTheme.self)
  /// ```
  ///
  /// - Parameter themeType: The theme type to apply.
  /// - Returns: A view with the theme applied.
  public func theme(_ themeType: any JSONRenderTheme.Type) -> some View {
    modifier(ThemeModifier(themeType: themeType))
  }
}
