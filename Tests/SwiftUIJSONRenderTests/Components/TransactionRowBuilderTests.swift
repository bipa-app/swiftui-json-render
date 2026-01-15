import SwiftUI
import Testing

@testable import SwiftUIJSONRender

@Suite("TransactionRowBuilder Tests")
@MainActor
struct TransactionRowBuilderTests {

  func makeContext() -> RenderContext {
    let registry = ComponentRegistry()
    registry.register(module: BuiltInComponentsModule())
    return RenderContext(registry: registry)
  }

  @Test("Transaction row with required props")
  func testTransactionRowRequired() throws {
    let json = """
      {"type": "TransactionRow", "props": {"description": "PIX", "amount": -50000, "date": "2026-01-14"}}
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()
    let view = TransactionRowBuilder.build(node: node, context: context)

    #expect(node.string("description") == "PIX")
    #expect(node.int("amount") == -50000)
    #expect(node.string("date") == "2026-01-14")
    #expect(view != nil)
  }

  @Test("Transaction row with optional fields")
  func testTransactionRowOptional() throws {
    let json = """
      {"type": "TransactionRow", "props": {"description": "Salary", "amount": 500000, "category": "income", "icon": "arrow.down"}}
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()
    let view = TransactionRowBuilder.build(node: node, context: context)

    #expect(node.string("category") == "income")
    #expect(node.string("icon") == "arrow.down")
    #expect(view != nil)
  }

  @Test("Builder has correct type name")
  func testTypeName() throws {
    #expect(TransactionRowBuilder.typeName == "TransactionRow")
  }
}
