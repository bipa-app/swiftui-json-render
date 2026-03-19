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
    let color =
      ColorResolver.resolve(node.string("color"), context: context) ?? context.primaryColor
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

/// Smooth Bézier sparkline with rounded caps — matches BipaChart.SparkLine style.
private struct SparklineChartView: View {
  let data: [Double]
  let color: Color

  var body: some View {
    GeometryReader { geo in
      let minY = data.min() ?? 0
      let maxY = data.max() ?? 1
      let range = max(maxY - minY, 1)
      let w = geo.size.width
      let h = geo.size.height

      Path { path in
        let pts = data.enumerated().map { i, v in
          CGPoint(
            x: w * CGFloat(i) / CGFloat(max(data.count - 1, 1)),
            y: h * (1 - CGFloat((v - minY) / range))
          )
        }
        guard let first = pts.first else { return }
        path.move(to: first)
        for i in 1..<pts.count {
          let cx = (pts[i].x + pts[i - 1].x) / 2
          path.addCurve(
            to: pts[i],
            control1: CGPoint(x: cx, y: pts[i - 1].y),
            control2: CGPoint(x: cx, y: pts[i].y)
          )
        }
      }
      .stroke(color, style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
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
            Spacer(minLength: 0)

            RoundedRectangle(cornerRadius: context.radiusSM)
              .fill(color.opacity(0.25 + 0.75 * value / maxVal))
              .frame(height: max(4, geo.size.height * 0.85 * CGFloat(value / maxVal)))

            if let labels, i < labels.count {
              Text(labels[i])
                .font(context.captionFont)
                .foregroundStyle(context.textSecondary)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
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
