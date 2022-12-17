//
//  File.swift
//  
//
//  Created by Pavel Trafimuk on 11/2/22.
//

import Foundation

public enum Routes {
    case setWebhook
    case sendMessage
    case broadcastMessage
    case getAccountInfo
    case getOnline
    
    private enum Constants {
        static let baseUrl = "https://chatapi.viber.com/pa"
    }

    public var urlPath: String {
        switch self {
        case .setWebhook: return Constants.baseUrl + "/set_webhook"
        case .sendMessage: return Constants.baseUrl + "/send_message"
        case .broadcastMessage: return Constants.baseUrl + "/broadcast_message"
        case .getAccountInfo: return Constants.baseUrl + "/get_account_info"
        case .getOnline: return Constants.baseUrl + "/get_online"
        }
    }    
}
