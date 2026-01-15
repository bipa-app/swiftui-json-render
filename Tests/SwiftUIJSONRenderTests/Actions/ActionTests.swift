import Foundation
import Testing

@testable import SwiftUIJSONRender

@Suite("Action Tests")
struct ActionTests {

  // MARK: - Action Parsing

  @Test("Parse simple action")
  func testParseSimpleAction() throws {
    let value = AnyCodable(["name": "submit"])

    let action = Action.from(value)

    #expect(action != nil)
    #expect(action?.name == "submit")
    #expect(action?.params == nil)
    #expect(action?.confirm == nil)
  }

  @Test("Parse action with params")
  func testParseActionWithParams() throws {
    let value = AnyCodable([
      "name": "send_pix",
      "params": ["amount": 1000, "recipient": "user@email.com"],
    ])

    let action = Action.from(value)

    #expect(action != nil)
    #expect(action?.name == "send_pix")
    #expect(action?.params != nil)
    #expect(action?.string("recipient") == "user@email.com")
    #expect(action?.int("amount") == 1000)
  }

  @Test("Parse action with confirm config")
  func testParseActionWithConfirm() throws {
    let value = AnyCodable([
      "name": "delete",
      "confirm": [
        "title": "Confirm Delete",
        "message": "Are you sure?",
        "confirmLabel": "Delete",
        "cancelLabel": "Cancel",
      ],
    ])

    let action = Action.from(value)

    #expect(action != nil)
    #expect(action?.name == "delete")
    #expect(action?.confirm != nil)
    #expect(action?.confirm?.title == "Confirm Delete")
    #expect(action?.confirm?.message == "Are you sure?")
    #expect(action?.confirm?.confirmLabel == "Delete")
    #expect(action?.confirm?.cancelLabel == "Cancel")
  }

  @Test("Parse action with partial confirm")
  func testParseActionWithPartialConfirm() throws {
    let value = AnyCodable([
      "name": "delete",
      "confirm": [
        "title": "Confirm"
      ],
    ])

    let action = Action.from(value)

    #expect(action != nil)
    #expect(action?.confirm != nil)
    #expect(action?.confirm?.title == "Confirm")
    #expect(action?.confirm?.message == nil)
    #expect(action?.confirm?.confirmLabel == nil)
    #expect(action?.confirm?.cancelLabel == nil)
  }

  @Test("Parse invalid action (missing name)")
  func testParseInvalidAction() throws {
    let value = AnyCodable(["params": ["id": 123]])

    let action = Action.from(value)

    #expect(action == nil)
  }

  @Test("Parse nil value returns nil")
  func testParseNilValue() throws {
    let action = Action.from(nil)

    #expect(action == nil)
  }

  @Test("Parse non-dictionary value returns nil")
  func testParseNonDictionary() throws {
    let value = AnyCodable("not a dictionary")

    let action = Action.from(value)

    #expect(action == nil)
  }

  // MARK: - Param Accessors

  @Test("String param accessor")
  func testStringParamAccessor() throws {
    let action = Action(
      name: "test",
      params: ["key": "value"]
    )

    #expect(action.string("key") == "value")
    #expect(action.string("nonexistent") == nil)
  }

  @Test("Int param accessor")
  func testIntParamAccessor() throws {
    let action = Action(
      name: "test",
      params: ["count": 42]
    )

    #expect(action.int("count") == 42)
    #expect(action.int("nonexistent") == nil)
  }

  @Test("Double param accessor")
  func testDoubleParamAccessor() throws {
    let action = Action(
      name: "test",
      params: ["amount": 3.14]
    )

    #expect(action.double("amount") == 3.14)
    #expect(action.double("nonexistent") == nil)
  }

  @Test("Bool param accessor")
  func testBoolParamAccessor() throws {
    let action = Action(
      name: "test",
      params: ["enabled": true]
    )

    #expect(action.bool("enabled") == true)
    #expect(action.bool("nonexistent") == nil)
  }

  @Test("Param accessors return nil when params is nil")
  func testParamAccessorsWithNilParams() throws {
    let action = Action(name: "test", params: nil)

    #expect(action.string("key") == nil)
    #expect(action.int("key") == nil)
    #expect(action.double("key") == nil)
    #expect(action.bool("key") == nil)
  }

  // MARK: - ConfirmConfig

