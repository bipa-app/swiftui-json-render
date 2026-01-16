import SwiftUI

/// Renders a Stack component (VStack or HStack).

public enum StackDirection: String, Sendable, Codable, CaseIterable {
  case vertical
  case horizontal
}

public enum StackAlignment: String, Sendable, Codable, CaseIterable {
  case leading
  case center
  case trailing
}
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
private struct StackProps: Decodable {
  let direction: StackDirection?
  let spacing: Double?
  let alignment: StackAlignment?
}

public struct StackBuilder: ComponentBuilder {
  public static var typeName: String { "Stack" }

  public static func build(node: ComponentNode, context: RenderContext) -> AnyView {
    let props = node.decodeProps(StackProps.self)
    let direction = props?.direction ?? node.enumValue("direction", default: StackDirection.vertical)
    let spacing = CGFloat(props?.spacing ?? node.double("spacing") ?? Double(context.spacingSM))
    let alignment = parseAlignment(
      props?.alignment ?? node.enumValue("alignment", default: StackAlignment.center)
    )

    let children = context.renderChildren(node.children)

    if direction == .horizontal {
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

  private static func parseAlignment(_ value: StackAlignment) -> (
    horizontal: HorizontalAlignment, vertical: VerticalAlignment
  ) {
    switch value {
    case .leading:
      return (.leading, .top)
    case .trailing:
      return (.trailing, .bottom)
    case .center:
      return (.center, .center)
    }
  }
}
