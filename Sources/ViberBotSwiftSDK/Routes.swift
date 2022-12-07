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
    
    private enum Constants {
        static let baseUrl = "https://chatapi.viber.com/pa"
    }
    
    public var urlPath: String {
        switch self {
        case .setWebhook: return Constants.baseUrl + "/set_webhook"
        case .sendMessage: return Constants.baseUrl + "/send_message"
        }
    }    
}
