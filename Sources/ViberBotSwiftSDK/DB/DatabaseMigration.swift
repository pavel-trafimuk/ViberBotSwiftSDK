import Foundation
import Fluent

struct CreateSubscriber: AsyncMigration {
    // Prepares the database for storing Galaxy models.
    func prepare(on database: Database) async throws {
        try await database
            .schema(Subscriber.schema)
            .field("user_id", .string, .identifier(auto: false))
            .field("name", .string)
            .field("avatar", .string)
            .field("is_subscribed", .bool, .required)
            .field("join_time", .int64)
            .field("last_context", .string)
            .field("country", .string)
            .field("language", .string)
            .field("api_version", .int)
            .field("primary_device_os", .string)
            .field("viber_version", .string)
            .field("device_type", .string)
            .field("mcc", .int)
            .field("mnc", .int)
            .field("external_id", .string)
            .field("external_status", .string)
            .create()
    }
    
    // Optionally reverts the changes made in the prepare method.
    func revert(on database: Database) async throws {
        try await database
            .schema(Subscriber.schema)
            .delete()
    }
}

struct AddSubscribersBotInfoEvent: AsyncMigration {
    // Prepares the database for storing Galaxy models.
    func prepare(on database: Database) async throws {
        try await database
            .schema(Subscriber.schema)
            .field("unjoin_time", .int64)
            .field("bot_id", .string)
            .update()
    }
    
    // Optionally reverts the changes made in the prepare method.
    func revert(on database: Database) async throws {
        try await database
            .schema(Subscriber.schema)
            .deleteField("bot_id")
            .deleteField("unjoin_time")
            .update()
    }
}


struct FillSubscribersBotInfoDefailEvent: AsyncMigration {
    
    let defaultBotName: String
    
    // Prepares the database for storing Galaxy models.
    func prepare(on database: Database) async throws {
        try await Subscriber
            .query(on: database)
            .filter(\.$botId == nil)
            .set(\.$botId, to: defaultBotName)
            .update()
    }
    
    // Optionally reverts the changes made in the prepare method.
    func revert(on database: Database) async throws {
        try await Subscriber
            .query(on: database)
            .filter(\.$botId == defaultBotName)
            .set(\.$botId, to: nil)
            .update()
    }
}


struct CreateSavedCallbackEvent: AsyncMigration {
    // Prepares the database for storing Galaxy models.
    func prepare(on database: Database) async throws {
        try await database
            .schema(SavedCallbackEvent.schema)
            .id()
            .field("user_id", .string)
            .field("event_type", .string)
            .field("timestamp", .int64)
            .create()
    }
    
    // Optionally reverts the changes made in the prepare method.
    func revert(on database: Database) async throws {
        try await database
            .schema(SavedCallbackEvent.schema)
            .delete()
    }
}

struct AddSavedCallbackBotInfoEvent: AsyncMigration {
    // Prepares the database for storing Galaxy models.
    func prepare(on database: Database) async throws {
        try await database
            .schema(SavedCallbackEvent.schema)
            .field("bot_id", .string)
            .update()
    }
    
    // Optionally reverts the changes made in the prepare method.
    func revert(on database: Database) async throws {
        try await database
            .schema(SavedCallbackEvent.schema)
            .deleteField("bot_id")
            .update()
    }
}

struct FillSavedCallbackBotInfoEvent: AsyncMigration {
    
    let defaultBotName: String
    
    // Prepares the database for storing Galaxy models.
    func prepare(on database: Database) async throws {
        
        try await SavedCallbackEvent
            .query(on: database)
            .filter(\.$botId == nil)
            .set(\.$botId, to: defaultBotName)
            .update()
    }
    
    // Optionally reverts the changes made in the prepare method.
    func revert(on database: Database) async throws {
        try await SavedCallbackEvent
            .query(on: database)
            .filter(\.$botId == defaultBotName)
            .set(\.$botId, to: nil)
            .update()
    }
}


struct CreateSavedStepbackEvent: AsyncMigration {
    // Prepares the database for storing Galaxy models.
    func prepare(on database: Database) async throws {
        try await database
            .schema(SavedStepEvent.schema)
            .id()
            .field("user_id", .string)
            .field("step", .string)
            .field("timestamp", .int64)
            .create()
    }
    
    // Optionally reverts the changes made in the prepare method.
    func revert(on database: Database) async throws {
        try await database
            .schema(SavedStepEvent.schema)
            .delete()
    }
}

struct AddSavedStepbackBotInfoEvent: AsyncMigration {
    // Prepares the database for storing Galaxy models.
    func prepare(on database: Database) async throws {
        try await database
            .schema(SavedStepEvent.schema)
            .field("bot_id", .string)
            .update()
    }
    
    // Optionally reverts the changes made in the prepare method.
    func revert(on database: Database) async throws {
        try await database
            .schema(SavedStepEvent.schema)
            .deleteField("bot_id")
            .update()
    }
}

struct FillSavedStepbackBotInfoEvent: AsyncMigration {
    
    let defaultBotName: String
    
    // Prepares the database for storing Galaxy models.
    func prepare(on database: Database) async throws {
        
        try await SavedStepEvent
            .query(on: database)
            .filter(\.$botId == nil)
            .set(\.$botId, to: defaultBotName)
            .update()
    }
    
    // Optionally reverts the changes made in the prepare method.
    func revert(on database: Database) async throws {
        try await SavedStepEvent
            .query(on: database)
            .filter(\.$botId == defaultBotName)
            .set(\.$botId, to: nil)
            .update()
    }
}
