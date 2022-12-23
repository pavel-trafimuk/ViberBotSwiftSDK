//
//  File.swift
//  
//
//  Created by Pavel Trafimuk on 04/11/2022.
//

import Foundation

public struct SenderInfo: Codable {
    public let name: String
    public let avatar: URL?
    
    public init(name: String,
                avatar: URL? = nil) {
        self.name = name
        self.avatar = avatar
    }
}
