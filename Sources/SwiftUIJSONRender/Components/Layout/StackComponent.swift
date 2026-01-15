import SwiftUI

/// Renders a Stack component (VStack or HStack).
///
/// ## JSON Example
/// ```json
/// {
///   "type": "Stack",
///   "props": {
///     "direction": "vertical",
///     "spacing": 16,
///     "alignment": "leading"
///   },
///   "children": [...]
/// }
/// ```
///
/// ## Props
/// - `direction`: "vertical" (default) or "horizontal"
/// - `spacing`: Number for spacing between children (default: 8)
/// - `alignment`: "leading", "center" (default), or "trailing"
public struct StackBuilder: ComponentBuilder {
  public static var typeName: String { "Stack" }

  public static func build(node: ComponentNode, context: RenderContext) -> AnyView {
    let direction = node.string("direction", default: "vertical")
    let spacing = CGFloat(node.double("spacing") ?? Double(context.spacingSM))
    let alignment = parseAlignment(node.string("alignment"))

    let children = context.renderChildren(node.children)

    if direction == "horizontal" {
      return AnyView(
        HStack(alignment: alignment.vertical, spacing: spacing) {
          ForEach(Array(children.enumerated()), id: \.offset) { _, child in
            child
          }
        }
      )
    } else {
      return AnyView(
        VStack(alignment: alignment.horizontal, spacing: spacing) {
          ForEach(Array(children.enumerated()), id: \.offset) { _, child in
            child
          }
        }
      )
    }
  }

  private static func parseAlignment(_ value: String?) -> (
    horizontal: HorizontalAlignment, vertical: VerticalAlignment
  ) {
    switch value?.lowercased() {
    case "leading":
      return (.leading, .top)
    case "trailing":
      return (.trailing, .bottom)
    case "center":
      return (.center, .center)
    default:
      return (.center, .center)
    }
  }
}
