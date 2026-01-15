import SwiftUI

#if canImport(Charts)
  import Charts
#endif

/// Renders a PieChart component.
///
/// ## JSON Example
/// ```json
/// {
///   "type": "PieChart",
///   "props": {
///     "title": "Spending by Category",
///     "segments": [
///       { "label": "Food", "value": 45000, "color": "#FF6B6B" }
///     ],
///     "showLegend": true
///   }
/// }
/// ```
///
/// ## Props
/// - `title`: Optional title
/// - `segments`: Array of segments with label, value, color
/// - `showLegend`: Show legend list (default: true)
public struct PieChartBuilder: ComponentBuilder {
  public static var typeName: String { "PieChart" }

  public static func build(node: ComponentNode, context: RenderContext) -> AnyView {
    let title = node.string("title")
    let showLegend = node.bool("showLegend") ?? true
    let segments = parseSegments(node.array("segments"), context: context)

    return AnyView(
      VStack(alignment: .leading, spacing: context.spacingSM) {
        if let title = title {
          Text(title)
            .font(context.headingFont)
            .foregroundColor(context.textPrimary)
        }

        #if canImport(Charts)
          if #available(iOS 17.0, macOS 14.0, *) {
            if !segments.isEmpty {
              Chart(segments) { segment in
                SectorMark(
                  angle: .value("Value", segment.value)
                )
                .foregroundStyle(segment.color)
              }
              .frame(height: context.chartHeight)
            } else {
              EmptyStateView(context: context)
            }
          } else {
            EmptyStateView(context: context)
          }
        #else
          EmptyStateView(context: context)
        #endif

        if showLegend {
          VStack(alignment: .leading, spacing: context.spacingXS) {
            ForEach(Array(segments.enumerated()), id: \.offset) { _, segment in
              HStack(spacing: context.spacingXS) {
                Circle()
                  .fill(segment.color)
                  .frame(width: context.legendIndicatorSize, height: context.legendIndicatorSize)
                Text(segment.label)
                  .font(context.captionFont)
                  .foregroundColor(context.textSecondary)
              }
            }
          }
        }
      }
      .padding(context.spacingMD)
      .background(context.surfaceColor)
      .clipShape(.rect(cornerRadius: context.radiusMD))
    )
  }

  private static func parseSegments(_ array: [Any]?, context: RenderContext) -> [PieSegment] {
    guard let array = array else { return [] }
    return array.compactMap { item in
      guard let dict = item as? [String: Any] else { return nil }
      return PieSegment(dict: dict, context: context)
    }
  }
}

private struct PieSegment: Identifiable {
  let id = UUID()
  let label: String
  let value: Double
  let color: Color

  init?(dict: [String: Any], context: RenderContext) {
    self.label = dict["label"] as? String ?? ""
    self.value = dict["value"] as? Double ?? Double(dict["value"] as? Int ?? 0)
    let colorString = dict["color"] as? String
    self.color = ColorParser.parse(colorString, default: context.primaryColor, context: context)
  }
}

private struct EmptyStateView: View {
  let context: RenderContext

  var body: some View {
    Text(context.noDataAvailable)
      .font(context.captionFont)
      .foregroundColor(context.textSecondary)
      .frame(maxWidth: .infinity, minHeight: context.emptyStateHeight)
  }
}
