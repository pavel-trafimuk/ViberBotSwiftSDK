import Foundation
import ViberSharedSwiftSDK

// for request body
public struct TextMessageRequestModel: Codable, SendMessageRequestCommonValues {
    public let text: String

    public let receiver: String
    public let messageType: MessageType = .text
    public let sender: SenderInfo
    public let trackingData: String?
    
    public let keyboard: UIGridView?
    public let minApiVersion: Int
    public let authToken: String
    
    public init(text: String,
                keyboard: UIGridView? = nil,
                receiver: String,
                sender: SenderInfo,
                trackingData: String? = nil,
                minApiVersion: Int,
                authToken: String) {
        self.text = text
        self.receiver = receiver
        self.sender = sender
        self.trackingData = trackingData
        self.authToken = authToken
        self.keyboard = keyboard
        self.minApiVersion = minApiVersion
    }
    
    public enum CodingKeys: String, CodingKey {
        case text
        case receiver
        case messageType = "type"
        case sender
        case authToken = "auth_token"
        case trackingData = "tracking_data"
        case minApiVersion = "min_api_version"
        case keyboard = "keyboard"
    }
}
