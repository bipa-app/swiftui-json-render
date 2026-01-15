import SwiftUI

enum ColorParser {
  static func parse(
    _ colorString: String?,
    default defaultColor: Color,
    context: RenderContext
  ) -> Color {
    guard let colorString = colorString else {
      return defaultColor
    }

    // Handle hex colors
    if colorString.hasPrefix("#") {
      return Color(hex: colorString) ?? defaultColor
    }

    // Handle named colors
    switch colorString.lowercased() {
    case "primary":
      return context.textPrimary
    case "secondary":
      return context.textSecondary
    case "error", "red":
      return context.errorColor
    case "success", "green":
      return context.successColor
    case "warning", "orange":
      return context.warningColor
    default:
      return defaultColor
    }
  }
}

extension Color {
  fileprivate init?(hex: String) {
    var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
    hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

    var rgb: UInt64 = 0

    guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else {
      return nil
    }

    let length = hexSanitized.count

    switch length {
    case 6:
      self.init(
        red: Double((rgb & 0xFF0000) >> 16) / 255.0,
        green: Double((rgb & 0x00FF00) >> 8) / 255.0,
        blue: Double(rgb & 0x0000FF) / 255.0
      )
    case 8:
      self.init(
        red: Double((rgb & 0xFF00_0000) >> 24) / 255.0,
        green: Double((rgb & 0x00FF_0000) >> 16) / 255.0,
        blue: Double((rgb & 0x0000_FF00) >> 8) / 255.0,
        opacity: Double(rgb & 0x0000_00FF) / 255.0
      )
    default:
      return nil
    }
  }
}
