import Foundation

enum FinancialFormatter {
  static func formatBRL(cents: Int) -> String {
    let amount = Double(cents) / 100.0
    return formatCurrency(amount: amount, code: "BRL")
  }

  static func formatBRLAmount(_ amount: Double) -> String {
    formatCurrency(amount: amount, code: "BRL")
  }

  static func formatBTC(satoshis: Int) -> String {
    let btc = Double(satoshis) / 100_000_000.0
    let formatted = formatNumber(
      value: btc,
      minimumFractionDigits: 2,
      maximumFractionDigits: 8
    )
    return "\(formatted) BTC"
  }

  static func formatUSDT(micros: Int) -> String {
    let usdt = Double(micros) / 1_000_000.0
    let formatted = formatNumber(
      value: usdt,
      minimumFractionDigits: 2,
      maximumFractionDigits: 2
    )
    return "\(formatted) USDT"
  }

  static func formatPercent(_ percent: Double) -> String {
    let formatted = formatNumber(
      value: percent,
      minimumFractionDigits: 2,
      maximumFractionDigits: 2
    )
    return "\(formatted)%"
  }

  private static func formatCurrency(amount: Double, code: String) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.currencyCode = code
    return formatter.string(from: NSNumber(value: amount)) ?? "\(amount)"
  }

  private static func formatNumber(
    value: Double,
    minimumFractionDigits: Int,
    maximumFractionDigits: Int
  ) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.minimumFractionDigits = minimumFractionDigits
    formatter.maximumFractionDigits = maximumFractionDigits
    return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
  }
}
