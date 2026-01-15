import SwiftUI

/// Renders a TransactionRow component.
///
/// ## JSON Example
/// ```json
/// {
///   "type": "TransactionRow",
///   "props": {
///     "id": "tx_123",
///     "description": "PIX to Maria",
///     "amount": -50000,
///     "date": "2026-01-14",
///     "category": "transfer",
///     "icon": "arrow.up.right"
///   }
/// }
/// ```
///
/// ## Props
/// - `id`: Transaction identifier
/// - `description`: Description text
/// - `amount`: Amount in cents (negative = expense)
/// - `date`: ISO date string
/// - `category`: Optional category
/// - `icon`: Optional SF Symbol name
public struct TransactionRowBuilder: ComponentBuilder {
  public static var typeName: String { "TransactionRow" }

  public static func build(node: ComponentNode, context: RenderContext) -> AnyView {
    let description = node.string("description") ?? context.defaultTransactionDescription
    let amount = node.int("amount") ?? 0
    let date = node.string("date") ?? ""
    let category = node.string("category")
    let icon = node.string("icon")

    return AnyView(
      HStack(spacing: context.spacingSM) {
        if let icon = icon {
          Image(systemName: icon)
            .foregroundStyle(context.primaryColor)
        }

        VStack(alignment: .leading, spacing: context.spacingXS) {
          Text(description)
            .font(context.bodyFont)
            .foregroundStyle(context.textPrimary)
          if let category = category, !category.isEmpty {
            Text(category)
              .font(context.captionFont)
              .foregroundStyle(context.textSecondary)
          }
        }

        Spacer()

        VStack(alignment: .trailing, spacing: context.spacingXS) {
          Text(FinancialFormatter.formatBRL(cents: amount))
            .font(context.bodyFont)
            .foregroundStyle(amount < 0 ? context.errorColor : context.successColor)
          if !date.isEmpty {
            Text(date)
              .font(context.captionFont)
              .foregroundStyle(context.textSecondary)
          }
        }
      }
      .padding(.vertical, context.spacingSM)
    )
  }

}
