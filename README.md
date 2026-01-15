# SwiftUI JSON Render

[![Swift 5.9+](https://img.shields.io/badge/Swift-5.9+-orange.svg)](https://swift.org)
[![iOS 16+](https://img.shields.io/badge/iOS-16+-blue.svg)](https://developer.apple.com/ios/)
[![macOS 13+](https://img.shields.io/badge/macOS-13+-blue.svg)](https://developer.apple.com/macos/)
[![License: Apache-2.0](https://img.shields.io/badge/License-Apache%202.0-green.svg)](LICENSE)

> **Pre-release** - This library is currently in early development (v0.x). The API may change between releases and it may contain bugs. Use in production at your own risk. Feedback and bug reports are welcome!

A Swift library for rendering JSON-defined UI into native SwiftUI views. Designed for AI-generated interfaces, server-driven UI, and dynamic content rendering.

## Features

- **21 Built-in Components** - Layout, content, interactive, feedback, and financial components
- **Streaming Support** - Render partial JSON as it arrives from AI/LLM responses
- **Schema Versioning** - Compatibility checking between JSON and library versions
- **Theming** - Customizable colors, fonts, spacing, and more
- **Localization** - Customizable strings for internationalization
- **Custom Components** - Register your own component builders
- **Action Handling** - Capture user interactions from buttons, inputs, and choices
- **Validation** - Validate JSON structure before rendering

## Installation

### Swift Package Manager

Add to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/bipa-app/swiftui-json-render.git", from: "0.1.0")
]
```

Or in Xcode: **File → Add Package Dependencies** and enter:
```
https://github.com/bipa-app/swiftui-json-render.git
```

## Quick Start

```swift
import SwiftUIJSONRender

let json = """
{
  "schemaVersion": "1.0",
  "type": "Stack",
  "props": { "direction": "vertical", "spacing": 16 },
  "children": [
    { "type": "Heading", "props": { "text": "Welcome", "level": 1 } },
    { "type": "Text", "props": { "content": "Hello from JSON!" } },
    { "type": "Button", "props": { "label": "Get Started", "action": { "name": "start" } } }
  ]
}
"""

struct ContentView: View {
    var body: some View {
        JSONView(json)
            .onAction { action in
                print("Action triggered:", action.name)
            }
    }
}
```

## Schema Versioning

The library uses semantic versioning for the JSON schema. Include a `schemaVersion` field in your JSON to enable compatibility checking:

```json
{
  "schemaVersion": "1.0",
  "type": "Stack",
  "children": [...]
}
```

### Version Compatibility

| JSON Version | Library Behavior |
|--------------|------------------|
| Same major version | Fully compatible |
| Newer minor version | Renders with warnings (unknown components handled gracefully) |
| Older supported version | Renders normally |
| Too old/new major version | Shows version error |

### Unknown Component Handling

Configure how unknown components are rendered:

```swift
JSONView(json)
    .unknownComponentBehavior(.placeholder)  // Gray placeholder (default)
    .unknownComponentBehavior(.skip)         // Render nothing
    .unknownComponentBehavior(.error)        // Show error indicator
```

### Exporting Schema for AI

Export the current schema for AI prompt engineering:

```swift
let schema = SchemaDocument.current
print(schema.json())      // Full JSON schema
print(schema.filename)    // "schema-v1.0.json"
print(schema.version)     // SchemaVersion(1, 0, 0)
```

## Streaming Rendering

Render JSON incrementally as it streams from an AI/LLM:

```swift
struct StreamingView: View {
    @StateObject private var renderer = StreamingJSONRenderer()

    var body: some View {
        renderer.currentView
            .task {
                for await chunk in aiResponseStream {
                    renderer.append(chunk)
                }
                renderer.complete()
            }
    }
}
```

## Components

### Layout

#### Stack
```json
{
  "type": "Stack",
  "props": {
    "direction": "vertical | horizontal",
    "spacing": 8,
    "alignment": "leading | center | trailing"
  },
  "children": [...]
}
```

#### Card
```json
{
  "type": "Card",
  "props": {
    "title": "Optional Title",
    "padding": 16,
    "cornerRadius": 12
  },
  "children": [...]
}
```

#### Divider
```json
{
  "type": "Divider",
  "props": {
    "orientation": "horizontal | vertical",
    "thickness": 1,
    "color": "#E5E7EB"
  }
}
```

#### Spacer
```json
{ "type": "Spacer", "props": { "size": 24 } }
```

### Content

#### Text
```json
{
  "type": "Text",
  "props": {
    "content": "Hello, world!",
    "style": "body | caption | footnote | headline | title | largeTitle | subheadline",
    "weight": "regular | medium | semibold | bold | heavy | light | thin",
    "color": "#000000"
  }
}
```

#### Heading
```json
{
  "type": "Heading",
  "props": {
    "text": "Section Title",
    "level": 1
  }
}
```

#### Image
```json
{
  "type": "Image",
  "props": {
    "url": "https://example.com/image.png",
    "contentMode": "fit | fill",
    "width": 200,
    "height": 120
  }
}
```

#### Icon
```json
{
  "type": "Icon",
  "props": {
    "name": "star.fill",
    "size": 20,
    "color": "#FFB100"
  }
}
```

### Interactive

#### Button
```json
{
  "type": "Button",
  "props": {
    "label": "Submit",
    "style": "primary | secondary | destructive",
    "icon": "paperplane.fill",
    "disabled": false,
    "action": {
      "name": "submit",
      "params": { "id": "123" }
    }
  }
}
```

#### AmountInput
```json
{
  "type": "AmountInput",
  "props": {
    "label": "Amount",
    "placeholder": "0.00",
    "currency": "USD",
    "action": { "name": "submit_amount" }
  }
}
```

#### ConfirmDialog
```json
{
  "type": "ConfirmDialog",
  "props": {
    "title": "Confirm Action",
    "message": "Are you sure?",
    "confirmLabel": "Yes",
    "cancelLabel": "No",
    "triggerLabel": "Delete",
    "action": { "name": "delete" }
  }
}
```

#### ChoiceList
```json
{
  "type": "ChoiceList",
  "props": {
    "question": "Select an option",
    "options": [
      { "id": "opt1", "label": "Option 1", "description": "First choice" },
      { "id": "opt2", "label": "Option 2" }
    ],
    "action": { "name": "select", "paramKey": "option_id" }
  }
}
```

### Feedback

#### Alert
```json
{
  "type": "Alert",
  "props": {
    "title": "Notice",
    "message": "Something important happened",
    "severity": "info | warning | error | success",
    "dismissible": true,
    "action": {
      "label": "View Details",
      "name": "view_details"
    }
  }
}
```

### Financial

#### BalanceCard
```json
{
  "type": "BalanceCard",
  "props": {
    "brl": 1245032,
    "btc": 234000,
    "usdt": 50000000,
    "showChange": true,
    "brlChange": 5.2
  }
}
```

#### TransactionRow
```json
{
  "type": "TransactionRow",
  "props": {
    "id": "tx_123",
    "description": "Payment to John",
    "amount": -50000,
    "date": "2025-01-14",
    "category": "transfer",
    "icon": "arrow.up.right"
  }
}
```

#### TransactionList
```json
{
  "type": "TransactionList",
  "props": {
    "transactions": [
      { "id": "tx1", "description": "Payment", "amount": -50000, "date": "2025-01-14" },
      { "id": "tx2", "description": "Deposit", "amount": 500000, "date": "2025-01-10" }
    ]
  }
}
```

#### AssetPrice
```json
{
  "type": "AssetPrice",
  "props": {
    "symbol": "BTC",
    "price": 65000.23,
    "change": 1200.5,
    "changePercent": 1.88
  }
}
```

#### PieChart
```json
{
  "type": "PieChart",
  "props": {
    "title": "Spending by Category",
    "segments": [
      { "label": "Food", "value": 450, "color": "#FF6B6B" },
      { "label": "Transport", "value": 220, "color": "#4ECDC4" }
    ],
    "showLegend": true
  }
}
```

#### LineChart
```json
{
  "type": "LineChart",
  "props": {
    "title": "Portfolio Value",
    "points": [
      { "x": "Jan", "y": 1200 },
      { "x": "Feb", "y": 1350 },
      { "x": "Mar", "y": 1280 }
    ],
    "color": "#45B7D1"
  }
}
```

## Theming

Customize the appearance by implementing `JSONRenderTheme`. All properties have sensible defaults, so you only need to override what you want to change:

```swift
struct MyTheme: JSONRenderTheme {
    // Colors
    static var primaryColor: Color { .purple }
    static var secondaryColor: Color { .pink }
    static var backgroundColor: Color { Color(.systemBackground) }
    static var surfaceColor: Color { Color(.systemGray6) }
    static var textPrimary: Color { .primary }
    static var textSecondary: Color { .secondary }
    static var errorColor: Color { .red }
    static var successColor: Color { .green }
    static var warningColor: Color { .orange }

    // Typography
    static var headingFont: Font { .title2.bold() }
    static var bodyFont: Font { .body }
    static var captionFont: Font { .caption }

    // Spacing
    static var spacingXS: CGFloat { 4 }
    static var spacingSM: CGFloat { 8 }
    static var spacingMD: CGFloat { 16 }
    static var spacingLG: CGFloat { 24 }
    static var spacingXL: CGFloat { 32 }

    // Corner Radius
    static var radiusSM: CGFloat { 4 }
    static var radiusMD: CGFloat { 12 }
    static var radiusLG: CGFloat { 16 }

    // Opacity
    static var disabledOpacity: Double { 0.5 }
    static var placeholderOpacity: Double { 0.2 }
    static var alertBackgroundOpacity: Double { 0.1 }
    static var alertBorderOpacity: Double { 0.3 }

    // Sizes
    static var defaultIconSize: CGFloat { 16 }
    static var chartHeight: CGFloat { 180 }
    static var emptyStateHeight: CGFloat { 120 }
    static var legendIndicatorSize: CGFloat { 10 }
    static var borderWidth: CGFloat { 1 }

    // Animation
    static var animationDuration: Double { 0.2 }
    static var loadingBadgeScale: CGFloat { 0.7 }

    // Button Colors
    static var buttonPrimaryForeground: Color { .white }
    static var buttonDestructiveForeground: Color { .white }
}

JSONView(json)
    .theme(MyTheme.self)
```

## Localization

Customize strings for internationalization by implementing `JSONRenderStrings`:

```swift
struct SpanishStrings: JSONRenderStrings {
    static var defaultButtonLabel: String { "Botón" }
    static var defaultAlertTitle: String { "Alerta" }
    static var confirmDialogTitle: String { "Confirmar" }
    static var confirmButtonLabel: String { "Confirmar" }
    static var cancelButtonLabel: String { "Cancelar" }
    static var chooseOptionPrompt: String { "Elige una opción" }
    static var noDataAvailable: String { "Sin datos disponibles" }
    static var balancesTitle: String { "Saldos" }
    static var defaultIconName: String { "questionmark" }
    static var defaultTransactionDescription: String { "Transacción" }
}

JSONView(json)
    .strings(SpanishStrings.self)
```

You can combine theme and strings:

```swift
JSONView(json)
    .theme(MyTheme.self)
    .strings(SpanishStrings.self)
```

## Custom Components

Register custom component builders:

```swift
struct BadgeBuilder: ComponentBuilder {
    static var typeName: String { "Badge" }

    @MainActor
    static func build(node: ComponentNode, context: RenderContext) -> AnyView {
        let text = node.string("text") ?? ""
        let colorString = node.string("color")
        let color = ColorParser.parse(colorString, default: context.primaryColor, context: context)

        return AnyView(
            Text(text)
                .font(.caption)
                .padding(.horizontal, context.spacingSM)
                .padding(.vertical, context.spacingXS)
                .background(color)
                .foregroundStyle(.white)
                .clipShape(.rect(cornerRadius: context.radiusSM))
        )
    }
}

// Register and use
let registry = ComponentRegistry.shared.copy()
registry.register(BadgeBuilder.self)

JSONView(json)
    .componentRegistry(registry)
```

## Action Handling

Handle user interactions from interactive components:

```swift
JSONView(json)
    .onAction { action in
        switch action.name {
        case "navigate":
            let destination = action.string("destination")
            // Handle navigation
        case "submit":
            let data = action.dictionary("data")
            // Handle form submission
        default:
            print("Unknown action:", action.name)
        }
    }
```

## Validation

Validate JSON before rendering:

```swift
let result = JSONValidator.validate(json)

switch result {
case .valid:
    // Safe to render
    JSONView(json)
case .invalid(let errors):
    // Handle validation errors
    for error in errors {
        print("Validation error:", error)
    }
}
```

## Example App

A complete example app is available in the `Example/` directory demonstrating:

- Full JSON tree rendering
- Action handling
- Streaming JSON updates
- Custom theming
- Component showcase

## Requirements

- iOS 16.0+ / macOS 13.0+
- Swift 5.9+
- Xcode 15.0+

## License

Apache License 2.0. See [LICENSE](LICENSE) for details.

## Contributing

Contributions are welcome! Please read our contributing guidelines and submit pull requests to the `main` branch.
