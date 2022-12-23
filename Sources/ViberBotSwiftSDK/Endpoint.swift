//
//  File.swift
//  
//
//  Created by Pavel Trafimuk on 11/2/22.
//

import Foundation

public enum Endpoint: String {
    case setWebhook = "set_webhook"
    case sendMessage = "send_message"
    case broadcastMessage = "broadcast_message"
    case getAccountInfo = "get_account_info"
    case getOnline = "get_online"
    
    private enum Constants {
        static let baseUrl = "https://chatapi.viber.com/pa"
    }

    public var urlPath: String {
        Constants.baseUrl + "/" + rawValue
    }
}
