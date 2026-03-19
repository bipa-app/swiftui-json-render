import Foundation

/// Represents structured input collected from the user via an `input` component.
///
/// When the user completes an input (e.g., enters an amount, selects a choice),
/// the `InputHandler` callback is invoked with the input ID and value.
public struct InputResponse: Sendable, Equatable {
  /// The input component's unique identifier (matches `id` in the JSON).
  public let inputId: String

  /// The collected value.
  public let value: InputValue

  public init(inputId: String, value: InputValue) {
    self.inputId = inputId
    self.value = value
  }
}

/// The value types that input components can collect.
public enum InputValue: Sendable, Equatable {
  /// Text string (from text input).
  case text(String)

  /// Numeric amount in minor units (from amount input — e.g., cents).
  case amount(Int)

  /// Selected option ID (from single choice).
  case choice(String)

  /// Selected option IDs (from multi-choice).
  case multiChoice([String])

  /// Date value (from date picker).
  case date(Date)

  /// Numeric value (from slider).
  case number(Double)

  /// Boolean (from confirm input).
  case bool(Bool)
}

/// A callback invoked when the user completes an input component.
public typealias InputHandler = (InputResponse) -> Void
