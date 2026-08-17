import XCTest
@testable import ViberBotSwiftSDK

final class ReceiversListTests: XCTestCase {
    func testSingleReceiverUsesSendMessageFields() {
        let receivers = ReceiversList(list: ["user-1"])
        XCTAssertFalse(receivers.shouldSendAsBroadcast)
        XCTAssertEqual(receivers.singleReceiverValue, "user-1")
        XCTAssertNil(receivers.broadcastReceiversValue)
    }

    func testMultipleReceiversUsesBroadcastList() {
        let receivers = ReceiversList(list: ["user-1", "user-2"])
        XCTAssertTrue(receivers.shouldSendAsBroadcast)
        XCTAssertNil(receivers.singleReceiverValue)
        XCTAssertEqual(receivers.broadcastReceiversValue, ["user-1", "user-2"])
    }

    func testEmptyListDoesNotProduceSlices() {
        XCTAssertTrue(ReceiversList(list: []).slicesForSend().isEmpty)
    }

    func testBroadcastIsChunkedAtViberLimit() {
        let ids = (1...301).map { "user-\($0)" }
        let slices = ReceiversList(list: ids).slicesForSend()
        XCTAssertEqual(slices.count, 2)
        XCTAssertEqual(slices[0].broadcastReceiversValue?.count, 300)
        XCTAssertTrue(slices[0].shouldSendAsBroadcast)
        XCTAssertEqual(slices[1].singleReceiverValue, "user-301")
        XCTAssertFalse(slices[1].shouldSendAsBroadcast)
    }
}
