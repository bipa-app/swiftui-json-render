import SwiftUI

/// Renders an Alert/Banner component.
///
/// ## JSON Example
/// ```json
/// {
///   "type": "Alert",
///   "props": {
///     "title": "Success!",
///     "message": "Your changes have been saved.",
///     "severity": "success",
///     "dismissible": true,
///     "action": {
///       "label": "Undo",
///       "name": "undo_save"
///     }
///   }
/// }
/// ```
///
/// ## Props
/// - `title`: Alert title (required)
/// - `message`: Optional message text
/// - `severity`: "info" (default), "success", "warning", "error"
/// - `dismissible`: Whether to show a dismiss button (default: false)
/// - `action`: Optional action with `label` and action details
public struct AlertBuilder: ComponentBuilder {
  public static var typeName: String { "Alert" }

  public static func build(node: ComponentNode, context: RenderContext) -> AnyView {
    let title = node.string("title") ?? context.defaultAlertTitle
    let message = node.string("message")
    let severity = node.string("severity", default: "info")
    let dismissible = node.bool("dismissible") ?? false
    let actionValue = node.props?["action"]

    return AnyView(
      AlertView(
        title: title,
        message: message,
        severity: severity,
        dismissible: dismissible,
        actionValue: actionValue,
        context: context
      )
    )
  }
}

// MARK: - Alert View

private struct AlertView: View {
  let title: String
  let message: String?
  let severity: String
  let dismissible: Bool
  let actionValue: AnyCodable?
  let context: RenderContext

  @State private var isVisible = true

  var body: some View {
    if isVisible {
      HStack(alignment: .top, spacing: context.spacingSM) {
        // Icon
        Image(systemName: iconName)
          .font(.title3)
          .foregroundColor(severityColor)

        // Content
        VStack(alignment: .leading, spacing: context.spacingXS) {
          Text(title)
            .font(context.headingFont)
            .foregroundColor(context.textPrimary)

          if let message = message {
            Text(message)
              .font(context.bodyFont)
              .foregroundColor(context.textSecondary)
          }

          // Action button
          if let actionDict = actionValue?.dictionaryValue,
            let actionLabel = actionDict["label"] as? String
          {
            Button(actionLabel) {
              context.handleAction(actionValue)
            }
            .font(context.bodyFont)
            .foregroundColor(severityColor)
            .padding(.top, context.spacingXS)
          }
        }

        Spacer()

        // Dismiss button
        if dismissible {
          Button {
            withAnimation {
              isVisible = false
            }
          } label: {
            Image(systemName: "xmark")
              .font(.caption)
              .foregroundColor(context.textSecondary)
          }
        }
      }
      .padding(context.spacingMD)
      .background(severityColor.opacity(context.alertBackgroundOpacity))
      .clipShape(.rect(cornerRadius: context.radiusMD))
      .overlay(
        RoundedRectangle(cornerRadius: context.radiusMD)
          .stroke(severityColor.opacity(context.alertBorderOpacity), lineWidth: context.borderWidth)
      )
    }
  }

  private var severityColor: Color {
    switch severity.lowercased() {
    case "success":
      return context.successColor
    case "warning":
      return context.warningColor
    case "error":
      return context.errorColor
    default:
      return context.primaryColor
    }
  }

  private var iconName: String {
    switch severity.lowercased() {
    case "success":
      return "checkmark.circle.fill"
    case "warning":
      return "exclamationmark.triangle.fill"
    case "error":
      return "xmark.circle.fill"
    default:
      return "info.circle.fill"
    }
  }
}
