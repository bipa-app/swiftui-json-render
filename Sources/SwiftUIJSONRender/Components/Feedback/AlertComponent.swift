import SwiftUI

/// Renders an Alert/Banner component.

public enum AlertSeverity: String, Sendable, Codable, CaseIterable {
  case info
  case success
  case warning
  case error
}
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
private struct AlertProps: Decodable {
  let title: String?
  let message: String?
  let severity: AlertSeverity?
  let dismissible: Bool?
  let action: AlertAction?
}

private struct AlertAction: Decodable {
  let label: String?
  let action: Action?

  private enum CodingKeys: String, CodingKey {
    case label
    case name
    case params
    case confirm
  }

  init(label: String?, action: Action?) {
    self.label = label
    self.action = action
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    label = try container.decodeIfPresent(String.self, forKey: .label)
    let name = try container.decodeIfPresent(String.self, forKey: .name)
    let params = try container.decodeIfPresent([String: AnyCodable].self, forKey: .params)
    let confirm = try container.decodeIfPresent(ConfirmConfig.self, forKey: .confirm)
    if let name {
      action = Action(name: name, params: params, confirm: confirm)
    } else {
      action = nil
    }
  }
}

public struct AlertBuilder: ComponentBuilder {
  public static var typeName: String { "Alert" }

  public static func build(node: ComponentNode, context: RenderContext) -> AnyView {
    let props = node.decodeProps(AlertProps.self)
    let title = props?.title ?? node.string("title") ?? context.defaultAlertTitle
    let message = props?.message ?? node.string("message")
    let severity = props?.severity ?? node.enumValue("severity", default: AlertSeverity.info)
    let dismissible = props?.dismissible ?? node.bool("dismissible") ?? false
    let actionValue = props?.action ?? parseAlertAction(node.props?["action"])

    return AnyView(
      AlertView(
        title: title,
        message: message,
        severity: severity,
        dismissible: dismissible,
        action: actionValue,
        context: context
      )
    )
  }

  private static func parseAlertAction(_ value: AnyCodable?) -> AlertAction? {
    guard let dict = value?.dictionaryValue else { return nil }
    let label = dict["label"] as? String
    let action = Action.from(value)
    return AlertAction(label: label, action: action)
  }
}

// MARK: - Alert View

private struct AlertView: View {
  let title: String
  let message: String?
  let severity: AlertSeverity
  let dismissible: Bool
  let action: AlertAction?
  let context: RenderContext

  @State private var isVisible = true

  var body: some View {
    if isVisible {
      HStack(alignment: .top, spacing: context.spacingSM) {
        // Icon
        Image(systemName: iconName)
          .font(.title3)
          .foregroundStyle(severityColor)

        // Content
        VStack(alignment: .leading, spacing: context.spacingXS) {
          Text(title)
            .font(context.headingFont)
            .foregroundStyle(context.textPrimary)

          if let message = message {
            Text(message)
              .font(context.bodyFont)
              .foregroundStyle(context.textSecondary)
          }

          // Action button
          if let actionLabel = action?.label {
            Button(actionLabel) {
              if let action = action?.action {
                context.handle(action)
              }
            }
            .font(context.bodyFont)
            .foregroundStyle(severityColor)
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
              .foregroundStyle(context.textSecondary)
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
    switch severity {
    case .success:
      return context.successColor
    case .warning:
      return context.warningColor
    case .error:
      return context.errorColor
    case .info:
      return context.primaryColor
    }
  }

  private var iconName: String {
    switch severity {
    case .success:
      return "checkmark.circle.fill"
    case .warning:
      return "exclamationmark.triangle.fill"
    case .error:
      return "xmark.circle.fill"
    case .info:
      return "info.circle.fill"
    }
  }
}
