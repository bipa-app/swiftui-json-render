import SwiftUI
import Testing

@testable import SwiftUIJSONRender

@Suite("UnknownComponentBehavior Tests")
struct UnknownComponentBehaviorTests {

  // MARK: - Enum Cases

  @Test("UnknownComponentBehavior has expected cases")
  func testEnumCases() {
    let placeholder = UnknownComponentBehavior.placeholder
    let skip = UnknownComponentBehavior.skip
    let error = UnknownComponentBehavior.error

    #expect(placeholder == .placeholder)
    #expect(skip == .skip)
    #expect(error == .error)
  }

  // MARK: - RenderContext Default

  @Test("RenderContext defaults to placeholder behavior")
  func testRenderContextDefault() {
    let context = RenderContext()
    #expect(context.unknownComponentBehavior == .placeholder)
  }

  @Test("RenderContext accepts custom behavior")
  func testRenderContextCustomBehavior() {
    let contextSkip = RenderContext(unknownComponentBehavior: .skip)
    let contextError = RenderContext(unknownComponentBehavior: .error)

    #expect(contextSkip.unknownComponentBehavior == .skip)
    #expect(contextError.unknownComponentBehavior == .error)
  }

  @Test("RenderContext.with(unknownComponentBehavior:) creates new context")
  func testRenderContextWithBehavior() {
    let original = RenderContext(unknownComponentBehavior: .placeholder)
    let modified = original.with(unknownComponentBehavior: .error)

    #expect(original.unknownComponentBehavior == .placeholder)
    #expect(modified.unknownComponentBehavior == .error)
  }

  // MARK: - Render Behavior with Unknown Component

  @Test("Unknown component with placeholder behavior renders placeholder")
  @MainActor
  func testUnknownComponentPlaceholder() {
    let node = ComponentNode(type: "NonExistentComponent", props: nil)
    let context = RenderContext(unknownComponentBehavior: .placeholder)

    // Should not crash and should return a view
    let view = context.render(node)
    #expect(view != nil)
  }

  @Test("Unknown component with skip behavior renders empty")
  @MainActor
  func testUnknownComponentSkip() {
    let node = ComponentNode(type: "NonExistentComponent", props: nil)
    let context = RenderContext(unknownComponentBehavior: .skip)

    // Should not crash and should return a view
    let view = context.render(node)
    #expect(view != nil)
  }

  @Test("Unknown component with error behavior renders error view")
  @MainActor
  func testUnknownComponentError() {
    let node = ComponentNode(type: "NonExistentComponent", props: nil)
    let context = RenderContext(unknownComponentBehavior: .error)

    // Should not crash and should return a view
    let view = context.render(node)
    #expect(view != nil)
  }

  // MARK: - Known Component Still Works

  @Test("Known component renders regardless of unknown behavior setting")
  @MainActor
  func testKnownComponentStillWorks() {
    let node = ComponentNode(type: "Text", props: ["content": "Hello"])

    let contextPlaceholder = RenderContext(unknownComponentBehavior: .placeholder)
    let contextSkip = RenderContext(unknownComponentBehavior: .skip)
    let contextError = RenderContext(unknownComponentBehavior: .error)

    // All should render the Text component
    let view1 = contextPlaceholder.render(node)
    let view2 = contextSkip.render(node)
    let view3 = contextError.render(node)

    #expect(view1 != nil)
    #expect(view2 != nil)
    #expect(view3 != nil)
  }

  // MARK: - Sendable Conformance

  @Test("UnknownComponentBehavior is Sendable")
  func testSendable() {
    let behavior: UnknownComponentBehavior = .placeholder

    // This test verifies the type conforms to Sendable
    // If it compiles, the test passes
    Task {
      let _ = behavior
    }
  }
}
