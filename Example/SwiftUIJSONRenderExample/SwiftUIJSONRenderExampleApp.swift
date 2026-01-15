import SwiftUI
import SwiftUIJSONRender

@main
struct SwiftUIJSONRenderExampleApp: App {
  init() {
    initializeJSONRender()
  }

  var body: some Scene {
    WindowGroup {
      TabView {
        ContentView()
          .tabItem {
            Label("Render", systemImage: "rectangle.grid.2x2")
          }

        StreamingDemoView()
          .tabItem {
            Label("Streaming", systemImage: "waveform.path.ecg")
          }

        AIPlaygroundView()
          .tabItem {
            Label("AI", systemImage: "sparkles")
          }
      }
    }
  }
}
