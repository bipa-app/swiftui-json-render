import SwiftUI

/// Renders a ChoiceList component.
///
/// ## JSON Example
/// ```json
/// {
///   "type": "ChoiceList",
///   "props": {
///     "question": "Which PIX key?",
///     "options": [
///       { "id": "cpf", "label": "CPF: ***456", "description": "Tax ID" }
///     ],
///     "action": { "name": "select_pix_key", "paramKey": "key_id" }
///   }
/// }
/// ```
///
/// ## Props
/// - `question`: Prompt text
/// - `options`: Array of options (id, label, description)
/// - `action`: Action with `name` and `paramKey`
private struct ChoiceListProps: Decodable {
  let question: String?
  let options: [ChoiceOption]
  let action: ChoiceActionConfig?
}

public struct ChoiceListBuilder: ComponentBuilder {
  public static var typeName: String { "ChoiceList" }

  public static func build(node: ComponentNode, context: RenderContext) -> AnyView {
    let props = node.decodeProps(ChoiceListProps.self)
    let question = props?.question ?? node.string("question") ?? context.chooseOptionPrompt
    let options = props?.options ?? parseOptions(node.array("options"))
    let actionConfig = props?.action ?? parseActionConfig(node.dictionary("action"))

    return AnyView(
      ChoiceListView(
        question: question,
        options: options,
        actionConfig: actionConfig,
        context: context
      )
    )
  }

  private static func parseOptions(_ array: [Any]?) -> [ChoiceOption] {
    guard let array = array else { return [] }
    return array.compactMap { item in
      guard let dict = item as? [String: Any] else { return nil }
      return ChoiceOption(dict: dict)
    }
  }

  private static func parseActionConfig(_ dict: [String: Any]?) -> ChoiceActionConfig? {
    guard let dict = dict, let name = dict["name"] as? String else { return nil }
    let paramKey = dict["paramKey"] as? String ?? "id"
    return ChoiceActionConfig(name: name, paramKey: paramKey)
  }
}

private struct ChoiceOption: Identifiable, Decodable {
  let id: String
  let label: String
  let description: String?

  init?(dict: [String: Any]) {
    guard let id = dict["id"] as? String,
      let label = dict["label"] as? String
    else { return nil }
    self.id = id
    self.label = label
    self.description = dict["description"] as? String
  }
}

private struct ChoiceActionConfig: Decodable {
  let name: String
  let paramKey: String

  private enum CodingKeys: String, CodingKey {
    case name
    case paramKey
  }

  init(name: String, paramKey: String) {
    self.name = name
    self.paramKey = paramKey
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    name = try container.decode(String.self, forKey: .name)
    paramKey = try container.decodeIfPresent(String.self, forKey: .paramKey) ?? "id"
  }
}

private struct ChoiceListView: View {
  let question: String
  let options: [ChoiceOption]
  let actionConfig: ChoiceActionConfig?
  let context: RenderContext

  var body: some View {
    VStack(alignment: .leading, spacing: context.spacingSM) {
      Text(question)
        .font(context.headingFont)
        .foregroundStyle(context.textPrimary)

      ForEach(options) { option in
        Button {
          handleSelection(option)
        } label: {
          VStack(alignment: .leading, spacing: context.spacingXS) {
            Text(option.label)
              .font(context.bodyFont)
              .foregroundStyle(context.textPrimary)
            if let description = option.description {
              Text(description)
                .font(context.captionFont)
                .foregroundStyle(context.textSecondary)
            }
          }
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding(context.spacingSM)
          .background(context.surfaceColor)
          .clipShape(.rect(cornerRadius: context.radiusSM))
        }
      }
    }
  }

  private func handleSelection(_ option: ChoiceOption) {
    guard let actionConfig = actionConfig else { return }
    let params = [actionConfig.paramKey: AnyCodable(option.id)]
    let action = Action(name: actionConfig.name, params: params)
    context.handle(action)
  }
}
