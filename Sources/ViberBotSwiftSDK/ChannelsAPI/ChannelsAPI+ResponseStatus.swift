//
//  File.swift
//  
//
//  Created by Pavel Trafimuk on 12/11/2022.
//

import Foundation

extension ChannelsAPI {
    public enum ResponseStatus: Int, Codable, Error {
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
}
