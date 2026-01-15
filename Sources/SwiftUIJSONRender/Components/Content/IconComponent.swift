import SwiftUI

/// Renders an Icon component using SF Symbols.
///
/// ## JSON Example
/// ```json
/// {
///   "type": "Icon",
///   "props": {
///     "name": "star.fill",
///     "size": 20,
///     "color": "#FFB100"
///   }
/// }
/// ```
///
/// ## Props
/// - `name`: SF Symbol name (required)
/// - `size`: Icon size (default: 16)
/// - `color`: Hex or named color (default: theme textPrimary)
public struct IconBuilder: ComponentBuilder {
  public static var typeName: String { "Icon" }

  public static func build(node: ComponentNode, context: RenderContext) -> AnyView {
    let name = node.string("name") ?? "questionmark"
    let size = CGFloat(node.double("size") ?? 16)
    let color = ColorParser.parse(
      node.string("color"), default: context.textPrimary, context: context)

    return AnyView(
      Image(systemName: name)
        .font(.system(size: size))
        .foregroundColor(color)
    )
  }
}
