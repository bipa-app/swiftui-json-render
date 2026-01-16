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
private struct PieChartProps: Decodable {
  let title: String?
  let segments: [PieSegmentData]
  let showLegend: Bool?
}

public struct PieChartBuilder: ComponentBuilder {
  public static var typeName: String { "PieChart" }

  public static func build(node: ComponentNode, context: RenderContext) -> AnyView {
    let props = node.decodeProps(PieChartProps.self)
    let title = props?.title ?? node.string("title")
    let showLegend = props?.showLegend ?? node.bool("showLegend") ?? true
    let segments = props?.segments.map { PieSegment(data: $0, context: context) }
      ?? parseSegments(node.array("segments"), context: context)

    return AnyView(
      VStack(alignment: .leading, spacing: context.spacingSM) {
        if let title = title {
          Text(title)
            .font(context.headingFont)
            .foregroundStyle(context.textPrimary)
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
                  .foregroundStyle(context.textSecondary)
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

private struct PieSegmentData: Decodable {
  let label: String
  let value: Double
  let color: String?

  private enum CodingKeys: String, CodingKey {
    case label
    case value
    case color
  }

  init(label: String, value: Double, color: String?) {
    self.label = label
    self.value = value
    self.color = color
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    label = try container.decodeIfPresent(String.self, forKey: .label) ?? ""
    if let value = try container.decodeIfPresent(Double.self, forKey: .value) {
      self.value = value
    } else {
      self.value = Double(try container.decodeIfPresent(Int.self, forKey: .value) ?? 0)
    }
    color = try container.decodeIfPresent(String.self, forKey: .color)
  }
}

private struct PieSegment: Identifiable {
  let id = UUID()
  let label: String
  let value: Double
  let color: Color

  init(label: String, value: Double, color: Color) {
    self.label = label
    self.value = value
    self.color = color
  }

  init?(dict: [String: Any], context: RenderContext) {
    self.label = dict["label"] as? String ?? ""
    self.value = dict["value"] as? Double ?? Double(dict["value"] as? Int ?? 0)
    let colorString = dict["color"] as? String
    self.color = ColorParser.parse(colorString, default: context.primaryColor, context: context)
  }

  init(data: PieSegmentData, context: RenderContext) {
    label = data.label
    value = data.value
    color = ColorParser.parse(data.color, default: context.primaryColor, context: context)
  }
}

private struct EmptyStateView: View {
  let context: RenderContext

  var body: some View {
    Text(context.noDataAvailable)
      .font(context.captionFont)
      .foregroundStyle(context.textSecondary)
      .frame(maxWidth: .infinity, minHeight: context.emptyStateHeight)
  }
}
