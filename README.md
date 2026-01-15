# SwiftUI JSON Render

Render AI-generated, schema-constrained JSON into native SwiftUI components.

## Requirements

- iOS 15+ / macOS 12+
- Swift 5.9+

## Install

Add the package to your project:

```
https://github.com/bipa-app/swiftui-json-render.git
```

Or add it to `Package.swift`:

```
.package(url: "https://github.com/bipa-app/swiftui-json-render.git", from: "0.1.0")
```

## Quick Start

```swift
import SwiftUIJSONRender

let json = """
{
  "type": "Stack",
  "props": { "direction": "vertical", "spacing": 16 },
  "children": [
    { "type": "Heading", "props": { "text": "Overview", "level": 2 } },
    { "type": "Text", "props": { "content": "Hello from JSON!" } },
    { "type": "Divider", "props": { "thickness": 1 } },
    { "type": "Button", "props": { "label": "Continue", "action": { "name": "continue" } } }
  ]
}
"""

struct ContentView: View {
  var body: some View {
    JSONView(json)
      .onAction { action in
        print("Action:", action.name)
      }
  }
}
```

## Components (Phase 1 + 2 + 3 + 4)

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
  "children": [ ... ]
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
  "children": [ ... ]
}
```

#### Divider
```json
{
  "type": "Divider",
  "props": {
    "orientation": "horizontal | vertical",
    "thickness": 1,
    "color": "#E5E7EB",
    "padding": 8,
    "length": 200
  }
}
```

#### Spacer
```json
{
  "type": "Spacer",
  "props": { "size": 24 }
}
```

### Content

#### Text
```json
{
  "type": "Text",
  "props": {
    "content": "Hello, world!",
    "style": "body | caption | footnote | headline | title | largeTitle | subheadline",
    "color": "#000000",
    "weight": "regular | medium | semibold | bold | heavy | light | thin"
  }
}
```

#### Heading
```json
{
  "type": "Heading",
  "props": {
    "text": "Section Title",
    "level": 1 | 2 | 3
  }
}
```

#### Image
```json
{
  "type": "Image",
  "props": {
    "url": "https://example.com/image.png",
    "name": "local_asset",
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
    "label": "Send PIX",
    "style": "primary | secondary | destructive",
    "icon": "paperplane.fill",
    "disabled": false,
    "action": {
      "name": "send_pix",
      "params": { "preset": "contacts" }
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
    "placeholder": "0,00",
    "currency": "BRL",
    "action": { "name": "submit_amount" }
  }
}
```

#### ConfirmDialog
```json
{
  "type": "ConfirmDialog",
  "props": {
    "title": "Confirm Transfer",
    "message": "Send R$ 10.00?",
    "confirmLabel": "Confirm",
    "cancelLabel": "Cancel",
    "triggerLabel": "Send",
    "action": { "name": "send_pix" }
  }
}
```

#### ChoiceList
```json
{
  "type": "ChoiceList",
  "props": {
    "question": "Which PIX key?",
    "options": [
      { "id": "cpf", "label": "CPF: ***456", "description": "Tax ID" },
      { "id": "phone", "label": "Phone: +55 11 ****-5678" }
    ],
    "action": { "name": "select_pix_key", "paramKey": "key_id" }
  }
}
```

### Feedback

#### Alert
```json
{
  "type": "Alert",
  "props": {
    "title": "Bill Due Soon",
    "message": "Your card bill of R$ 890 is due in 3 days",
    "severity": "info | warning | error | success",
    "dismissible": true,
    "action": {
      "label": "Pay Now",
      "name": "pay_bill"
    }
  }
}
```

### Financial (Phase 3)

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
    "description": "PIX to Maria",
    "amount": -50000,
    "date": "2026-01-14",
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
      { "id": "tx1", "description": "PIX to Maria", "amount": -50000, "date": "2026-01-14" },
      { "id": "tx2", "description": "Salary", "amount": 500000, "date": "2026-01-10" }
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
    "price": 180000.23,
    "change": 1200.5,
    "changePercent": 1.28
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
      { "label": "Food", "value": 45000, "color": "#FF6B6B" },
      { "label": "Transport", "value": 22000, "color": "#4ECDC4" }
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
      { "x": "2026-01-10", "y": 120000 },
      { "x": "2026-01-11", "y": 124000 }
    ],
    "color": "#45B7D1"
  }
}
```

## Theme

Provide a custom theme by conforming to `JSONRenderTheme` and applying it via `.theme(...)`.

```swift
struct MyTheme: JSONRenderTheme {
  static var primaryColor: Color { .purple }
  static var surfaceColor: Color { Color(.systemGray6) }
  static var headingFont: Font { .title2 }
}

JSONView(json)
  .theme(MyTheme.self)
```

## Custom Components

Register your own builders and use them in JSON:

```swift
struct MyBadgeBuilder: ComponentBuilder {
  static var typeName: String { "Badge" }
  static func build(node: ComponentNode, context: RenderContext) -> AnyView {
    AnyView(Text(node.string("text") ?? "").padding(6).background(.blue))
  }
}

let registry = ComponentRegistry()
registry.register(MyBadgeBuilder.self)

JSONView(json)
  .componentRegistry(registry)
```

## Validation

Validate JSON before rendering:

```swift
let result = JSONValidator.validate(json)
if result.isValid {
  JSONView(json)
}
```

## Actions

Interactive components can emit actions:

```swift
JSONView(json)
  .onAction { action in
    switch action.name {
    case "navigate":
      // handle navigation
      break
    default:
      break
    }
  }
```
