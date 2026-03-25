import Foundation
import Testing

@testable import SwiftUIJSONRender

@Suite("JSONSanitizer Tests")
struct JSONSanitizerTests {

  // MARK: - Smart Quotes

  @Test("Replaces left/right double smart quotes with straight quotes")
  func testSmartDoubleQuotes() {
    let input = "{\u{201C}key\u{201D}: \u{201C}value\u{201D}}"
    let result = JSONSanitizer.replaceSmartQuotes(input)
    #expect(result == "{\"key\": \"value\"}")
  }

  @Test("Replaces left/right single smart quotes with straight single quotes")
  func testSmartSingleQuotes() {
    let input = "it\u{2018}s a test\u{2019}s"
    let result = JSONSanitizer.replaceSmartQuotes(input)
    #expect(result == "it's a test's")
  }

  // MARK: - Trailing Commas

  @Test("Removes trailing comma in object")
  func testTrailingCommaObject() {
    let input = """
      {"a": 1, "b": 2,}
      """
    let result = JSONSanitizer.removeTrailingCommas(input)
    #expect(result == """
      {"a": 1, "b": 2}
      """)
  }

  @Test("Removes trailing comma in array")
  func testTrailingCommaArray() {
    let input = """
      [1, 2, 3,]
      """
    let result = JSONSanitizer.removeTrailingCommas(input)
    #expect(result == """
      [1, 2, 3]
      """)
  }

  @Test("Does not remove commas inside strings")
  func testPreservesCommasInStrings() {
    let input = """
      {"key": "a, b, c,"}
      """
    let result = JSONSanitizer.removeTrailingCommas(input)
    #expect(result == input)
  }

  @Test("Removes trailing comma with whitespace before closing brace")
  func testTrailingCommaWithWhitespace() {
    let input = """
      {"a": 1,  }
      """
    let result = JSONSanitizer.removeTrailingCommas(input)
    #expect(result == """
      {"a": 1  }
      """)
  }

  // MARK: - Unescaped Quotes

  @Test("Escapes unescaped quotes inside string values")
  func testUnescapedQuotes() {
    let input = """
      {"value": "Mude "Compra Única" para Recorrente"}
      """
    let result = JSONSanitizer.fixUnescapedQuotes(input)
    #expect(result == """
      {"value": "Mude \\"Compra Única\\" para Recorrente"}
      """)
  }

  @Test("Preserves already-escaped quotes")
  func testPreservesEscapedQuotes() {
    let input = """
      {"value": "She said \\"hello\\""}
      """
    let result = JSONSanitizer.fixUnescapedQuotes(input)
    #expect(result == input)
  }

  @Test("Handles empty strings")
  func testEmptyStrings() {
    let input = """
      {"key": "", "other": ""}
      """
    let result = JSONSanitizer.fixUnescapedQuotes(input)
    #expect(result == input)
  }

  @Test("Handles multiple unescaped quotes")
  func testMultipleUnescapedQuotes() {
    let input = """
      {"a": "he said "hi" and "bye""}
      """
    let result = JSONSanitizer.fixUnescapedQuotes(input)
    #expect(result == """
      {"a": "he said \\"hi\\" and \\"bye\\""}
      """)
  }

  // MARK: - Full Sanitize

  @Test("Valid JSON passes through unchanged")
  func testValidJSONUnchanged() {
    let input = """
      {"type": "Text", "props": {"content": "Hello"}}
      """
    let result = JSONSanitizer.sanitize(input)
    #expect(result == input)
  }

  @Test("Combined: smart quotes + trailing comma + unescaped quotes")
  func testCombinedIssues() {
    let input = "{\u{201C}items\u{201D}: [\u{201C}say \u{201C}hi\u{201D}\u{201D},]}"
    let result = JSONSanitizer.sanitize(input)

    // After smart quote replacement: {"items": ["say "hi"",]}
    // After trailing comma removal: {"items": ["say "hi""]}
    // After unescaped quote fix:    {"items": ["say \"hi\""]}
    let data = result.data(using: .utf8)!
    let parsed = try? JSONSerialization.jsonObject(with: data)
    #expect(parsed != nil)
  }

  // MARK: - Integration with ComponentNode

  @Test("ComponentNode.from(json:) recovers from unescaped quotes")
  func testComponentNodeRecovery() {
    let json = """
      {"type": "table", "props": {"rows": [{"label": "3", "value": "Mude "Compra Única" para Recorrente"}]}}
      """
    let node = ComponentNode.from(json: json)

    #expect(node != nil)
    #expect(node?.type == .table)
  }

  @Test("ComponentNode.from(json:) recovers from trailing commas")
  func testComponentNodeTrailingComma() {
    let json = """
      {"type": "Text", "props": {"content": "Hello",}}
      """
    let node = ComponentNode.from(json: json)

    #expect(node != nil)
    #expect(node?.type == .text)
    #expect(node?.string("content") == "Hello")
  }

  @Test("ComponentNode.from(json:) recovers from smart quotes")
  func testComponentNodeSmartQuotes() {
    let json = "{\u{201C}type\u{201D}: \u{201C}Text\u{201D}, \u{201C}props\u{201D}: {\u{201C}content\u{201D}: \u{201C}Hello\u{201D}}}"
    let node = ComponentNode.from(json: json)

    #expect(node != nil)
    #expect(node?.type == .text)
    #expect(node?.string("content") == "Hello")
  }

  // MARK: - Integration with RenderRequest

  @Test("RenderRequest parses double-encoded root with unescaped quotes")
  func testRenderRequestDoubleEncodedRoot() {
    // Simulate the real-world case: root is a JSON string with unescaped quotes inside
    let rootJSON = """
      {"type": "table", "props": {"rows": [{"label": "3", "value": "Mude \\"Compra Única\\" para Recorrente"}]}}
      """
    let wrapper: [String: Any] = [
      "display": "inline",
      "root": rootJSON,
    ]
    let request = RenderRequest.from(dictionary: wrapper)

    #expect(request != nil)
    #expect(request?.display == .inline)
    #expect(request?.root.type == .table)
  }

  @Test("RenderRequest recovers double-encoded root with LLM errors")
  func testRenderRequestDoubleEncodedRootWithErrors() {
    // root string has unescaped quotes — needs sanitization
    let rootJSON = """
      {"type": "table", "props": {"rows": [{"label": "3", "value": "Mude "Compra Única" para Recorrente"}]}}
      """
    let wrapper: [String: Any] = [
      "display": "inline",
      "root": rootJSON,
    ]
    let request = RenderRequest.from(dictionary: wrapper)

    #expect(request != nil)
    #expect(request?.root.type == .table)
  }

  @Test("Real-world LLM JSON with multiple issues")
  func testRealWorldLLMJSON() {
    // This mirrors the actual crash scenario
    let json = """
      {
        "type": "Stack",
        "props": {"direction": "vertical"},
        "children": [
          {
            "type": "card",
            "children": [
              {
                "type": "table",
                "props": {
                  "rows": [
                    {"label": "1", "value": "Toque em no menu inferior"},
                    {"label": "3", "value": "Mude "Compra Única" para Recorrente"}
                  ]
                }
              }
            ]
          }
        ]
      }
      """
    let node = ComponentNode.from(json: json)

    #expect(node != nil)
    #expect(node?.type == .stack)
    #expect(node?.children?.first?.type == .custom("card"))
  }

  @Test("Exact double-encoded JSON from production crash")
  func testExactProductionCrashJSON() {
    // This is the exact raw JSON string that caused the crash.
    // The outer envelope has display + root, where root is a double-encoded
    // JSON string containing unescaped quotes inside a value.
    let raw = """
      {"display":"inline","root":"{\\"type\\": \\"Stack\\",\\"props\\": {\\"direction\\": \\"vertical\\"},\\"children\\": [{\\"type\\": \\"card\\",\\"props\\": {\\"title\\": \\"Compras Recorrentes Ativas\\", \\"icon\\": \\"repeat.circle.fill\\"},\\"children\\": [{\\"type\\": \\"list\\",\\"props\\": {\\"items\\": [{\\"title\\": \\"Compra diária\\", \\"subtitle\\": \\"Bitcoin\\", \\"trailing\\": \\"R$ 8,00\\", \\"trailingColor\\": \\"bitcoin\\", \\"icon\\": \\"bitcoinsign.circle.fill\\"},{\\"title\\": \\"Compra diária\\", \\"subtitle\\": \\"Bitcoin\\", \\"trailing\\": \\"R$ 1,00\\", \\"trailingColor\\": \\"bitcoin\\", \\"icon\\": \\"bitcoinsign.circle.fill\\"},{\\"title\\": \\"Compra semanal\\", \\"subtitle\\": \\"Bitcoin\\", \\"trailing\\": \\"R$ 1,00\\", \\"trailingColor\\": \\"bitcoin\\", \\"icon\\": \\"bitcoinsign.circle.fill\\"}]}},{\\"type\\": \\"text\\", \\"props\\": {\\"content\\": \\"Total diário: R$ 9,00 · Estratégia DCA ativa 🟢\\", \\"style\\": \\"caption\\"}}]},{\\"type\\": \\"card\\",\\"props\\": {\\"title\\": \\"Para adicionar nova recorrência\\", \\"icon\\": \\"plus.circle.fill\\"},\\"children\\": [{\\"type\\": \\"table\\",\\"props\\": {\\"rows\\": [{\\"label\\": \\"1\\", \\"value\\": \\"Toque em 📈 no menu inferior\\"},{\\"label\\": \\"2\\", \\"value\\": \\"Selecione Bitcoin → Comprar\\"},{\\"label\\": \\"3\\", \\"value\\": \\"Mude \\"Compra Única\\" para Recorrente\\"},{\\"label\\": \\"4\\", \\"value\\": \\"Escolha Diária e o valor\\"},{\\"label\\": \\"5\\", \\"value\\": \\"Confirme!\\"}]}}]}]}"}
      """

    let request = RenderRequest.from(json: raw)

    #expect(request != nil)
    #expect(request?.display == .inline)
    #expect(request?.root.type == .stack)

    // Verify the full tree parsed correctly
    let children = request?.root.children
    #expect(children?.count == 2)

    // First card: "Compras Recorrentes Ativas"
    let firstCard = children?[0]
    #expect(firstCard?.type == .custom("card"))
    #expect(firstCard?.string("title") == "Compras Recorrentes Ativas")
    #expect(firstCard?.children?.count == 2)

    // List inside first card
    let list = firstCard?.children?[0]
    #expect(list?.type == .list)

    // Caption text
    let caption = firstCard?.children?[1]
    #expect(caption?.type == .custom("text"))
    #expect(caption?.string("content") == "Total diário: R$ 9,00 · Estratégia DCA ativa 🟢")

    // Second card: instructions table
    let secondCard = children?[1]
    #expect(secondCard?.type == .custom("card"))
    #expect(secondCard?.string("title") == "Para adicionar nova recorrência")

    let table = secondCard?.children?[0]
    #expect(table?.type == .table)
  }

  @Test("Exact raw string from debugger with triple-escaped quotes")
  func testExactDebuggerString() {
    // The user observed this string in the debugger/log output with display escaping.
    // The \\\  (triple backslash) in the log is one level of display escaping:
    //   \\\" displayed → \" actual bytes → " after JSON parse
    //
    // After outer JSON parse, root is a string. Inside that string,
    // "Mude "Compra Única" para Recorrente" has UNESCAPED quotes —
    // the \" at the boundary are string delimiters, not escaping for the inner content.
    //
    // Escaping levels:
    //   Debugger:  \\\"Mude \\\"Compra Única\\\" para Recorrente\\\"
    //   Wire JSON: \"Mude \"Compra Única\" para Recorrente\"
    //   Root str:  "Mude "Compra Única" para Recorrente"
    //                     ^              ^  ← unescaped in inner JSON
    //
    // The sanitizer fixes these unescaped quotes when parsing the root string.

    // Build the exact wire-level JSON (what JSONSerialization actually receives).
    // In Swift string literals, \\ = literal \, \" would end the string,
    // so we use a multiline literal where \\ produces \.
    let wireJSON = """
      {"display":"inline","root":"{\\"type\\": \\"Stack\\",\\"props\\": {\\"direction\\": \\"vertical\\"},\\"children\\": [{\\"type\\": \\"card\\",\\"props\\": {\\"title\\": \\"Para adicionar nova recorrência\\", \\"icon\\": \\"plus.circle.fill\\"},\\"children\\": [{\\"type\\": \\"table\\",\\"props\\": {\\"rows\\": [{\\"label\\": \\"3\\", \\"value\\": \\"Mude \\"Compra Única\\" para Recorrente\\"}]}}]}]}"}
      """

    let request = RenderRequest.from(json: wireJSON)

    #expect(request != nil)
    #expect(request?.display == .inline)
    #expect(request?.root.type == .stack)

    // Drill into the table row to verify the problematic value was recovered
    let card = request?.root.children?.first
    #expect(card?.type == .custom("card"))

    let table = card?.children?.first
    #expect(table?.type == .table)
  }
}
