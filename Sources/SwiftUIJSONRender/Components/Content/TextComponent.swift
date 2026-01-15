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
    let color = ColorParser.parse(colorString, default: context.textPrimary, context: context)

    return AnyView(
      Text(content)
        .font(font)
        .fontWeight(fontWeight)
        .foregroundStyle(color)
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

}
