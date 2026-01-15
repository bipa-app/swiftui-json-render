import Testing

@testable import SwiftUIJSONRender

@Suite("PartialJSONParser Tests")
struct PartialJSONParserTests {
  @Test("Returns nil until JSON completes")
  func testPartialParse() {
    var parser = PartialJSONParser()
    parser.append("{\"type\":\"Text\"")
    #expect(parser.latestComponentNode() == nil)

    parser.append("}")
    let node = parser.latestComponentNode()
    #expect(node?.type == "Text")
  }

  @Test("Ignores braces inside strings")
  func testBracesInsideStrings() {
    var parser = PartialJSONParser()
    parser.append("{\"type\":\"Text\",\"props\":{\"content\":\"Hello } world\"}}")
    let node = parser.latestComponentNode()
    #expect(node?.string("content") == "Hello } world")
  }

  @Test("Returns latest complete object")
  func testLastCompleteObject() {
    var parser = PartialJSONParser()
    parser.append("{\"type\":\"Text\"}")
    parser.append("{\"type\":\"Stack\"}")
    let node = parser.latestComponentNode()
    #expect(node?.type == "Stack")
  }

  @Test("Returns raw JSON string for latest object")
  func testLatestJSONString() {
    var parser = PartialJSONParser()
    parser.append("noise ")
    parser.append("{\"type\":\"Text\"}")
    #expect(parser.latestJSONString() == "{\"type\":\"Text\"}")
  }
}
