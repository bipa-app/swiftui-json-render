import SwiftUI

/// Renders an AssetPrice component.
///
/// ## JSON Example
/// ```json
/// {
///   "type": "AssetPrice",
///   "props": {
///     "symbol": "BTC",
///     "price": 180000.23,
///     "change": 2.3,
///     "changePercent": 1.28
///   }
/// }
/// ```
///
/// ## Props
/// - `symbol`: Asset symbol (e.g., BTC)
/// - `price`: Current price
/// - `change`: Absolute change
/// - `changePercent`: Percentage change
public struct AssetPriceBuilder: ComponentBuilder {
  public static var typeName: String { "AssetPrice" }

  public static func build(node: ComponentNode, context: RenderContext) -> AnyView {
    let symbol = node.string("symbol") ?? "ASSET"
    let price = node.double("price") ?? 0
    let change = node.double("change")
    let changePercent = node.double("changePercent")

    return AnyView(
      HStack {
        VStack(alignment: .leading, spacing: context.spacingXS) {
          Text(symbol)
            .font(context.headingFont)
            .foregroundColor(context.textPrimary)
          Text(FinancialFormatter.formatBRLAmount(price))
            .font(context.bodyFont)
            .foregroundColor(context.textSecondary)
        }

        Spacer()

        if let changePercent = changePercent {
          let positive = changePercent >= 0
          VStack(alignment: .trailing, spacing: context.spacingXS) {
            if let change = change {
              Text(FinancialFormatter.formatBRLAmount(change))
                .font(context.bodyFont)
            }
            Text(FinancialFormatter.formatPercent(changePercent))
              .font(context.captionFont)
          }
          .foregroundColor(positive ? context.successColor : context.errorColor)
        }
      }
      .padding(context.spacingMD)
      .background(context.surfaceColor)
      .clipShape(.rect(cornerRadius: context.radiusMD))
    )
  }

}
