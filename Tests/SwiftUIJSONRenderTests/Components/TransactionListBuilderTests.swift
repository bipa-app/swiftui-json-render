import SwiftUI
import Testing

@testable import SwiftUIJSONRender

@Suite("TransactionListBuilder Tests")
@MainActor
struct TransactionListBuilderTests {

  func makeContext() -> RenderContext {
    let registry = ComponentRegistry()
    registry.register(module: BuiltInComponentsModule())
    return RenderContext(registry: registry)
  }

  @Test("Transaction list renders items")
  func testTransactionList() throws {
    let json = """
      {
        "type": "TransactionList",
        "props": {
          "transactions": [
            { "description": "PIX to Maria", "amount": -50000, "date": "2026-01-14" },
            { "description": "Salary", "amount": 500000, "date": "2026-01-10" }
          ]
        }
      }
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()
    let view = TransactionListBuilder.build(node: node, context: context)

    #expect(node.array("transactions")?.count == 2)
    #expect(view != nil)
  }

  @Test("Transaction list with empty array")
  func testTransactionListEmpty() throws {
    let json = """
      { "type": "TransactionList", "props": { "transactions": [] } }
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()
    let view = TransactionListBuilder.build(node: node, context: context)

    #expect(node.array("transactions")?.isEmpty == true)
    #expect(view != nil)
  }

  @Test("Builder has correct type name")
  func testTypeName() throws {
    #expect(TransactionListBuilder.typeName == "TransactionList")
  }
}
