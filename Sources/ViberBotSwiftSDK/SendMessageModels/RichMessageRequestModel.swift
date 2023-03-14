import Foundation
import ViberSharedSwiftSDK

public struct RichMessageRequestModel: Codable, SendMessageRequestCommonValues {
    
    /// Maximum total JSON size of the request is 30kb.
    public let richMedia: UIGridView
    
    /// Maximum total JSON size of the request is 30kb.
    public let keyboard: UIGridView?

    /// mandatory for 1to1 message
    public let receiver: String?
    
    /// mandatory for broadcast messages
    public let broadcastList: [String]?
    
    public let messageType: MessageType = .rich
    public let sender: SenderInfo
    public let rawTrackingData: String?
    
    public let minApiVersion: Int
    public let authToken: String
    
    public let isSilent: Bool

    public init(richMedia: UIGridView,
                keyboard: UIGridView? = nil,
                receiver: String?,
                broadcastList: [String]? = nil,
                sender: SenderInfo,
                rawTrackingData: String? = nil,
                minApiVersion: Int,
                authToken: String,
                isSilent: Bool = false) {
        self.richMedia = richMedia
        self.keyboard = keyboard
        self.receiver = receiver
        self.broadcastList = broadcastList
        self.sender = sender
        self.rawTrackingData = rawTrackingData
        self.minApiVersion = minApiVersion
        self.authToken = authToken
        self.isSilent = isSilent
    }
    
    public init(richMedia: UIGridView,
                keyboard: UIGridView? = nil,
                receiver: String?,
                broadcastList: [String]? = nil,
                sender: SenderInfo,
                trackingData: TrackingData? = nil,
                minApiVersion: Int,
                authToken: String,
                isSilent: Bool = false) {
        self.richMedia = richMedia
        self.keyboard = keyboard
        self.receiver = receiver
        self.broadcastList = broadcastList
        self.sender = sender
        self.rawTrackingData = try? trackingData?.toJSON()
        self.minApiVersion = minApiVersion
        self.authToken = authToken
        self.isSilent = isSilent
    }
    
    public enum CodingKeys: String, CodingKey {
        case richMedia = "rich_media"
        case receiver
        case broadcastList = "broadcast_list"
        case messageType = "type"
        case sender
        case authToken = "auth_token"
        case rawTrackingData = "tracking_data"
        case minApiVersion = "min_api_version"
        case keyboard
        case isSilent = "silent"
    }
}
