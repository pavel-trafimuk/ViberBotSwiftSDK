import Foundation
import ViberSharedSwiftSDK

public struct GetAccountInfo: Codable {
    /// Action result.
    /// 0 for success. In case of failure - appropriate failure status number. See error codes table for additional information
    public let status: ResponseStatus
    
    /// ok or failure reason.
    public let statusMessage: String
    
    /// Unique numeric id of the account
    public let id: String

    /// Account name
    /// Max 75 characters
    public let name: String
    
    /// Unique URI of the Account
    public let uri: String
    
    /// Account icon URL
    /// JPEG, 720x720, size no more than 512 kb
    public let icon: URL?
    
    /// Conversation background URL
    /// JPEG, max 1920x1920, size no more than 512 kb
    public let background: URL?
    
    /// Account category
    public let category: String?
    /// Account sub-category
    public let subcategory: String?
    
    // TODO: implement
    /// Account location (coordinates). Will be used for finding accounts near me
    /// lat & lon coordinates
//    "location":{
//       "lat":50.76891,
//       "lon":6.11499
//    },
//    public let location: Any?
    
    /// Account country
    /// 2 letters country code - ISO ALPHA-2 Code
    public let country: String?
    
    /// Account registered webhook
    /// webhook URL
    public let webhook: String?
    
    ///  Account registered events – as set by set_webhook request
    /// delivered, seen, failed and conversation_started
    public let eventTypes: [CallbackEventType]?
    
    /// Number of subscribers
    public let subscribersCount: Int
    
    
    public struct Member: Codable {
        public let id: String
        public let name: String?
        public let avatar: String?
        
        public enum Role: String, Codable {
            case admin
            case participant
        }
    }
    
    /// Members of the bot’s public chat
    /// Deprecated
    public let members: [Member]?
    
    public enum CodingKeys: String, CodingKey {
        case status
        case statusMessage = "status_message"
        case id
        case name
        case uri
        case icon
        case background
        case category
        case subcategory
        case country
        case webhook
        case eventTypes = "event_types"
        case subscribersCount = "subscribers_count"
        case members
    }
}
