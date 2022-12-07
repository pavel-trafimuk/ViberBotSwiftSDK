//
//  File.swift
//  
//
//  Created by Pavel Trafimuk on 12/11/2022.
//

import Foundation

public struct GetAccountInfoRequestModel: Codable {
    public let authToken: String
    
    public init(authToken: String) {
        self.authToken = authToken
    }
    
    public enum CodingKeys: String, CodingKey {
        case authToken = "auth_token"
    }
}

public struct GetAccountInfoResponseModel: Codable {
    public let status: ResponseStatus
    public let statusMessage: String
    
    public let id: String?
    public let name: String?
    public let background: URL?
    
    public let members: [Member]?
    
    public enum CodingKeys: String, CodingKey {
        case status
        case statusMessage = "status_message"
        case id
        case name
        case background
        case members
    }
}
