//
//  File.swift
//  
//
//  Created by Pavel Trafimuk on 11/2/22.
//

import Foundation

public enum Endpoint {
    case setWebhook(model: SetWebhookRequestModel)
    case sendMessage
    
    private enum Constants {
        static let baseUrl = "https://chatapi.viber.com/pa"
    }
    
    public var urlPath: String {
        switch self {
        case .setWebhook(_): return Constants.baseUrl + "/set_webhook"
        case .sendMessage: return Constants.baseUrl + "/send_message"
        }
    }    
}
