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
private struct TransactionListProps: Decodable {
  let transactions: [TransactionItem]
}

public struct TransactionListBuilder: ComponentBuilder {
  public static var typeName: String { "TransactionList" }

  public static func build(node: ComponentNode, context: RenderContext) -> AnyView {
    let props = node.decodeProps(TransactionListProps.self)
    let transactions = props?.transactions ?? parseTransactions(node.array("transactions"))

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

  private static func parseTransactions(_ array: [Any]?) -> [TransactionItem] {
    guard let array = array else { return [] }
    return array.compactMap { item in
      guard let dict = item as? [String: Any] else { return nil }
      return TransactionItem(dict: dict)
    }
  }
}

private struct TransactionItem: Decodable {
  let description: String
  let amount: Int
  let date: String
  let category: String?
  let icon: String?

  private enum CodingKeys: String, CodingKey {
    case description
    case amount
    case date
    case category
    case icon
  }

  init(description: String, amount: Int, date: String, category: String?, icon: String?) {
    self.description = description
    self.amount = amount
    self.date = date
    self.category = category
    self.icon = icon
  }

  init?(dict: [String: Any]) {
    self.description = dict["description"] as? String ?? "Transaction"
    self.amount = dict["amount"] as? Int ?? 0
    self.date = dict["date"] as? String ?? ""
    self.category = dict["category"] as? String
    self.icon = dict["icon"] as? String
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    description = try container.decodeIfPresent(String.self, forKey: .description) ?? "Transaction"
    amount = try container.decodeIfPresent(Int.self, forKey: .amount) ?? 0
    date = try container.decodeIfPresent(String.self, forKey: .date) ?? ""
    category = try container.decodeIfPresent(String.self, forKey: .category)
    icon = try container.decodeIfPresent(String.self, forKey: .icon)
  }
}

private struct TransactionRowView: View {
  let transaction: TransactionItem
  let context: RenderContext

  var body: some View {
    HStack(spacing: context.spacingSM) {
      if let icon = transaction.icon {
        Image(systemName: icon)
          .foregroundStyle(context.primaryColor)
      }

      VStack(alignment: .leading, spacing: context.spacingXS) {
        Text(transaction.description)
          .font(context.bodyFont)
          .foregroundStyle(context.textPrimary)
        if let category = transaction.category, !category.isEmpty {
          Text(category)
            .font(context.captionFont)
            .foregroundStyle(context.textSecondary)
        }
      }

      Spacer()

      VStack(alignment: .trailing, spacing: context.spacingXS) {
        Text(FinancialFormatter.formatBRL(cents: transaction.amount))
          .font(context.bodyFont)
          .foregroundStyle(transaction.amount < 0 ? context.errorColor : context.successColor)
        if !transaction.date.isEmpty {
          Text(transaction.date)
            .font(context.captionFont)
            .foregroundStyle(context.textSecondary)
        }
      }
    }
    .padding(.vertical, context.spacingSM)
  }

}
