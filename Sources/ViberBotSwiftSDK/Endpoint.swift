//
//  File.swift
//  
//
//  Created by Pavel Trafimuk on 11/2/22.
//

import Foundation
import Vapor

public enum Endpoint: String {
    case setWebhook = "set_webhook"
    case sendMessage = "send_message"
    case broadcastMessage = "broadcast_message"
    case getAccountInfo = "get_account_info"
    case getOnline = "get_online"
    
    private enum Constants {
        static let baseUrl = "https://chatapi.viber.com/pa/"
    }

    public var urlPath: String {
        Constants.baseUrl + rawValue
    }
    
    public var uri: URI {
        .init(stringLiteral: urlPath)
    }
}

extension URI {
    static let setWebhook: URI = Endpoint.setWebhook.uri
    static let sendMessage: URI = Endpoint.sendMessage.uri
    static let broadcastMessage: URI = Endpoint.broadcastMessage.uri
    static let getOnline: URI = Endpoint.getOnline.uri
    static let getAccountInfo: URI = Endpoint.getAccountInfo.uri
}
