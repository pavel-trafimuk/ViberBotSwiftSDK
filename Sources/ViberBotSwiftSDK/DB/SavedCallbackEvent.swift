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

    /// Creates a new, empty Subscriber.
    public init() { }

    /// Creates a new Subscriber with all properties set.
    public init(userId: String,
                type: CallbackEventType,
                timestamp: Int) {
        self.userId = userId
        self.type = type
        self.timestamp = timestamp
    }
}


extension SavedCallbackEvent {
    public convenience init?(event: CallbackEvent) {
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
            
        case .seen(let model):
            self.init()
            id = .generateRandom()
            userId = model.userId
            type = .seen
            timestamp = model.timestamp

        case .failed(let model):
            self.init()
            id = .generateRandom()
            userId = model.userId
            type = .failed
            timestamp = model.timestamp

        case .subscribed(let model):
            self.init()
            id = .generateRandom()
            userId = model.user.id
            type = .subscribed
            timestamp = model.timestamp

        case .unsubscribed(let model):
            self.init()
            id = .generateRandom()
            userId = model.userId
            type = .unsubscribed
            timestamp = model.timestamp

        case .conversationStarted(let model):
            self.init()
            id = .generateRandom()
            userId = model.user.id
            type = .conversationStarted
            timestamp = model.timestamp

        case .message(let model):
            self.init()
            id = .generateRandom()
            userId = model.sender.id
            type = .message
            timestamp = model.timestamp
            
        case .clientStatus(let model):
            self.init()
            id = .generateRandom()
            userId = model.user.id
            type = .clientStatus
            timestamp = model.timestamp
            
        case .action:
            return nil
        case .webhook:
            return nil
        }
    }
}
