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
      name: "stack",
      json: """
      {
        "type": "Stack",
        "props": { "direction": "vertical", "spacing": 8, "alignment": "leading" },
        "children": [
          { "type": "Text", "props": { "content": "Line 1" } },
          { "type": "Text", "props": { "content": "Line 2" } }
        ]
      }
      """,
      size: CGSize(width: 320, height: 120)
    ),
    .init(
      name: "card",
      json: """
      {
        "type": "Card",
        "props": { "title": "Card Title", "padding": 16 },
        "children": [
          { "type": "Text", "props": { "content": "Card content" } }
        ]
      }
      """,
      size: CGSize(width: 320, height: 140)
    ),
    .init(
      name: "divider",
      json: """
      { "type": "Divider", "props": { "thickness": 2, "color": "#DDDDDD" } }
      """,
      size: CGSize(width: 320, height: 40)
    ),
    .init(
      name: "spacer",
      json: """
      {
        "type": "Stack",
        "props": { "direction": "vertical", "spacing": 8 },
        "children": [
          { "type": "Text", "props": { "content": "Above" } },
          { "type": "Spacer", "props": { "size": 24 } },
          { "type": "Text", "props": { "content": "Below" } }
        ]
      }
      """,
      size: CGSize(width: 320, height: 140)
    ),
    .init(
      name: "text",
      json: """
      { "type": "Text", "props": { "content": "Hello, world!", "style": "headline" } }
      """,
      size: CGSize(width: 320, height: 80)
    ),
    .init(
      name: "heading",
      json: """
      { "type": "Heading", "props": { "text": "Section Title", "level": 2 } }
      """,
      size: CGSize(width: 320, height: 80)
    ),
    .init(
      name: "icon",
      json: """
      { "type": "Icon", "props": { "name": "star.fill", "size": 28, "color": "#FFB100" } }
      """,
      size: CGSize(width: 120, height: 120)
    ),
    .init(
      name: "image",
      json: """
      { "type": "Image", "props": { "url": "https://example.com/image.png", "contentMode": "fit", "width": 200, "height": 120 } }
      """,
      size: CGSize(width: 240, height: 160)
    ),
    .init(
      name: "button",
      json: """
      { "type": "Button", "props": { "label": "Continue", "style": "primary" } }
      """,
      size: CGSize(width: 320, height: 100)
    ),
    .init(
      name: "amount-input",
      json: """
      { "type": "AmountInput", "props": { "label": "Amount", "placeholder": "0,00", "currency": "BRL" } }
      """,
      size: CGSize(width: 320, height: 120)
    ),
    .init(
      name: "confirm-dialog",
      json: """
      {
        "type": "ConfirmDialog",
        "props": {
          "title": "Confirm",
          "message": "Proceed?",
          "confirmLabel": "Yes",
          "cancelLabel": "No",
          "triggerLabel": "Open"
        }
      }
      """,
      size: CGSize(width: 320, height: 120)
    ),
    .init(
      name: "choice-list",
      json: """
      {
        "type": "ChoiceList",
        "props": {
          "question": "Pick one",
          "options": [
            { "id": "1", "label": "Option A" },
            { "id": "2", "label": "Option B" },
            { "id": "3", "label": "Option C" }
          ]
        }
      }
      """,
      size: CGSize(width: 320, height: 200)
    ),
    .init(
      name: "alert",
      json: """
      { "type": "Alert", "props": { "title": "Heads up", "message": "Something happened.", "severity": "warning" } }
      """,
      size: CGSize(width: 320, height: 140)
    ),
    .init(
      name: "balance-card",
      json: """
      { "type": "BalanceCard", "props": { "brl": 120000, "btc": 4200000, "usdt": 500000, "showChange": true, "brlChange": 2.4 } }
      """,
      size: CGSize(width: 320, height: 180)
    ),
    .init(
      name: "transaction-row",
      json: """
      { "type": "TransactionRow", "props": { "description": "Coffee", "amount": -1500, "date": "2026-01-15", "category": "Food", "icon": "cup.and.saucer" } }
      """,
      size: CGSize(width: 320, height: 140)
    ),
    .init(
      name: "transaction-list",
      json: """
      {
        "type": "TransactionList",
        "props": {
          "transactions": [
            { "description": "Coffee", "amount": -1500, "date": "2026-01-15", "category": "Food" },
            { "description": "Salary", "amount": 250000, "date": "2026-01-01", "category": "Income" }
          ]
        }
      }
      """,
      size: CGSize(width: 320, height: 220)
    ),
    .init(
      name: "asset-price",
      json: """
      { "type": "AssetPrice", "props": { "symbol": "BTC", "price": 240000.00, "change": 2500, "changePercent": 1.2 } }
      """,
      size: CGSize(width: 320, height: 160)
    ),
    .init(
      name: "pie-chart",
      json: """
      {
        "type": "PieChart",
        "props": {
          "title": "Portfolio",
          "segments": [
            { "label": "BTC", "value": 60, "color": "#FFB100" },
            { "label": "USDT", "value": 25, "color": "#5CB85C" },
            { "label": "BRL", "value": 15, "color": "#3B82F6" }
          ]
        }
      }
      """,
      size: CGSize(width: 320, height: 240)
    ),
    .init(
      name: "line-chart",
      json: """
      {
        "type": "LineChart",
        "props": {
          "title": "Price trend",
          "points": [
            { "x": "Mon", "y": 10 },
            { "x": "Tue", "y": 14 },
            { "x": "Wed", "y": 9 },
            { "x": "Thu", "y": 16 },
            { "x": "Fri", "y": 12 }
          ]
        }
      }
      """,
      size: CGSize(width: 320, height: 240)
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

    let registry = ComponentRegistry()
    registry.register(module: BuiltInComponentsModule())

    for spec in SnapshotSpec.all {
      let view = JSONView(spec.json)
        .componentRegistry(registry)
        .padding(16)
        .frame(width: spec.size.width, height: spec.size.height, alignment: .topLeading)
        .background(Color.white)

      try await render(view: view, name: spec.name, outputDirectory: outputURL)
    }
  }

  private static func render<V: View>(
    view: V,
    name: String,
    outputDirectory: URL
  ) async throws {
    let image = try await MainActor.run { () -> CGImage? in
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
