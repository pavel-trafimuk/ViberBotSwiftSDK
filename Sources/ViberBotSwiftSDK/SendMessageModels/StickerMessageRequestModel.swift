import Foundation
import ViberSharedSwiftSDK

public struct StickerMessageRequestModel: Codable, SendMessageRequestCommonValues {
    
    public let stickerId: String
    
    /// mandatory for 1to1 message
    public let receiver: String?
    
    /// mandatory for broadcast messages
    public let broadcastList: [String]?
    
    public let messageType: MessageType = .sticker
    public let sender: SenderInfo
    public let rawTrackingData: String?
    
    public let minApiVersion: Int
    public let authToken: String
    
    public let keyboard: UIGridView?

    public let isSilent: Bool

    public init(stickerId: String,
                keyboard: UIGridView?,
                receiver: String?,
                broadcastList: [String]? = nil,
                sender: SenderInfo,
                rawTrackingData: String? = nil,
                minApiVersion: Int,
                authToken: String,
                isSilent: Bool = false) {
        self.stickerId = stickerId
        self.receiver = receiver
        self.broadcastList = broadcastList
        self.sender = sender
        self.rawTrackingData = rawTrackingData
        self.minApiVersion = minApiVersion
        self.authToken = authToken
        self.keyboard = keyboard
        self.isSilent = isSilent
    }
    
    public init(stickerId: String,
                keyboard: UIGridView?,
                receiver: String?,
                broadcastList: [String]? = nil,
                sender: SenderInfo,
                trackingData: TrackingData? = nil,
                minApiVersion: Int,
                authToken: String,
                isSilent: Bool = false) {
        self.stickerId = stickerId
        self.receiver = receiver
        self.broadcastList = broadcastList
        self.sender = sender
        self.rawTrackingData = try? trackingData?.toJSON()
        self.minApiVersion = minApiVersion
        self.authToken = authToken
        self.keyboard = keyboard
        self.isSilent = isSilent
    }
    
    public enum CodingKeys: String, CodingKey {
        case stickerId = "sticker_id"
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
