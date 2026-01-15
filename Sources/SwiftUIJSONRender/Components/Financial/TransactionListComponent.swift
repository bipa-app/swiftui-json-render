import SwiftUI

/// Renders a TransactionList component.
///
/// ## JSON Example
/// ```json
/// {
///   "type": "TransactionList",
///   "props": {
///     "transactions": [
///       { "id": "tx1", "description": "PIX to Maria", "amount": -50000, "date": "2026-01-14" }
///     ]
///   }
/// }
/// ```
///
/// ## Props
/// - `transactions`: Array of transaction objects
public struct TransactionListBuilder: ComponentBuilder {
  public static var typeName: String { "TransactionList" }

  public static func build(node: ComponentNode, context: RenderContext) -> AnyView {
    let transactions = parseTransactions(
      node.dictionary("transactions"), node.array("transactions"))

    return AnyView(
      VStack(alignment: .leading, spacing: 0) {
        ForEach(Array(transactions.enumerated()), id: \.offset) { index, transaction in
          TransactionRowView(transaction: transaction, context: context)
          if index < transactions.count - 1 {
            Divider()
          }
        }
      }
    )
  }

  private static func parseTransactions(
    _ dict: [String: Any]?,
    _ array: [Any]?
  ) -> [TransactionItem] {
    guard let array = array else { return [] }
    return array.compactMap { item in
      guard let dict = item as? [String: Any] else { return nil }
      return TransactionItem(dict: dict)
    }
  }
}

private struct TransactionItem {
  let description: String
  let amount: Int
  let date: String
  let category: String?
  let icon: String?

  init?(dict: [String: Any]) {
    self.description = dict["description"] as? String ?? "Transaction"
    self.amount = dict["amount"] as? Int ?? 0
    self.date = dict["date"] as? String ?? ""
    self.category = dict["category"] as? String
    self.icon = dict["icon"] as? String
  }
}

private struct TransactionRowView: View {
  let transaction: TransactionItem
  let context: RenderContext

  var body: some View {
    HStack(spacing: context.spacingSM) {
      if let icon = transaction.icon {
        Image(systemName: icon)
          .foregroundColor(context.primaryColor)
      }

      VStack(alignment: .leading, spacing: context.spacingXS) {
        Text(transaction.description)
          .font(context.bodyFont)
          .foregroundColor(context.textPrimary)
        if let category = transaction.category, !category.isEmpty {
          Text(category)
            .font(context.captionFont)
            .foregroundColor(context.textSecondary)
        }
      }

      Spacer()

      VStack(alignment: .trailing, spacing: context.spacingXS) {
        Text(FinancialFormatter.formatBRL(cents: transaction.amount))
          .font(context.bodyFont)
          .foregroundColor(transaction.amount < 0 ? context.errorColor : context.successColor)
        if !transaction.date.isEmpty {
          Text(transaction.date)
            .font(context.captionFont)
            .foregroundColor(context.textSecondary)
        }
      }
    }
    .padding(.vertical, context.spacingSM)
  }

}
