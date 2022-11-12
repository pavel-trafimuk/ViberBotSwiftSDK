//
//  File.swift
//  
//
//  Created by Pavel Trafimuk on 12/11/2022.
//

import Foundation

extension ChannelsAPI {
    
    public struct SendTextRequestModel: Codable {
        public let type: MessageType = .text
        public let text: String
        
        public let senderMemberId: String
        public let authToken: String
        
        public init(text: String, senderMemberId: String, authToken: String) {
            self.text = text
            self.senderMemberId = senderMemberId
            self.authToken = authToken
        }
        
        public enum CodingKeys: String, CodingKey {
            case type
            case text
            case senderMemberId = "from"
            case authToken = "auth_token"
        }
    }
    
    
    public struct SendMessageResponseModel: Codable {
        let status: ResponseStatus
        let statusMessage: String
        
        let messageToken: Int64?

        public enum CodingKeys: String, CodingKey {
            case status
            case statusMessage = "status_message"
            case messageToken = "message_token"
        }
    }
    
}
