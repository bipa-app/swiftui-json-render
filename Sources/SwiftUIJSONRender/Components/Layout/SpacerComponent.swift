import SwiftUI

/// Renders a Spacer component.
///
/// ## JSON Example
/// ```json
/// {
///   "type": "Spacer",
///   "props": {
///     "size": 24
///   }
/// }
/// ```
///
/// ## Props
/// - `size`: Optional minimum spacing length
public struct SpacerBuilder: ComponentBuilder {
  public static var typeName: String { "Spacer" }

  public static func build(node: ComponentNode, context: RenderContext) -> AnyView {
    let size = node.double("size").map { CGFloat($0) }
    let spacer = Spacer(minLength: size)
    return AnyView(spacer)
  }
}
