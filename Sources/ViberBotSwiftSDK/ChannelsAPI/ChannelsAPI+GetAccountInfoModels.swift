//
//  File.swift
//  
//
//  Created by Pavel Trafimuk on 12/11/2022.
//

import Foundation

extension ChannelsAPI {
    public struct GetAccountInfoRequestModel: Codable {
        public init() {
        }
    }
    
    public struct GetAccountInfoResponseModel: Codable {
        public let status: ResponseStatus
        public let statusMessage: String
        
        public let channelId: String?
        public let chatHostName: String?
        public let background: URL?
                
        public let members: [Member]?
        
        public enum CodingKeys: String, CodingKey {
            case status
            case statusMessage = "status_message"
            case chatHostName = "chat_hostname"
            case channelId = "Id"
            case background
            case members
        }
    }
}
