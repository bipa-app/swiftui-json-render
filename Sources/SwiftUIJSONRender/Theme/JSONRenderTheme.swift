import SwiftUI

/// A protocol defining the visual theme for rendered components.
///
/// Implement this protocol to create custom themes that can be applied
/// to `JSONView` using the `.theme()` modifier. Default values are provided
/// for all properties, so you only need to override what you want to customize.
///
/// ## Example
/// ```swift
/// struct MyTheme: JSONRenderTheme {
///     static var primaryColor: Color { .purple }
///     static var surfaceColor: Color { Color(.systemGray5) }
///     // Other properties use defaults
/// }
/// ```
public protocol JSONRenderTheme: Sendable {
  // MARK: - Colors

  /// The primary brand color.
  static var primaryColor: Color { get }

  /// The secondary brand color.
  static var secondaryColor: Color { get }

  /// The main background color.
  static var backgroundColor: Color { get }

  /// The surface color for cards and elevated elements.
  static var surfaceColor: Color { get }

  /// The primary text color.
  static var textPrimary: Color { get }

  /// The secondary text color for less prominent text.
  static var textSecondary: Color { get }

  /// The color for error states.
  static var errorColor: Color { get }

  /// The color for success states.
  static var successColor: Color { get }

  /// The color for warning states.
  static var warningColor: Color { get }

  // MARK: - Typography

  /// The font for headings.
  static var headingFont: Font { get }

  /// The font for body text.
  static var bodyFont: Font { get }

  /// The font for captions and small text.
  static var captionFont: Font { get }

  // MARK: - Spacing

  /// Extra small spacing (4pt).
  static var spacingXS: CGFloat { get }

  /// Small spacing (8pt).
  static var spacingSM: CGFloat { get }

  /// Medium spacing (16pt).
  static var spacingMD: CGFloat { get }

  /// Large spacing (24pt).
  static var spacingLG: CGFloat { get }

  /// Extra large spacing (32pt).
  static var spacingXL: CGFloat { get }

  // MARK: - Corner Radius

  /// Small corner radius (4pt).
  static var radiusSM: CGFloat { get }

  /// Medium corner radius (8pt).
  static var radiusMD: CGFloat { get }

  /// Large corner radius (16pt).
  static var radiusLG: CGFloat { get }

  // MARK: - Opacity

  /// Opacity for disabled interactive elements.
  static var disabledOpacity: Double { get }

  /// Opacity for placeholder backgrounds.
  static var placeholderOpacity: Double { get }

  /// Opacity for alert/feedback backgrounds.
  static var alertBackgroundOpacity: Double { get }

  /// Opacity for alert/feedback borders.
  static var alertBorderOpacity: Double { get }

  // MARK: - Sizes

  /// Default icon size when not specified.
  static var defaultIconSize: CGFloat { get }

  /// Default height for charts.
  static var chartHeight: CGFloat { get }

  /// Height for empty state views.
  static var emptyStateHeight: CGFloat { get }

  /// Size for legend indicator circles.
  static var legendIndicatorSize: CGFloat { get }

  /// Default border width.
  static var borderWidth: CGFloat { get }

  // MARK: - Animation

  /// Duration for standard animations.
  static var animationDuration: Double { get }

  /// Scale factor for loading indicators.
  static var loadingBadgeScale: CGFloat { get }

  // MARK: - Button Colors

  /// Foreground color for primary buttons.
  static var buttonPrimaryForeground: Color { get }

  /// Foreground color for destructive buttons.
  static var buttonDestructiveForeground: Color { get }
}

// MARK: - Default Values

extension JSONRenderTheme {
  public static var primaryColor: Color { .blue }
  public static var secondaryColor: Color { .gray }
  #if os(iOS)
    public static var backgroundColor: Color { Color(UIColor.systemBackground) }
    public static var surfaceColor: Color { Color(UIColor.secondarySystemBackground) }
  #else
    public static var backgroundColor: Color { Color(NSColor.windowBackgroundColor) }
    public static var surfaceColor: Color { Color(NSColor.controlBackgroundColor) }
  #endif
  public static var textPrimary: Color { .primary }
  public static var textSecondary: Color { .secondary }
  public static var errorColor: Color { .red }
  public static var successColor: Color { .green }
  public static var warningColor: Color { .orange }

  public static var headingFont: Font { .headline }
  public static var bodyFont: Font { .body }
  public static var captionFont: Font { .caption }

  public static var spacingXS: CGFloat { 4 }
  public static var spacingSM: CGFloat { 8 }
  public static var spacingMD: CGFloat { 16 }
  public static var spacingLG: CGFloat { 24 }
  public static var spacingXL: CGFloat { 32 }

  public static var radiusSM: CGFloat { 4 }
  public static var radiusMD: CGFloat { 8 }
  public static var radiusLG: CGFloat { 16 }

  // Opacity defaults
  public static var disabledOpacity: Double { 0.5 }
  public static var placeholderOpacity: Double { 0.2 }
  public static var alertBackgroundOpacity: Double { 0.1 }
  public static var alertBorderOpacity: Double { 0.3 }

  // Size defaults
  public static var defaultIconSize: CGFloat { 16 }
  public static var chartHeight: CGFloat { 180 }
  public static var emptyStateHeight: CGFloat { 120 }
  public static var legendIndicatorSize: CGFloat { 10 }
  public static var borderWidth: CGFloat { 1 }

  // Animation defaults
  public static var animationDuration: Double { 0.2 }
  public static var loadingBadgeScale: CGFloat { 0.7 }

  // Button color defaults
  public static var buttonPrimaryForeground: Color { .white }
  public static var buttonDestructiveForeground: Color { .white }
}
