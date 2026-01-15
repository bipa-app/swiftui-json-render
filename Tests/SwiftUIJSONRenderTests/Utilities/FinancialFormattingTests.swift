import Foundation
import Testing

@testable import SwiftUIJSONRender

@Suite("FinancialFormatting Tests")
struct FinancialFormattingTests {

  // MARK: - BRL Formatting (cents)

  @Test("Format BRL from cents - basic amount")
  func testFormatBRLBasic() {
    let result = FinancialFormatter.formatBRL(cents: 12345)
    // 12345 cents = R$ 123.45 or 123,45 depending on locale
    #expect(result.contains("123"))
    #expect(result.contains("45"))
  }

  @Test("Format BRL from cents - zero")
  func testFormatBRLZero() {
    let result = FinancialFormatter.formatBRL(cents: 0)
    #expect(result.contains("0"))
  }

  @Test("Format BRL from cents - large amount")
  func testFormatBRLLarge() {
    let result = FinancialFormatter.formatBRL(cents: 1_000_000_00)  // 1 million BRL
    #expect(result.contains("1"))
    #expect(result.contains("000"))
  }

  @Test("Format BRL from cents - negative")
  func testFormatBRLNegative() {
    let result = FinancialFormatter.formatBRL(cents: -5000)
    #expect(result.contains("50"))
    #expect(result.contains("-") || result.contains("("))  // Negative indicator varies by locale
  }

  @Test("Format BRL from cents - small amount")
  func testFormatBRLSmall() {
    let result = FinancialFormatter.formatBRL(cents: 1)
    #expect(result.contains("0"))
    #expect(result.contains("01"))
  }

  // MARK: - BRL Amount Formatting (double)

  @Test("Format BRL amount - basic")
  func testFormatBRLAmountBasic() {
    let result = FinancialFormatter.formatBRLAmount(123.45)
    #expect(result.contains("123"))
    #expect(result.contains("45"))
  }

  @Test("Format BRL amount - whole number")
  func testFormatBRLAmountWholeNumber() {
    let result = FinancialFormatter.formatBRLAmount(100.00)
    #expect(result.contains("100"))
  }

  // MARK: - BTC Formatting (satoshis)

  @Test("Format BTC from satoshis - one BTC")
  func testFormatBTCOneBTC() {
    let result = FinancialFormatter.formatBTC(satoshis: 100_000_000)
    #expect(result.contains("1"))
    #expect(result.contains("BTC"))
  }

  @Test("Format BTC from satoshis - fractional BTC")
  func testFormatBTCFractional() {
    let result = FinancialFormatter.formatBTC(satoshis: 50_000_000)  // 0.5 BTC
    #expect(result.contains("0"))
    #expect(result.contains("5"))
    #expect(result.contains("BTC"))
  }

  @Test("Format BTC from satoshis - small amount")
  func testFormatBTCSmall() {
    let result = FinancialFormatter.formatBTC(satoshis: 1000)  // 0.00001 BTC
    #expect(result.contains("0"))
    #expect(result.contains("00001"))
    #expect(result.contains("BTC"))
  }

  @Test("Format BTC from satoshis - zero")
  func testFormatBTCZero() {
    let result = FinancialFormatter.formatBTC(satoshis: 0)
    #expect(result.contains("0"))
    #expect(result.contains("BTC"))
  }

  @Test("Format BTC includes BTC suffix")
  func testFormatBTCHasSuffix() {
    let result = FinancialFormatter.formatBTC(satoshis: 234000)
    #expect(result.hasSuffix("BTC"))
  }

  // MARK: - USDT Formatting (micros)

  @Test("Format USDT from micros - one USDT")
  func testFormatUSDTOne() {
    let result = FinancialFormatter.formatUSDT(micros: 1_000_000)
    #expect(result.contains("1"))
    #expect(result.contains("USDT"))
  }

  @Test("Format USDT from micros - fractional")
  func testFormatUSDTFractional() {
    let result = FinancialFormatter.formatUSDT(micros: 500_000)  // 0.50 USDT
    #expect(result.contains("0"))
    #expect(result.contains("50") || result.contains("5"))
    #expect(result.contains("USDT"))
  }

  @Test("Format USDT from micros - large amount")
  func testFormatUSDTLarge() {
    let result = FinancialFormatter.formatUSDT(micros: 50_000_000)  // 50 USDT
    #expect(result.contains("50"))
    #expect(result.contains("USDT"))
  }

  @Test("Format USDT from micros - zero")
  func testFormatUSDTZero() {
    let result = FinancialFormatter.formatUSDT(micros: 0)
    #expect(result.contains("0"))
    #expect(result.contains("USDT"))
  }

  @Test("Format USDT includes USDT suffix")
  func testFormatUSDTHasSuffix() {
    let result = FinancialFormatter.formatUSDT(micros: 1_000_000)
    #expect(result.hasSuffix("USDT"))
  }

  // MARK: - Percent Formatting

  @Test("Format percent - positive")
  func testFormatPercentPositive() {
    let result = FinancialFormatter.formatPercent(5.25)
    #expect(result.contains("5"))
    #expect(result.contains("25"))
    #expect(result.contains("%"))
  }

  @Test("Format percent - negative")
  func testFormatPercentNegative() {
    let result = FinancialFormatter.formatPercent(-3.50)
    #expect(result.contains("3"))
    #expect(result.contains("50") || result.contains("5"))
    #expect(result.contains("%"))
    #expect(result.contains("-"))
  }

  @Test("Format percent - zero")
  func testFormatPercentZero() {
    let result = FinancialFormatter.formatPercent(0.0)
    #expect(result.contains("0"))
    #expect(result.contains("%"))
  }

  @Test("Format percent - whole number")
  func testFormatPercentWholeNumber() {
    let result = FinancialFormatter.formatPercent(10.0)
    #expect(result.contains("10"))
    #expect(result.contains("%"))
  }

  @Test("Format percent includes % suffix")
  func testFormatPercentHasSuffix() {
    let result = FinancialFormatter.formatPercent(1.23)
    #expect(result.hasSuffix("%"))
  }

  @Test("Format percent - small decimal")
  func testFormatPercentSmallDecimal() {
    let result = FinancialFormatter.formatPercent(0.01)
    #expect(result.contains("0"))
    #expect(result.contains("01"))
    #expect(result.contains("%"))
  }
}
