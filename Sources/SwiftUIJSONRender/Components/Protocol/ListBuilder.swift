import SwiftUI

/// `list` — Item rows with expand to sheet.
///
/// ```json
/// { "type": "list", "props": { "items": [{ "title": "PIX", "subtitle": "18/03", "trailing": "R$ 250", "icon": "arrow.up.right" }], "maxVisible": 3, "expandLabel": "Ver todas (20)" } }
/// ```
public struct ListBuilder: ComponentBuilder {
  public static var typeName: String { "list" }

  @MainActor
  public static func build(node: ComponentNode, context: RenderContext) -> AnyView {
    let items: [ListItemData] = node.array("items")?
      .compactMap { item -> ListItemData? in
        guard let dict = item as? [String: Any],
              let title = dict["title"] as? String
        else { return nil }
        return ListItemData(
          title: title,
          subtitle: dict["subtitle"] as? String,
          trailing: dict["trailing"] as? String,
          trailingColor: dict["trailingColor"] as? String,
          icon: dict["icon"] as? String,
          action: dict["action"] as? [String: Any]
        )
      } ?? []
    let maxVisible = node.int("maxVisible") ?? 3
    let expandLabel = node.string("expandLabel")

    return AnyView(
      ListView(
        items: items,
        maxVisible: maxVisible,
        expandLabel: expandLabel,
        context: context
      )
    )
  }
}

struct ListItemData: Identifiable {
  let id = UUID()
  let title: String
  let subtitle: String?
  let trailing: String?
  let trailingColor: String?
  let icon: String?
  let action: [String: Any]?
}

private struct ListView: View {
  let items: [ListItemData]
  let maxVisible: Int
  let expandLabel: String?
  let context: RenderContext

  @State private var showSheet = false

  private var inlineItems: [ListItemData] {
    Array(items.prefix(maxVisible))
  }

  private var hasMore: Bool {
    items.count > maxVisible
  }

  var body: some View {
    VStack(spacing: 0) {
      ForEach(Array(inlineItems.enumerated()), id: \.element.id) { idx, item in
        ListItemRow(item: item, context: context)

        if idx < inlineItems.count - 1 || hasMore {
          Divider().padding(.horizontal, context.spacingMD)
        }
      }

      if hasMore {
        Button {
          showSheet = true
        } label: {
          HStack(spacing: context.spacingXS) {
            Image(systemName: "list.bullet")
              .font(.caption)
            Text(expandLabel ?? "Ver todas (\(items.count))")
              .font(context.captionFont)
          }
          .foregroundStyle(context.primaryColor)
          .frame(maxWidth: .infinity)
          .padding(.vertical, context.spacingSM)
        }
      }
    }
    .sheet(isPresented: $showSheet) {
      ListSheetView(items: items, context: context)
    }
  }
}

private struct ListItemRow: View {
  let item: ListItemData
  let context: RenderContext

  var body: some View {
    HStack(spacing: context.spacingSM) {
      if let icon = item.icon {
        IconResolver.view(for: icon, context: context)
          .font(.body)
          .foregroundStyle(context.textSecondary)
          .frame(width: 24, height: 24)
      }

      VStack(alignment: .leading, spacing: 2) {
        Text(item.title)
          .font(context.bodyFont)
          .foregroundStyle(context.textPrimary)
          .lineLimit(1)

        if let subtitle = item.subtitle {
          Text(subtitle)
            .font(context.captionFont)
            .foregroundStyle(context.textSecondary)
        }
      }
      .frame(maxWidth: .infinity, alignment: .leading)

      if let trailing = item.trailing {
        Text(trailing)
          .font(context.headingFont)
          .foregroundStyle(
            ColorResolver.resolve(item.trailingColor, context: context) ?? context.textPrimary
          )
          .lineLimit(1)
          .minimumScaleFactor(0.8)
      }
    }
    .padding(.horizontal, context.spacingMD)
    .padding(.vertical, context.spacingSM)
  }
}

private struct ListSheetView: View {
  let items: [ListItemData]
  let context: RenderContext
  @Environment(\.dismiss) private var dismiss

  var body: some View {
    NavigationStack {
      ScrollView {
        LazyVStack(spacing: 0) {
          ForEach(Array(items.enumerated()), id: \.element.id) { idx, item in
            ListItemRow(item: item, context: context)
            if idx < items.count - 1 {
              Divider().padding(.horizontal, context.spacingMD)
            }
          }
        }
        .background(
          RoundedRectangle(cornerRadius: context.radiusLG)
            .fill(context.surfaceColor)
        )
        .padding(.horizontal, context.spacingMD)
        .padding(.vertical, context.spacingSM)
      }
      #if os(iOS)
      .navigationBarTitleDisplayMode(.inline)
      #endif
      .toolbar {
        ToolbarItem(placement: .cancellationAction) {
          Button { dismiss() } label: {
            Image(systemName: "xmark.circle.fill")
              .foregroundStyle(context.textSecondary)
          }
        }
      }
    }
    .presentationDetents([.medium, .large])
    .presentationDragIndicator(.visible)
  }
}
