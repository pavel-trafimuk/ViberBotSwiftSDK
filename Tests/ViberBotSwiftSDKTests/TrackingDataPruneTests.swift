//
//  TrackingDataPruneTests.swift
//  
//
//  Created by Pavel Trafimuk on 13/03/2023.
//

import XCTest
import ViberBotSwiftSDK
import ViberSharedSwiftSDK

final class TrackingDataPruneTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        let step = "step1"
        let storage = [String: String]()
        let history = [TrackingData.HistoryItem]()
        var trackingData = TrackingData(activeStep: step,
                                        storage: storage,
                                        history: history)
        
        XCTAssert(trackingData.activeStep == step)
        XCTAssert(trackingData.storage == storage)
        XCTAssert(trackingData.history! == history)
        
        trackingData.activeStep = "step2"
        XCTAssert(trackingData.activeStep == "step2")
        
        trackingData.storage!["k"] = "value"
        XCTAssert(trackingData.storage!["k"] == "value")
    }
    
    func testEncoding() throws {
        let step = "step1"
        let storage = ["k": "value"]
        var history = [TrackingData.HistoryItem]()
        history.append(.init(role: .participant, content: "Word1"))
        history.append(.init(role: .bot, content: "Answer1"))
        var trackingData = TrackingData(activeStep: step,
                                        storage: storage,
                                        history: history)
        
        XCTAssert(trackingData.activeStep == step)
        XCTAssert(trackingData.storage == storage)
        XCTAssert(trackingData.history! == history)
        
        trackingData.activeStep = "step2"
        XCTAssert(trackingData.activeStep == "step2")
        
        let jsonEncoder = JSONEncoder()
        let data = try jsonEncoder.encode(trackingData)
        
        guard let resultString = String(data: data, encoding: .utf8) else {
            XCTFail()
            return
        }
        let resultCount = resultString.lengthOfBytes(using: .utf8)
        let sourceCount = trackingData.lengthCountInJson
        XCTAssert(resultCount == sourceCount)
    }


    func testCounts() throws {
        do {
            let step = "step1"
            let storage = ["k": "value"]
            var history = [TrackingData.HistoryItem]()
            history.append(.init(role: .participant, content: "Word1"))
            history.append(.init(role: .bot, content: "Answer1"))
            let trackingData = TrackingData(activeStep: step,
                                            storage: storage,
                                            history: history)
            
            XCTAssert(trackingData.activeStep == step)
            XCTAssert(trackingData.storage == storage)
            XCTAssert(trackingData.history! == history)
            
            let jsonEncoder = JSONEncoder()
            let data = try jsonEncoder.encode(trackingData)
            guard let resultString = String(data: data, encoding: .utf8) else {
                XCTFail()
                return
            }
            let resultCount = resultString.lengthOfBytes(using: .utf8)
            let sourceCount = trackingData.lengthCountInJson
            XCTAssert(resultCount == sourceCount)
        }
        do {
            let step = "step1"
            var history = [TrackingData.HistoryItem]()
            history.append(.init(role: .participant, content: "Word1"))
            history.append(.init(role: .bot, content: "Answer1"))
            let trackingData = TrackingData(activeStep: step,
                                            storage: nil,
                                            history: history)
            
            XCTAssert(trackingData.activeStep == step)
            XCTAssert(trackingData.storage == nil)
            XCTAssert(trackingData.history! == history)
            
            let jsonEncoder = JSONEncoder()
            let data = try jsonEncoder.encode(trackingData)
            guard let resultString = String(data: data, encoding: .utf8) else {
                XCTFail()
                return
            }
            let resultCount = resultString.lengthOfBytes(using: .utf8)
            let sourceCount = trackingData.lengthCountInJson
            XCTAssert(resultCount == sourceCount)
        }
        do {
            let step = "step1"
            let trackingData = TrackingData(activeStep: step,
                                            storage: nil,
                                            history: nil)
            
            XCTAssert(trackingData.activeStep == step)
            XCTAssert(trackingData.storage == nil)
            XCTAssert(trackingData.history == nil)
            
            let jsonEncoder = JSONEncoder()
            let data = try jsonEncoder.encode(trackingData)
            guard let resultString = String(data: data, encoding: .utf8) else {
                XCTFail()
                return
            }
            let resultCount = resultString.lengthOfBytes(using: .utf8)
            let sourceCount = trackingData.lengthCountInJson
            XCTAssert(resultCount == sourceCount)
        }
        do {
            let step = "step1"
            let storage = ["k": "value", "v": "😀"]
            var history = [TrackingData.HistoryItem]()
            history.append(.init(role: .participant, content: "Word1"))
            let trackingData = TrackingData(activeStep: step,
                                            storage: storage,
                                            history: history)
            
            XCTAssert(trackingData.activeStep == step)
            XCTAssert(trackingData.storage == storage)
            XCTAssert(trackingData.history! == history)
            
            let jsonEncoder = JSONEncoder()
            let data = try jsonEncoder.encode(trackingData)
            guard let resultString = String(data: data, encoding: .utf8) else {
                XCTFail()
                return
            }
            let resultCount = resultString.lengthOfBytes(using: .utf8)
            let sourceCount = trackingData.lengthCountInJson
            XCTAssert(resultCount == sourceCount)
        }
    }
    
    func testPrunes() throws {
        do {
            let step = "1"
            var history = [TrackingData.HistoryItem]()
            history.append(.init(role: .participant, content: "Word1"))
            history.append(.init(role: .bot, content: "Answer1"))
            var trackingData = TrackingData(activeStep: step,
                                            storage: nil,
                                            history: history)
            
            trackingData.pruneHistory()

            XCTAssert(trackingData.activeStep == step)
            XCTAssert(trackingData.storage == nil)
            XCTAssert(trackingData.history! == history)

            
            let jsonEncoder = JSONEncoder()
            let data = try jsonEncoder.encode(trackingData)
            guard let resultString = String(data: data, encoding: .utf8) else {
                XCTFail()
                return
            }
            let resultCount = resultString.lengthOfBytes(using: .utf8)
            let sourceCount = trackingData.lengthCountInJson
            XCTAssert(resultCount == sourceCount)
        }
        do {
            let step = "1"
            var history = [TrackingData.HistoryItem]()
            for idx in 0...419 {
                history.append(.init(role: .participant, content: "Step\(idx)"))
            }
            var trackingData = TrackingData(activeStep: step,
                                            storage: nil,
                                            history: history)
            print(trackingData.lengthCountInJson)
            
            trackingData.pruneHistory()

            XCTAssert(trackingData.lengthCountInJson <= 4096)
            XCTAssert(trackingData.activeStep == step)
            XCTAssert(trackingData.storage == nil)
            XCTAssert(trackingData.history! != history)
            XCTAssert(trackingData.history!.count == 418)
            XCTAssert(trackingData.history?.first?.content == "Step2")

            
            let jsonEncoder = JSONEncoder()
            let data = try jsonEncoder.encode(trackingData)
            guard let resultString = String(data: data, encoding: .utf8) else {
                XCTFail()
                return
            }
            let resultCount = resultString.lengthOfBytes(using: .utf8)
            let sourceCount = trackingData.lengthCountInJson
            XCTAssert(resultCount == sourceCount)
        }
    }
    
}
