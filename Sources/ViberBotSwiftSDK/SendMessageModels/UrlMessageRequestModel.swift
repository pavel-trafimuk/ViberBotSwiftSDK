import Foundation
import ViberSharedSwiftSDK

public struct UrlMessageRequestModel: Codable, SendMessageRequestCommonValues {
    
    // Max 2,000 characters
    public let media: URL
    
    public let receiver: String
    public let messageType: MessageType = .url
    public let sender: SenderInfo
    public let trackingData: String?
    
    public let minApiVersion: Int
    public let authToken: String
    
    public let keyboard: UIGridView?

    public init(media: URL,
                keyboard: UIGridView?,
                receiver: String,
                sender: SenderInfo,
                trackingData: String?,
                minApiVersion: Int,
                authToken: String) {
        self.media = media
        self.receiver = receiver
        self.sender = sender
        self.trackingData = trackingData
        self.minApiVersion = minApiVersion
        self.authToken = authToken
        self.keyboard = keyboard
    }
    
    public enum CodingKeys: String, CodingKey {
        case media
        case receiver
        case messageType = "type"
        case sender
        case authToken = "auth_token"
        case trackingData = "tracking_data"
        case minApiVersion = "min_api_version"
        case keyboard = "keyboard"
    }
}
