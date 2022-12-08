//
//  File.swift
//  
//
//  Created by Pavel Trafimuk on 04/11/2022.
//

import Foundation
import ViberSharedSwiftSDK

// for request body
public struct PictureMessageRequestModel: Codable, SendMessageRequestCommonValues {
    public init(text: String,
                media: URL,
                thumbnail: URL? = nil,
                keyboard: UIGridView?,
                receiver: String,
                sender: SenderInfo,
                trackingData: String? = nil,
                authToken: String) {
        self.text = text
        self.media = media
        self.thumbnail = thumbnail
        self.receiver = receiver
        self.sender = sender
        self.trackingData = trackingData
        self.authToken = authToken
        self.keyboard = keyboard
    }
    
    public let text: String
    public let media: URL
    
    // Recommended: 400x400. Max size: 100kb.
    public let thumbnail: URL?

    public let keyboard: UIGridView?

    public let receiver: String
    public let messageType: MessageType = .picture
    public let sender: SenderInfo
    public let trackingData: String?
    
    public let minApiVersion: Int = 3 // TODO: use latest one
    public let authToken: String
    
    public enum CodingKeys: String, CodingKey {
        case text
        case media
        case thumbnail
        case receiver
        case messageType = "type"
        case sender
        case authToken = "auth_token"
        case trackingData = "tracking_data"
        case minApiVersion = "min_api_version"
        case keyboard = "keyboard"
    }
}
