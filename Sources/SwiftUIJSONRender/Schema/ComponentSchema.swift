import Foundation

/// Schema definitions for JSON-rendered components.
public struct SchemaDocument: Codable, Sendable {
  public let version: String
  public let components: [ComponentSchema]

  public static let current = SchemaDocument(
    version: "0.1.0",
    components: ComponentSchema.builtIn
  )

  public func json(prettyPrinted: Bool = true) -> String {
    let encoder = JSONEncoder()
    if prettyPrinted {
      encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
    }
    guard let data = try? encoder.encode(self) else { return "{}" }
    return String(data: data, encoding: .utf8) ?? "{}"
  }
}

public struct ComponentSchema: Codable, Sendable {
  public let type: String
  public let children: Bool
  public let props: [ComponentPropSchema]
}

public struct ComponentPropSchema: Codable, Sendable {
  public let name: String
  public let type: String
  public let required: Bool?
  public let enumValues: [String]?
  public let items: PropItemsSchema?
  public let properties: [ComponentPropSchema]?

  public init(
    name: String,
    type: String,
    required: Bool? = nil,
    enumValues: [String]? = nil,
    items: PropItemsSchema? = nil,
    properties: [ComponentPropSchema]? = nil
  ) {
    self.name = name
    self.type = type
    self.required = required
    self.enumValues = enumValues
    self.items = items
    self.properties = properties
  }
}

public struct PropItemsSchema: Codable, Sendable {
  public let type: String
  public let properties: [ComponentPropSchema]?
}

