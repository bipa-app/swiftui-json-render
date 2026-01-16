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
private struct ConfirmDialogProps: Decodable {
  let title: String?
  let message: String?
  let confirmLabel: String?
  let cancelLabel: String?
  let triggerLabel: String?
  let action: Action?
}

public struct ConfirmDialogBuilder: ComponentBuilder {
  public static var typeName: String { "ConfirmDialog" }

  public static func build(node: ComponentNode, context: RenderContext) -> AnyView {
    let props = node.decodeProps(ConfirmDialogProps.self)
    let title = props?.title ?? node.string("title") ?? context.confirmDialogTitle
    let message = props?.message ?? node.string("message")
    let confirmLabel = props?.confirmLabel ?? node.string("confirmLabel") ?? context.confirmButtonLabel
    let cancelLabel = props?.cancelLabel ?? node.string("cancelLabel") ?? context.cancelButtonLabel
    let triggerLabel = props?.triggerLabel ?? node.string("triggerLabel") ?? context.confirmButtonLabel
    let action = props?.action ?? Action.from(node.props?["action"])

    return AnyView(
      ConfirmDialogView(
        title: title,
        message: message,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        triggerLabel: triggerLabel,
        action: action,
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
  let action: Action?
  let context: RenderContext

  @State private var isPresented = false

  var body: some View {
    Button(triggerLabel) {
      isPresented = true
    }
    .confirmationDialog(title, isPresented: $isPresented, titleVisibility: .visible) {
      Button(confirmLabel) {
        if let action {
          context.handle(action)
        }
      }
      Button(cancelLabel, role: .cancel) {}
    } message: {
      if let message = message {
        Text(message)
      }
    }
  }
}
