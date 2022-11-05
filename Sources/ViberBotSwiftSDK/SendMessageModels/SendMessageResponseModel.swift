//
//  File.swift
//  
//
//  Created by Pavel Trafimuk on 04/11/2022.
//

import Foundation

public struct SendMessageResponseModel: Codable {
    let status: ResponseStatus
    let statusMessage: String
    
    let messageToken: Int64?
    
    // TODO: implement
//    let billing_status: Int?
    
    public enum CodingKeys: String, CodingKey {
        case status
        case statusMessage = "status_message"
        case messageToken = "message_token"
    }
}
