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
private struct IconProps: Decodable {
  let name: String?
  let size: Double?
  let color: String?
}

public struct IconBuilder: ComponentBuilder {
  public static var typeName: String { "Icon" }

  public static func build(node: ComponentNode, context: RenderContext) -> AnyView {
    let props = node.decodeProps(IconProps.self)
    let name = props?.name ?? node.string("name") ?? context.defaultIconName
    let size = CGFloat(props?.size ?? node.double("size") ?? Double(context.defaultIconSize))
    let color = ColorParser.parse(
      props?.color ?? node.string("color"), default: context.textPrimary, context: context)

    return AnyView(
      Image(systemName: name)
        .font(.system(size: size))
        .foregroundStyle(color)
    )
  }
}
