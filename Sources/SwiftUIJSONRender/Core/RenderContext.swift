import SwiftUI

/// Context passed through the component render tree.
///
/// The render context provides access to the theme, action handler, and registry,
/// as well as methods for rendering child nodes and handling actions.
public struct RenderContext {
  /// The theme type to use for styling.
  public let themeType: any JSONRenderTheme.Type

  /// The action handler closure, if provided.
  public let actionHandler: ActionHandler?

  /// The component registry to use for looking up builders.
  public let registry: ComponentRegistry

  /// The behavior for handling unknown components.
  public let unknownComponentBehavior: UnknownComponentBehavior

  /// Creates a new render context.
  /// - Parameters:
  ///   - themeType: The theme type to use. Defaults to `DefaultTheme.self`.
  ///   - actionHandler: Optional action handler closure.
  ///   - registry: The component registry. Defaults to the shared registry.
  ///   - unknownComponentBehavior: How to handle unknown components. Defaults to `.placeholder`.
  public init(
    themeType: any JSONRenderTheme.Type = DefaultTheme.self,
    actionHandler: ActionHandler? = nil,
    registry: ComponentRegistry = .shared,
    unknownComponentBehavior: UnknownComponentBehavior = .placeholder
  ) {
    self.themeType = themeType
    self.actionHandler = actionHandler
    self.registry = registry
    self.unknownComponentBehavior = unknownComponentBehavior
  }

  /// Renders a child component node.
  /// - Parameter node: The component node to render.
  /// - Returns: The rendered view, or an appropriate fallback based on `unknownComponentBehavior`.
  @MainActor
  public func render(_ node: ComponentNode) -> AnyView {
    guard let builder = registry.builder(for: node.type) else {
      return renderUnknownComponent(typeName: node.type)
    }
    return builder.build(node: node, context: self)
  }

  /// Renders a fallback view for an unknown component based on the configured behavior.
  @MainActor
  private func renderUnknownComponent(typeName: String) -> AnyView {
    switch unknownComponentBehavior {
    case .placeholder:
      return AnyView(UnknownComponentPlaceholderView(typeName: typeName))
    case .skip:
      return AnyView(EmptyView())
    case .error:
      return AnyView(UnknownComponentErrorView(typeName: typeName))
    }
  }

  /// Renders multiple child component nodes.
  /// - Parameter nodes: The component nodes to render.
  /// - Returns: An array of rendered views.
  @MainActor
  public func renderChildren(_ nodes: [ComponentNode]?) -> [AnyView] {
    guard let nodes = nodes else { return [] }
    return nodes.map { render($0) }
  }

  /// Handles an action from component props.
  /// - Parameter actionValue: The action value from props (typically `props["action"]`).
  public func handleAction(_ actionValue: AnyCodable?) {
    guard let action = Action.from(actionValue) else { return }
    actionHandler?(action)
  }

  /// Handles an action directly.
  /// - Parameter action: The action to handle.
  public func handle(_ action: Action) {
    actionHandler?(action)
  }

  /// Creates a new context with an updated theme type.
  /// - Parameter themeType: The new theme type.
  /// - Returns: A new context with the updated theme.
  public func with(themeType: any JSONRenderTheme.Type) -> RenderContext {
    RenderContext(
      themeType: themeType,
      actionHandler: actionHandler,
      registry: registry,
      unknownComponentBehavior: unknownComponentBehavior
    )
  }

  /// Creates a new context with an updated action handler.
  /// - Parameter actionHandler: The new action handler.
  /// - Returns: A new context with the updated handler.
  public func with(actionHandler: ActionHandler?) -> RenderContext {
    RenderContext(
      themeType: themeType,
      actionHandler: actionHandler,
      registry: registry,
      unknownComponentBehavior: unknownComponentBehavior
    )
  }

