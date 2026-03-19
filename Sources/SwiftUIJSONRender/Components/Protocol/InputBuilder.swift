import SwiftUI

/// `input` — Collect user data (text, amount, choice, date, slider, confirm).
///
/// ```json
/// { "type": "input", "props": { "inputType": "choice", "id": "goal", "label": "Objetivo", "options": [{ "id": "emergency", "label": "Reserva" }] } }
/// ```
public struct InputBuilder: ComponentBuilder {
  public static var typeName: String { "input" }

  @MainActor
  public static func build(node: ComponentNode, context: RenderContext) -> AnyView {
    let inputType = node.string("inputType") ?? "text"
    let inputId = node.string("id") ?? UUID().uuidString
    let label = node.string("label") ?? ""

    return AnyView(
      InputContainerView(
        inputType: inputType,
        inputId: inputId,
        label: label,
        node: node,
        context: context
      )
    )
  }
}

private struct InputContainerView: View {
  let inputType: String
  let inputId: String
  let label: String
  let node: ComponentNode
  let context: RenderContext

  var body: some View {
    VStack(alignment: .leading, spacing: context.spacingSM) {
      Text(label)
        .font(context.bodyFont)
        .foregroundStyle(context.textPrimary)

      Group {
        switch inputType {
        case "text":
          TextInputView(inputId: inputId, node: node, context: context)
        case "choice":
          ChoiceInputView(inputId: inputId, node: node, context: context)
        case "multiChoice":
          MultiChoiceInputView(inputId: inputId, node: node, context: context)
        case "confirm":
          ConfirmInputView(inputId: inputId, node: node, context: context)
        case "slider":
          SliderInputView(inputId: inputId, node: node, context: context)
        default:
          TextInputView(inputId: inputId, node: node, context: context)
        }
      }
    }
  }
}

// MARK: - Text Input

private struct TextInputView: View {
  let inputId: String
  let node: ComponentNode
  let context: RenderContext
  @State private var text = ""

  var body: some View {
    let placeholder = node.string("placeholder") ?? ""

    HStack {
      TextField(placeholder, text: $text)
        .font(context.bodyFont)
        .textFieldStyle(.plain)
        .onSubmit {
          context.handleInput(InputResponse(inputId: inputId, value: .text(text)))
        }

      if !text.isEmpty {
        Button {
          context.handleInput(InputResponse(inputId: inputId, value: .text(text)))
        } label: {
          Image(systemName: "arrow.up.circle.fill")
            .font(.title3)
            .foregroundStyle(context.primaryColor)
        }
      }
    }
    .padding(context.spacingSM)
    .background(
      RoundedRectangle(cornerRadius: context.radiusMD)
        .fill(context.surfaceColor)
    )
  }
}

// MARK: - Choice Input

private struct ChoiceInputView: View {
  let inputId: String
  let node: ComponentNode
  let context: RenderContext
  @State private var selectedId: String?

  private var options: [(id: String, label: String, subtitle: String?)] {
    node.array("options")?.compactMap { item -> (String, String, String?)? in
      guard let dict = item as? [String: Any],
            let id = dict["id"] as? String,
            let label = dict["label"] as? String
      else { return nil }
      return (id, label, dict["subtitle"] as? String)
    } ?? []
  }

  var body: some View {
    VStack(spacing: 0) {
      ForEach(Array(options.enumerated()), id: \.element.id) { idx, option in
        Button {
          selectedId = option.id
          context.handleInput(InputResponse(inputId: inputId, value: .choice(option.id)))
        } label: {
          HStack {
            Circle()
              .strokeBorder(
                selectedId == option.id ? context.primaryColor : context.textSecondary.opacity(0.3),
                lineWidth: 1.5
              )
              .background(
                Circle().fill(selectedId == option.id ? context.primaryColor : Color.clear)
                  .padding(4)
              )
              .frame(width: 22, height: 22)

            VStack(alignment: .leading, spacing: 2) {
              Text(option.label)
                .font(context.bodyFont)
                .foregroundStyle(context.textPrimary)
              if let subtitle = option.subtitle {
                Text(subtitle)
                  .font(context.captionFont)
                  .foregroundStyle(context.textSecondary)
              }
            }

            Spacer()
          }
          .padding(.horizontal, context.spacingMD)
          .padding(.vertical, context.spacingSM)
        }
        .buttonStyle(.plain)

        if idx < options.count - 1 {
          Divider().padding(.horizontal, context.spacingMD)
        }
      }
    }
    .background(
      RoundedRectangle(cornerRadius: context.radiusMD)
        .fill(context.surfaceColor)
    )
  }
}

