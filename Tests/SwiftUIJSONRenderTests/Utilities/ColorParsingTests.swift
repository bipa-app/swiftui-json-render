import SwiftUI
import Testing

@testable import SwiftUIJSONRender

@Suite("ColorParsing Tests")
struct ColorParsingTests {

  private var context: RenderContext {
    RenderContext()
  }

  // MARK: - Nil and Default Handling

  @Test("Nil color string returns default color")
  func testNilReturnsDefault() {
    let result = ColorParser.parse(nil, default: .blue, context: context)
    #expect(result == .blue)
  }

  @Test("Empty string returns default color")
  func testEmptyStringReturnsDefault() {
    let result = ColorParser.parse("", default: .blue, context: context)
    #expect(result == .blue)
  }

  // MARK: - Hex Colors (6 digit)

  @Test("Parse 6-digit hex color with hash")
  func testHex6DigitWithHash() {
    let result = ColorParser.parse("#FF0000", default: .blue, context: context)
    // Red color - we can't easily compare Color values, so just verify it doesn't return default
    #expect(result != .blue)
  }

  @Test("Parse 6-digit hex color lowercase")
  func testHex6DigitLowercase() {
    let result = ColorParser.parse("#ff0000", default: .blue, context: context)
    #expect(result != .blue)
  }

  @Test("Parse black hex color")
  func testHexBlack() {
    let result = ColorParser.parse("#000000", default: .blue, context: context)
    #expect(result != .blue)
  }

  @Test("Parse white hex color")
  func testHexWhite() {
    let result = ColorParser.parse("#FFFFFF", default: .blue, context: context)
    #expect(result != .blue)
  }

  // MARK: - Hex Colors (8 digit with alpha)

  @Test("Parse 8-digit hex color with alpha")
  func testHex8DigitWithAlpha() {
    let result = ColorParser.parse("#FF000080", default: .blue, context: context)
    #expect(result != .blue)
  }

  @Test("Parse 8-digit hex fully transparent")
  func testHex8DigitTransparent() {
    let result = ColorParser.parse("#FF000000", default: .blue, context: context)
    #expect(result != .blue)
  }

  @Test("Parse 8-digit hex fully opaque")
  func testHex8DigitOpaque() {
    let result = ColorParser.parse("#FF0000FF", default: .blue, context: context)
    #expect(result != .blue)
  }

  // MARK: - Invalid Hex

  @Test("Invalid hex returns default")
  func testInvalidHexReturnsDefault() {
    let result = ColorParser.parse("#GGGGGG", default: .blue, context: context)
    #expect(result == .blue)
  }

  @Test("Short hex returns default")
  func testShortHexReturnsDefault() {
    let result = ColorParser.parse("#FFF", default: .blue, context: context)
    #expect(result == .blue)
  }

  @Test("7-digit hex returns default")
  func testSevenDigitHexReturnsDefault() {
    let result = ColorParser.parse("#FF00000", default: .blue, context: context)
    #expect(result == .blue)
  }

  // MARK: - Named Colors

  @Test("Primary color name")
  func testPrimaryColorName() {
    let result = ColorParser.parse("primary", default: .blue, context: context)
    #expect(result == context.textPrimary)
  }

  @Test("Secondary color name")
  func testSecondaryColorName() {
    let result = ColorParser.parse("secondary", default: .blue, context: context)
    #expect(result == context.textSecondary)
  }

  @Test("Error color name")
  func testErrorColorName() {
    let result = ColorParser.parse("error", default: .blue, context: context)
    #expect(result == context.errorColor)
  }

  @Test("Red color name (alias for error)")
  func testRedColorName() {
    let result = ColorParser.parse("red", default: .blue, context: context)
    #expect(result == context.errorColor)
  }

  @Test("Success color name")
  func testSuccessColorName() {
    let result = ColorParser.parse("success", default: .blue, context: context)
    #expect(result == context.successColor)
  }

  @Test("Green color name (alias for success)")
  func testGreenColorName() {
    let result = ColorParser.parse("green", default: .blue, context: context)
    #expect(result == context.successColor)
  }

  @Test("Warning color name")
  func testWarningColorName() {
    let result = ColorParser.parse("warning", default: .blue, context: context)
    #expect(result == context.warningColor)
  }

  @Test("Orange color name (alias for warning)")
  func testOrangeColorName() {
    let result = ColorParser.parse("orange", default: .blue, context: context)
    #expect(result == context.warningColor)
  }

  // MARK: - Case Insensitivity

  @Test("Color names are case insensitive")
  func testColorNamesCaseInsensitive() {
    let primary = ColorParser.parse("PRIMARY", default: .blue, context: context)
    let secondary = ColorParser.parse("Secondary", default: .blue, context: context)
    let error = ColorParser.parse("ERROR", default: .blue, context: context)

    #expect(primary == context.textPrimary)
    #expect(secondary == context.textSecondary)
    #expect(error == context.errorColor)
  }

  // MARK: - Unknown Names

  @Test("Unknown color name returns default")
  func testUnknownColorNameReturnsDefault() {
    let result = ColorParser.parse("purple", default: .blue, context: context)
    #expect(result == .blue)
  }

  @Test("Random string returns default")
  func testRandomStringReturnsDefault() {
    let result = ColorParser.parse("notacolor", default: .blue, context: context)
    #expect(result == .blue)
  }
}
