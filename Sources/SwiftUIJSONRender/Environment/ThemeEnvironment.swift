import SwiftUI

// MARK: - Theme Environment Key

private struct ThemeTypeKey: EnvironmentKey {
  static let defaultValue: any JSONRenderTheme.Type = DefaultTheme.self
}

extension EnvironmentValues {
  /// The current theme type for JSON rendering.
  public var componentTheme: any JSONRenderTheme.Type {
    get { self[ThemeTypeKey.self] }
    set { self[ThemeTypeKey.self] = newValue }
  }
}
