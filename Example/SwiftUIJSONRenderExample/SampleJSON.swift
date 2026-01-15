import Foundation

enum SampleJSON {
  static let overview = """
    {
      "type": "Stack",
      "props": { "direction": "vertical", "spacing": 16 },
      "children": [
        { "type": "Heading", "props": { "text": "Account Overview", "level": 2 } },
        { "type": "BalanceCard", "props": { "brl": 1245032, "btc": 234000, "usdt": 50000000, "showChange": true, "brlChange": 5.2 } },
        { "type": "Divider", "props": { "thickness": 1 } },
        { "type": "TransactionList", "props": { "transactions": [
          { "description": "PIX to Maria", "amount": -50000, "date": "2026-01-14" },
          { "description": "Salary", "amount": 500000, "date": "2026-01-10" }
        ] } },
        { "type": "Button", "props": { "label": "Continue", "style": "primary", "action": { "name": "continue" } } }
      ]
    }
    """

  static let streamingChunks = [
    "{",
    "\"type\":\"Stack\",",
    "\"props\":{\"direction\":\"vertical\",\"spacing\":12},",
    "\"children\":[",
    "{\"type\":\"Heading\",\"props\":{\"text\":\"Streaming\",\"level\":2}},",
    "{\"type\":\"Text\",\"props\":{\"content\":\"Chunked UI\"}},",
    "{\"type\":\"Divider\",\"props\":{\"thickness\":1}},",
    "{\"type\":\"Button\",\"props\":{\"label\":\"Continue\",\"style\":\"primary\",\"action\":{\"name\":\"continue\"}}}",
    "]",
    "}",
  ]
}
