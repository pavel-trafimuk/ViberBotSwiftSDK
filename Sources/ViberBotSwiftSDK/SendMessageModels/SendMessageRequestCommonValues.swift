import ViberSharedSwiftSDK
import Vapor

public protocol SendMessageRequestCommonValues: Content {
    var authToken: String { get }

    var receiver: String { get }
    var messageType: MessageType { get }
    var sender: SenderInfo  { get }

    var keyboard: UIGridView? { get }

    // context of talking
    var trackingData: String? { get }
    
    var minApiVersion: Int { get }
}
