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

// MARK: - Option parsing

private struct OptionItem: Identifiable {
  let id: String
  let label: String
  let subtitle: String?
}

private func parseOptions(from node: ComponentNode) -> [OptionItem] {
  node.array("options")?.compactMap { item -> OptionItem? in
    guard let dict = item as? [String: Any],
          let id = dict["id"] as? String,
          let label = dict["label"] as? String
    else { return nil }
    return OptionItem(id: id, label: label, subtitle: dict["subtitle"] as? String)
  } ?? []
}

// MARK: - Text Input

private struct TextInputView: View {
  let inputId: String
  let node: ComponentNode
  let context: RenderContext
  @State private var text = ""

  var body: some View {
    HStack(spacing: context.spacingSM) {
      TextField(node.string("placeholder") ?? "", text: $text)
        .font(context.bodyFont)
        .textFieldStyle(.plain)
        .onSubmit {
          guard !text.isEmpty else { return }
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
        .buttonStyle(.plain)
      }
    }
    .padding(context.spacingSM)
    .background(
      RoundedRectangle(cornerRadius: context.radiusMD)
        .fill(context.surfaceColor)
    )
  }
}

// MARK: - Choice Input (radio)

private struct ChoiceInputView: View {
  let inputId: String
  let node: ComponentNode
  let context: RenderContext
  @State private var selectedId: String?

  private var options: [OptionItem] { parseOptions(from: node) }

  var body: some View {
    VStack(spacing: 0) {
      ForEach(Array(options.enumerated()), id: \.element.id) { idx, option in
        Button {
          withAnimation(.bouncy(duration: 0.2)) {
            selectedId = option.id
          }
          context.handleInput(InputResponse(inputId: inputId, value: .choice(option.id)))
        } label: {
          HStack(spacing: context.spacingMD) {
            // Radio circle — matches Apolo RadioButton
            ZStack {
              Circle()
                .fill(selectedId == option.id ? context.textPrimary : Color.clear)
                .frame(width: 10, height: 10)
              Circle()
                .stroke(context.textSecondary.opacity(0.5), lineWidth: 1)
                .frame(width: 24, height: 24)
            }

            VStack(alignment: .leading, spacing: context.spacingXS) {
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
          .frame(minHeight: 56)
          .contentShape(Rectangle())
        }
        .buttonStyle(.plain)

        if idx < options.count - 1 {
          Divider()
            .overlay(context.surfaceColor.opacity(0.5))
            .padding(.horizontal, context.spacingMD)
        }
      }
    }
    .background(
      RoundedRectangle(cornerRadius: context.radiusMD)
        .fill(context.surfaceColor)
    )
  }
}

// MARK: - Multi Choice Input (checkbox)

private struct MultiChoiceInputView: View {
  let inputId: String
  let node: ComponentNode
  let context: RenderContext
  @State private var selectedIds: Set<String> = []

  private var options: [OptionItem] { parseOptions(from: node) }

  var body: some View {
    VStack(spacing: 0) {
      ForEach(Array(options.enumerated()), id: \.element.id) { idx, option in
        let isSelected = selectedIds.contains(option.id)

        Button {
          withAnimation(.bouncy(duration: 0.2)) {
            if isSelected {
              selectedIds.remove(option.id)
            } else {
              selectedIds.insert(option.id)
            }
          }
          context.handleInput(
            InputResponse(inputId: inputId, value: .multiChoice(Array(selectedIds)))
          )
        } label: {
          HStack(spacing: context.spacingMD) {
            // Checkbox — matches Apolo Checkbox
            Image(systemName: isSelected ? "checkmark.square.fill" : "square")
              .font(.title3)
              .foregroundStyle(isSelected ? context.textPrimary : context.textSecondary.opacity(0.5))

            VStack(alignment: .leading, spacing: context.spacingXS) {
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
          .frame(minHeight: 56)
          .contentShape(Rectangle())
        }
        .buttonStyle(.plain)

        if idx < options.count - 1 {
          Divider()
            .overlay(context.surfaceColor.opacity(0.5))
            .padding(.horizontal, context.spacingMD)
        }
      }
    }
    .background(
      RoundedRectangle(cornerRadius: context.radiusMD)
        .fill(context.surfaceColor)
    )
  }
}

// MARK: - Confirm Input (yes/no)

private struct ConfirmInputView: View {
  let inputId: String
  let node: ComponentNode
  let context: RenderContext

  var body: some View {
    HStack(spacing: context.spacingSM) {
      Button {
        context.handleInput(InputResponse(inputId: inputId, value: .bool(false)))
      } label: {
        Text(node.string("cancelLabel") ?? "Não")
          .font(context.bodyFont)
          .foregroundStyle(context.textPrimary)
          .frame(maxWidth: .infinity)
          .padding(.vertical, context.spacingSM)
          .background(Capsule().fill(context.surfaceColor))
      }
      .buttonStyle(.plain)

      Button {
        context.handleInput(InputResponse(inputId: inputId, value: .bool(true)))
      } label: {
        Text(node.string("confirmLabel") ?? "Sim")
          .font(context.bodyFont)
          .foregroundStyle(context.buttonPrimaryForeground)
          .frame(maxWidth: .infinity)
          .padding(.vertical, context.spacingSM)
          .background(Capsule().fill(context.primaryColor))
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
  @State private var didAppear = false

  private var min: Double { node.double("min") ?? 0 }
  private var max: Double { node.double("max") ?? 100 }
  private var step: Double { node.double("step") ?? 1 }
  private var unit: String { node.string("unit") ?? "" }

  var body: some View {
    VStack(spacing: context.spacingXS) {
      HStack {
        Text(String(format: "%.0f", value) + (unit.isEmpty ? "" : " \(unit)"))
          .font(context.headingFont)
          .foregroundStyle(context.textPrimary)
        Spacer()
      }

      Slider(value: $value, in: min...max, step: step)
        .tint(context.primaryColor)
        .onChange(of: value) { newValue in
          guard didAppear else { return }
          context.handleInput(InputResponse(inputId: inputId, value: .number(newValue)))
        }
    }
    .onAppear {
      value = min
      didAppear = true
    }
  }
}
