//
//  File.swift
//  
//
//  Created by Pavel Trafimuk on 11/2/22.
//

import Foundation

// for high-level sender
public struct TextMessageRequestModel {
    public init(text: String, trackingData: String? = nil) {
        self.text = text
        self.trackingData = trackingData
    }
    
    public let text: String
    public let trackingData: String?
}

// for request body
public struct TextMessageInternalRequestModel: Codable, SendMessageInternalRequestCommonValues {
    public init(text: String, receiver: String, sender: SenderInfo, trackingData: String? = nil, authToken: String) {
        self.text = text
        self.receiver = receiver
        self.sender = sender
        self.trackingData = trackingData
        self.authToken = authToken
    }
    
    public let text: String

    public let receiver: String // emid?
    public let messageType: MessageType = .text
    public let sender: SenderInfo
    public let trackingData: String?
    
    public let minApiVersion: Int = 3 // TODO: use latest one
    public let authToken: String
    
    public enum CodingKeys: String, CodingKey {
        case text
        case receiver
        case messageType
        case sender
        case authToken = "auth_token"
        case trackingData = "tracking_data"
        case minApiVersion = "min_api_version"
    }
}