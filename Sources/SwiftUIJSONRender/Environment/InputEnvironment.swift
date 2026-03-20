import SwiftUI

// MARK: - Input Handler Environment Key

struct InputHandlerKey: EnvironmentKey {
  static let defaultValue: InputHandler? = nil
}

extension EnvironmentValues {
  var inputHandler: InputHandler? {
    get { self[InputHandlerKey.self] }
    set { self[InputHandlerKey.self] = newValue }
  }
}
