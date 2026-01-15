import SwiftUI

// MARK: - Strings Environment Key

private struct StringsTypeKey: EnvironmentKey {
  static let defaultValue: any JSONRenderStrings.Type = DefaultStrings.self
}

extension EnvironmentValues {
  /// The current strings type for JSON rendering.
  public var renderStrings: any JSONRenderStrings.Type {
    get { self[StringsTypeKey.self] }
    set { self[StringsTypeKey.self] = newValue }
  }
}

// MARK: - View Modifier

extension View {
  /// Sets the strings for localization in this view hierarchy.
  /// - Parameter stringsType: The strings type to use for component labels.
  /// - Returns: A view with the specified strings.
  public func strings(_ stringsType: any JSONRenderStrings.Type) -> some View {
    environment(\.renderStrings, stringsType)
  }
}
