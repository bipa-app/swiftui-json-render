import SwiftUI

/// `table` — Key-value detail rows with optional "Ver mais" expand.
///
/// ```json
/// { "type": "table", "props": { "rows": [{ "label": "CPF", "value": "***8900" }], "maxVisible": 3 } }
/// ```
public struct TableBuilder: ComponentBuilder {
  public static var typeName: String { "table" }

  @MainActor
  public static func build(node: ComponentNode, context: RenderContext) -> AnyView {
    let rows: [(label: String, value: String)] = node.array("rows")?
      .compactMap { item -> (String, String)? in
        guard let dict = item as? [String: Any],
              let label = dict["label"] as? String,
              let value = dict["value"] as? String,
              !value.isEmpty
        else { return nil }
        return (label, value)
      } ?? []
    let maxVisible = node.int("maxVisible")

    return AnyView(
      TableView(rows: rows, maxVisible: maxVisible, context: context)
    )
  }
}

private struct TableView: View {
  let rows: [(label: String, value: String)]
  let maxVisible: Int?
  let context: RenderContext

  @State private var expanded = false

  private var visibleRows: [(label: String, value: String)] {
    if expanded || maxVisible == nil { return rows }
    return Array(rows.prefix(maxVisible!))
  }

  private var hasMore: Bool {
    guard let max = maxVisible else { return false }
    return !expanded && rows.count > max
  }

  var body: some View {
    VStack(spacing: 0) {
      ForEach(Array(visibleRows.enumerated()), id: \.offset) { idx, row in
        HStack(alignment: .center) {
          Text(row.label)
            .font(context.captionFont)
            .foregroundStyle(context.textSecondary)

          Spacer()

          Text(row.value)
            .font(context.bodyFont)
            .foregroundStyle(context.textPrimary)
            .multilineTextAlignment(.trailing)
        }
        .padding(.horizontal, context.spacingMD)
        .padding(.vertical, context.spacingSM)

        if idx < visibleRows.count - 1 || hasMore {
          Divider()
            .overlay(context.surfaceColor.opacity(0.5))
            .padding(.horizontal, context.spacingMD)
        }
      }

      if hasMore {
        Button {
          withAnimation(.easeOut(duration: context.animationDuration)) {
            expanded = true
          }
        } label: {
          HStack(spacing: context.spacingXS) {
            Text("Ver mais")
              .font(context.captionFont)
            Image(systemName: "chevron.down")
              .font(.caption2)
          }
          .foregroundStyle(context.primaryColor)
          .frame(maxWidth: .infinity)
          .padding(.vertical, context.spacingSM)
        }
        .buttonStyle(.plain)
      }
    }
    .background(
      RoundedRectangle(cornerRadius: context.radiusMD)
        .fill(context.surfaceColor)
    )
  }
}
