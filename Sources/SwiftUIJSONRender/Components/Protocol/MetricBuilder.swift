import SwiftUI

/// `metric` — Hero number with label, caption, and icon.
///
/// ```json
/// { "type": "metric", "props": { "label": "Bitcoin", "value": "R$ 374.438", "caption": "+0.8%", "captionColor": "green", "icon": "btc" } }
/// ```
public struct MetricBuilder: ComponentBuilder {
  public static var typeName: String { "metric" }

  @MainActor
  public static func build(node: ComponentNode, context: RenderContext) -> AnyView {
    let label = node.string("label") ?? ""
    let value = node.string("value") ?? ""
    let caption = node.string("caption")
    let captionColor = node.string("captionColor")
    let icon = node.string("icon")

    return AnyView(
      MetricView(
        label: label,
        value: value,
        caption: caption,
        captionColor: ColorResolver.resolve(captionColor, context: context),
        icon: icon,
        context: context
      )
    )
  }
}

private struct MetricView: View {
  let label: String
  let value: String
  let caption: String?
  let captionColor: Color?
  let icon: String?
  let context: RenderContext

  var body: some View {
    HStack(spacing: context.spacingSM) {
      if let icon {
        IconResolver.view(for: icon, context: context)
          .font(.title3)
      }

      VStack(alignment: .leading, spacing: 2) {
        Text(label)
          .font(context.captionFont)
          .foregroundStyle(context.textSecondary)

        Text(value)
          .font(context.headingFont)
          .foregroundStyle(context.textPrimary)

        if let caption {
          Text(caption)
            .font(context.captionFont)
            .foregroundStyle(captionColor ?? context.textSecondary)
        }
      }

      Spacer(minLength: 0)
    }
  }
}
