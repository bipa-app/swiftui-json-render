import SwiftUI
import SwiftUIJSONRender

struct AIPlaygroundView: View {
  @State private var apiKey: String = ""
  @State private var model: String = "claude-3-5-sonnet-20241022"
  @State private var prompt: String = "Create a card with a title and a button."
  @State private var jsonOutput: String = ""
  @State private var isLoading = false
  @State private var errorMessage: String?

  var body: some View {
    NavigationStack {
      ScrollView {
        VStack(alignment: .leading, spacing: 16) {
          SectionHeader(title: "API Key")
          SecureField("Anthropic API Key", text: $apiKey)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            .onChange(of: apiKey) { _, newValue in
              saveKey(newValue)
            }

          Text("Stored locally in Keychain. Never committed.")
            .font(.caption)
            .foregroundColor(.secondary)

          SectionHeader(title: "Model")
          Picker("Model", selection: $model) {
            ForEach(modelOptions, id: \.self) { option in
              Text(option).tag(option)
            }
          }
          .pickerStyle(.menu)

          SectionHeader(title: "Prompt")
          TextEditor(text: $prompt)
            .frame(minHeight: 100)
            .overlay(
              RoundedRectangle(cornerRadius: 8)
                .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
            )

          Button(action: generate) {
            if isLoading {
              ProgressView()
            } else {
              Text("Generate UI")
            }
          }
          .buttonStyle(.borderedProminent)
          .disabled(apiKey.isEmpty || isLoading)

          if let errorMessage = errorMessage {
            Text(errorMessage)
              .foregroundColor(.red)
              .font(.caption)
          }

          SectionHeader(title: "Rendered")
          JSONView(jsonOutput)
            .padding()
            .background(Color.secondary.opacity(0.05))
            .cornerRadius(12)

          SectionHeader(title: "JSON Output")
          TextEditor(text: $jsonOutput)
            .frame(minHeight: 160)
            .font(.system(.caption, design: .monospaced))
            .overlay(
              RoundedRectangle(cornerRadius: 8)
                .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
            )
        }
        .padding()
      }
      .navigationTitle("AI Playground")
      .onAppear {
        loadKey()
      }
    }
  }

  private func generate() {
    errorMessage = nil
    isLoading = true
    Task {
      do {
        let output = try await AnthropicClient.generateJSON(
          prompt: prompt,
          apiKey: apiKey,
          model: model
        )
        await MainActor.run {
          jsonOutput = output
          isLoading = false
        }
      } catch {
        await MainActor.run {
          if let apiError = error as? AnthropicError {
            switch apiError {
            case .api(let message):
              errorMessage = message
            case .http(let statusCode):
              errorMessage = "Request failed (HTTP \(statusCode))."
            case .emptyResponse:
              errorMessage = "Empty response."
            }
          } else {
            errorMessage = "Request failed. Check your API key and network."
          }
          isLoading = false
        }
      }
    }
  }

  private func loadKey() {
    if let stored = try? KeychainStore.load(key: "anthropic_api_key") {
      apiKey = stored ?? ""
    }
  }

  private func saveKey(_ value: String) {
    if value.isEmpty {
      try? KeychainStore.delete(key: "anthropic_api_key")
    } else {
      try? KeychainStore.save(key: "anthropic_api_key", value: value)
    }
  }

  private var modelOptions: [String] {
    [
      "claude-4-5-opus-20251101",
      "claude-3-5-sonnet-20241022",
      "claude-3-5-haiku-20241022",
      "claude-3-opus-20240229",
      "claude-3-sonnet-20240229",
      "claude-3-haiku-20240307",
    ]
  }
}

private struct SectionHeader: View {
  let title: String

  var body: some View {
    Text(title)
      .font(.headline)
  }
}
