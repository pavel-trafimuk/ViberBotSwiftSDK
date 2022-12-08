//
//  File.swift
//  
//
//  Created by Pavel Trafimuk on 11/2/22.
//

import Foundation
import ViberSharedSwiftSDK

// for request body
struct TextMessageRequestModel: Codable, SendMessageRequestCommonValues {
    public init(text: String,
                keyboard: UIGridView?,
                receiver: String,
                sender: SenderInfo,
                trackingData: String? = nil,
                authToken: String) {
        self.text = text
        self.receiver = receiver
        self.sender = sender
        self.trackingData = trackingData
        self.authToken = authToken
        self.keyboard = keyboard
    }
    
    public let text: String

    public let receiver: String // emid?
    public let messageType: MessageType = .text
    public let sender: SenderInfo
    public let trackingData: String?
    
    public let keyboard: UIGridView?
    public let minApiVersion: Int = 7 // TODO: use latest one
    public let authToken: String
    
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
