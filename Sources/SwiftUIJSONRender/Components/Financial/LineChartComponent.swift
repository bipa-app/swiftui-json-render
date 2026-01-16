import SwiftUI

#if canImport(Charts)
  import Charts
#endif

/// Renders a LineChart component.
///
/// ## JSON Example
/// ```json
/// {
///   "type": "LineChart",
///   "props": {
///     "title": "Portfolio Value",
///     "points": [
///       { "x": "2026-01-10", "y": 120000 },
///       { "x": "2026-01-11", "y": 124000 }
///     ],
///     "color": "#45B7D1"
///   }
/// }
/// ```
///
/// ## Props
/// - `title`: Optional title
/// - `points`: Array of points with x (string) and y (number)
/// - `color`: Line color
private struct LineChartProps: Decodable {
  let title: String?
  let color: String?
  let points: [LinePoint]
}

public struct LineChartBuilder: ComponentBuilder {
  public static var typeName: String { "LineChart" }

  public static func build(node: ComponentNode, context: RenderContext) -> AnyView {
    let props = node.decodeProps(LineChartProps.self)
    let title = props?.title ?? node.string("title")
    let color = ColorParser.parse(
      props?.color ?? node.string("color"), default: context.primaryColor, context: context)
    let points = props?.points ?? parsePoints(node.array("points"))

    return AnyView(
      VStack(alignment: .leading, spacing: context.spacingSM) {
        if let title = title {
          Text(title)
            .font(context.headingFont)
            .foregroundStyle(context.textPrimary)
        }

        #if canImport(Charts)
          if #available(iOS 17.0, macOS 14.0, *) {
            if !points.isEmpty {
              Chart(points) { point in
                LineMark(
                  x: .value("X", point.x),
                  y: .value("Y", point.y)
                )
                .foregroundStyle(color)
              }
              .frame(height: context.chartHeight)
            } else {
              EmptyLineStateView(context: context)
            }
          } else {
            EmptyLineStateView(context: context)
          }
        #else
          EmptyLineStateView(context: context)
        #endif
      }
      .padding(context.spacingMD)
      .background(context.surfaceColor)
      .clipShape(.rect(cornerRadius: context.radiusMD))
    )
  }

  private static func parsePoints(_ array: [Any]?) -> [LinePoint] {
    guard let array = array else { return [] }
    return array.compactMap { item in
      guard let dict = item as? [String: Any] else { return nil }
      return LinePoint(dict: dict)
    }
  }
}

private struct LinePoint: Identifiable, Decodable {
  let id = UUID()
  let x: String
  let y: Double

  private enum CodingKeys: String, CodingKey {
    case x
    case y
  }

  init(x: String, y: Double) {
    self.x = x
    self.y = y
  }

  init?(dict: [String: Any]) {
    self.x = dict["x"] as? String ?? ""
    self.y = dict["y"] as? Double ?? Double(dict["y"] as? Int ?? 0)
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    x = try container.decodeIfPresent(String.self, forKey: .x) ?? ""
    if let value = try container.decodeIfPresent(Double.self, forKey: .y) {
      y = value
    } else {
      y = Double(try container.decodeIfPresent(Int.self, forKey: .y) ?? 0)
    }
  }
}

private struct EmptyLineStateView: View {
  let context: RenderContext

  var body: some View {
    Text(context.noDataAvailable)
      .font(context.captionFont)
      .foregroundStyle(context.textSecondary)
      .frame(maxWidth: .infinity, minHeight: context.emptyStateHeight)
  }
}
