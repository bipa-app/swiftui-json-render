import Foundation

struct AnthropicClient {
  struct Response: Decodable {
    struct ContentBlock: Decodable {
      let type: String
      let text: String?
    }

    let content: [ContentBlock]
  }

  struct ErrorResponse: Decodable {
    struct ErrorDetail: Decodable {
      let type: String
      let message: String
    }

    let error: ErrorDetail
  }

  static func generateJSON(
    prompt: String,
    apiKey: String,
    model: String = "claude-3-5-sonnet-20241022",
    maxTokens: Int = 1024
  ) async throws -> String {
    let url = URL(string: "https://api.anthropic.com/v1/messages")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue(apiKey, forHTTPHeaderField: "x-api-key")
    request.setValue("2023-06-01", forHTTPHeaderField: "anthropic-version")

    let system = """
      Return ONLY valid JSON for a SwiftUIJSONRender ComponentNode tree.
      Do not include markdown, comments, or extra text.
      """

    let body: [String: Any] = [
      "model": model,
      "max_tokens": maxTokens,
      "system": system,
      "messages": [
        [
          "role": "user",
          "content": [
            ["type": "text", "text": prompt]
          ],
        ]
      ],
    ]

    request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])

    let (data, response) = try await URLSession.shared.data(for: request)
    if let http = response as? HTTPURLResponse, http.statusCode >= 400 {
      if let apiError = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
        throw AnthropicError.api(message: apiError.error.message)
      }
      throw AnthropicError.http(statusCode: http.statusCode)
    }

    let decoded = try JSONDecoder().decode(Response.self, from: data)
    guard let text = decoded.content.first(where: { $0.type == "text" })?.text else {
      throw AnthropicError.emptyResponse
    }
    return text.trimmingCharacters(in: .whitespacesAndNewlines)
  }
}

enum AnthropicError: Error {
  case http(statusCode: Int)
  case emptyResponse
  case api(message: String)
}
