import SwiftUI

/// Renders a Divider component.

public enum DividerOrientation: String, Sendable, Codable, CaseIterable {
  case horizontal
  case vertical
}
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
private struct DividerProps: Decodable {
  let orientation: DividerOrientation?
  let thickness: Double?
  let padding: Double?
  let length: Double?
  let color: String?
}

public struct DividerBuilder: ComponentBuilder {
  public static var typeName: String { "Divider" }

  public static func build(node: ComponentNode, context: RenderContext) -> AnyView {
    let props = node.decodeProps(DividerProps.self)
    let orientation = props?.orientation
      ?? node.enumValue("orientation", default: DividerOrientation.horizontal)
    let thickness = CGFloat(props?.thickness ?? node.double("thickness") ?? 1)
    let padding = CGFloat(props?.padding ?? node.double("padding") ?? 0)
    let length = props?.length ?? node.double("length")
    let color = ColorParser.parse(
      props?.color ?? node.string("color"), default: context.textSecondary, context: context)

    let base = Rectangle().fill(color)

    let divider: AnyView
    if orientation == .vertical {
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
