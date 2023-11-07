import Foundation
import ViberSharedSwiftSDK

public struct PictureMessageRequestModel: Codable, SendMessageRequestCommonValues {
    
    /// Max 512 characters
    public let text: String
    
    /// The URL must have a resource with a .jpeg, .png or .gif file extension as the last path segment.
    /// Example: http://www.example.com/path/image.jpeg.
    /// Animated GIFs can be sent as URL messages or file messages.
    /// Max image size: 1MB on iOS, 3MB on Android.
    public let media: URL
    
    /// Recommended: 400x400. Max size: 100kb.
    public let thumbnail: URL?

    public let keyboard: UIGridView?

    /// mandatory for 1to1 message
    public let receiver: String?
    
    /// mandatory for broadcast messages
    public let broadcastList: [String]?
    
    public let messageType: MessageType = .picture
    public let sender: SenderInfo
    public let rawTrackingData: String?
    
    public let minApiVersion: Int
    public let authToken: String
    
    public let isSilent: Bool

    public init(text: String,
                media: URL,
                thumbnail: URL?,
                keyboard: UIGridView? = nil,
                receiver: String?,
                broadcastList: [String]? = nil,
                sender: SenderInfo,
                rawTrackingData: String? = nil,
                minApiVersion: Int,
                authToken: String,
                isSilent: Bool = false) {
        self.text = text
        self.media = media
        self.thumbnail = thumbnail
        self.receiver = receiver
        self.broadcastList = broadcastList
        self.sender = sender
        self.rawTrackingData = rawTrackingData
        self.authToken = authToken
        self.keyboard = keyboard
        self.minApiVersion = minApiVersion
        self.isSilent = isSilent
    }
    
    public init(text: String,
                media: URL,
                thumbnail: URL?,
                keyboard: UIGridView? = nil,
                receiver: String?,
                broadcastList: [String]? = nil,
                sender: SenderInfo,
                trackingData: TrackingData? = nil,
                minApiVersion: Int,
                authToken: String,
                isSilent: Bool = false) {
        self.text = text
        self.media = media
        self.thumbnail = thumbnail
        self.receiver = receiver
        self.broadcastList = broadcastList
        self.sender = sender
        self.rawTrackingData = try? trackingData?.toJSON()
        self.authToken = authToken
        self.keyboard = keyboard
        self.minApiVersion = minApiVersion
        self.isSilent = isSilent
    }
    
    public enum CodingKeys: String, CodingKey {
        case text
        case media
        case thumbnail
        case receiver
        case broadcastList = "broadcast_list"
        case messageType = "type"
        case sender
        case authToken = "auth_token"
        case rawTrackingData = "tracking_data"
        case minApiVersion = "min_api_version"
        case keyboard = "keyboard"
        case isSilent = "silent"
    }
}
