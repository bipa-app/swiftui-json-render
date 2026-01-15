import SwiftUI
import Testing

@testable import SwiftUIJSONRender

@Suite("Environment Defaults")
struct EnvironmentDefaultsTests {
  @Test("Default theme is DefaultTheme")
  func testDefaultTheme() {
    let values = EnvironmentValues()
    #expect(values.componentTheme == DefaultTheme.self)
  }

  @Test("Default registry is shared")
  func testDefaultRegistry() {
    let values = EnvironmentValues()
    #expect(values.componentRegistry === ComponentRegistry.shared)
  }

  @Test("Default action handler is nil")
  func testDefaultActionHandler() {
    let values = EnvironmentValues()
    #expect(values.actionHandler == nil)
  }
}
