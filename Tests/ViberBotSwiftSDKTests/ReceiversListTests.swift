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
}