  /// Creates a new context with an updated registry.
  /// - Parameter registry: The new registry.
  /// - Returns: A new context with the updated registry.
  public func with(registry: ComponentRegistry) -> RenderContext {
    RenderContext(
      themeType: themeType,
      actionHandler: actionHandler,
      registry: registry,
      unknownComponentBehavior: unknownComponentBehavior
    )
  }

  /// Creates a new context with an updated unknown component behavior.
  /// - Parameter behavior: The new behavior for unknown components.
  /// - Returns: A new context with the updated behavior.
  public func with(unknownComponentBehavior behavior: UnknownComponentBehavior) -> RenderContext {
    RenderContext(
      themeType: themeType,
      actionHandler: actionHandler,
      registry: registry,
      unknownComponentBehavior: behavior
    )
  }
}

// MARK: - Theme Accessors

extension RenderContext {
  /// The primary color from the theme.
  public var primaryColor: Color { themeType.primaryColor }

  /// The secondary color from the theme.
  public var secondaryColor: Color { themeType.secondaryColor }

  /// The background color from the theme.
  public var backgroundColor: Color { themeType.backgroundColor }

  /// The surface color from the theme.
  public var surfaceColor: Color { themeType.surfaceColor }

  /// The primary text color from the theme.
  public var textPrimary: Color { themeType.textPrimary }

  /// The secondary text color from the theme.
  public var textSecondary: Color { themeType.textSecondary }

  /// The error color from the theme.
  public var errorColor: Color { themeType.errorColor }

  /// The success color from the theme.
  public var successColor: Color { themeType.successColor }

  /// The warning color from the theme.
  public var warningColor: Color { themeType.warningColor }

  /// The heading font from the theme.
  public var headingFont: Font { themeType.headingFont }

  /// The body font from the theme.
  public var bodyFont: Font { themeType.bodyFont }

  /// The caption font from the theme.
  public var captionFont: Font { themeType.captionFont }

  /// Extra small spacing from the theme.
  public var spacingXS: CGFloat { themeType.spacingXS }

  /// Small spacing from the theme.
  public var spacingSM: CGFloat { themeType.spacingSM }

  /// Medium spacing from the theme.
  public var spacingMD: CGFloat { themeType.spacingMD }

  /// Large spacing from the theme.
  public var spacingLG: CGFloat { themeType.spacingLG }

  /// Extra large spacing from the theme.
  public var spacingXL: CGFloat { themeType.spacingXL }

  /// Small corner radius from the theme.
  public var radiusSM: CGFloat { themeType.radiusSM }

  /// Medium corner radius from the theme.
  public var radiusMD: CGFloat { themeType.radiusMD }

  /// Large corner radius from the theme.
  public var radiusLG: CGFloat { themeType.radiusLG }
}

// MARK: - Unknown Component Views

/// A placeholder view displayed when a component type is not found in the registry.
/// Shows a subtle gray indicator that something is missing.
struct UnknownComponentPlaceholderView: View {
  let typeName: String

  var body: some View {
    RoundedRectangle(cornerRadius: 4)
      .fill(Color.gray.opacity(0.15))
      .frame(height: 24)
      .overlay(
        HStack(spacing: 4) {
          Image(systemName: "questionmark.square.dashed")
            .font(.caption2)
          Text(typeName)
            .font(.caption2)
        }
        .foregroundColor(.gray)
      )
  }
}

/// An error view displayed when a component type is not found in the registry.
/// Shows a more prominent red indicator with the component type name.
struct UnknownComponentErrorView: View {
  let typeName: String

  var body: some View {
    HStack(spacing: 6) {
      Image(systemName: "exclamationmark.triangle.fill")
        .font(.caption)
      Text("Unknown: \(typeName)")
        .font(.caption)
    }
    .foregroundColor(.red)
    .padding(.horizontal, 8)
    .padding(.vertical, 4)
    .background(Color.red.opacity(0.1))
    .cornerRadius(4)
  }
}
