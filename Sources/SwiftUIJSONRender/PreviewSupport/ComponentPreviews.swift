import SwiftUI

#if DEBUG
  struct ComponentPreviews: PreviewProvider {
    private static let previewRegistry: ComponentRegistry = {
      let registry = ComponentRegistry()
      registry.register(module: BuiltInComponentsModule())
      return registry
    }()

    static var previews: some View {
      ScrollView {
        VStack(alignment: .leading, spacing: 24) {
          previewSection("Versioning") {
            VersioningPreviewView()
          }

          previewSection("Streaming") {
            StreamingPreviewView()
          }
          previewSection("Layout") {
            JSONView(
              """
              {
                "type": "Stack",
                "props": { "direction": "vertical", "spacing": 12 },
                "children": [
                  { "type": "Text", "props": { "content": "Line 1" } },
                  { "type": "Text", "props": { "content": "Line 2" } }
                ]
              }
              """)
            JSONView(
              """
              {
                "type": "Stack",
                "props": { "direction": "horizontal", "spacing": 8, "alignment": "center" },
                "children": [
                  { "type": "Text", "props": { "content": "Left" } },
                  { "type": "Text", "props": { "content": "Right" } }
                ]
              }
              """)
            JSONView(
              """
              {
                "type": "Card",
                "props": { "title": "Card Title", "padding": 16 },
                "children": [
                  { "type": "Text", "props": { "content": "Card content" } }
                ]
              }
              """)
            JSONView(
              """
              {
                "type": "Card",
                "props": { "title": "Dense Card", "padding": 8, "cornerRadius": 6 },
                "children": [
                  { "type": "Text", "props": { "content": "Smaller padding" } }
                ]
              }
              """)
            JSONView(
              """
              { "type": "Divider", "props": { "thickness": 2, "color": "#DDDDDD" } }
              """)
            JSONView(
              """
              { "type": "Divider", "props": { "orientation": "vertical", "thickness": 2, "length": 60, "color": "#BBBBBB" } }
              """)
            JSONView(
              """
              {
                "type": "Stack",
                "props": { "direction": "vertical", "spacing": 8 },
                "children": [
                  { "type": "Text", "props": { "content": "Above" } },
                  { "type": "Spacer", "props": { "size": 24 } },
                  { "type": "Text", "props": { "content": "Below" } }
                ]
              }
              """)
            JSONView(
              """
              {
                "type": "Stack",
                "props": { "direction": "vertical", "spacing": 4 },
                "children": [
                  { "type": "Text", "props": { "content": "Tight" } },
                  { "type": "Spacer", "props": { "size": 8 } },
                  { "type": "Text", "props": { "content": "Spacing" } }
                ]
              }
              """)
          }

          previewSection("Content") {
            JSONView(
              """
              { "type": "Text", "props": { "content": "Hello, world!", "style": "headline", "weight": "semibold" } }
              """)
            JSONView(
              """
              { "type": "Text", "props": { "content": "Caption text", "style": "caption", "color": "secondary" } }
              """)
            JSONView(
              """
              { "type": "Text", "props": { "content": "Light text", "weight": "light", "color": "#666666" } }
              """)
            JSONView(
              """
              { "type": "Heading", "props": { "text": "Section Title", "level": 2 } }
              """)
            JSONView(
              """
              { "type": "Heading", "props": { "text": "Primary Title", "level": 1 } }
              """)
            JSONView(
              """
              { "type": "Heading", "props": { "text": "Subsection", "level": 3 } }
              """)
            JSONView(
              """
              { "type": "Icon", "props": { "name": "star.fill", "size": 20, "color": "#FFB100" } }
              """)
            JSONView(
              """
              { "type": "Icon", "props": { "name": "heart.fill", "size": 28, "color": "success" } }
              """)
            JSONView(
              """
              { "type": "Icon", "props": { "name": "exclamationmark.triangle.fill", "size": 22, "color": "warning" } }
              """)
            JSONView(
              """
              { "type": "Image", "props": { "url": "https://example.com/image.png", "contentMode": "fit", "width": 120, "height": 80 } }
              """)
            JSONView(
              """
              { "type": "Image", "props": { "name": "local_asset", "contentMode": "fill", "width": 120, "height": 80 } }
              """)
            JSONView(
              """
              { "type": "Image", "props": { "url": "https://example.com/image.png", "contentMode": "fill", "width": 200, "height": 120 } }
              """)
          }

          previewSection("Interactive") {
            JSONView(
              """
              { "type": "Button", "props": { "label": "Continue", "style": "primary" } }
              """)
            JSONView(
              """
              { "type": "Button", "props": { "label": "Secondary", "style": "secondary" } }
              """)
            JSONView(
              """
              { "type": "Button", "props": { "label": "Delete", "style": "destructive", "icon": "trash" } }
              """)
            JSONView(
              """
              { "type": "Button", "props": { "label": "Disabled", "style": "primary", "disabled": true } }
              """)
            JSONView(
              """
              { "type": "AmountInput", "props": { "label": "Amount", "placeholder": "0,00", "currency": "BRL" } }
              """)
            JSONView(
              """
              { "type": "AmountInput", "props": { "label": "Amount (USD)", "placeholder": "0.00", "currency": "USD" } }
              """)
            JSONView(
              """
              {
                "type": "ConfirmDialog",
                "props": {
                  "title": "Confirm",
                  "message": "Proceed?",
                  "confirmLabel": "Yes",
                  "cancelLabel": "No",
                  "triggerLabel": "Open"
                }
              }
              """)
            JSONView(
              """
              {
                "type": "ConfirmDialog",
                "props": {
                  "title": "Delete item",
                  "message": "This cannot be undone.",
                  "confirmLabel": "Delete",
                  "cancelLabel": "Cancel",
                  "triggerLabel": "Remove"
                }
              }
              """)
            JSONView(
              """
              {
                "type": "ChoiceList",
                "props": {
                  "question": "Choose one",
                  "options": [
                    { "id": "a", "label": "Option A" },
                    { "id": "b", "label": "Option B" }
                  ],
                  "action": { "name": "select", "paramKey": "id" }
                }
              }
              """)
            JSONView(
              """
              {
                "type": "ChoiceList",
                "props": {
                  "question": "Select a key",
                  "options": [
                    { "id": "cpf", "label": "CPF: ***456", "description": "Tax ID" },
                    { "id": "phone", "label": "Phone: +55 11 ****-5678", "description": "Mobile" }
                  ],
                  "action": { "name": "select_pix_key", "paramKey": "key_id" }
                }
              }
              """)
          }

          previewSection("Feedback") {
            JSONView(
              """
              {
                "type": "Alert",
                "props": {
                  "title": "Info",
                  "message": "This is an informational alert.",
                  "severity": "info",
                  "dismissible": true
                }
              }
              """)
            JSONView(
              """
              {
                "type": "Alert",
                "props": {
                  "title": "Warning",
                  "message": "Please double check your input.",
                  "severity": "warning",
                  "dismissible": true
                }
              }
              """)
            JSONView(
              """
              {
                "type": "Alert",
                "props": {
                  "title": "Error",
                  "message": "Something went wrong.",
                  "severity": "error"
                }
              }
              """)
            JSONView(
              """
              {
                "type": "Alert",
                "props": {
                  "title": "Success",
                  "message": "Payment completed.",
                  "severity": "success"
                }
              }
              """)
          }

          previewSection("Financial") {
            JSONView(
              """
              {
                "type": "BalanceCard",
                "props": { "brl": 1245032, "btc": 234000, "usdt": 50000000, "showChange": true, "brlChange": 5.2 }
              }
              """)
            JSONView(
              """
              {
                "type": "BalanceCard",
                "props": { "brl": 90500, "btc": 12000, "showChange": true, "brlChange": -2.4 }
              }
              """)
            JSONView(
              """
              {
                "type": "TransactionRow",
                "props": { "description": "PIX to Maria", "amount": -50000, "date": "2026-01-14", "icon": "arrow.up.right" }
              }
              """)
            JSONView(
              """
              {
                "type": "TransactionRow",
                "props": { "description": "Salary", "amount": 500000, "date": "2026-01-10", "icon": "arrow.down.left" }
              }
              """)
            JSONView(
              """
              {
                "type": "TransactionList",
                "props": {
                  "transactions": [
                    { "description": "PIX to Maria", "amount": -50000, "date": "2026-01-14" },
                    { "description": "Salary", "amount": 500000, "date": "2026-01-10" }
                  ]
                }
              }
              """)
            JSONView(
              """
              { "type": "AssetPrice", "props": { "symbol": "BTC", "price": 180000.23, "change": 1200.5, "changePercent": 1.28 } }
              """)
            JSONView(
              """
              { "type": "AssetPrice", "props": { "symbol": "ETH", "price": 9000.10, "change": -120.5, "changePercent": -1.3 } }
              """)
            JSONView(
              """
              {
                "type": "PieChart",
                "props": {
                  "title": "Spending",
                  "segments": [
                    { "label": "Food", "value": 45000, "color": "#FF6B6B" },
                    { "label": "Transport", "value": 22000, "color": "#4ECDC4" },
                    { "label": "Entertainment", "value": 18000, "color": "#45B7D1" },
                    { "label": "Bills", "value": 15000, "color": "#A78BFA" }
                  ],
                  "showLegend": true
                }
              }
              """)
            JSONView(
              """
              {
                "type": "PieChart",
                "props": {
                  "title": "Empty chart",
                  "segments": [],
                  "showLegend": false
                }
              }
              """)
            JSONView(
              """
              {
                "type": "LineChart",
                "props": {
                  "title": "Portfolio",
                  "points": [
                    { "x": "2026-01-10", "y": 120000 },
                    { "x": "2026-01-11", "y": 124000 },
                    { "x": "2026-01-12", "y": 121500 },
                    { "x": "2026-01-13", "y": 128000 },
                    { "x": "2026-01-14", "y": 129200 }
                  ],
                  "color": "#45B7D1"
                }
              }
              """)
            JSONView(
              """
              {
                "type": "LineChart",
                "props": {
                  "title": "Empty series",
                  "points": []
                }
              }
              """)
          }

          previewSection("Protocol — Metric") {
            JSONView(
              """
              { "type": "metric", "props": { "label": "Bitcoin", "value": "R$ 374.438", "caption": "+0.8%", "captionColor": "green", "icon": "btc" } }
              """)
            JSONView(
              """
              { "type": "metric", "props": { "label": "Dólar", "value": "$ 85,03", "icon": "usdt" } }
              """)
            JSONView(
              """
              { "type": "metric", "props": { "label": "Reais", "value": "R$ 12.345,67", "caption": "Saldo disponível", "icon": "brl" } }
              """)
            JSONView(
              """
              { "type": "metric", "props": { "label": "Portfólio BTC", "value": "R$ 3.720.523", "caption": "+34.5%", "captionColor": "green", "icon": "btc" } }
              """)
            JSONView(
              """
              { "type": "metric", "props": { "label": "Fatura fechada", "value": "R$ 3.456,00", "caption": "Vence 10/04", "captionColor": "yellow", "icon": "card" } }
              """)
          }

          previewSection("Protocol — Chart") {
            JSONView(
              """
              { "type": "chart", "props": { "style": "sparkline", "data": [640,642,638,645,648,644,650,652,649,655,653,656], "color": "violet" } }
              """)
            JSONView(
              """
              { "type": "chart", "props": { "style": "sparkline", "data": [5.52,5.54,5.53,5.55,5.54,5.56,5.55,5.57], "color": "green" } }
              """)
            JSONView(
              """
              { "type": "chart", "props": { "style": "bar", "data": [1200, 800, 600, 450, 300], "labels": ["Alimentação", "Transporte", "Moradia", "Lazer", "Saúde"], "color": "violet" } }
              """)
            JSONView(
              """
              { "type": "chart", "props": { "style": "progress", "value": 0.62, "color": "green" } }
              """)
            JSONView(
              """
              { "type": "chart", "props": { "style": "progress", "value": 0.15, "color": "red" } }
              """)
          }

          previewSection("Protocol — Table") {
            JSONView(
              """
              {
                "type": "table",
                "props": {
                  "rows": [
                    { "label": "Destinatário", "value": "João Silva" },
                    { "label": "CPF", "value": "***8900" },
                    { "label": "Banco", "value": "Nubank" },
                    { "label": "Tipo", "value": "Chave CPF" }
                  ],
                  "maxVisible": 3
                }
              }
              """)
            JSONView(
              """
              {
                "type": "table",
                "props": {
                  "rows": [
                    { "label": "Ativo", "value": "PIX" },
                    { "label": "Período", "value": "Diurno" }
                  ]
                }
              }
              """)
          }

          previewSection("Protocol — List") {
            JSONView(
              """
              {
                "type": "list",
                "props": {
                  "maxVisible": 3,
                  "expandLabel": "Ver todas (20)",
                  "items": [
                    { "title": "PIX para Maria Silva", "subtitle": "18/03 14:32", "trailing": "R$ 250", "trailingColor": "red", "icon": "arrow.up.right" },
                    { "title": "PIX recebido de João", "subtitle": "18/03 10:15", "trailing": "+R$ 1.500", "trailingColor": "green", "icon": "arrow.down.left" },
                    { "title": "iFood", "subtitle": "17/03 20:45", "trailing": "R$ 45,90", "icon": "creditcard" },
                    { "title": "Compra Bitcoin", "subtitle": "17/03 09:00", "trailing": "R$ 500", "icon": "bitcoinsign.circle" },
                    { "title": "Aluguel", "subtitle": "15/03 08:00", "trailing": "R$ 2.500", "trailingColor": "red", "icon": "arrow.up.right" }
                  ]
                }
              }
              """)
          }

          previewSection("Protocol — Action") {
            JSONView(
              """
              { "type": "action", "props": { "label": "Comprar Bitcoin", "icon": "btc", "style": "primary", "action": { "name": "buy_btc" } } }
              """)
            JSONView(
              """
              { "type": "action", "props": { "label": "Cancelar transferência", "style": "destructive", "action": { "name": "cancel" } } }
              """)
            JSONView(
              """
              { "type": "action", "props": { "label": "Ver detalhes", "icon": "arrow.right", "style": "secondary", "action": { "name": "details" } } }
              """)
          }

          previewSection("Protocol — Input") {
            JSONView(
              """
              { "type": "input", "props": { "inputType": "text", "id": "pix_key", "label": "Para qual chave PIX?", "placeholder": "CPF, e-mail ou telefone" } }
              """)
            JSONView(
              """
              {
                "type": "input",
                "props": {
                  "inputType": "choice",
                  "id": "goal",
                  "label": "Qual seu objetivo?",
                  "options": [
                    { "id": "emergency", "label": "Reserva de emergência", "subtitle": "3-6 meses de gastos" },
                    { "id": "retirement", "label": "Aposentadoria", "subtitle": "Longo prazo" },
                    { "id": "travel", "label": "Viagem", "subtitle": "Próximos 12 meses" }
                  ]
                }
              }
              """)
            JSONView(
              """
              {
                "type": "input",
                "props": {
                  "inputType": "multiChoice",
                  "id": "categories",
                  "label": "Quais categorias quer acompanhar?",
                  "options": [
                    { "id": "food", "label": "Alimentação" },
                    { "id": "transport", "label": "Transporte" },
                    { "id": "housing", "label": "Moradia" },
                    { "id": "leisure", "label": "Lazer" }
                  ]
                }
              }
              """)
            JSONView(
              """
              { "type": "input", "props": { "inputType": "confirm", "id": "proceed", "label": "Deseja continuar?", "confirmLabel": "Sim, continuar", "cancelLabel": "Não" } }
              """)
            JSONView(
              """
              { "type": "input", "props": { "inputType": "slider", "id": "risk", "label": "Nível de risco", "min": 1, "max": 10, "step": 1 } }
              """)
          }

          previewSection("Protocol — Composed: Balance Overview") {
            JSONView(
              """
              {
                "type": "Card",
                "children": [
                  { "type": "metric", "props": { "label": "Bitcoin", "value": "5.200.000 sats", "caption": "~R$ 3.720.523", "icon": "btc" } },
                  { "type": "metric", "props": { "label": "Dólar", "value": "$ 85,03", "icon": "usdt" } },
                  { "type": "metric", "props": { "label": "Reais", "value": "R$ 12.345,67", "icon": "brl" } }
                ]
              }
              """)
          }

          previewSection("Protocol — Composed: Price Card") {
            JSONView(
              """
              {
                "type": "Card",
                "props": { "title": "Bitcoin" },
                "children": [
                  { "type": "chart", "props": { "style": "sparkline", "data": [640,642,638,645,648,644,650,652,649,655,653,656], "color": "violet" } },
                  { "type": "Stack", "props": { "direction": "horizontal" }, "children": [
                    { "type": "metric", "props": { "label": "Preço", "value": "R$ 656.460" } },
                    { "type": "metric", "props": { "label": "Variação", "value": "+0.8%", "captionColor": "green" } }
                  ]}
                ]
              }
              """)
          }

          previewSection("Protocol — Composed: Confirmation Card") {
            JSONView(
              """
              {
                "type": "Card",
                "children": [
                  { "type": "metric", "props": { "label": "PIX para João Silva", "value": "R$ 50,00", "icon": "arrow.up.right" } },
                  { "type": "table", "props": { "rows": [
                    { "label": "CPF", "value": "***8900" },
                    { "label": "Banco", "value": "Nubank" },
                    { "label": "Tipo", "value": "Chave CPF" }
                  ] } },
                  { "type": "Stack", "props": { "direction": "horizontal", "spacing": 8 }, "children": [
                    { "type": "action", "props": { "label": "Cancelar", "style": "secondary", "action": { "name": "cancel" } } },
                    { "type": "action", "props": { "label": "Confirmar", "style": "primary", "action": { "name": "confirm" } } }
                  ]}
                ]
              }
              """)
          }

          previewSection("Protocol — Composed: Financial Plan Input") {
            JSONView(
              """
              {
                "type": "Card",
                "props": { "title": "Planejamento financeiro" },
                "children": [
                  { "type": "input", "props": { "inputType": "text", "id": "income", "label": "Qual sua renda mensal?", "placeholder": "R$ 0,00" } },
                  { "type": "input", "props": {
                    "inputType": "multiChoice",
                    "id": "goals",
                    "label": "Quais são seus objetivos?",
                    "options": [
                      { "id": "emergency", "label": "Reserva de emergência", "subtitle": "3-6 meses" },
                      { "id": "retirement", "label": "Aposentadoria", "subtitle": "Longo prazo" },
                      { "id": "travel", "label": "Viagem" }
                    ]
                  } },
                  { "type": "input", "props": { "inputType": "slider", "id": "risk", "label": "Tolerância a risco", "min": 1, "max": 5, "step": 1 } },
                  { "type": "action", "props": { "label": "Gerar meu plano", "style": "primary", "action": { "name": "generate_plan" } } }
                ]
              }
              """)
          }

          previewSection("Protocol — Composed: Spending Report") {
            JSONView(
              """
              {
                "type": "Stack",
                "props": { "direction": "vertical", "spacing": 12 },
                "children": [
                  { "type": "metric", "props": { "label": "Total gasto", "value": "R$ 4.523,00", "caption": "+12% vs fevereiro", "captionColor": "red" } },
                  { "type": "chart", "props": { "style": "bar", "data": [1200, 800, 600, 450, 300], "labels": ["Alimentação", "Transporte", "Moradia", "Lazer", "Saúde"], "color": "violet" } },
                  { "type": "list", "props": {
                    "items": [
                      { "title": "Alimentação", "subtitle": "23 transações", "trailing": "R$ 1.200", "icon": "fork.knife" },
                      { "title": "Transporte", "subtitle": "12 transações", "trailing": "R$ 800", "icon": "car.fill" },
                      { "title": "Moradia", "subtitle": "3 transações", "trailing": "R$ 600", "icon": "house.fill" }
                    ]
                  } }
                ]
              }
              """)
          }
        }
        .padding(16)
      }
      .background(previewBackground)
      .previewLayout(.sizeThatFits)
      .componentRegistry(previewRegistry)
    }

    private static var previewBackground: Color {
      #if os(iOS)
        return Color(UIColor.systemBackground)
      #else
        return Color(NSColor.windowBackgroundColor)
      #endif
    }

    private struct StreamingPreviewView: View {
      @StateObject private var renderer = StreamingJSONRenderer()

      var body: some View {
        renderer.currentView
          .onAppear {
            renderer.reset()
            sendChunks()
          }
      }

      private func sendChunks() {
        let chunks = [
          "{",
          "\"type\":\"Stack\",",
          "\"props\":{\"direction\":\"vertical\",\"spacing\":8},",
          "\"children\":[",
          "{\"type\":\"Heading\",\"props\":{\"text\":\"Streaming\",\"level\":2}},",
          "{\"type\":\"Text\",\"props\":{\"content\":\"Chunked render\"}},",
          "{\"type\":\"Divider\",\"props\":{\"thickness\":1}}",
          "]",
          "}",
        ]

        for (index, chunk) in chunks.enumerated() {
          DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.1) {
            renderer.append(chunk)
            if index == chunks.count - 1 {
              renderer.complete()
            }
          }
        }
      }
    }

    private struct VersioningPreviewView: View {
      // JSON with unknown component
      private let jsonWithUnknown = """
        {
            "type": "Stack",
            "props": { "direction": "vertical", "spacing": 8 },
            "children": [
                { "type": "Text", "props": { "content": "Known component above" } },
                { "type": "FutureWidget", "props": { "data": "unknown" } },
                { "type": "Text", "props": { "content": "Known component below" } }
            ]
        }
        """

      // JSON with incompatible version (too new)
      private let jsonTooNew = """
        {
            "schemaVersion": "99.0.0",
            "type": "Text",
            "props": { "content": "This won't render" }
        }
        """

      // JSON with valid version
      private let jsonWithVersion = """
        {
            "schemaVersion": "1.0.0",
            "type": "Stack",
            "props": { "direction": "vertical", "spacing": 8 },
            "children": [
                { "type": "Text", "props": { "content": "Valid schema version 1.0.0" } }
            ]
        }
        """

      var body: some View {
        VStack(alignment: .leading, spacing: 16) {
          // Unknown component behaviors
          Text("Unknown Component Handling")
            .font(.subheadline)
            .foregroundStyle(.secondary)

          VStack(alignment: .leading, spacing: 4) {
            Text(".placeholder (default)")
              .font(.caption)
              .foregroundStyle(.secondary)
            JSONView(jsonWithUnknown)
              .unknownComponentBehavior(.placeholder)
          }

          VStack(alignment: .leading, spacing: 4) {
            Text(".skip")
              .font(.caption)
              .foregroundStyle(.secondary)
            JSONView(jsonWithUnknown)
              .unknownComponentBehavior(.skip)
          }

          VStack(alignment: .leading, spacing: 4) {
            Text(".error")
              .font(.caption)
              .foregroundStyle(.secondary)
            JSONView(jsonWithUnknown)
              .unknownComponentBehavior(.error)
          }

          Divider()

          // Version compatibility
          Text("Version Compatibility")
            .font(.subheadline)
            .foregroundStyle(.secondary)

          VStack(alignment: .leading, spacing: 4) {
            Text("Valid version (1.0.0)")
              .font(.caption)
              .foregroundStyle(.secondary)
            JSONView(jsonWithVersion)
          }

          VStack(alignment: .leading, spacing: 4) {
            Text("Incompatible version (99.0.0)")
              .font(.caption)
              .foregroundStyle(.secondary)
            JSONView(jsonTooNew)
          }
        }
      }
    }

    private static func previewSection<Content: View>(
      _ title: String,
      @ViewBuilder content: () -> Content
    ) -> some View {
      VStack(alignment: .leading, spacing: 12) {
        Text(title)
          .font(.headline)
        content()
          .frame(maxWidth: .infinity, alignment: .leading)
      }
    }
  }
#endif
