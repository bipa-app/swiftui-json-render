import SwiftUI

/// `action` — Tappable button / action row.
///
/// Styles: "primary" (filled), "secondary" (surface bg), "destructive" (error filled).
///
/// ```json
/// { "type": "action", "props": { "label": "Comprar Bitcoin", "icon": "btc", "style": "primary", "action": { "name": "buy_btc" } } }
/// ```
public struct ActionBuilder: ComponentBuilder {
  public static var typeName: String { "action" }

  @MainActor
  public static func build(node: ComponentNode, context: RenderContext) -> AnyView {
    let label = node.string("label") ?? ""
    let icon = node.string("icon")
    let style = node.string("style") ?? "primary"

    return AnyView(
      ActionView(
        label: label,
        icon: icon,
        style: style,
        actionValue: node.props?["action"],
        context: context
      )
    )
  }
}

private struct ActionView: View {
  let label: String
  let icon: String?
  let style: String
  let actionValue: AnyCodable?
  let context: RenderContext

  private var isPrimary: Bool { style == "primary" }
  private var isDestructive: Bool { style == "destructive" }

  private var bgColor: Color {
    if isPrimary { return context.primaryColor }
    if isDestructive { return context.errorColor }
    return context.surfaceColor
  }

  private var fgColor: Color {
    if isPrimary { return context.buttonPrimaryForeground }
    if isDestructive { return context.buttonDestructiveForeground }
    return context.textPrimary
  }

  var body: some View {
    Button {
      context.handleAction(actionValue)
    } label: {
      HStack(spacing: context.spacingSM) {
        if let icon {
          Image(systemName: IconResolver.sfSymbol(for: icon))
            .font(.body)
        }
        Text(label)
          .font(context.bodyFont)
      }
      .foregroundStyle(fgColor)
      .frame(maxWidth: .infinity)
      .padding(.vertical, context.spacingSM)
      .padding(.horizontal, context.spacingMD)
      .background(
        Capsule().fill(bgColor)
      )
    }
    .buttonStyle(.plain)
  }
}
