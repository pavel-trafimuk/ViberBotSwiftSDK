//
//  File.swift
//  
//
//  Created by Pavel Trafimuk on 07/11/2022.
//

import Foundation

public enum CallbackEventType: String, Codable {
    case delivered
    case seen
    case failed
    case subscribed
    case unsubscribed
    case conversationStarted = "conversation_started"
    case clientStatus = "client_status"
    case message
    case action
    
    // specific one
    case webhook
    
    public static let allAvailableToSubscribe: [CallbackEventType] = {
        [.delivered, .seen, .failed, .subscribed, .unsubscribed, .conversationStarted, .message, .clientStatus, .action]
    }()
}