// MARK: - Multi Choice Input

private struct MultiChoiceInputView: View {
  let inputId: String
  let node: ComponentNode
  let context: RenderContext
  @State private var selectedIds: Set<String> = []

  private var options: [(id: String, label: String, subtitle: String?)] {
    node.array("options")?.compactMap { item -> (String, String, String?)? in
      guard let dict = item as? [String: Any],
            let id = dict["id"] as? String,
            let label = dict["label"] as? String
      else { return nil }
      return (id, label, dict["subtitle"] as? String)
    } ?? []
  }

  var body: some View {
    VStack(spacing: 0) {
      ForEach(Array(options.enumerated()), id: \.element.id) { idx, option in
        Button {
          if selectedIds.contains(option.id) {
            selectedIds.remove(option.id)
          } else {
            selectedIds.insert(option.id)
          }
          context.handleInput(
            InputResponse(inputId: inputId, value: .multiChoice(Array(selectedIds)))
          )
        } label: {
          HStack {
            Image(systemName: selectedIds.contains(option.id) ? "checkmark.square.fill" : "square")
              .foregroundStyle(
                selectedIds.contains(option.id) ? context.primaryColor : context.textSecondary.opacity(0.3)
              )
              .font(.title3)

            VStack(alignment: .leading, spacing: 2) {
              Text(option.label)
                .font(context.bodyFont)
                .foregroundStyle(context.textPrimary)
              if let subtitle = option.subtitle {
                Text(subtitle)
                  .font(context.captionFont)
                  .foregroundStyle(context.textSecondary)
              }
            }

            Spacer()
          }
          .padding(.horizontal, context.spacingMD)
          .padding(.vertical, context.spacingSM)
        }
        .buttonStyle(.plain)

        if idx < options.count - 1 {
          Divider().padding(.horizontal, context.spacingMD)
        }
      }
    }
    .background(
      RoundedRectangle(cornerRadius: context.radiusMD)
        .fill(context.surfaceColor)
    )
  }
}

// MARK: - Confirm Input

private struct ConfirmInputView: View {
  let inputId: String
  let node: ComponentNode
  let context: RenderContext

  var body: some View {
    let confirmLabel = node.string("confirmLabel") ?? "Sim"
    let cancelLabel = node.string("cancelLabel") ?? "Não"

    HStack(spacing: context.spacingSM) {
      Button {
        context.handleInput(InputResponse(inputId: inputId, value: .bool(false)))
      } label: {
        Text(cancelLabel)
          .font(context.bodyFont)
          .foregroundStyle(context.textPrimary)
          .frame(maxWidth: .infinity)
          .padding(.vertical, context.spacingSM)
          .background(RoundedRectangle(cornerRadius: context.radiusLG).fill(context.surfaceColor))
      }
      .buttonStyle(.plain)

      Button {
        context.handleInput(InputResponse(inputId: inputId, value: .bool(true)))
      } label: {
        Text(confirmLabel)
          .font(context.bodyFont)
          .foregroundStyle(context.buttonPrimaryForeground)
          .frame(maxWidth: .infinity)
          .padding(.vertical, context.spacingSM)
          .background(RoundedRectangle(cornerRadius: context.radiusLG).fill(context.primaryColor))
      }
      .buttonStyle(.plain)
    }
  }
}

// MARK: - Slider Input

private struct SliderInputView: View {
  let inputId: String
  let node: ComponentNode
  let context: RenderContext
  @State private var value: Double = 0

  var body: some View {
    let min = node.double("min") ?? 0
    let max = node.double("max") ?? 100
    let step = node.double("step") ?? 1
    let unit = node.string("unit") ?? ""

    VStack(spacing: context.spacingXS) {
      HStack {
        Text(String(format: "%.0f%@", value, unit.isEmpty ? "" : " \(unit)"))
          .font(context.headingFont)
          .foregroundStyle(context.textPrimary)
        Spacer()
      }

      Slider(value: $value, in: min...max, step: step) { _ in
        context.handleInput(InputResponse(inputId: inputId, value: .number(value)))
      }
      .tint(context.primaryColor)
    }
    .onAppear { value = min }
  }
}
