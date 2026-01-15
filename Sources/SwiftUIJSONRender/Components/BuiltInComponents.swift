import Foundation

/// A module containing all built-in components.
///
/// This module is automatically registered with the shared `ComponentRegistry`.
public struct BuiltInComponentsModule: ComponentModule {
  public init() {}

  public var builders: [AnyComponentBuilder] {
    [
      // Layout
      AnyComponentBuilder(StackBuilder.self),
      AnyComponentBuilder(CardBuilder.self),
      AnyComponentBuilder(DividerBuilder.self),
      AnyComponentBuilder(SpacerBuilder.self),

      // Content
      AnyComponentBuilder(TextBuilder.self),
      AnyComponentBuilder(HeadingBuilder.self),
      AnyComponentBuilder(ImageBuilder.self),
      AnyComponentBuilder(IconBuilder.self),

      // Financial
      AnyComponentBuilder(BalanceCardBuilder.self),
      AnyComponentBuilder(TransactionRowBuilder.self),
      AnyComponentBuilder(TransactionListBuilder.self),
      AnyComponentBuilder(AssetPriceBuilder.self),
      AnyComponentBuilder(PieChartBuilder.self),
      AnyComponentBuilder(LineChartBuilder.self),

      // Interactive
      AnyComponentBuilder(ButtonBuilder.self),
      AnyComponentBuilder(AmountInputBuilder.self),
      AnyComponentBuilder(ConfirmDialogBuilder.self),
      AnyComponentBuilder(ChoiceListBuilder.self),

      // Feedback
      AnyComponentBuilder(AlertBuilder.self),
    ]
  }
}

/// Registers all built-in components with the shared registry.
///
/// This is called automatically when the framework is imported.
public func registerBuiltInComponents() {
  ComponentRegistry.shared.register(module: BuiltInComponentsModule())
}
