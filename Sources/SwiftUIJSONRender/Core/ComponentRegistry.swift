import Foundation
import SwiftUI

/// A registry that maps component type names to their builders.
///
/// Use the registry to register custom components or component modules.
/// The default shared registry includes all built-in components.
///
/// ## Registering Custom Components
/// ```swift
/// // Register a single component
/// ComponentRegistry.shared.register(MyButtonBuilder.self)
///
/// // Register a module of components
/// ComponentRegistry.shared.register(module: ApoloModule())
/// ```
public final class ComponentRegistry: @unchecked Sendable {
  /// The shared default registry with built-in components.
  public static let shared = ComponentRegistry()

  private var builders: [ComponentType: AnyComponentBuilder] = [:]
  private let lock = NSLock()

  /// Creates a new empty registry.
  public init() {}

  /// Registers a component builder type.
  /// - Parameter builderType: The builder type to register.
  public func register<T: ComponentBuilder>(_ builderType: T.Type) {
    lock.lock()
    defer { lock.unlock() }
    builders[T.componentType] = AnyComponentBuilder(builderType)
  }

  /// Registers all components from a module.
  /// - Parameter module: The component module to register.
  public func register(module: ComponentModule) {
    for builder in module.builders {
      lock.lock()
      builders[builder.type] = builder
      lock.unlock()
    }
  }

  /// Looks up a builder for the given component type.
  /// - Parameter type: The component type.
  /// - Returns: The builder if found, or `nil` if no builder is registered for this type.
  func builder(for type: ComponentType) -> AnyComponentBuilder? {
    lock.lock()
    defer { lock.unlock() }
    return builders[type]
  }

  /// Looks up a builder for the given type name.
  /// - Parameter typeName: The component type name.
  /// - Returns: The builder if found, or `nil` if no builder is registered for this type.
  func builder(for typeName: String) -> AnyComponentBuilder? {
    builder(for: ComponentType(rawValue: typeName))
  }

  /// Returns all registered type names.
  public var registeredTypes: [String] {
    lock.lock()
    defer { lock.unlock() }
    return builders.keys.map { $0.rawValue }.sorted()
  }

  /// Returns all registered component types.
  public var registeredComponentTypes: [ComponentType] {
    lock.lock()
    defer { lock.unlock() }
    return Array(builders.keys).sorted { $0.rawValue < $1.rawValue }
  }

  /// Checks if a builder is registered for the given component type.
  /// - Parameter type: The component type.
  /// - Returns: `true` if a builder is registered, `false` otherwise.
  public func hasBuilder(for type: ComponentType) -> Bool {
    lock.lock()
    defer { lock.unlock() }
    return builders[type] != nil
  }

  /// Checks if a builder is registered for the given type name.
  /// - Parameter typeName: The component type name.
  /// - Returns: `true` if a builder is registered, `false` otherwise.
  public func hasBuilder(for typeName: String) -> Bool {
    hasBuilder(for: ComponentType(rawValue: typeName))
  }

  /// Removes a builder for the given component type.
  /// - Parameter type: The component type to remove.
  public func unregister(_ type: ComponentType) {
    lock.lock()
    defer { lock.unlock() }
    builders.removeValue(forKey: type)
  }

  /// Removes a builder for the given type name.
  /// - Parameter typeName: The component type name to remove.
  public func unregister(_ typeName: String) {
    unregister(ComponentType(rawValue: typeName))
  }

  /// Removes all registered builders.
  public func unregisterAll() {
    lock.lock()
    defer { lock.unlock() }
    builders.removeAll()
  }

  /// Creates a copy of this registry.
  /// - Returns: A new registry with the same registered builders.
  public func copy() -> ComponentRegistry {
    let newRegistry = ComponentRegistry()
    lock.lock()
    newRegistry.builders = builders
    lock.unlock()
    return newRegistry
  }
}
