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
public struct LineChartBuilder: ComponentBuilder {
  public static var typeName: String { "LineChart" }

  public static func build(node: ComponentNode, context: RenderContext) -> AnyView {
    let title = node.string("title")
    let color = ColorParser.parse(
      node.string("color"), default: context.primaryColor, context: context)
    let points = parsePoints(node.array("points"))

    return AnyView(
      VStack(alignment: .leading, spacing: context.spacingSM) {
        if let title = title {
          Text(title)
            .font(context.headingFont)
            .foregroundColor(context.textPrimary)
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

private struct LinePoint: Identifiable {
  let id = UUID()
  let x: String
  let y: Double

  init?(dict: [String: Any]) {
    self.x = dict["x"] as? String ?? ""
    self.y = dict["y"] as? Double ?? Double(dict["y"] as? Int ?? 0)
  }
}

private struct EmptyLineStateView: View {
  let context: RenderContext

  var body: some View {
    Text(context.noDataAvailable)
      .font(context.captionFont)
      .foregroundColor(context.textSecondary)
      .frame(maxWidth: .infinity, minHeight: context.emptyStateHeight)
  }
}
