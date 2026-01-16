import SwiftUI

/// A protocol for building SwiftUI views from JSON component data.
///
/// Implement this protocol to create custom component renderers that can be
/// registered with the `ComponentRegistry`. This enables extensibility,
/// allowing teams to add their own design system components.
///
/// ## Example
/// ```swift
/// struct MyButtonBuilder: ComponentBuilder {
///     static var typeName: String { "MyButton" }
///
///     static func build(
///         node: ComponentNode,
///         context: RenderContext
///     ) -> AnyView {
///         let label = node.string("label") ?? "Button"
///         return AnyView(
///             Button(label) {
///                 if let action = node.props?["action"] {
///                     context.handleAction(action)
///                 }
///             }
///         )
///     }
/// }
/// ```
public protocol ComponentBuilder {
  /// The type name that this builder handles (e.g., "Button", "Card", "ApoloTag").
  ///
  /// This must match the `type` field in the JSON component node.
  static var typeName: String { get }

  /// The strongly typed component identifier.
  static var componentType: ComponentType { get }

  /// Builds a SwiftUI view from the component node.
  /// - Parameters:
  ///   - node: The component node containing type, props, and children.
  ///   - context: The render context providing theme, actions, and child rendering.
  /// - Returns: An `AnyView` wrapping the rendered component.
  @MainActor
  static func build(node: ComponentNode, context: RenderContext) -> AnyView
}

/// A type-erased wrapper for component builders.
public extension ComponentBuilder {
  static var componentType: ComponentType {
    ComponentType(rawValue: typeName)
  }
}

public struct AnyComponentBuilder: @unchecked Sendable {
  public let type: ComponentType
  public var typeName: String { type.rawValue }
  private let _build: @MainActor (ComponentNode, RenderContext) -> AnyView

  public init<T: ComponentBuilder>(_ builderType: T.Type) {
    self.type = T.componentType
    self._build = { node, context in
      T.build(node: node, context: context)
    }
  }

  @MainActor
  public func build(node: ComponentNode, context: RenderContext) -> AnyView {
    _build(node, context)
  }
}
