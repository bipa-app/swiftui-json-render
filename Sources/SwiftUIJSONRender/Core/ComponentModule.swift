import Foundation

/// A protocol for grouping related component builders.
///
/// Implement this protocol to create a module of components that can be
/// registered with the `ComponentRegistry` in a single call.
///
/// ## Example
/// ```swift
/// struct ApoloModule: ComponentModule {
///     static var builders: [AnyComponentBuilder] {
///         [
///             AnyComponentBuilder(ApoloButtonBuilder.self),
///             AnyComponentBuilder(ApoloTagBuilder.self),
///             AnyComponentBuilder(ApoloCardBuilder.self),
///         ]
///     }
/// }
///
/// // Register all components at once
/// ComponentRegistry.shared.register(module: ApoloModule())
/// ```
public protocol ComponentModule {
  /// The builders provided by this module.
  var builders: [AnyComponentBuilder] { get }
}
