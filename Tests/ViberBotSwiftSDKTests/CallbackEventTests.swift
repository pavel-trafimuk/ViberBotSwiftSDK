//
//  CallbackEventTests.swift
//  
//
//  Created by Pavel Trafimuk on 08/11/2022.
//

import XCTest
import ViberBotSwiftSDK
import ViberSharedSwiftSDK

final class CallbackEventTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSubscribe() throws {
        let json = """
{
   "event":"subscribed",
   "timestamp":1457764197627,
   "user":{
      "id":"01234567890A=",
      "name":"John McClane",
      "avatar":"http://avatar.example.com",
      "country":"UK",
      "language":"en",
      "api_version":1
   },
   "message_token":4912661846655238145
}
"""
        guard let data = json.data(using: .utf8) else {
            XCTAssert(false)
            return
        }
        
        let event = try JSONDecoder().decode(CallbackEvent.self, from: data)

        if case .subscribed(let model) = event {
            XCTAssert(model.messageToken == 4912661846655238145)
            XCTAssert(model.timestamp == 1457764197627)
            XCTAssert(model.user.name == "John McClane")
        }
        else {
            XCTAssert(false)
        }
    }

    func testUnSubscribe() throws {
        let json = """
{
   "event":"unsubscribed",
   "timestamp":1457764197627,
   "user_id":"01234567890A=",
   "message_token":4912661846655238145
}
"""
        guard let data = json.data(using: .utf8) else {
            XCTAssert(false)
            return
        }
        
        let event = try JSONDecoder().decode(CallbackEvent.self, from: data)

        if case .unsubscribed(let model) = event {
            XCTAssert(model.messageToken == 4912661846655238145)
            XCTAssert(model.timestamp == 1457764197627)
            XCTAssert(model.userId == "01234567890A=")
        }
        else {
            XCTAssert(false)
        }
    }
    
    func testConversationStarted() throws {
        let json = """
        {
           "event":"conversation_started",
           "timestamp":1457764197627,
           "message_token":4912661846655238145,
           "type":"open",
           "context":"context information",
           "user":{
              "id":"01234567890A=",
              "name":"John McClane",
              "avatar":"http://avatar.example.com",
              "country":"UK",
              "language":"en",
              "api_version":1
           },
           "subscribed":false
        }
"""
        guard let data = json.data(using: .utf8) else {
            XCTAssert(false)
            return
        }
        
        let event = try JSONDecoder().decode(CallbackEvent.self, from: data)

        if case .conversationStarted(let model) = event {
            XCTAssert(model.messageToken == 4912661846655238145)
            XCTAssert(model.timestamp == 1457764197627)
            XCTAssert(model.isSubscribed == false)
            XCTAssert(model.user.name == "John McClane")
        }
        else {
            XCTAssert(false)
        }
    }
    
    func testDelivered() throws {
        let json = """
       {
          "event":"delivered",
          "timestamp":1457764197627,
          "message_token":4912661846655238145,
          "user_id":"01234567890A="
       }
"""
        guard let data = json.data(using: .utf8) else {
            XCTAssert(false)
            return
        }
        
        let event = try JSONDecoder().decode(CallbackEvent.self, from: data)

        if case .delivered(let model) = event {
            XCTAssert(model.messageToken == 4912661846655238145)
            XCTAssert(model.timestamp == 1457764197627)
            XCTAssert(model.userId == "01234567890A=")
        }
        else {
            XCTAssert(false)
        }
    }
    
    func testSeen() throws {
        let json = """
      {
         "event":"seen",
         "timestamp":1457764197627,
         "message_token":4912661846655238145,
         "user_id":"01234567890A="
      }
"""
        guard let data = json.data(using: .utf8) else {
            XCTAssert(false)
            return
        }
        
        let event = try JSONDecoder().decode(CallbackEvent.self, from: data)

        if case .seen(let model) = event {
            XCTAssert(model.messageToken == 4912661846655238145)
            XCTAssert(model.timestamp == 1457764197627)
            XCTAssert(model.userId == "01234567890A=")
        }
        else {
            XCTAssert(false)
        }
    }
    
    func testFailed() throws {
        let json = """
      {
         "event":"failed",
         "timestamp":1457764197627,
         "message_token":4912661846655238145,
         "user_id":"01234567890A=",
         "desc":"failure description"
      }
"""
        guard let data = json.data(using: .utf8) else {
            XCTAssert(false)
            return
        }
        
        let event = try JSONDecoder().decode(CallbackEvent.self, from: data)

        if case .failed(let model) = event {
            XCTAssert(model.messageToken == 4912661846655238145)
            XCTAssert(model.timestamp == 1457764197627)
            XCTAssert(model.userId == "01234567890A=")
            XCTAssert(model.description == "failure description")
        }
        else {
            XCTAssert(false)
        }
    }
    
    func testMsg() throws {
        let json = """
     {
        "event":"message",
        "timestamp":1457764197627,
        "message_token":4912661846655238145,
        "sender":{
           "id":"01234567890A=",
           "name":"John McClane",
           "avatar":"http://avatar.example.com",
           "country":"UK",
           "language":"en",
           "api_version":1
        },
        "message":{
           "type":"text",
           "text":"a message to the service",
           "media":"http://example.com",
           "location":{
              "lat":50.76891,
              "lon":6.11499
           },
           "tracking_data":"tracking data"
        }
     }
"""
        guard let data = json.data(using: .utf8) else {
            XCTAssert(false)
            return
        }
        
        let event = try JSONDecoder().decode(CallbackEvent.self, from: data)

        if case .message(let model) = event {
            XCTAssert(model.messageToken == 4912661846655238145)
            XCTAssert(model.timestamp == 1457764197627)
            XCTAssert(model.sender.name == "John McClane")
            XCTAssert(model.message.text == "a message to the service")
            XCTAssert(model.message.trackingData == "tracking data")
            XCTAssert(model.message.media == URL(string: "http://example.com"))
        }
        else {
            XCTAssert(false)
        }
    }
}
