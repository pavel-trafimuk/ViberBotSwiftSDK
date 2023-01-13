import ViberSharedSwiftSDK
import Vapor

public protocol SendMessageRequestCommonValues: Content {
    var authToken: String { get }

    /// mandatory for 1to1 message
    var receiver: String? { get }
    
    /// mandatory for broadcast messages
    var broadcastList: [String]? { get }

    var messageType: MessageType { get }
    var sender: SenderInfo  { get }

    var keyboard: UIGridView? { get }

    /// context of talking
    var trackingData: String? { get }
    
    var minApiVersion: Int { get }
}
