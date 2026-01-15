import Testing

@testable import SwiftUIJSONRender

@Suite("Action Tests")
struct ActionTests {

  @Test("Parses action from AnyCodable")
  func parsesActionFromAnyCodable() {
    let actionDict: [String: Any] = [
      "name": "test_action",
      "params": ["key": "value"],
    ]
    let anyCodable = AnyCodable(actionDict)

    let action = Action.from(anyCodable)

    #expect(action != nil)
    #expect(action?.name == "test_action")
    #expect(action?.string("key") == "value")
  }

  @Test("Parses action with confirm config")
  func parsesActionWithConfirm() {
    let actionDict: [String: Any] = [
      "name": "delete",
      "confirm": [
        "title": "Confirm Delete",
        "message": "Are you sure?",
        "confirmLabel": "Delete",
        "cancelLabel": "Cancel",
      ],
    ]
    let anyCodable = AnyCodable(actionDict)

    let action = Action.from(anyCodable)

    #expect(action != nil)
    #expect(action?.confirm != nil)
    #expect(action?.confirm?.title == "Confirm Delete")
    #expect(action?.confirm?.message == "Are you sure?")
    #expect(action?.confirm?.confirmLabel == "Delete")
    #expect(action?.confirm?.cancelLabel == "Cancel")
  }

  @Test("Returns nil for invalid action")
  func returnsNilForInvalid() {
    let invalidDict: [String: Any] = ["invalid": "data"]
    let anyCodable = AnyCodable(invalidDict)

    let action = Action.from(anyCodable)

    #expect(action == nil)
  }

  @Test("Returns nil for nil input")
  func returnsNilForNilInput() {
    let action = Action.from(nil)

    #expect(action == nil)
  }

  @Test("Parameter accessors work")
  func parameterAccessorsWork() {
    let action = Action(
      name: "test",
      params: [
        "string": "hello",
        "int": 42,
        "double": 3.14,
        "bool": true,
      ]
    )

    #expect(action.string("string") == "hello")
    #expect(action.int("int") == 42)
    #expect(action.double("double") == 3.14)
    #expect(action.bool("bool") == true)
  }

  @Test("Equatable conformance works")
  func equatableWorks() {
    let action1 = Action(name: "test", params: ["key": "value"])
    let action2 = Action(name: "test", params: ["key": "value"])
    let action3 = Action(name: "other")

    #expect(action1 == action2)
    #expect(action1 != action3)
  }

  @Test("Codable conformance works")
  func codableWorks() throws {
    let original = Action(
      name: "submit",
      params: ["formId": "contact"],
      confirm: ConfirmConfig(title: "Submit?", message: "Send form?")
    )

    let data = try JSONEncoder().encode(original)
    let decoded = try JSONDecoder().decode(Action.self, from: data)

    #expect(decoded.name == original.name)
    #expect(decoded.confirm?.title == original.confirm?.title)
  }
}
