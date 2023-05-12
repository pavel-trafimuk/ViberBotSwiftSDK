import Foundation
import Vapor

public struct DatabaseStorageLevel: OptionSet {
    public let rawValue: UInt

    public init(rawValue: UInt) {
        self.rawValue = rawValue
    }
    
    public static let subscriberInfo = DatabaseStorageLevel(rawValue: 1 << 0)
    public static let callbackEvent = DatabaseStorageLevel(rawValue: 1 << 1)
    public static let selectedSteps = DatabaseStorageLevel(rawValue: 1 << 2)
}

public final class BotConfig {
    public init(apiKey: String,
                hostAddress: String,
                routePath: String = "viber_bot",
                sendName: Bool = true,
                sendPhoto: Bool = true,
                defaultSenderInfo: SenderInfo,
                minApiVersion: Int = 7,
                databaseLevel: DatabaseStorageLevel = [],
                verboseLevel: Int = 0) {
        self.apiKey = apiKey
        self.hostAddress = hostAddress
        self.routePath = routePath
        self.sendName = sendName
        self.sendPhoto = sendPhoto
        self.verboseLevel = verboseLevel
        self.defaultSenderInfo = defaultSenderInfo
        self.minApiVersion = minApiVersion
        self.databaseLevel = databaseLevel
    }
    
    let apiKey: String
    public let hostAddress: String
    public let routePath: String
    let sendName: Bool
    let sendPhoto: Bool
    public var verboseLevel: Int
    public var defaultSenderInfo: SenderInfo
    public let minApiVersion: Int
    public let databaseLevel: DatabaseStorageLevel
}
