# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.1.0] - 2025-01-15

### Added

- **Core Rendering**
  - `JSONView` for rendering JSON-defined UI as native SwiftUI views
  - `ComponentNode` for parsing and representing component trees
  - `RenderContext` for passing theme, strings, and handlers through the render tree

- **21 Built-in Components**
  - Layout: `Stack`, `Card`, `Divider`, `Spacer`
  - Content: `Text`, `Heading`, `Image`, `Icon`
  - Interactive: `Button`, `AmountInput`, `ConfirmDialog`, `ChoiceList`
  - Feedback: `Alert`
  - Financial: `BalanceCard`, `TransactionRow`, `TransactionList`, `AssetPrice`, `PieChart`, `LineChart`

- **Streaming Support**
  - `StreamingJSONRenderer` for rendering partial JSON as it arrives
  - `PartialJSONParser` for parsing incomplete JSON streams

- **Schema Versioning**
  - `SchemaVersion` for semantic version handling
  - Version compatibility checking between JSON and library
  - `UnknownComponentBehavior` for configurable handling of unknown components

- **Theming**
  - `JSONRenderTheme` protocol with 30+ customizable properties
  - Colors, typography, spacing, corner radius, opacity, sizes, animation settings
  - `DefaultTheme` with sensible defaults

- **Localization**
  - `JSONRenderStrings` protocol for customizable strings
  - Support for internationalization of component labels

- **Custom Components**
  - `ComponentBuilder` protocol for creating custom components
  - `ComponentRegistry` for registering and looking up builders

- **Action Handling**
  - `Action` type for representing user interactions
  - `.onAction()` modifier for handling actions

- **Validation**
  - `JSONValidator` for validating JSON structure before rendering

- **Utilities**
  - `ColorParser` for parsing hex and named colors
  - `FinancialFormatter` for BRL, BTC, USDT, and percentage formatting

[Unreleased]: https://github.com/bipa-app/swiftui-json-render/compare/0.1.0...HEAD
[0.1.0]: https://github.com/bipa-app/swiftui-json-render/releases/tag/0.1.0
