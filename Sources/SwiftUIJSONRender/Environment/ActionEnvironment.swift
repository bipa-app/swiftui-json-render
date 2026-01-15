import SwiftUI

// MARK: - Action Handler Environment Key

private struct ActionHandlerKey: EnvironmentKey {
  static let defaultValue: ActionHandler? = nil
}

extension EnvironmentValues {
  /// The current action handler for JSON-rendered components.
  public var actionHandler: ActionHandler? {
    get { self[ActionHandlerKey.self] }
    set { self[ActionHandlerKey.self] = newValue }
  }
}
