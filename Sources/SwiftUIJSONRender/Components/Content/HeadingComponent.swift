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
private struct HeadingProps: Decodable {
  let text: String?
  let level: Int?
}

public struct HeadingBuilder: ComponentBuilder {
  public static var typeName: String { "Heading" }

  public static func build(node: ComponentNode, context: RenderContext) -> AnyView {
    let props = node.decodeProps(HeadingProps.self)
    let text = props?.text ?? node.string("text") ?? ""
    let level = props?.level ?? node.int("level") ?? 1

    let font = headingFont(for: level, context: context)

    return AnyView(
      Text(text)
        .font(font)
        .foregroundStyle(context.textPrimary)
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
