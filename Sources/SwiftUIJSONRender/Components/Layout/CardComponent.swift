import SwiftUI

/// Renders a Card component with optional title.
///
/// ## JSON Example
/// ```json
/// {
///   "type": "Card",
///   "props": {
///     "title": "My Card",
///     "padding": 16,
///     "cornerRadius": 12
///   },
///   "children": [...]
/// }
/// ```
///
/// ## Props
/// - `title`: Optional title string displayed at the top
/// - `padding`: Padding inside the card (default: 16)
/// - `cornerRadius`: Corner radius (default: 12)
public struct CardBuilder: ComponentBuilder {
  public static var typeName: String { "Card" }

  public static func build(node: ComponentNode, context: RenderContext) -> AnyView {
    let title = node.string("title")
    let padding = CGFloat(node.double("padding") ?? Double(context.spacingMD))
    let cornerRadius = CGFloat(node.double("cornerRadius") ?? Double(context.radiusMD))

    let children = context.renderChildren(node.children)

    return AnyView(
      VStack(alignment: .leading, spacing: context.spacingSM) {
        if let title = title {
          Text(title)
            .font(context.headingFont)
            .foregroundStyle(context.textPrimary)
        }

        ForEach(Array(children.enumerated()), id: \.offset) { _, child in
          child
        }
      }
      .padding(padding)
      .frame(maxWidth: .infinity, alignment: .leading)
      .background(context.surfaceColor)
      .clipShape(.rect(cornerRadius: cornerRadius))
    )
  }
}
