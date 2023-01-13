//
//  File.swift
//  
//
//  Created by Pavel Trafimuk on 23/12/2022.
//

import Foundation
import Vapor

public final class BotConfig {
    public init(apiKey: String,
                hostAddress: String,
                routePath: String = "viber_bot",
                sendName: Bool = true,
                sendPhoto: Bool = true,
                defaultSenderInfo: SenderInfo,
                minApiVersion: Int = 7,
                useDatabase: Bool = true,
                verboseLevel: Int = 0) {
        self.apiKey = apiKey
        self.hostAddress = hostAddress
        self.routePath = routePath
        self.sendName = sendName
        self.sendPhoto = sendPhoto
        self.verboseLevel = verboseLevel
        self.defaultSenderInfo = defaultSenderInfo
        self.minApiVersion = minApiVersion
        self.useDatabase = useDatabase
    }
    
    let apiKey: String
    public let hostAddress: String
    public let routePath: String
    let sendName: Bool
    let sendPhoto: Bool
    public var verboseLevel: Int
    public var defaultSenderInfo: SenderInfo
    public let minApiVersion: Int
    public let useDatabase: Bool
}
