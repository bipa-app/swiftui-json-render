import SwiftUI

/// Resolves color names from the protocol DSL to SwiftUI colors.
///
/// Colors can be semantic names ("green", "red", "violet") or hex codes.
/// The host app can override these by providing a custom theme.
public enum ColorResolver {
  public static func resolve(_ name: String?, context: RenderContext) -> Color? {
    guard let name else { return nil }
    switch name {
    case "green": return context.successColor
    case "red": return context.errorColor
    case "yellow": return context.warningColor
    case "violet", "purple": return context.primaryColor
    case "blue": return .blue
    case "orange": return .orange
    case "mint", "teal": return .mint
    case "secondary": return context.textSecondary
    default:
      return ColorParser.parse(name, default: context.textPrimary, context: context)
    }
  }
}

/// Resolves icon names to SwiftUI views.
///
/// Supports shorthand names ("btc", "usdt", "brl", "card") and
/// any SF Symbol name ("arrow.up.right", "creditcard.fill", etc.).
public enum IconResolver {
  @ViewBuilder
  public static func view(for name: String, context: RenderContext) -> some View {
    Image(systemName: sfSymbol(for: name))
      .foregroundStyle(color(for: name, context: context))
  }

  public static func sfSymbol(for name: String) -> String {
    switch name {
    case "btc", "bitcoin": return "bitcoinsign.circle.fill"
    case "usdt", "dollar", "usd": return "dollarsign.circle.fill"
    case "brl", "real": return "brazilianrealsign.circle.fill"
    case "card", "credit": return "creditcard.fill"
    case "pix": return "arrow.left.arrow.right"
    case "lightning": return "bolt.fill"
    default: return name
    }
  }

  public static func color(for name: String, context: RenderContext) -> Color {
    switch name {
    case "btc", "bitcoin": return context.primaryColor  // violet in Bipa
    case "usdt", "dollar", "usd": return .mint
    case "brl", "real": return context.successColor  // green in Bipa
    case "card", "credit": return context.primaryColor
    default: return context.textSecondary
    }
  }
}
