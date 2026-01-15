import SwiftUI

// MARK: - Registry Environment Key

private struct RegistryKey: EnvironmentKey {
  static let defaultValue: ComponentRegistry = .shared
}

extension EnvironmentValues {
  /// The current component registry for JSON rendering.
  public var componentRegistry: ComponentRegistry {
    get { self[RegistryKey.self] }
    set { self[RegistryKey.self] = newValue }
  }
}
