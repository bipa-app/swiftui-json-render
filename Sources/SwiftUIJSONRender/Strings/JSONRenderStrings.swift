import Foundation

/// A protocol defining localizable strings for rendered components.
///
/// Implement this protocol to provide custom or localized strings
/// that can be applied to `JSONView` using the `.strings()` modifier.
/// Default English values are provided for all properties.
///
/// ## Example
/// ```swift
/// struct SpanishStrings: JSONRenderStrings {
///     static var confirmButtonLabel: String { "Confirmar" }
///     static var cancelButtonLabel: String { "Cancelar" }
///     // Other properties use defaults
/// }
///
/// JSONView(json)
///     .strings(SpanishStrings.self)
/// ```
public protocol JSONRenderStrings: Sendable {
  /// Default label for buttons when not specified.
  static var defaultButtonLabel: String { get }

  /// Default title for alerts when not specified.
  static var defaultAlertTitle: String { get }

  /// Default title for confirmation dialogs.
  static var confirmDialogTitle: String { get }

  /// Label for confirm/OK buttons.
  static var confirmButtonLabel: String { get }

  /// Label for cancel buttons.
  static var cancelButtonLabel: String { get }

  /// Default prompt for choice lists.
  static var chooseOptionPrompt: String { get }

  /// Message shown when charts have no data.
  static var noDataAvailable: String { get }

  /// Default title for balance cards.
  static var balancesTitle: String { get }

  /// Default SF Symbol name for icons.
  static var defaultIconName: String { get }

  /// Default description for transactions.
  static var defaultTransactionDescription: String { get }
}

// MARK: - Default Values

extension JSONRenderStrings {
  public static var defaultButtonLabel: String { "Button" }
  public static var defaultAlertTitle: String { "Alert" }
  public static var confirmDialogTitle: String { "Confirm" }
  public static var confirmButtonLabel: String { "Confirm" }
  public static var cancelButtonLabel: String { "Cancel" }
  public static var chooseOptionPrompt: String { "Choose an option" }
  public static var noDataAvailable: String { "No data available" }
  public static var balancesTitle: String { "Balances" }
  public static var defaultIconName: String { "questionmark" }
  public static var defaultTransactionDescription: String { "Transaction" }
}

// MARK: - Default Implementation

/// The default strings implementation using English values.
public struct DefaultStrings: JSONRenderStrings {}
