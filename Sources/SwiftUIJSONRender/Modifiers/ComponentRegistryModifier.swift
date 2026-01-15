import SwiftUI

// MARK: - Component Registry Modifier

private struct ComponentRegistryModifier: ViewModifier {
  let registry: ComponentRegistry

  func body(content: Content) -> some View {
    content
      .environment(\.componentRegistry, registry)
  }
}

extension View {
  /// Uses a custom component registry for JSON-rendered components.
  ///
  /// This is useful when you want to use a different set of components
  /// than the default shared registry.
  ///
  /// ## Example
  /// ```swift
  /// let customRegistry = ComponentRegistry()
  /// customRegistry.register(MyCustomComponent.self)
  ///
  /// JSONView(json)
  ///     .componentRegistry(customRegistry)
  /// ```
  ///
  /// - Parameter registry: The registry to use.
  /// - Returns: A view with the custom registry applied.
  public func componentRegistry(_ registry: ComponentRegistry) -> some View {
    modifier(ComponentRegistryModifier(registry: registry))
  }
}
