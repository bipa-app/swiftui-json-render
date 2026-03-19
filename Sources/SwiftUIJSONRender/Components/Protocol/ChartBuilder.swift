import SwiftUI

/// `chart` — Sparkline, bar chart, or progress bar.
///
/// ```json
/// { "type": "chart", "props": { "style": "sparkline", "data": [340,345,350], "color": "violet" } }
/// ```
public struct ChartBuilder: ComponentBuilder {
  public static var typeName: String { "chart" }

  @MainActor
  public static func build(node: ComponentNode, context: RenderContext) -> AnyView {
    let style = node.string("style") ?? "sparkline"
    let data = node.array("data")?.compactMap { ($0 as? NSNumber)?.doubleValue } ?? []
    let color = ColorResolver.resolve(node.string("color"), context: context) ?? context.primaryColor
    let height = node.double("height") ?? Double(context.chartHeight)
    let labels = node.array("labels")?.compactMap { $0 as? String }
    let progressValue = node.double("value") ?? 0

    return AnyView(
      Group {
        switch style {
        case "bar":
          BarChartView(data: data, labels: labels, color: color, context: context)
            .frame(height: CGFloat(height))
        case "progress":
          ProgressBarView(value: progressValue, color: color, context: context)
        default:
          SparklineChartView(data: data, color: color)
            .frame(height: CGFloat(height))
        }
      }
    )
  }
}

// MARK: - Sparkline

private struct SparklineChartView: View {
  let data: [Double]
  let color: Color

  var body: some View {
    GeometryReader { geo in
      let minY = data.min() ?? 0
      let maxY = data.max() ?? 1
      let range = max(maxY - minY, 1)

      Path { path in
        let points = data.enumerated().map { i, value in
          CGPoint(
            x: geo.size.width * CGFloat(i) / CGFloat(max(data.count - 1, 1)),
            y: geo.size.height * (1 - CGFloat((value - minY) / range))
          )
        }
        guard let first = points.first else { return }
        path.move(to: first)
        for i in 1..<points.count {
          let ctrl = CGPoint(x: (points[i].x + points[i-1].x) / 2, y: points[i-1].y)
          let ctrl2 = CGPoint(x: (points[i].x + points[i-1].x) / 2, y: points[i].y)
          path.addCurve(to: points[i], control1: ctrl, control2: ctrl2)
        }
      }
      .stroke(color, style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
    }
  }
}

// MARK: - Bar Chart

private struct BarChartView: View {
  let data: [Double]
  let labels: [String]?
  let color: Color
  let context: RenderContext

  var body: some View {
    let maxVal = data.max() ?? 1

    GeometryReader { geo in
      HStack(alignment: .bottom, spacing: context.spacingXS) {
        ForEach(Array(data.enumerated()), id: \.offset) { i, value in
          VStack(spacing: context.spacingXS) {
            RoundedRectangle(cornerRadius: context.radiusSM)
              .fill(color.opacity(0.2 + 0.8 * value / maxVal))
              .frame(height: max(4, geo.size.height * CGFloat(value / maxVal)))

            if let labels, i < labels.count {
              Text(labels[i])
                .font(context.captionFont)
                .foregroundStyle(context.textSecondary)
                .lineLimit(1)
                .minimumScaleFactor(0.6)
            }
          }
          .frame(maxWidth: .infinity)
        }
      }
    }
  }
}

// MARK: - Progress Bar

private struct ProgressBarView: View {
  let value: Double
  let color: Color
  let context: RenderContext

  var body: some View {
    GeometryReader { geo in
      ZStack(alignment: .leading) {
        RoundedRectangle(cornerRadius: context.radiusSM)
          .fill(color.opacity(0.15))

        RoundedRectangle(cornerRadius: context.radiusSM)
          .fill(color)
          .frame(width: geo.size.width * CGFloat(min(max(value, 0), 1)))
      }
    }
    .frame(height: 8)
  }
}
