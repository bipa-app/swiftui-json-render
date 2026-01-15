import SwiftUI

/// Renders a Text component.
///
/// ## JSON Example
/// ```json
/// {
///   "type": "Text",
///   "props": {
///     "content": "Hello, World!",
///     "style": "body",
///     "weight": "semibold",
///     "color": "#FF5733"
///   }
/// }
/// ```
///
/// ## Props
/// - `content`: The text to display (required)
/// - `style`: "body" (default), "caption", "footnote", "headline", "title", "largeTitle"
/// - `weight`: "regular" (default), "medium", "semibold", "bold"
/// - `color`: Hex color string (e.g., "#FF5733") or named color
public struct TextBuilder: ComponentBuilder {
  public static var typeName: String { "Text" }

  public static func build(node: ComponentNode, context: RenderContext) -> AnyView {
    let content = node.string("content") ?? ""
    let style = node.string("style", default: "body")
    let weight = node.string("weight", default: "regular")
    let colorString = node.string("color")

    let font = parseFont(style: style, context: context)
    let fontWeight = parseFontWeight(weight)
    let color = parseColor(colorString, context: context)

    return AnyView(
      Text(content)
        .font(font)
        .fontWeight(fontWeight)
        .foregroundColor(color)
    )
  }

  private static func parseFont(style: String, context: RenderContext) -> Font {
    switch style.lowercased() {
    case "caption":
      return context.captionFont
    case "footnote":
      return .footnote
    case "headline":
      return context.headingFont
    case "title":
      return .title
    case "largetitle":
      return .largeTitle
    case "subheadline":
      return .subheadline
    default:
      return context.bodyFont
    }
  }

  private static func parseFontWeight(_ weight: String) -> Font.Weight {
    switch weight.lowercased() {
    case "medium":
      return .medium
    case "semibold":
      return .semibold
    case "bold":
      return .bold
    case "heavy":
      return .heavy
    case "light":
      return .light
    case "thin":
      return .thin
    default:
      return .regular
    }
  }

  private static func parseColor(_ colorString: String?, context: RenderContext) -> Color {
    guard let colorString = colorString else {
      return context.textPrimary
    }

    // Handle hex colors
    if colorString.hasPrefix("#") {
      return Color(hex: colorString) ?? context.textPrimary
    }

    // Handle named colors
    switch colorString.lowercased() {
    case "primary":
      return context.textPrimary
    case "secondary":
      return context.textSecondary
    case "error", "red":
      return context.errorColor
    case "success", "green":
      return context.successColor
    case "warning", "orange":
      return context.warningColor
    default:
      return context.textPrimary
    }
  }
}

// MARK: - Color Hex Extension

extension Color {
  fileprivate init?(hex: String) {
    var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
    hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

    var rgb: UInt64 = 0

    guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else {
      return nil
    }

    let length = hexSanitized.count

    switch length {
    case 6:
      self.init(
        red: Double((rgb & 0xFF0000) >> 16) / 255.0,
        green: Double((rgb & 0x00FF00) >> 8) / 255.0,
        blue: Double(rgb & 0x0000FF) / 255.0
      )
    case 8:
      self.init(
        red: Double((rgb & 0xFF00_0000) >> 24) / 255.0,
        green: Double((rgb & 0x00FF_0000) >> 16) / 255.0,
        blue: Double((rgb & 0x0000_FF00) >> 8) / 255.0,
        opacity: Double(rgb & 0x0000_00FF) / 255.0
      )
    default:
      return nil
    }
  }
}