  @Test("ConfirmConfig initialization")
  func testConfirmConfigInit() throws {
    let config = ConfirmConfig(
      title: "Title",
      message: "Message",
      confirmLabel: "OK",
      cancelLabel: "Cancel"
    )

    #expect(config.title == "Title")
    #expect(config.message == "Message")
    #expect(config.confirmLabel == "OK")
    #expect(config.cancelLabel == "Cancel")
  }

  @Test("ConfirmConfig with optional fields")
  func testConfirmConfigOptionalFields() throws {
    let config = ConfirmConfig(title: "Title")

    #expect(config.title == "Title")
    #expect(config.message == nil)
    #expect(config.confirmLabel == nil)
    #expect(config.cancelLabel == nil)
  }

  // MARK: - Equatable

  @Test("Action equatable")
  func testActionEquatable() throws {
    let action1 = Action(name: "submit", params: ["id": 1])
    let action2 = Action(name: "submit", params: ["id": 1])
    let action3 = Action(name: "cancel", params: nil)

    #expect(action1 == action2)
    #expect(action1 != action3)
  }

  @Test("ConfirmConfig equatable")
  func testConfirmConfigEquatable() throws {
    let config1 = ConfirmConfig(title: "Confirm", message: "Sure?")
    let config2 = ConfirmConfig(title: "Confirm", message: "Sure?")
    let config3 = ConfirmConfig(title: "Different", message: nil)

    #expect(config1 == config2)
    #expect(config1 != config3)
  }

  // MARK: - Codable

  @Test("Action is Codable")
  func testActionCodable() throws {
    let original = Action(
      name: "submit",
      params: ["id": 123, "name": "test"],
      confirm: ConfirmConfig(title: "Sure?")
    )

    let data = try JSONEncoder().encode(original)
    let decoded = try JSONDecoder().decode(Action.self, from: data)

    #expect(decoded.name == "submit")
    #expect(decoded.int("id") == 123)
    #expect(decoded.string("name") == "test")
    #expect(decoded.confirm?.title == "Sure?")
  }

  @Test("ConfirmConfig is Codable")
  func testConfirmConfigCodable() throws {
    let original = ConfirmConfig(
      title: "Title",
      message: "Message",
      confirmLabel: "Yes",
      cancelLabel: "No"
    )

    let data = try JSONEncoder().encode(original)
    let decoded = try JSONDecoder().decode(ConfirmConfig.self, from: data)

    #expect(decoded.title == "Title")
    #expect(decoded.message == "Message")
    #expect(decoded.confirmLabel == "Yes")
    #expect(decoded.cancelLabel == "No")
  }

  // MARK: - Action from JSON

  @Test("Parse action from JSON via ComponentNode")
  func testParseActionFromJSON() throws {
    let json = """
      {
          "type": "Button",
          "props": {
              "label": "Submit",
              "action": {
                  "name": "submit_form",
                  "params": {"formId": "contact"}
              }
          }
      }
      """

    let node = ComponentNode.from(json: json)
    let actionValue = node?.props?["action"]
    let action = Action.from(actionValue)

    #expect(action != nil)
    #expect(action?.name == "submit_form")
    #expect(action?.string("formId") == "contact")
  }

  @Test("Complex action with all fields")
  func testComplexAction() throws {
    let value = AnyCodable([
      "name": "transfer_money",
      "params": [
        "amount": 50000,
        "currency": "BRL",
        "recipient": "12345678900",
        "description": "Payment for services",
      ],
      "confirm": [
        "title": "Confirm Transfer",
        "message": "Transfer R$ 500.00 to recipient?",
        "confirmLabel": "Transfer Now",
        "cancelLabel": "Go Back",
      ],
    ])

    let action = Action.from(value)

    #expect(action != nil)
    #expect(action?.name == "transfer_money")
    #expect(action?.int("amount") == 50000)
    #expect(action?.string("currency") == "BRL")
    #expect(action?.string("recipient") == "12345678900")
    #expect(action?.string("description") == "Payment for services")
    #expect(action?.confirm?.title == "Confirm Transfer")
    #expect(action?.confirm?.message == "Transfer R$ 500.00 to recipient?")
    #expect(action?.confirm?.confirmLabel == "Transfer Now")
    #expect(action?.confirm?.cancelLabel == "Go Back")
  }
}
