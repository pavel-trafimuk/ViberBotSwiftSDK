//
//  File.swift
//  
//
//  Created by Pavel Trafimuk on 02/01/2023.
//

import Vapor

public protocol ViberBotCommonContainer {
    var app: Application { get }
    var config: BotConfig { get set }
    var handling: IncomesHandlingStorage { get }
    var webhook: WebhookUpdater { get }
    func prepareDB() throws
}

public extension ViberBotCommonContainer {
    var config: BotConfig {
        get {
            app._viberBotConfig
        }
        set {
            app._viberBotConfig = newValue
        }
    }
    
    var handling: IncomesHandlingStorage {
        app._viberHandling
    }
    
    // TODO: maybe not correct order
    func prepareDB() throws {
        if config.useDatabase {
            app.databases.use(.sqlite(.file("viberBot.sqlite")), as: .sqlite)
            app.migrations.add(CreateSubscriber())
            try app.autoMigrate().wait()
        }
    }
    
    var webhook: WebhookUpdater {
        WebhookUpdater(app: app)
    }
}

public struct ViberBotAppContainer: ViberBotCommonContainer {
    public let app: Application
    
    init(application: Application) {
        self.app = application
    }
}

public struct ViberBotRequestContainer: ViberBotCommonContainer {
    public let app: Application
    public let request: Request

    init(request: Request) {
        self.app = request.application
        self.request = request
    }
    
    public var sender: Sender {
        Sender(request: request)
    }
}


extension Application {
    public var viberBot: ViberBotAppContainer {
        ViberBotAppContainer(application: self)
    }
    
    private struct BotConfigKey: StorageKey {
        typealias Value = BotConfig
    }

    private struct HandlingKey: StorageKey {
        typealias Value = IncomesHandlingStorage
    }
    
    fileprivate var _viberBotConfig: BotConfig {
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
    
    fileprivate var _viberHandling: IncomesHandlingStorage {
        if let existing = storage[HandlingKey.self] {
            return existing
        } else {
            let new = IncomesHandlingStorage()
            storage[HandlingKey.self] = new
            return new
        }
    }
}

extension Request {
    public var viberBot: ViberBotRequestContainer {
        ViberBotRequestContainer(request: self)
    }
}
