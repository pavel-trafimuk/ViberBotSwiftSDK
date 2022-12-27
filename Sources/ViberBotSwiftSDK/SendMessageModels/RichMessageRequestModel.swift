import Foundation
import ViberSharedSwiftSDK

public struct RichMessageRequestModel: Codable, SendMessageRequestCommonValues {
    
    public let richMedia: UIGridView
    
    public let keyboard: UIGridView?

    public let receiver: String
    public let messageType: MessageType = .rich
    public let sender: SenderInfo
    public let trackingData: String?
    
    public let minApiVersion: Int
    public let authToken: String
    
    public init(richMedia: UIGridView,
                keyboard: UIGridView? = nil,
                receiver: String,
                sender: SenderInfo,
                trackingData: String? = nil,
                minApiVersion: Int,
                authToken: String) {
        self.richMedia = richMedia
        self.keyboard = keyboard
        self.receiver = receiver
        self.sender = sender
        self.trackingData = trackingData
        self.minApiVersion = minApiVersion
        self.authToken = authToken
    }
    
    public enum CodingKeys: String, CodingKey {
        case richMedia = "rich_media"
        case receiver
        case messageType = "type"
        case sender
        case authToken = "auth_token"
        case trackingData = "tracking_data"
        case minApiVersion = "min_api_version"
        case keyboard = "keyboard"
    }
}
