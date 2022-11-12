//
//  File.swift
//  
//
//  Created by Pavel Trafimuk on 12/11/2022.
//

import Foundation

extension ChannelsAPI {
    public struct Member: Codable {
        public let id: String
        public let name: String?
        public let avatar: URL?
        
        public let role: Role?
        
        public enum Role: String, Codable {
            case admin
            case superadmin
        }
    }
}
