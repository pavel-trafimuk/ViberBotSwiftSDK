//
//  File.swift
//  
//
//  Created by Pavel Trafimuk on 12/11/2022.
//

import Foundation
import ViberSharedSwiftSDK

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

public struct SendPictureRequestModel: Codable {
    public let type: MessageType = .picture
    
    //      Description of the photo. Can be an empty string if irrelevant
    //      Required. Max 768 characters
    public let text: String
    
    //        URL of the image (JPEG)
    //        Required. Max size 1 MB. Only JPEG format is supported. Other image formats as well as animated GIFs can be sent as URL messages or file messages. The URL must have a resource with a .jpeg file extension. Example: http://www.example.com/path/image.jpeg
    public let media: URL
    
    //        URL of a reduced size image (JPEG)
    // Optional. Max size 100 kb. Recommended: 400x400. Only JPEG format is supported
    public let thumbnail: URL?
    
    public let senderMemberId: String
    public let authToken: String
    
    public init(text: String,
                media: URL,
                thumbnail: URL?,
                senderMemberId: String,
                authToken: String) {
        self.text = text
        self.media = media
        self.thumbnail = thumbnail
        self.senderMemberId = senderMemberId
        self.authToken = authToken
    }
    
    public enum CodingKeys: String, CodingKey {
        case type
        case text
        case media
        case thumbnail
        case senderMemberId = "from"
        case authToken = "auth_token"
    }
}

public struct SendVideoRequestModel: Codable {
    public let type: MessageType = .video
    
    //        URL of the video (MP4, H264)    Required. Max size 50 MB. Only MP4 and H264 are supported
    public let media: URL
    
    //        URL of a reduced size image (JPEG)
    // Optional. Max size 100 kb. Recommended: 400x400. Only JPEG format is supported
    public let thumbnail: URL?
    
    //        Size of the video in bytes    Required
    public let size: Int
    
    //        Video duration in seconds; will be displayed to the receiver
    public let duration: TimeInterval?
    
    public let senderMemberId: String
    public let authToken: String
    
    public init(media: URL,
                thumbnail: URL?,
                size: Int,
                duration: TimeInterval?,
                senderMemberId: String,
                authToken: String) {
        self.media = media
        self.thumbnail = thumbnail
        self.size = size
        self.duration = duration
        self.senderMemberId = senderMemberId
        self.authToken = authToken
    }
    
    public enum CodingKeys: String, CodingKey {
        case type
        case media
        case thumbnail
        case size
        case duration
        case senderMemberId = "from"
        case authToken = "auth_token"
    }
}

public struct SendFileRequestModel: Codable {
    public let type: MessageType = .file
    
    //        URL of the file
    //        Required. Max size 50 MB. See forbidden file formats for unsupported file types
    public let media: URL
    
    //        URL of a reduced size image (JPEG)
    // Optional. Max size 100 kb. Recommended: 400x400. Only JPEG format is supported
    public let thumbnail: URL?
    
    //        Size of the file in bytes    Required
    public let size: Int
    
    public let fileName: String
    
    public let senderMemberId: String
    public let authToken: String
    
    public init(media: URL,
                thumbnail: URL?,
                size: Int,
                fileName: String,
                senderMemberId: String,
                authToken: String) {
        self.media = media
        self.thumbnail = thumbnail
        self.size = size
        self.fileName = fileName
        self.senderMemberId = senderMemberId
        self.authToken = authToken
    }
    
    public enum CodingKeys: String, CodingKey {
        case type
        case media
        case thumbnail
        case size
        case fileName = "file_name"
        case senderMemberId = "from"
        case authToken = "auth_token"
    }
}

public struct SendURLRequestModel: Codable {
    public let type: MessageType = .url
    
    public let media: URL
    
    public let text: String?
    
    public let senderMemberId: String
    public let authToken: String
    
    public init(media: URL,
                text: String?,
                senderMemberId: String,
                authToken: String) {
        self.media = media
        self.text = text
        self.senderMemberId = senderMemberId
        self.authToken = authToken
    }
    
    public enum CodingKeys: String, CodingKey {
        case type
        case media
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


