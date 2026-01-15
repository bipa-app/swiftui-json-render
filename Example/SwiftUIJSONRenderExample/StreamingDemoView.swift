import SwiftUI
import SwiftUIJSONRender

struct StreamingDemoView: View {
  @StateObject private var renderer = StreamingJSONRenderer()

  var body: some View {
    VStack(spacing: 16) {
      renderer.currentView
        .padding()

      Button("Restart Stream") {
        startStream()
      }
    }
    .navigationTitle("Streaming")
    .onAppear {
      startStream()
    }
  }

  private func startStream() {
    renderer.reset()

    let chunks = SampleJSON.streamingChunks
    for (index, chunk) in chunks.enumerated() {
      DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.6) {
        renderer.append(chunk)
        if index == chunks.count - 1 {
          renderer.complete()
        }
      }
    }
  }
}
