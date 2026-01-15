// SwiftUIJSONRender
// A Swift package for rendering AI-generated JSON into native SwiftUI views.

import SwiftUI

// MARK: - Auto-Registration

/// Ensures built-in components are registered when the module is loaded.
private let _registerBuiltInComponents: Void = {
  registerBuiltInComponents()
}()

/// Call this to ensure the framework is properly initialized.
/// This is typically not needed as importing the module auto-registers components.
public func initializeJSONRender() {
  _ = _registerBuiltInComponents
}
