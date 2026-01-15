import SwiftUI
import Testing

@testable import SwiftUIJSONRender

@Suite("ComponentRegistry Tests")
struct ComponentRegistryTests {

  @Test("Registers and retrieves component builder")
  func registersAndRetrievesBuilder() {
    let registry = ComponentRegistry()
    registry.register(MockComponentBuilder.self)

    #expect(registry.hasBuilder(for: "MockComponent"))
    #expect(registry.registeredTypes.contains("MockComponent"))
  }

  @Test("Returns nil for unregistered component")
  func returnsNilForUnregistered() {
    let registry = ComponentRegistry()

    #expect(registry.hasBuilder(for: "NonExistent") == false)
    #expect(registry.builder(for: "NonExistent") == nil)
  }

  @Test("Unregisters component")
  func unregistersComponent() {
    let registry = ComponentRegistry()
    registry.register(MockComponentBuilder.self)

    #expect(registry.hasBuilder(for: "MockComponent"))

    registry.unregister("MockComponent")

    #expect(registry.hasBuilder(for: "MockComponent") == false)
  }

  @Test("Unregisters all components")
  func unregistersAllComponents() {
    let registry = ComponentRegistry()
    registry.register(MockComponentBuilder.self)
    registry.register(AnotherMockBuilder.self)

    #expect(registry.registeredTypes.count == 2)

    registry.unregisterAll()

    #expect(registry.registeredTypes.count == 0)
  }

  @Test("Copies registry")
  func copiesRegistry() {
    let registry = ComponentRegistry()
    registry.register(MockComponentBuilder.self)

    let copy = registry.copy()

    #expect(copy.hasBuilder(for: "MockComponent"))

    // Modifying original doesn't affect copy
    registry.unregister("MockComponent")
    #expect(copy.hasBuilder(for: "MockComponent"))
  }

  @Test("Registers module")
  func registersModule() {
    let registry = ComponentRegistry()
    registry.register(module: MockModule())

    #expect(registry.hasBuilder(for: "MockComponent"))
    #expect(registry.hasBuilder(for: "AnotherMock"))
  }

  @Test("Shared registry has built-in components")
  func sharedRegistryHasBuiltInComponents() {
    // Ensure built-in components are registered
    registerBuiltInComponents()

    let shared = ComponentRegistry.shared

    #expect(shared.hasBuilder(for: "Stack"))
    #expect(shared.hasBuilder(for: "Card"))
    #expect(shared.hasBuilder(for: "Text"))
    #expect(shared.hasBuilder(for: "Button"))
    #expect(shared.hasBuilder(for: "Alert"))
  }
}

// MARK: - Mock Components

private struct MockComponentBuilder: ComponentBuilder {
  static var typeName: String { "MockComponent" }

  static func build(node: ComponentNode, context: RenderContext) -> AnyView {
    AnyView(Text("Mock"))
  }
}

private struct AnotherMockBuilder: ComponentBuilder {
  static var typeName: String { "AnotherMock" }

  static func build(node: ComponentNode, context: RenderContext) -> AnyView {
    AnyView(Text("Another"))
  }
}

private struct MockModule: ComponentModule {
  var builders: [AnyComponentBuilder] {
    [
      AnyComponentBuilder(MockComponentBuilder.self),
      AnyComponentBuilder(AnotherMockBuilder.self),
    ]
  }
}
