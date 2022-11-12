//
//  File.swift
//  
//
//  Created by Pavel Trafimuk on 12/11/2022.
//

import Foundation

extension ChannelsAPI {
    public struct SetWebhookRequestModel: Codable {
        public init(url: String,
                    authToken: String) {
            self.url = url
            self.authToken = authToken
        }
        
        // your URL, which supports HTTPS&SSL and returns OK-200 on empty post request
        public let url: String
        
        public let authToken: String
        
        public enum CodingKeys: String, CodingKey {
            case url
            case authToken = "auth_token"
        }
    }

    public struct SetWebhookResponseModel: Codable {
        
        let status: ResponseStatus
        let statusMessage: String
        
        // TODO: add failable behavior, to decode even if event is unknown
        let eventTypes: [CallbackEventType]?
        
        public enum CodingKeys: String, CodingKey {
            case status
            case statusMessage = "status_message"
            case eventTypes = "event_types"
        }
    }
}
