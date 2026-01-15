import Testing

@testable import SwiftUIJSONRender

@Suite("StreamingJSONRenderer Tests")
@MainActor
struct StreamingJSONRendererTests {
  @Test("Emits node when JSON completes")
  func testAppendAndComplete() {
    let renderer = StreamingJSONRenderer()
    #expect(renderer.node == nil)
    #expect(renderer.isLoading == true)

    renderer.append("{\"type\":\"Text\"")
    #expect(renderer.node == nil)
    #expect(renderer.isLoading == true)

    renderer.append("}")
    #expect(renderer.node?.type == "Text")
    #expect(renderer.isLoading == true)

    renderer.complete()
    #expect(renderer.isLoading == false)
  }

  @Test("Reset clears state")
  func testReset() {
    let renderer = StreamingJSONRenderer()
    renderer.append("{\"type\":\"Text\"}")
    #expect(renderer.node?.type == "Text")

    renderer.reset()
    #expect(renderer.node == nil)
    #expect(renderer.isLoading == true)
  }
}
