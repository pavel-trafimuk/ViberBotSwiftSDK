import Foundation
import ViberSharedSwiftSDK

public struct TextMessageRequestModel: Codable, SendMessageRequestCommonValues {
    public let text: String

    /// mandatory for 1to1 message
    public let receiver: String?
    
    /// mandatory for broadcast messages
    public let broadcastList: [String]?
    
    public let messageType: MessageType = .text
    public let sender: SenderInfo
    public let trackingData: String?
    
    public let keyboard: UIGridView?
    public let minApiVersion: Int
    public let authToken: String
    
    public let isSilent: Bool
    
    public init(text: String,
                keyboard: UIGridView? = nil,
                receiver: String?,
                broadcastList: [String]? = nil,
                sender: SenderInfo,
                trackingData: String? = nil,
                minApiVersion: Int,
                authToken: String,
                isSilent: Bool = false) {
        self.text = text
        self.receiver = receiver
        self.broadcastList = broadcastList
        self.sender = sender
        self.trackingData = trackingData
        self.authToken = authToken
        self.keyboard = keyboard
        self.minApiVersion = minApiVersion
        self.isSilent = isSilent
    }
    
    public enum CodingKeys: String, CodingKey {
        case text
        case receiver
        case broadcastList = "broadcast_list"
        case messageType = "type"
        case sender
        case authToken = "auth_token"
        case trackingData = "tracking_data"
        case minApiVersion = "min_api_version"
        case keyboard = "keyboard"
        case isSilent = "silent"
    }
}
