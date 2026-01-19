import Foundation
import SwiftUI
import SwiftUIJSONRender

#if canImport(AppKit)
  import AppKit
#endif

enum SnapshotGeneratorError: Error, LocalizedError {
  case missingImage(String)
  case invalidOutput(String)

  var errorDescription: String? {
    switch self {
    case .missingImage(let name):
      return "Failed to render image for \(name)."
    case .invalidOutput(let path):
      return "Invalid output directory: \(path)."
    }
  }
}

struct SnapshotSpec {
  let name: String
  let json: String
  let size: CGSize

  static let all: [SnapshotSpec] = [
    .init(
      name: "marketing-overview",
      json: """
      {
        "type": "Stack",
        "props": { "direction": "vertical", "spacing": 16, "alignment": "leading" },
        "children": [
          { "type": "Heading", "props": { "text": "SwiftUI JSON Render", "level": 1 } },
          { "type": "Text", "props": { "content": "Build native SwiftUI from JSON for AI and server-driven experiences." } },
          { "type": "Image", "props": { "url": "https://example.com/hero.png", "contentMode": "fit", "width": 320, "height": 160 } },
          {
            "type": "Stack",
            "props": { "direction": "horizontal", "spacing": 12, "alignment": "leading" },
            "children": [
              { "type": "Button", "props": { "label": "Get Started", "style": "primary" } },
              { "type": "Button", "props": { "label": "Read Docs", "style": "secondary" } }
            ]
          },
          {
            "type": "Card",
            "props": { "title": "Highlights", "padding": 16 },
            "children": [
              {
                "type": "Stack",
                "props": { "direction": "vertical", "spacing": 6, "alignment": "leading" },
                "children": [
                  { "type": "Text", "props": { "content": "• 21 built-in components" } },
                  { "type": "Text", "props": { "content": "• Streaming JSON rendering" } },
                  { "type": "Text", "props": { "content": "• Themeable and localizable" } }
                ]
              }
            ]
          }

        ]
      }
      """,
      size: CGSize(width: 360, height: 700)
    ),
    .init(
      name: "form-flow",
      json: """
      {
        "type": "Stack",
        "props": { "direction": "vertical", "spacing": 16, "alignment": "leading" },
        "children": [
          { "type": "Heading", "props": { "text": "Send payment", "level": 1 } },
          { "type": "Text", "props": { "content": "Choose a recipient and confirm the amount." } },
          {
            "type": "Card",
            "props": { "title": "Details", "padding": 16 },
            "children": [
              { "type": "AmountInput", "props": { "label": "Amount", "placeholder": "0,00", "currency": "BRL" } },
              {
                "type": "ChoiceList",
                "props": {
                  "question": "Speed",
                  "options": [
                    { "id": "standard", "label": "Standard", "description": "Free" },
                    { "id": "fast", "label": "Instant", "description": "R$ 4,99" }
                  ]
                }
              }
            ]
          },
          {
            "type": "Stack",
            "props": { "direction": "horizontal", "spacing": 12, "alignment": "leading" },
            "children": [
              { "type": "Button", "props": { "label": "Review", "style": "primary" } },
              { "type": "Button", "props": { "label": "Cancel", "style": "secondary" } }
            ]
          }
        ]
      }
      """,
      size: CGSize(width: 360, height: 760)
    ),
    .init(
      name: "alerts-choices",
      json: """
      {
        "type": "Stack",
        "props": { "direction": "vertical", "spacing": 16, "alignment": "leading" },
        "children": [
          { "type": "Heading", "props": { "text": "Account Alerts", "level": 2 } },
          {
            "type": "Alert",
            "props": {
              "title": "Identity verification",
              "message": "Verify your documents to unlock transfers.",
              "severity": "warning",
              "action": { "label": "Start", "name": "start_kyc" }
            }
          },
          {
            "type": "Alert",
            "props": {
              "title": "Scheduled maintenance",
              "message": "Transfers pause at 02:00 UTC.",
              "severity": "info"
            }
          },
          {
            "type": "ChoiceList",
            "props": {
              "question": "Notification frequency",
              "options": [
                { "id": "realtime", "label": "Real-time" },
                { "id": "daily", "label": "Daily summary" },
                { "id": "weekly", "label": "Weekly summary" }
              ]
            }
          }
        ]
      }
      """,
      size: CGSize(width: 360, height: 700)
    ),
    .init(
      name: "financial-dashboard",
      json: """
      {
        "type": "Stack",
        "props": { "direction": "vertical", "spacing": 16, "alignment": "leading" },
        "children": [
          { "type": "Heading", "props": { "text": "Portfolio", "level": 1 } },
          { "type": "BalanceCard", "props": { "brl": 256000, "btc": 5200000, "usdt": 800000, "showChange": true, "brlChange": 1.8 } },
          { "type": "AssetPrice", "props": { "symbol": "BTC", "price": 240000.00, "change": 2500, "changePercent": 1.2 } },
          { "type": "PieChart", "props": { "title": "Allocation", "segments": [ { "label": "BTC", "value": 60, "color": "#FFB100" }, { "label": "USDT", "value": 25, "color": "#5CB85C" }, { "label": "BRL", "value": 15, "color": "#3B82F6" } ] } },
          { "type": "LineChart", "props": { "title": "Price trend", "points": [ { "x": "Mon", "y": 10 }, { "x": "Tue", "y": 14 }, { "x": "Wed", "y": 9 }, { "x": "Thu", "y": 16 }, { "x": "Fri", "y": 12 } ] } },
          {
            "type": "TransactionList",
            "props": {
              "transactions": [
                { "description": "Coffee", "amount": -1500, "date": "2026-01-15", "category": "Food" },
                { "description": "Salary", "amount": 250000, "date": "2026-01-01", "category": "Income" },
                { "description": "Rent", "amount": -120000, "date": "2026-01-03", "category": "Housing" }
              ]
            }
          }
        ]
      }
      """,
      size: CGSize(width: 360, height: 840)
    ),
  ]
}

