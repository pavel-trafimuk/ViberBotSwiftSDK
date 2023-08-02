import Foundation
import Fluent
import ViberSharedSwiftSDK

public final class SavedStepEvent: Model {
    /// Name of the table or collection.
    public static let schema = "stepEvents"

    @ID(key: .id)
    public var id: UUID?
    
    @Field(key: "user_id")
    public var userId: String

    @Field(key: "step")
    public var step: String

    @Field(key: "timestamp")
    public var timestamp: Int

    @Field(key: "bot_id")
    public var botId: String?
    
    /// Creates a new, empty Subscriber.
    public init() { }

    /// Creates a new Subscriber with all properties set.
    public init(userId: String,
                step: String,
                timestamp: Int,
                botId: String) {
        self.userId = userId
        self.step = step
        self.timestamp = timestamp
        self.botId = botId
    }
}