extension ComponentSchema {
  static let builtIn: [ComponentSchema] = [
    ComponentSchema(
      type: "Stack",
      children: true,
      props: [
        ComponentPropSchema(
          name: "direction", type: "string", enumValues: ["vertical", "horizontal"]),
        ComponentPropSchema(name: "spacing", type: "number"),
        ComponentPropSchema(
          name: "alignment", type: "string", enumValues: ["leading", "center", "trailing"]),
      ]
    ),
    ComponentSchema(
      type: "Card",
      children: true,
      props: [
        ComponentPropSchema(name: "title", type: "string"),
        ComponentPropSchema(name: "padding", type: "number"),
        ComponentPropSchema(name: "cornerRadius", type: "number"),
      ]
    ),
    ComponentSchema(
      type: "Divider",
      children: false,
      props: [
        ComponentPropSchema(
          name: "orientation", type: "string", enumValues: ["horizontal", "vertical"]),
        ComponentPropSchema(name: "thickness", type: "number"),
        ComponentPropSchema(name: "color", type: "string"),
        ComponentPropSchema(name: "padding", type: "number"),
        ComponentPropSchema(name: "length", type: "number"),
      ]
    ),
    ComponentSchema(
      type: "Spacer",
      children: false,
      props: [
        ComponentPropSchema(name: "size", type: "number"),
      ]
    ),
    ComponentSchema(
      type: "Text",
      children: false,
      props: [
        ComponentPropSchema(name: "content", type: "string", required: true),
        ComponentPropSchema(
          name: "style",
          type: "string",
          enumValues: [
            "body", "caption", "footnote", "headline", "title", "largeTitle", "subheadline",
          ]
        ),
        ComponentPropSchema(
          name: "weight",
          type: "string",
          enumValues: ["regular", "medium", "semibold", "bold", "heavy", "light", "thin"]
        ),
        ComponentPropSchema(name: "color", type: "string"),
      ]
    ),
    ComponentSchema(
      type: "Heading",
      children: false,
      props: [
        ComponentPropSchema(name: "text", type: "string", required: true),
        ComponentPropSchema(name: "level", type: "integer"),
      ]
    ),
    ComponentSchema(
      type: "Image",
      children: false,
      props: [
        ComponentPropSchema(name: "url", type: "string"),
        ComponentPropSchema(name: "name", type: "string"),
        ComponentPropSchema(name: "contentMode", type: "string", enumValues: ["fit", "fill"]),
        ComponentPropSchema(name: "width", type: "number"),
        ComponentPropSchema(name: "height", type: "number"),
      ]
    ),
    ComponentSchema(
      type: "Icon",
      children: false,
      props: [
        ComponentPropSchema(name: "name", type: "string", required: true),
        ComponentPropSchema(name: "size", type: "number"),
        ComponentPropSchema(name: "color", type: "string"),
      ]
    ),
    ComponentSchema(
      type: "BalanceCard",
      children: false,
      props: [
        ComponentPropSchema(name: "brl", type: "integer", required: true),
        ComponentPropSchema(name: "btc", type: "integer", required: true),
        ComponentPropSchema(name: "usdt", type: "integer"),
        ComponentPropSchema(name: "showChange", type: "boolean"),
        ComponentPropSchema(name: "brlChange", type: "number"),
      ]
    ),
    ComponentSchema(
      type: "TransactionRow",
      children: false,
      props: [
        ComponentPropSchema(name: "id", type: "string"),
        ComponentPropSchema(name: "description", type: "string"),
        ComponentPropSchema(name: "amount", type: "integer"),
        ComponentPropSchema(name: "date", type: "string"),
        ComponentPropSchema(name: "category", type: "string"),
        ComponentPropSchema(name: "icon", type: "string"),
      ]
    ),
    ComponentSchema(
      type: "TransactionList",
      children: false,
      props: [
        ComponentPropSchema(
          name: "transactions",
          type: "array",
          items: PropItemsSchema(
            type: "object",
            properties: [
              ComponentPropSchema(name: "id", type: "string"),
              ComponentPropSchema(name: "description", type: "string"),
              ComponentPropSchema(name: "amount", type: "integer"),
              ComponentPropSchema(name: "date", type: "string"),
              ComponentPropSchema(name: "category", type: "string"),
              ComponentPropSchema(name: "icon", type: "string"),
            ]
          )
        )
      ]
    ),
    ComponentSchema(
      type: "AssetPrice",
      children: false,
      props: [
        ComponentPropSchema(name: "symbol", type: "string"),
        ComponentPropSchema(name: "price", type: "number"),
        ComponentPropSchema(name: "change", type: "number"),
        ComponentPropSchema(name: "changePercent", type: "number"),
      ]
    ),
    ComponentSchema(
      type: "PieChart",
      children: false,
      props: [
        ComponentPropSchema(name: "title", type: "string"),
        ComponentPropSchema(name: "showLegend", type: "boolean"),
        ComponentPropSchema(
          name: "segments",
          type: "array",
          items: PropItemsSchema(
            type: "object",
            properties: [
              ComponentPropSchema(name: "label", type: "string"),
              ComponentPropSchema(name: "value", type: "number"),
              ComponentPropSchema(name: "color", type: "string"),
            ]
          )
        ),
      ]
    ),
    ComponentSchema(
      type: "LineChart",
      children: false,
      props: [
        ComponentPropSchema(name: "title", type: "string"),
        ComponentPropSchema(name: "color", type: "string"),
        ComponentPropSchema(
          name: "points",
          type: "array",
          items: PropItemsSchema(
            type: "object",
            properties: [
              ComponentPropSchema(name: "x", type: "string"),
              ComponentPropSchema(name: "y", type: "number"),
            ]
          )
        ),
      ]
    ),
    ComponentSchema(
      type: "Button",
      children: false,
      props: [
        ComponentPropSchema(name: "label", type: "string", required: true),
        ComponentPropSchema(
          name: "style", type: "string", enumValues: ["primary", "secondary", "destructive"]),
        ComponentPropSchema(name: "icon", type: "string"),
        ComponentPropSchema(name: "disabled", type: "boolean"),
        ComponentPropSchema(name: "action", type: "object"),
      ]
    ),
    ComponentSchema(
      type: "AmountInput",
      children: false,
      props: [
        ComponentPropSchema(name: "label", type: "string"),
        ComponentPropSchema(name: "placeholder", type: "string"),
        ComponentPropSchema(name: "currency", type: "string"),
        ComponentPropSchema(name: "action", type: "object"),
      ]
    ),
    ComponentSchema(
      type: "ConfirmDialog",
      children: false,
      props: [
        ComponentPropSchema(name: "title", type: "string"),
        ComponentPropSchema(name: "message", type: "string"),
        ComponentPropSchema(name: "confirmLabel", type: "string"),
        ComponentPropSchema(name: "cancelLabel", type: "string"),
        ComponentPropSchema(name: "triggerLabel", type: "string"),
        ComponentPropSchema(name: "action", type: "object"),
      ]
    ),
    ComponentSchema(
      type: "ChoiceList",
      children: false,
      props: [
        ComponentPropSchema(name: "question", type: "string"),
        ComponentPropSchema(
          name: "options",
          type: "array",
          items: PropItemsSchema(
            type: "object",
            properties: [
              ComponentPropSchema(name: "id", type: "string", required: true),
              ComponentPropSchema(name: "label", type: "string", required: true),
              ComponentPropSchema(name: "description", type: "string"),
            ]
          )
        ),
        ComponentPropSchema(
          name: "action",
          type: "object",
          properties: [
            ComponentPropSchema(name: "name", type: "string", required: true),
            ComponentPropSchema(name: "paramKey", type: "string"),
          ]
        ),
      ]
    ),
    ComponentSchema(
      type: "Alert",
      children: false,
      props: [
        ComponentPropSchema(name: "title", type: "string"),
        ComponentPropSchema(name: "message", type: "string"),
        ComponentPropSchema(
          name: "severity", type: "string", enumValues: ["info", "success", "warning", "error"]),
        ComponentPropSchema(name: "dismissible", type: "boolean"),
        ComponentPropSchema(
          name: "action",
          type: "object",
          properties: [
            ComponentPropSchema(name: "label", type: "string"),
            ComponentPropSchema(name: "name", type: "string"),
            ComponentPropSchema(name: "params", type: "object"),
            ComponentPropSchema(
              name: "confirm",
              type: "object",
              properties: [
                ComponentPropSchema(name: "title", type: "string"),
                ComponentPropSchema(name: "message", type: "string"),
                ComponentPropSchema(name: "confirmLabel", type: "string"),
                ComponentPropSchema(name: "cancelLabel", type: "string"),
              ]
            ),
          ]
        ),
      ]
    ),
  ]
}
