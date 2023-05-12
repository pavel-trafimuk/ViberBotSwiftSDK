import Vapor
import Fluent

public protocol ViberBotCommonContainer {
    var app: Application { get }
    var config: BotConfig { get set }
    var handling: IncomesHandlingStorage { get }
    var webhook: WebhookUpdater { get }
    var info: BotInfo { get }
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
    
    mutating func setup(with config: BotConfig) throws {
        if !config.databaseLevel.isEmpty {
            app.migrations.add(CreateSubscriber())
            app.migrations.add(CreateSavedCallbackEvent())
            app.migrations.add(CreateSavedStepbackEvent())
        }
        try app.group(.constant(config.routePath)) { builder in
            try builder.register(collection: ViberBotController())
        }
        self.config = config
    }
    
    func launch() async  {
        do {
            let currentInfo = try await self.info.getActualInfo()
            let webhook = webhook
            if currentInfo.webhook != webhook.fullUrl {
                app.logger.debug("Webhook should be changed")
                app.logger.debug("from \(currentInfo.webhook ?? "nil")")
                app.logger.debug("to \(webhook.fullUrl)")
                try await webhook.update()
            }
        }
        catch {
            app.logger.error("Error: \(error)")
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
    
    public var info: BotInfo {
        .init(app: app, request: nil)
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
    
    public var info: BotInfo {
        .init(app: app, request: request)
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
