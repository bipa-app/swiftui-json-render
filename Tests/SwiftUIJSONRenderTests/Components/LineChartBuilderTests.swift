import SwiftUI
import Testing

@testable import SwiftUIJSONRender

@Suite("LineChartBuilder Tests")
@MainActor
struct LineChartBuilderTests {

  func makeContext() -> RenderContext {
    let registry = ComponentRegistry()
    registry.register(module: BuiltInComponentsModule())
    return RenderContext(registry: registry)
  }

  @Test("Line chart with points")
  func testLineChartPoints() throws {
    let json = """
      {
        "type": "LineChart",
        "props": {
          "title": "Portfolio",
          "points": [
            { "x": "2026-01-10", "y": 120000 },
            { "x": "2026-01-11", "y": 124000 }
          ],
          "color": "#45B7D1"
        }
      }
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()
    let view = LineChartBuilder.build(node: node, context: context)

    #expect(node.array("points")?.count == 2)
    #expect(view != nil)
  }

  @Test("Line chart without points")
  func testLineChartEmpty() throws {
    let json = """
      { "type": "LineChart", "props": { "points": [] } }
      """

    let node = ComponentNode.from(json: json)!
    let context = makeContext()
    let view = LineChartBuilder.build(node: node, context: context)

    #expect(node.array("points")?.isEmpty == true)
    #expect(view != nil)
  }

  @Test("Builder has correct type name")
  func testTypeName() throws {
    #expect(LineChartBuilder.typeName == "LineChart")
  }
}
