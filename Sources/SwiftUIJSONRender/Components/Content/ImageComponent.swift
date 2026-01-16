import SwiftUI

/// Renders an Image component.

public enum ImageContentMode: String, Sendable, Codable, CaseIterable {
  case fit
  case fill
}
///
/// ## JSON Example
/// ```json
/// {
///   "type": "Image",
///   "props": {
///     "url": "https://example.com/image.png",
///     "contentMode": "fit",
///     "width": 200,
///     "height": 120
///   }
/// }
/// ```
///
/// ## Props
/// - `url`: Remote image URL
/// - `name`: Local asset name
/// - `contentMode`: "fit" (default) or "fill"
/// - `width`: Optional width
/// - `height`: Optional height
public struct ImageBuilder: ComponentBuilder {
  public static var typeName: String { "Image" }

  public static func build(node: ComponentNode, context: RenderContext) -> AnyView {
    let urlString = node.string("url")
    let name = node.string("name")
    let contentMode = parseContentMode(node.enumValue("contentMode", default: ImageContentMode.fit))
    let width = node.double("width").map { CGFloat($0) }
    let height = node.double("height").map { CGFloat($0) }

    if let urlString = urlString, let url = URL(string: urlString) {
      let placeholderOpacity = context.placeholderOpacity
      return AnyView(
        AsyncImage(url: url) { phase in
          switch phase {
          case .success(let image):
            image
              .resizable()
              .aspectRatio(contentMode: contentMode)
              .frame(width: width, height: height)
          case .failure:
            Color.gray.opacity(placeholderOpacity)
              .frame(width: width, height: height)
          case .empty:
            ProgressView()
              .frame(width: width, height: height)
          @unknown default:
            Color.gray.opacity(placeholderOpacity)
              .frame(width: width, height: height)
          }
        }
      )
    }

    if let name = name {
      return AnyView(
        Image(name)
          .resizable()
          .aspectRatio(contentMode: contentMode)
          .frame(width: width, height: height)
      )
    }

    return AnyView(EmptyView())
  }

  private static func parseContentMode(_ value: ImageContentMode) -> ContentMode {
    switch value {
    case .fill:
      return .fill
    case .fit:
      return .fit
    }
  }
}
