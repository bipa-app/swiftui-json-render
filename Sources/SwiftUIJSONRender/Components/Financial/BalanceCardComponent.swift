import SwiftUI

/// Renders a BalanceCard component.
///
/// ## JSON Example
/// ```json
/// {
///   "type": "BalanceCard",
///   "props": {
///     "brl": 1245032,
///     "btc": 234000,
///     "usdt": 50000000,
///     "showChange": true,
///     "brlChange": 5.2
///   }
/// }
/// ```
///
/// ## Props
/// - `brl`: Balance in cents (required)
/// - `btc`: Balance in satoshis (required)
/// - `usdt`: Balance in micros (optional)
/// - `showChange`: Show 24h change (optional)
/// - `brlChange`: Percentage change (optional)
public struct BalanceCardBuilder: ComponentBuilder {
  public static var typeName: String { "BalanceCard" }

  public static func build(node: ComponentNode, context: RenderContext) -> AnyView {
    let brl = node.int("brl") ?? 0
    let btc = node.int("btc") ?? 0
    let usdt = node.int("usdt")
    let showChange = node.bool("showChange") ?? false
    let brlChange = node.double("brlChange")

    return AnyView(
      VStack(alignment: .leading, spacing: context.spacingSM) {
        Text("Balances")
          .font(context.headingFont)
          .foregroundColor(context.textPrimary)

        BalanceRow(label: "BRL", value: FinancialFormatter.formatBRL(cents: brl), context: context)
        BalanceRow(
          label: "BTC", value: FinancialFormatter.formatBTC(satoshis: btc), context: context)
        if let usdt = usdt {
          BalanceRow(
            label: "USDT", value: FinancialFormatter.formatUSDT(micros: usdt), context: context)
        }

        if showChange, let brlChange = brlChange {
          HStack(spacing: context.spacingXS) {
            Image(systemName: brlChange >= 0 ? "arrow.up.right" : "arrow.down.right")
            Text(FinancialFormatter.formatPercent(brlChange))
          }
          .font(context.captionFont)
          .foregroundColor(brlChange >= 0 ? context.successColor : context.errorColor)
        }
      }
      .padding(context.spacingMD)
      .background(context.surfaceColor)
      .cornerRadius(context.radiusMD)
    )
  }

}

private struct BalanceRow: View {
  let label: String
  let value: String
  let context: RenderContext

  var body: some View {
    HStack {
      Text(label)
        .font(context.bodyFont)
        .foregroundColor(context.textSecondary)
      Spacer()
      Text(value)
        .font(context.bodyFont)
        .foregroundColor(context.textPrimary)
    }
  }
}
