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
    var rawTrackingData: String? { get }
    
    var minApiVersion: Int { get }
}

extension SendMessageRequestCommonValues {
    public var trackingData: TrackingData? {
        guard let string = rawTrackingData,
              !string.isEmpty,
              let data = string.data(using: .utf8)
        else {
            return nil
        }
        return try? JSONDecoder().decode(TrackingData.self, from: data)
    }
}
