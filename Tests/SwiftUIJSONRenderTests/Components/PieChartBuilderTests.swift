import SwiftUI
import Testing

@testable import SwiftUIJSONRender

@Suite("PieChartBuilder Tests")
@MainActor
struct PieChartBuilderTests {

  func makeContext() -> RenderContext {
    let registry = ComponentRegistry()
    registry.register(module: BuiltInComponentsModule())
    return RenderContext(registry: registry)
  }

  @Test("Pie chart with segments")
  func testPieChartSegments() throws {
    let json = """
      {
        "type": "PieChart",
        "props": {
          "title": "Spending",
          "segments": [
            { "label": "Food", "value": 45000, "color": "#FF6B6B" },
            { "label": "Transport", "value": 22000, "color": "#4ECDC4" }
          ],
          "showLegend": true
        }
      }
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()
    let view = PieChartBuilder.build(node: node, context: context)

    #expect(node.array("segments")?.count == 2)
    #expect(view != nil)
  }

  @Test("Pie chart without segments")
  func testPieChartEmpty() throws {
    let json = """
      { "type": "PieChart", "props": { "segments": [] } }
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()
    let view = PieChartBuilder.build(node: node, context: context)

    #expect(node.array("segments")?.isEmpty == true)
    #expect(view != nil)
  }

  @Test("Builder has correct type name")
  func testTypeName() throws {
    #expect(PieChartBuilder.typeName == "PieChart")
  }
}
