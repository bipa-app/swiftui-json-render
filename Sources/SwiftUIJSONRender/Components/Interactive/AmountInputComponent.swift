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
private struct AmountInputProps: Decodable {
  let label: String?
  let placeholder: String?
  let currency: String?
  let action: Action?
}

public struct AmountInputBuilder: ComponentBuilder {
  public static var typeName: String { "AmountInput" }

  public static func build(node: ComponentNode, context: RenderContext) -> AnyView {
    let props = node.decodeProps(AmountInputProps.self)
    let label = props?.label ?? node.string("label")
    let placeholder = props?.placeholder ?? node.string("placeholder") ?? ""
    let currency = props?.currency ?? node.string("currency", default: "BRL")
    let action = props?.action ?? Action.from(node.props?["action"])

    return AnyView(
      AmountInputView(
        label: label,
        placeholder: placeholder,
        currency: currency,
        action: action,
        context: context
      )
    )
  }
}

private struct AmountInputView: View {
  let label: String?
  let placeholder: String
  let currency: String
  let action: Action?
  let context: RenderContext

  @State private var text: String = ""

  var body: some View {
    VStack(alignment: .leading, spacing: context.spacingXS) {
      if let label = label {
        Text(label)
          .font(context.captionFont)
          .foregroundStyle(context.textSecondary)
      }

      HStack {
        Text(currency)
          .font(context.bodyFont)
          .foregroundStyle(context.textSecondary)
        Group {
          #if os(iOS)
            TextField(placeholder, text: $text)
              .keyboardType(.decimalPad)
          #else
            TextField(placeholder, text: $text)
          #endif
        }
        .font(context.bodyFont)
        .foregroundStyle(context.textPrimary)
        .onSubmit {
          if let action {
            context.handle(action)
          }
        }
      }
      .padding(context.spacingSM)
      .background(context.surfaceColor)
      .clipShape(.rect(cornerRadius: context.radiusSM))
    }
  }
}
