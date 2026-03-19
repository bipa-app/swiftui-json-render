import SwiftUI

/// `action` — Tappable button / action row.
///
/// ```json
/// { "type": "action", "props": { "label": "Comprar Bitcoin", "icon": "btc", "style": "primary", "action": { "name": "message", "params": { "text": "Quero comprar BTC" } } } }
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

  private var bgColor: Color {
    switch style {
    case "primary": context.primaryColor
    case "destructive": context.errorColor
    default: context.surfaceColor
    }
  }

  private var fgColor: Color {
    switch style {
    case "primary": context.buttonPrimaryForeground
    case "destructive": context.buttonDestructiveForeground
    default: context.textPrimary
    }
  }

  var body: some View {
    Button {
      context.handleAction(actionValue)
    } label: {
      HStack(spacing: context.spacingSM) {
        if let icon {
          IconResolver.view(for: icon, context: context)
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
        RoundedRectangle(cornerRadius: context.radiusLG)
          .fill(bgColor)
      )
    }
    .buttonStyle(.plain)
  }
}
