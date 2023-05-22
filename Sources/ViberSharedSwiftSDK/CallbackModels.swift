//
//  File.swift
//  
//
//  Created by Pavel Trafimuk on 07/11/2022.
//

import Foundation

public enum CallbackEvent: Decodable {
    case delivered(model: DeliveredCallbackModel)
    case seen(model: SeenCallbackModel)
    case failed(model: FailedCallbackModel)
    case subscribed(model: SubscribedCallbackModel)
    case unsubscribed(model: UnSubscribedCallbackModel)
    case conversationStarted(model: ConversationStartedCallbackModel)
    case message(model: MessageCallbackModel)
    case clientStatus(model: ClientStatusCallbackModel)
    
    // TODO: unknown scenario
    case action
    
    // specific one
    case webhook(model: SetWebhookCallbackModel)
    
    enum CodingKeys: String, CodingKey {
        case event
    }
    
    public var isImportantForDB: Bool {
        switch self {
        case .delivered, .seen: return true
        case .failed: return true
        case .subscribed, .unsubscribed: return true
        case .conversationStarted: return true
        case .message: return true
        case .clientStatus, .action, .webhook: return false
        }
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let event = try container.decode(CallbackEventType.self, forKey: .event)

        switch event {
        case .delivered:
            self = .delivered(model: try DeliveredCallbackModel(from: decoder))
        case .seen:
            self = .seen(model: try SeenCallbackModel(from: decoder))
        case .failed:
            self = .failed(model: try FailedCallbackModel(from: decoder))
        case .subscribed:
            self = .subscribed(model: try SubscribedCallbackModel(from: decoder))
        case .unsubscribed:
            self = .unsubscribed(model: try UnSubscribedCallbackModel(from: decoder))
        case .conversationStarted:
            self = .conversationStarted(model: try ConversationStartedCallbackModel(from: decoder))
        case .message:
            self = .message(model: try MessageCallbackModel(from: decoder))
        case .webhook:
            self = .webhook(model: try SetWebhookCallbackModel(from: decoder))
        case .clientStatus:
            self = .clientStatus(model: try ClientStatusCallbackModel(from: decoder))
        case .action:
            self = .action
        }
    }
}

public struct SetWebhookCallbackModel: Codable {
    public let timestamp: Int // TODO: convert epoch time to date
    public let messageToken: Int64
    
    public enum CodingKeys: String, CodingKey {
        case timestamp
        case messageToken = "message_token"
    }
}

public struct SubscribedCallbackModel: Codable {
    public let timestamp: Int // TODO: convert epoch time to date
    public let messageToken: Int64

    public let user: CallbackUser
    
    public enum CodingKeys: String, CodingKey {
        case timestamp
        case messageToken = "message_token"
        case user
    }
}


public struct UnSubscribedCallbackModel: Codable {
    public let timestamp: Int // TODO: convert epoch time to date
    public let messageToken: Int64
    public let userId: String
    
    public enum CodingKeys: String, CodingKey {
        case timestamp
        case messageToken = "message_token"
        case userId = "user_id"
    }
}

public struct ConversationStartedCallbackModel: Codable {
    public let timestamp: Int // TODO: convert epoch time to date
    public let messageToken: Int64

    public enum StartedType: String, Codable {
        case open
    }
    public let type: StartedType
    
    public let user: CallbackUser
    public let context: String?
    
    public let isSubscribed: Bool
    
    public enum CodingKeys: String, CodingKey {
        case timestamp
        case messageToken = "message_token"
        case type
        case context
        case isSubscribed = "subscribed"
        case user
    }
}

public struct DeliveredCallbackModel: Codable {
    public let timestamp: Int // TODO: convert epoch time to date
    public let messageToken: Int64
    public let userId: String
    
    public enum CodingKeys: String, CodingKey {
        case timestamp
        case messageToken = "message_token"
        case userId = "user_id"
    }
}


public struct SeenCallbackModel: Codable {
    public let timestamp: Int // TODO: convert epoch time to date
    public let messageToken: Int64
    public let userId: String
    
    public enum CodingKeys: String, CodingKey {
        case timestamp
        case messageToken = "message_token"
        case userId = "user_id"
    }
}

public struct FailedCallbackModel: Codable {
    public let timestamp: Int // TODO: convert epoch time to date
    public let messageToken: Int64
    public let userId: String
    public let description: String?

    public enum CodingKeys: String, CodingKey {
        case timestamp
        case messageToken = "message_token"
        case userId = "user_id"
        case description = "desc"
    }
}

// TODO: returns specific models for message kinds?
public struct MessageCallbackModel: Codable {
    public let timestamp: Int // TODO: convert epoch time to date
    public let messageToken: Int64
    public let sender: CallbackUser

    public struct Message: Codable {
        public let type: MessageType
        public let text: String?
        
        /// URL of the message media - can be image, video, file and url. Image/Video/File URLs will have a TTL of 1 hour
        public let media: URL?
        public let rawTrackingData: String?

        public var trackingData: TrackingData? {
            guard let string = rawTrackingData,
                  !string.isEmpty,
                  let data = string.data(using: .utf8)
            else {
                return nil
            }
            return try? JSONDecoder().decode(TrackingData.self, from: data)
        }
        
        // TODO: implement
    //    "location":{
    //       "lat":50.76891,
    //       "lon":6.11499
    //    },
    //    public let location: Any?
    //    public let contact: Any?
        
        public let fileName: String?
        public let fileSize: Int?
        public let duration: Double?
        
        public let stickerId: Int?
        
        public enum CodingKeys: String, CodingKey {
            case type = "type"
            case text
            case media
            case rawTrackingData = "tracking_data"
            case fileName = "file_name"
            case fileSize = "file_size"
            case duration
            case stickerId = "sticker_id"
        }
    }
    public let message: Message
    
    public enum CodingKeys: String, CodingKey {
        case timestamp
        case messageToken = "message_token"
        case sender
        case message
    }
}

public struct ClientStatusCallbackModel: Codable {
    public let timestamp: Int // TODO: convert epoch time to date
    public let messageToken: Int64
    public let user: CallbackUser
    public let status: Status
    
    public struct Status: Codable {
        public let type: String
        public let code: Int
        public let supportedPSPs: [String]
        public let rawTrackingData: String?
        
        public enum CodingKeys: String, CodingKey {
            case type
            case code
            case supportedPSPs = "supported_psps"
            case rawTrackingData = "tracking_data"
        }
    }

    public enum CodingKeys: String, CodingKey {
        case timestamp
        case messageToken = "message_token"
        case user
        case status
    }
}

public struct CallbackUser: Codable {
    public let id: String
    public let name: String?
    public let avatar: String?
    public let country: String
    public let language: String
    public let apiVersion: Int
    
    public enum CodingKeys: String, CodingKey {
        case id
        case name
        case avatar
        case country
        case language
        case apiVersion = "api_version"
    }
    
    public var nameOrEmptyText: String {
        name ?? ""
    }
}
