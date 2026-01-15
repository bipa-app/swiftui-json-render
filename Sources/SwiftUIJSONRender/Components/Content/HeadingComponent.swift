import SwiftUI

/// Renders a Heading component.
///
/// ## JSON Example
/// ```json
/// {
///   "type": "Heading",
///   "props": {
///     "text": "Section Title",
///     "level": 1
///   }
/// }
/// ```
///
/// ## Props
/// - `text`: The heading text (required)
/// - `level`: Heading level 1-3 (default: 1)
public struct HeadingBuilder: ComponentBuilder {
  public static var typeName: String { "Heading" }

  public static func build(node: ComponentNode, context: RenderContext) -> AnyView {
    let text = node.string("text") ?? ""
    let level = node.int("level") ?? 1

    let font = headingFont(for: level, context: context)

    return AnyView(
      Text(text)
        .font(font)
        .foregroundColor(context.textPrimary)
    )
  }

  private static func headingFont(for level: Int, context: RenderContext) -> Font {
    switch level {
    case 1:
      return .largeTitle
    case 2:
      return .title
    case 3:
      return .headline
    default:
      return context.headingFont
    }
  }
}
