import Foundation
import ViberSharedSwiftSDK

public struct UrlMessageRequestModel: Codable, SendMessageRequestCommonValues {
    
    /// Max 2,000 characters
    public let media: URL
    
    /// mandatory for 1to1 message
    public let receiver: String?
    
    /// mandatory for broadcast messages
    public let broadcastList: [String]?
    
    public let messageType: MessageType = .url
    public let sender: SenderInfo
    public let trackingData: String?
    
    public let minApiVersion: Int
    public let authToken: String
    
    public let keyboard: UIGridView?

    public let isSilent: Bool

    public init(media: URL,
                keyboard: UIGridView?,
                receiver: String?,
                broadcastList: [String]? = nil,
                sender: SenderInfo,
                trackingData: String?,
                minApiVersion: Int,
                authToken: String,
                isSilent: Bool = false) {
        self.media = media
        self.receiver = receiver
        self.broadcastList = broadcastList
        self.sender = sender
        self.trackingData = trackingData
        self.minApiVersion = minApiVersion
        self.authToken = authToken
        self.keyboard = keyboard
        self.isSilent = isSilent
    }
    
    public enum CodingKeys: String, CodingKey {
        case media
        case receiver
        case broadcastList = "broadcast_list"
        case messageType = "type"
        case sender
        case authToken = "auth_token"
        case trackingData = "tracking_data"
        case minApiVersion = "min_api_version"
        case keyboard
        case isSilent = "silent"
    }
}
