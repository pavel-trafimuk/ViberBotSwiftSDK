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
                routePath: String,
                sendName: Bool = true,
                sendPhoto: Bool = true,
                defaultSenderInfo: SenderInfo,
                minApiVersion: Int = 7,
                verboseLevel: Int = 0) {
        self.apiKey = apiKey
        self.hostAddress = hostAddress
        self.routePath = routePath
        self.sendName = sendName
        self.sendPhoto = sendPhoto
        self.verboseLevel = verboseLevel
        self.defaultSenderInfo = defaultSenderInfo
        self.minApiVersion = minApiVersion
    }
    
    let apiKey: String
    public let hostAddress: String
    public let routePath: String
    let sendName: Bool
    let sendPhoto: Bool
    public var verboseLevel: Int
    public var defaultSenderInfo: SenderInfo
    public let minApiVersion: Int
}

extension Application {
    public struct BotConfigKey: StorageKey {
        public typealias Value = BotConfig
    }
    
    public var viberBotConfig: BotConfig {
        get {
            guard let result = storage[BotConfigKey.self] else {
                fatalError("Please config ViberBot")
            }
            return result
        }
        set {
            storage[BotConfigKey.self] = newValue
        }
    }
}

extension Request {
    public var viberBotConfig: BotConfig {
        get {
            application.viberBotConfig
        }
        set {
            application.viberBotConfig = newValue
        }
    }
}
