import Foundation
import Fluent

struct CreateSubscriber: AsyncMigration {
    // Prepares the database for storing Galaxy models.
    func prepare(on database: Database) async throws {
        try await database.schema(Subscriber.schema)
            .field("user_id", .string, .identifier(auto: false))
            .field("name", .string)
            .field("avatar", .string)
            .field("is_subscribed", .bool, .required)
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
            .field("external_value", .data)
            .create()
    }
    
    // Optionally reverts the changes made in the prepare method.
    func revert(on database: Database) async throws {
        try await database.schema(Subscriber.schema).delete()
    }
}


struct CreateSavedCallbackEvent: AsyncMigration {
    // Prepares the database for storing Galaxy models.
    func prepare(on database: Database) async throws {
        try await database.schema(SavedCallbackEvent.schema)
            .id()
            .field("user_id", .string)
            .field("event_type", .string)
            .field("timestamp", .int64)
            .create()
    }
    
    // Optionally reverts the changes made in the prepare method.
    func revert(on database: Database) async throws {
        try await database.schema(SavedCallbackEvent.schema).delete()
    }
}


struct CreateSavedStepbackEvent: AsyncMigration {
    // Prepares the database for storing Galaxy models.
    func prepare(on database: Database) async throws {
        try await database.schema(SavedStepEvent.schema)
            .id()
            .field("user_id", .string)
            .field("step", .string)
            .field("timestamp", .int64)
            .create()
    }
    
    // Optionally reverts the changes made in the prepare method.
    func revert(on database: Database) async throws {
        try await database.schema(SavedStepEvent.schema).delete()
    }
}
