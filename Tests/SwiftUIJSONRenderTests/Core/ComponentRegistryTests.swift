import Foundation
import SwiftUI
import Testing

@testable import SwiftUIJSONRender

@Suite("ComponentRegistry Tests")
struct ComponentRegistryTests {

  // MARK: - Registration

  @Test("Register single builder")
  func testRegisterBuilder() throws {
    let registry = ComponentRegistry()

    registry.register(MockComponentBuilder.self)

    #expect(registry.hasBuilder(for: "MockComponent") == true)
  }

  @Test("Register module with multiple builders")
  func testRegisterModule() throws {
    let registry = ComponentRegistry()
    let module = BuiltInComponentsModule()

    registry.register(module: module)

    #expect(registry.hasBuilder(for: "Stack") == true)
    #expect(registry.hasBuilder(for: "Card") == true)
    #expect(registry.hasBuilder(for: "Text") == true)
    #expect(registry.hasBuilder(for: "Button") == true)
    #expect(registry.hasBuilder(for: "Alert") == true)
  }

  @Test("Register custom module")
  func testRegisterCustomModule() throws {
    let registry = ComponentRegistry()
    let module = TestModule()

    registry.register(module: module)

    #expect(registry.hasBuilder(for: "MockComponent") == true)
  }

  // MARK: - Lookup

  @Test("Builder lookup for registered type")
  func testBuilderLookup() throws {
    let registry = ComponentRegistry()
    registry.register(MockComponentBuilder.self)

    let builder = registry.builder(for: "MockComponent")

    #expect(builder != nil)
    #expect(builder?.typeName == "MockComponent")
  }

  @Test("Builder lookup returns nil for unknown type")
  func testBuilderNotFound() throws {
    let registry = ComponentRegistry()

    let builder = registry.builder(for: "UnknownComponent")

    #expect(builder == nil)
  }

  @Test("hasBuilder returns correct bool")
  func testHasBuilder() throws {
    let registry = ComponentRegistry()
    registry.register(MockComponentBuilder.self)

    #expect(registry.hasBuilder(for: "MockComponent") == true)
    #expect(registry.hasBuilder(for: "UnknownComponent") == false)
  }

  // MARK: - Registered Types

  @Test("registeredTypes returns all registered names")
  func testRegisteredTypes() throws {
    let registry = ComponentRegistry()
    registry.register(module: BuiltInComponentsModule())

    let types = registry.registeredTypes

    #expect(types.contains("Stack"))
    #expect(types.contains("Card"))
    #expect(types.contains("Text"))
    #expect(types.contains("Button"))
    #expect(types.contains("Alert"))
    #expect(types.count == 5)
  }

  @Test("registeredTypes is sorted")
  func testRegisteredTypesAreSorted() throws {
    let registry = ComponentRegistry()
    registry.register(module: BuiltInComponentsModule())

    let types = registry.registeredTypes

    #expect(types == types.sorted())
  }

  // MARK: - Unregister

  @Test("unregister removes builder")
  func testUnregister() throws {
    let registry = ComponentRegistry()
    registry.register(MockComponentBuilder.self)

    #expect(registry.hasBuilder(for: "MockComponent") == true)

    registry.unregister("MockComponent")

    #expect(registry.hasBuilder(for: "MockComponent") == false)
  }

  @Test("unregister non-existent type does nothing")
  func testUnregisterNonExistent() throws {
    let registry = ComponentRegistry()
    registry.register(MockComponentBuilder.self)

    registry.unregister("NonExistent")

    #expect(registry.hasBuilder(for: "MockComponent") == true)
  }

  @Test("unregisterAll clears registry")
  func testUnregisterAll() throws {
    let registry = ComponentRegistry()
    registry.register(module: BuiltInComponentsModule())

    #expect(registry.registeredTypes.count == 5)

    registry.unregisterAll()

    #expect(registry.registeredTypes.isEmpty)
  }

  // MARK: - Copy

  @Test("copy creates independent registry")
  func testCopy() throws {
    let original = ComponentRegistry()
    original.register(MockComponentBuilder.self)

    let copy = original.copy()

    // Both have the same builder initially
    #expect(copy.hasBuilder(for: "MockComponent") == true)

    // Modify original
    original.unregister("MockComponent")

    // Copy should be unaffected
    #expect(original.hasBuilder(for: "MockComponent") == false)
    #expect(copy.hasBuilder(for: "MockComponent") == true)
  }

  @Test("copy is independent of modifications")
  func testCopyIndependence() throws {
    let original = ComponentRegistry()
    original.register(module: BuiltInComponentsModule())

    let copy = original.copy()

    // Add to copy
    copy.register(MockComponentBuilder.self)

    // Original should not have MockComponent
    #expect(original.hasBuilder(for: "MockComponent") == false)
    #expect(copy.hasBuilder(for: "MockComponent") == true)
  }

  // MARK: - Thread Safety

  @Test("Concurrent registration is safe")
  func testConcurrentRegistration() async throws {
    let registry = ComponentRegistry()

    // Perform concurrent registrations
    await withTaskGroup(of: Void.self) { group in
      for _ in 0..<100 {
        group.addTask {
          registry.register(MockComponentBuilder.self)
        }
      }
    }

    // Should complete without crash
    #expect(registry.hasBuilder(for: "MockComponent") == true)
  }

  @Test("Concurrent lookup is safe")
  func testConcurrentLookup() async throws {
    let registry = ComponentRegistry()
    registry.register(module: BuiltInComponentsModule())

    // Perform concurrent lookups
    await withTaskGroup(of: Bool.self) { group in
      for _ in 0..<100 {
        group.addTask {
          return registry.hasBuilder(for: "Stack")
        }
      }

      for await result in group {
        #expect(result == true)
      }
    }
  }

  @Test("Concurrent read/write is safe")
  func testConcurrentReadWrite() async throws {
    let registry = ComponentRegistry()

    await withTaskGroup(of: Void.self) { group in
      // Writers
      for i in 0..<50 {
        group.addTask {
          if i % 2 == 0 {
            registry.register(MockComponentBuilder.self)
          } else {
            registry.unregister("MockComponent")
          }
        }
      }

      // Readers
      for _ in 0..<50 {
        group.addTask {
          _ = registry.hasBuilder(for: "MockComponent")
        }
      }
    }

    // Should complete without crash
    #expect(true)
  }

  // MARK: - Shared Registry

  @Test("Shared registry exists")
  func testSharedRegistry() throws {
    let shared = ComponentRegistry.shared

    #expect(shared != nil)
  }

  @Test("Shared registry has built-in components after init")
  func testSharedRegistryHasBuiltIns() throws {
    // Force initialization
    initializeJSONRender()

    let shared = ComponentRegistry.shared

    #expect(shared.hasBuilder(for: "Stack") == true)
    #expect(shared.hasBuilder(for: "Text") == true)
  }
}
