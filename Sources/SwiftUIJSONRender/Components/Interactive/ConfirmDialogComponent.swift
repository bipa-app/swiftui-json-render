import SwiftUI

/// Renders a ConfirmDialog component.
///
/// ## JSON Example
/// ```json
/// {
///   "type": "ConfirmDialog",
///   "props": {
///     "title": "Confirm Transfer",
///     "message": "Send R$ 10.00?",
///     "confirmLabel": "Confirm",
///     "cancelLabel": "Cancel",
///     "triggerLabel": "Send",
///     "action": { "name": "send_pix" }
///   }
/// }
/// ```
///
/// ## Props
/// - `title`: Dialog title
/// - `message`: Optional message
/// - `confirmLabel`: Confirm button label
/// - `cancelLabel`: Cancel button label
/// - `triggerLabel`: Label for the trigger button
/// - `action`: Action to trigger on confirm
public struct ConfirmDialogBuilder: ComponentBuilder {
  public static var typeName: String { "ConfirmDialog" }

  public static func build(node: ComponentNode, context: RenderContext) -> AnyView {
    let title = node.string("title") ?? "Confirm"
    let message = node.string("message")
    let confirmLabel = node.string("confirmLabel") ?? "Confirm"
    let cancelLabel = node.string("cancelLabel") ?? "Cancel"
    let triggerLabel = node.string("triggerLabel") ?? "Confirm"
    let actionValue = node.props?["action"]

    return AnyView(
      ConfirmDialogView(
        title: title,
        message: message,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        triggerLabel: triggerLabel,
        actionValue: actionValue,
        context: context
      )
    )
  }
}

private struct ConfirmDialogView: View {
  let title: String
  let message: String?
  let confirmLabel: String
  let cancelLabel: String
  let triggerLabel: String
  let actionValue: AnyCodable?
  let context: RenderContext

  @State private var isPresented = false

  var body: some View {
    Button(triggerLabel) {
      isPresented = true
    }
    .confirmationDialog(title, isPresented: $isPresented, titleVisibility: .visible) {
      Button(confirmLabel) {
        context.handleAction(actionValue)
      }
      Button(cancelLabel, role: .cancel) {}
    } message: {
      if let message = message {
        Text(message)
      }
    }
  }
}
