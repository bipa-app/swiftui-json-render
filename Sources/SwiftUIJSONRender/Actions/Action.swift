import Foundation

/// Represents an action that can be triggered by interactive components.
///
/// Actions are defined in JSON and passed to the action handler when
/// the user interacts with components like buttons or choice lists.
///
/// ## Example JSON
/// ```json
/// {
///   "type": "Button",
///   "props": {
///     "label": "Send PIX",
///     "action": {
///       "name": "send_pix",
///       "params": { "amount": 1000 },
///       "confirm": {
///         "title": "Confirm Transfer",
///         "message": "Send R$ 10.00?"
///       }
///     }
///   }
/// }
/// ```
public struct Action: Codable, Sendable, Equatable {
  /// The action identifier (e.g., "send_pix", "navigate", "copy").
  public let name: String

  /// Optional parameters to pass with the action.
  public let params: [String: AnyCodable]?

  /// Optional confirmation dialog configuration.
  public let confirm: ConfirmConfig?

  /// Creates a new action.
  /// - Parameters:
  ///   - name: The action identifier.
  ///   - params: Optional parameters dictionary.
  ///   - confirm: Optional confirmation configuration.
  public init(
    name: String,
    params: [String: AnyCodable]? = nil,
    confirm: ConfirmConfig? = nil
  ) {
    self.name = name
    self.params = params
    self.confirm = confirm
  }
}

// MARK: - ConfirmConfig

/// Configuration for a confirmation dialog shown before executing an action.
public struct ConfirmConfig: Codable, Sendable, Equatable {
  /// The dialog title.
  public let title: String

  /// Optional dialog message.
  public let message: String?

  /// Optional custom label for the confirm button.
  public let confirmLabel: String?

  /// Optional custom label for the cancel button.
  public let cancelLabel: String?

  /// Creates a new confirmation configuration.
  /// - Parameters:
  ///   - title: The dialog title.
  ///   - message: Optional dialog message.
  ///   - confirmLabel: Optional confirm button label. Defaults to "Confirm".
  ///   - cancelLabel: Optional cancel button label. Defaults to "Cancel".
  public init(
    title: String,
    message: String? = nil,
    confirmLabel: String? = nil,
    cancelLabel: String? = nil
  ) {
    self.title = title
    self.message = message
    self.confirmLabel = confirmLabel
    self.cancelLabel = cancelLabel
  }
}

// MARK: - Action Parsing

extension Action {
  /// Creates an `Action` from an `AnyCodable` value.
  /// - Parameter value: The value to parse (typically from component props).
  /// - Returns: An `Action` if parsing succeeds, or `nil` otherwise.
  public static func from(_ value: AnyCodable?) -> Action? {
    guard let dict = value?.dictionaryValue,
      let name = dict["name"] as? String
    else {
      return nil
    }

    let params: [String: AnyCodable]?
    if let paramsDict = dict["params"] as? [String: Any] {
      params = paramsDict.mapValues { AnyCodable($0) }
    } else {
      params = nil
    }

    let confirm: ConfirmConfig?
    if let confirmDict = dict["confirm"] as? [String: Any],
      let title = confirmDict["title"] as? String
    {
      confirm = ConfirmConfig(
        title: title,
        message: confirmDict["message"] as? String,
        confirmLabel: confirmDict["confirmLabel"] as? String,
        cancelLabel: confirmDict["cancelLabel"] as? String
      )
    } else {
      confirm = nil
    }

    return Action(name: name, params: params, confirm: confirm)
  }
}

// MARK: - Parameter Accessors

extension Action {
  /// Retrieves a string parameter by key.
  public func string(_ key: String) -> String? {
    params?[key]?.stringValue
  }

  /// Retrieves an integer parameter by key.
  public func int(_ key: String) -> Int? {
    params?[key]?.intValue
  }

  /// Retrieves a double parameter by key.
  public func double(_ key: String) -> Double? {
    params?[key]?.doubleValue
  }

  /// Retrieves a boolean parameter by key.
  public func bool(_ key: String) -> Bool? {
    params?[key]?.boolValue
  }
}

/// A type alias for the action handler closure.
public typealias ActionHandler = (Action) -> Void
