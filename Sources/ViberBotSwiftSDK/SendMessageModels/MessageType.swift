//
//  File.swift
//  
//
//  Created by Pavel Trafimuk on 04/11/2022.
//

import Foundation

public enum MessageType: String, Codable {
    case text
    case picture
    case video
    case file
    case location
    case contact
    case sticker
    case rich = "carousel"
    case url
}
