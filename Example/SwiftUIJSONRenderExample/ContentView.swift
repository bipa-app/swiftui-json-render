import SwiftUI
import SwiftUIJSONRender

struct ContentView: View {
  var body: some View {
    NavigationStack {
      ScrollView {
        JSONView(SampleJSON.overview)
          .onAction { action in
            // Example hook for action handling
            print("Action:", action.name)
          }
          .padding()
      }
      .navigationTitle("JSON Render")
    }
  }
}
