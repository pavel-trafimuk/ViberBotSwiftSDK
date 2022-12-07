//
//  File.swift
//  
//
//  Created by Pavel Trafimuk on 08/11/2022.
//

import Foundation

public enum Routes {
    case setWebhook
    case getAccountInfo
    case postMessage
    
    private enum Constants {
        static let baseUrl = "https://chatapi.viber.com/pa"
    }
    
    public var urlPath: String {
        switch self {
        case .setWebhook: return Constants.baseUrl + "/set_webhook"
        case .getAccountInfo: return Constants.baseUrl + "/get_account_info"
        case .postMessage: return Constants.baseUrl + "/post"
        }
    }
}
