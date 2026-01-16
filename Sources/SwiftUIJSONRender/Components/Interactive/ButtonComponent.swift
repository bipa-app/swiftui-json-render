import SwiftUI

/// Renders a Button component.

public enum ButtonStyle: String, Sendable, Codable, CaseIterable {
  case primary
  case secondary
  case destructive
}
///
/// ## JSON Example
/// ```json
/// {
///   "type": "Button",
///   "props": {
///     "label": "Submit",
///     "style": "primary",
///     "icon": "paperplane.fill",
///     "disabled": false,
///     "action": {
///       "name": "submit_form",
///       "params": { "formId": "contact" }
///     }
///   }
/// }
/// ```
///
/// ## Props
/// - `label`: Button text (required)
/// - `style`: "primary" (default), "secondary", "destructive"
/// - `icon`: SF Symbol name (optional)
/// - `disabled`: Whether the button is disabled (default: false)
/// - `action`: Action to trigger when tapped
public struct ButtonBuilder: ComponentBuilder {
  public static var typeName: String { "Button" }

  public static func build(node: ComponentNode, context: RenderContext) -> AnyView {
    let label = node.string("label") ?? context.defaultButtonLabel
    let style = node.enumValue("style", default: ButtonStyle.primary)
    let icon = node.string("icon")
    let disabled = node.bool("disabled") ?? false
    let actionValue = node.props?["action"]

    return AnyView(
      ButtonView(
        label: label,
        style: style,
        icon: icon,
        disabled: disabled,
        actionValue: actionValue,
        context: context
      )
    )
  }
}

// MARK: - Button View

private struct ButtonView: View {
  let label: String
  let style: ButtonStyle
  let icon: String?
  let disabled: Bool
  let actionValue: AnyCodable?
  let context: RenderContext

  var body: some View {
    Button(action: handleTap) {
      HStack(spacing: context.spacingXS) {
        if let icon = icon {
          Image(systemName: icon)
        }
        Text(label)
      }
      .padding(.horizontal, context.spacingMD)
      .padding(.vertical, context.spacingSM)
      .frame(maxWidth: style == .primary ? .infinity : nil)
      .background(backgroundColor)
      .foregroundStyle(foregroundColor)
      .clipShape(.rect(cornerRadius: context.radiusSM))
    }
    .disabled(disabled)
    .opacity(disabled ? context.disabledOpacity : 1.0)
  }

  private var backgroundColor: Color {
    switch style {
    case .primary:
      return context.primaryColor
    case .secondary:
      return context.surfaceColor
    case .destructive:
      return context.errorColor
    }
  }

  private var foregroundColor: Color {
    switch style {
    case .primary:
      return context.buttonPrimaryForeground
    case .destructive:
      return context.buttonDestructiveForeground
    case .secondary:
      return context.textPrimary
    }
  }

  private func handleTap() {
    context.handleAction(actionValue)
  }
}
