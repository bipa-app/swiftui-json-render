import SwiftUI

/// Renders a Divider component.
///
/// ## JSON Example
/// ```json
/// {
///   "type": "Divider",
///   "props": {
///     "orientation": "horizontal",
///     "thickness": 1,
///     "color": "#E5E7EB",
///     "padding": 8,
///     "length": 200
///   }
/// }
/// ```
///
/// ## Props
/// - `orientation`: "horizontal" (default) or "vertical"
/// - `thickness`: Divider thickness (default: 1)
/// - `color`: Hex or named color (default: theme textSecondary)
/// - `padding`: Padding around divider (default: 0)
/// - `length`: Optional length for divider (width for horizontal, height for vertical)
public struct DividerBuilder: ComponentBuilder {
  public static var typeName: String { "Divider" }

  public static func build(node: ComponentNode, context: RenderContext) -> AnyView {
    let orientation = node.string("orientation", default: "horizontal").lowercased()
    let thickness = CGFloat(node.double("thickness") ?? 1)
    let padding = CGFloat(node.double("padding") ?? 0)
    let length = node.double("length")
    let color = ColorParser.parse(node.string("color"), default: context.textSecondary, context: context)

    let base = Rectangle().fill(color)

    let divider: AnyView
    if orientation == "vertical" {
      divider = AnyView(
        base
          .frame(width: thickness, height: length.map { CGFloat($0) })
          .frame(maxHeight: length == nil ? .infinity : nil)
      )
    } else {
      divider = AnyView(
        base
          .frame(width: length.map { CGFloat($0) }, height: thickness)
          .frame(maxWidth: length == nil ? .infinity : nil)
      )
    }

    if padding > 0 {
      return AnyView(divider.padding(padding))
    }

    return divider
  }
}
