//
//  File.swift
//  
//
//  Created by Pavel Trafimuk on 11/2/22.
//

import Foundation

public enum CallbackEventType: String, Codable {
    case delivered
    case seen
    case failed
    case subscribed
    case unsubscribed
    case conversation_started
    case message
}

public struct SetWebhookRequestModel: Codable {
    // your URL, which supports HTTPS&SSL and returns OK-200 on empty post request
    let url: String
    
    let authToken: String
    
    // nil for alls
    let eventTypes: [CallbackEventType]?
    
    // Indicates whether or not the bot should receive the user name. Default false
    let sendName: Bool
    
    // Indicates whether or not the bot should receive the user photo. Default false
    let sendPhoto: Bool
    
    public enum CodingKeys: String, CodingKey {
        case url
        case authToken = "auth_token"
        case eventTypes = "event_types"
        case sendName = "send_name"
        case sendPhoto = "send_photo"
    }
}

// will be sent to the your webserver
public struct SetWebhookConfirmModel: Codable {
    
    public enum Event: Codable {
        case webhook
    }
    
    let event: Event
    let timestamp: Int // TODO: convert epoch time to date
    let messageToken: Int64
    
    public enum CodingKeys: String, CodingKey {
        case event
        case timestamp
        case messageToken = "message_token"
    }
}

public struct SetWebhookResponseModel: Codable {
    
    let status: ResponseStatus
    let statusMessage: String
    
    let eventTypes: [CallbackEventType]?
    
    public enum CodingKeys: String, CodingKey {
        case status
        case statusMessage = "status_message"
        case eventTypes = "event_types"
    }
}
