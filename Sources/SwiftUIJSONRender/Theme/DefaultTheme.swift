import SwiftUI

/// The default theme used when no custom theme is provided.
///
/// This theme uses all default values from the `JSONRenderTheme` protocol extension.
/// It serves as a concrete type for the default theme instance.
public struct DefaultTheme: JSONRenderTheme {
  public init() {}
}
