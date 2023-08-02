import Foundation
import Fluent
import ViberSharedSwiftSDK

public final class SavedCallbackEvent: Model {
    
    /// Name of the table or collection.
    public static let schema = "callbackEvents"

    @ID(key: .id)
    public var id: UUID?
    
    @Field(key: "user_id")
    public var userId: String

    @Enum(key: "event_type")
    public var type: CallbackEventType

    @Field(key: "timestamp")
    public var timestamp: Int

    @Field(key: "bot_id")
    public var botId: String?
    
    /// Creates a new, empty Subscriber.
    public init() { }

    /// Creates a new Subscriber with all properties set.
    public init(userId: String,
                type: CallbackEventType,
                timestamp: Int,
                botId: String) {
        self.userId = userId
        self.type = type
        self.timestamp = timestamp
        self.botId = botId
    }
}


extension SavedCallbackEvent {
    public convenience init?(event: CallbackEvent, botId: String) {
        guard event.isImportantForDB else {
            return nil
        }
        switch event {
        case .delivered(let model):
            self.init()
            id = .generateRandom()
            userId = model.userId
            type = .delivered
            timestamp = model.timestamp
            self.botId = botId
            
        case .seen(let model):
            self.init()
            id = .generateRandom()
            userId = model.userId
            type = .seen
            timestamp = model.timestamp
            self.botId = botId

        case .failed(let model):
            self.init()
            id = .generateRandom()
            userId = model.userId
            type = .failed
            timestamp = model.timestamp
            self.botId = botId

        case .subscribed(let model):
            self.init()
            id = .generateRandom()
            userId = model.user.id
            type = .subscribed
            timestamp = model.timestamp
            self.botId = botId

        case .unsubscribed(let model):
            self.init()
            id = .generateRandom()
            userId = model.userId
            type = .unsubscribed
            timestamp = model.timestamp
            self.botId = botId

        case .conversationStarted(let model):
            self.init()
            id = .generateRandom()
            userId = model.user.id
            type = .conversationStarted
            timestamp = model.timestamp
            self.botId = botId

        case .message(let model):
            self.init()
            id = .generateRandom()
            userId = model.sender.id
            type = .message
            timestamp = model.timestamp
            self.botId = botId

        case .clientStatus(let model):
            self.init()
            id = .generateRandom()
            userId = model.user.id
            type = .clientStatus
            timestamp = model.timestamp
            self.botId = botId

        case .action:
            return nil
        case .webhook:
            return nil
        }
    }
}
