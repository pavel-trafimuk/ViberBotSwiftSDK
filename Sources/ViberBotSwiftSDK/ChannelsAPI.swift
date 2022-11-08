//
//  File.swift
//  
//
//  Created by Pavel Trafimuk on 08/11/2022.
//

import Foundation

public enum ChannelsAPI {
    
    public enum Endpoint {
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
    
    public enum RequestStatus: Int, Codable, Error {
        case ok = 0
        case invalidUrl = 1
        case invalidAuthToken = 2
        case badData = 3
        case missingData = 4
        case publicAccountBlocked = 7
        case publicAccountNotFound = 8
        case publicAccountSuspended = 9
        case webhookNotSet = 10
        case tooManyRequests = 12
        
        case general = 1000
        
        public init(from decoder: Decoder) throws {
            let resultValue: Int
            
            if let raw = try? decoder.singleValueContainer().decode(String.self),
               let intRaw = Int(raw) {
                resultValue = intRaw
            }
            else if let raw = try? decoder.singleValueContainer().decode(Int.self) {
                resultValue = raw
            }
            else {
                resultValue = 1000
            }
            // TODO: fix it
            self.init(rawValue: resultValue)!
        }
    }
    
    public struct SendTextRequestModel: Codable {
        public let type: MessageType = .text
        public let text: String
        
        public let from: String
        public let authToken: String
        
        public init(text: String, from: String, authToken: String) {
            self.text = text
            self.from = from
            self.authToken = authToken
        }
        
        public enum CodingKeys: String, CodingKey {
            case type
            case text
            case from
            case authToken = "auth_token"
        }
    }
    
}