@main
struct PreviewSnapshotGenerator {
  static func main() async throws {
    let outputPath = outputDirectory()
    let outputURL = URL(fileURLWithPath: outputPath, isDirectory: true)

    guard outputURL.path.hasPrefix("/") else {
      throw SnapshotGeneratorError.invalidOutput(outputPath)
    }

    try FileManager.default.createDirectory(at: outputURL, withIntermediateDirectories: true)

    #if canImport(AppKit)
      await MainActor.run {
        _ = NSApplication.shared
        NSApp.setActivationPolicy(.prohibited)
      }
    #endif

    let registry = ComponentRegistry()
    registry.register(module: BuiltInComponentsModule())

    for spec in SnapshotSpec.all {
      let view = JSONView(spec.json)
        .componentRegistry(registry)
        .padding(20)
        .frame(width: spec.size.width, height: spec.size.height, alignment: .topLeading)
        .background(Color.white)

      let framedView = PhoneFrameView(content: view, contentSize: spec.size)

      try await render(view: framedView, name: spec.name, outputDirectory: outputURL)
    }
  }

  private static func render<V: View>(
    view: V,
    name: String,
    outputDirectory: URL
  ) async throws {
    let image = await MainActor.run { () -> CGImage? in
      let renderer = ImageRenderer(content: view)
      renderer.scale = 2
      return renderer.cgImage
    }

    guard let image else {
      throw SnapshotGeneratorError.missingImage(name)
    }

    #if canImport(AppKit)
      let bitmap = NSBitmapImageRep(cgImage: image)
      guard let data = bitmap.representation(using: .png, properties: [:]) else {
        throw SnapshotGeneratorError.missingImage(name)
      }
      let outputURL = outputDirectory.appendingPathComponent("\(name).png")
      try data.write(to: outputURL)
      print("Wrote \(outputURL.path)")
    #else
      throw SnapshotGeneratorError.missingImage(name)
    #endif
  }

  private static func outputDirectory() -> String {
    let args = CommandLine.arguments
    if let outputIndex = args.firstIndex(of: "--output"), outputIndex + 1 < args.count {
      return args[outputIndex + 1]
    }
    return "docs/images"
  }
}

private struct PhoneFrameView<Content: View>: View {
  let content: Content
  let contentSize: CGSize

  private var frameSize: CGSize {
    CGSize(width: 390, height: 844)
  }

  private var cornerRadius: CGFloat { 56 }

  private var screenInsets: EdgeInsets {
    EdgeInsets(top: 32, leading: 22, bottom: 32, trailing: 22)
  }

  private var availableSize: CGSize {
    CGSize(
      width: frameSize.width - (screenInsets.leading + screenInsets.trailing) - 24,
      height: frameSize.height - (screenInsets.top + screenInsets.bottom) - 24
    )
  }

  private var contentScale: CGFloat {
    let widthScale = availableSize.width / max(contentSize.width, 1)
    return min(widthScale, 1)
  }

  var body: some View {
    ZStack {
      RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
        .fill(Color.black)

      RoundedRectangle(cornerRadius: cornerRadius - 6, style: .continuous)
        .fill(Color.white)
        .padding(6)

      RoundedRectangle(cornerRadius: cornerRadius - 12, style: .continuous)
        .fill(Color(white: 0.98))
        .padding(12)

      content
        .scaleEffect(contentScale, anchor: .topLeading)
        .frame(
          width: contentSize.width * contentScale,
          height: contentSize.height * contentScale,
          alignment: .topLeading
        )
        .padding(screenInsets)
        .frame(width: frameSize.width - 24, height: frameSize.height - 24, alignment: .topLeading)
        .clipped()
    }
    .frame(width: frameSize.width, height: frameSize.height)
    .background(Color(white: 0.95))
  }
}
