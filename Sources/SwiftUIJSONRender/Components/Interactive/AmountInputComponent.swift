import SwiftUI

/// Renders an AmountInput component.
///
/// ## JSON Example
/// ```json
/// {
///   "type": "AmountInput",
///   "props": {
///     "label": "Amount",
///     "placeholder": "0,00",
///     "currency": "BRL",
///     "action": { "name": "submit_amount" }
///   }
/// }
/// ```
///
/// ## Props
/// - `label`: Optional label text
/// - `placeholder`: Placeholder text
/// - `currency`: Currency code (default: "BRL")
/// - `action`: Optional action to trigger on submit
public struct AmountInputBuilder: ComponentBuilder {
  public static var typeName: String { "AmountInput" }

  public static func build(node: ComponentNode, context: RenderContext) -> AnyView {
    let label = node.string("label")
    let placeholder = node.string("placeholder") ?? ""
    let currency = node.string("currency", default: "BRL")
    let actionValue = node.props?["action"]

    return AnyView(
      AmountInputView(
        label: label,
        placeholder: placeholder,
        currency: currency,
        actionValue: actionValue,
        context: context
      )
    )
  }
}

private struct AmountInputView: View {
  let label: String?
  let placeholder: String
  let currency: String
  let actionValue: AnyCodable?
  let context: RenderContext

  @State private var text: String = ""

  var body: some View {
    VStack(alignment: .leading, spacing: context.spacingXS) {
      if let label = label {
        Text(label)
          .font(context.captionFont)
          .foregroundColor(context.textSecondary)
      }

      HStack {
        Text(currency)
          .font(context.bodyFont)
          .foregroundColor(context.textSecondary)
        Group {
          #if os(iOS)
            TextField(placeholder, text: $text)
              .keyboardType(.decimalPad)
          #else
            TextField(placeholder, text: $text)
          #endif
        }
        .font(context.bodyFont)
        .foregroundColor(context.textPrimary)
        .onSubmit { context.handleAction(actionValue) }
      }
      .padding(context.spacingSM)
      .background(context.surfaceColor)
      .clipShape(.rect(cornerRadius: context.radiusSM))
    }
  }
}
