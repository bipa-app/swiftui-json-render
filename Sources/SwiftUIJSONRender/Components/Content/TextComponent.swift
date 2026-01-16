import SwiftUI

/// Renders a Text component.

public enum TextStyle: String, Sendable, Codable {
  case body
  case caption
  case footnote
  case headline
  case title
  case largeTitle
  case subheadline
}

public enum TextWeight: String, Sendable, Codable {
  case regular
  case medium
  case semibold
  case bold
  case heavy
  case light
  case thin
}
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
    let style = node.enumValue("style", default: TextStyle.body)
    let weight = node.enumValue("weight", default: TextWeight.regular)
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

  private static func parseFont(style: TextStyle, context: RenderContext) -> Font {
    switch style {
    case .caption:
      return context.captionFont
    case .footnote:
      return .footnote
    case .headline:
      return context.headingFont
    case .title:
      return .title
    case .largeTitle:
      return .largeTitle
    case .subheadline:
      return .subheadline
    case .body:
      return context.bodyFont
    }
  }

  private static func parseFontWeight(_ weight: TextWeight) -> Font.Weight {
    switch weight {
    case .medium:
      return .medium
    case .semibold:
      return .semibold
    case .bold:
      return .bold
    case .heavy:
      return .heavy
    case .light:
      return .light
    case .thin:
      return .thin
    case .regular:
      return .regular
    }
  }

}
