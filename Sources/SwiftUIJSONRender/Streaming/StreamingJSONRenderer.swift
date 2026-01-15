import SwiftUI

/// Renders partial JSON streams into SwiftUI views as content arrives.
@MainActor
public final class StreamingJSONRenderer: ObservableObject {
  @Published public private(set) var node: ComponentNode?
  @Published public private(set) var isLoading: Bool

  private var parser: PartialJSONParser

  public init() {
    self.node = nil
    self.isLoading = true
    self.parser = PartialJSONParser()
  }

  /// Append a new JSON chunk from the stream.
  /// - Parameter chunk: Partial JSON string to append.
  /// - Parameter animationDuration: Duration for the update animation. Pass theme's `animationDuration`.
  public func append(_ chunk: String, animationDuration: Double = DefaultTheme.animationDuration) {
    parser.append(chunk)
    if let parsed = parser.latestComponentNode() {
      withAnimation(.easeInOut(duration: animationDuration)) {
        node = parsed
      }
    }
    isLoading = true
  }

  /// Mark the stream as complete.
  public func complete() {
    isLoading = false
  }

  /// Reset the renderer to its initial empty state.
  public func reset() {
    parser.reset()
    node = nil
    isLoading = true
  }

  /// A view that renders the current streaming output.
  public var currentView: some View {
    StreamingRendererView(renderer: self)
  }
}

private struct StreamingRendererView: View {
  @ObservedObject var renderer: StreamingJSONRenderer
  @Environment(\.componentTheme) private var themeType

  var body: some View {
    let animationDuration = themeType.animationDuration
    Group {
      if let node = renderer.node {
        JSONView(node)
          .transition(.opacity)
          .overlay(alignment: .topTrailing) {
            if renderer.isLoading {
              StreamingLoadingBadge(themeType: themeType)
            }
          }
      } else {
        StreamingLoadingView(themeType: themeType)
          .transition(.opacity)
      }
    }
    .animation(.easeInOut(duration: animationDuration), value: renderer.node?.type ?? "")
    .animation(.easeInOut(duration: animationDuration), value: renderer.isLoading)
  }
}

private struct StreamingLoadingView: View {
  let themeType: any JSONRenderTheme.Type

  var body: some View {
    ProgressView()
      .tint(themeType.primaryColor)
      .frame(maxWidth: .infinity)
      .padding(themeType.spacingMD)
      .background(
        RoundedRectangle(cornerRadius: themeType.radiusMD)
          .fill(themeType.surfaceColor)
      )
  }
}

private struct StreamingLoadingBadge: View {
  let themeType: any JSONRenderTheme.Type

  var body: some View {
    ProgressView()
      .scaleEffect(themeType.loadingBadgeScale)
      .tint(themeType.primaryColor)
      .padding(themeType.spacingSM)
      .background(
        RoundedRectangle(cornerRadius: themeType.radiusSM)
          .fill(themeType.surfaceColor)
      )
      .padding(themeType.spacingSM)
  }
}
