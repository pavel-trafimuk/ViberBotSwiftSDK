//
//  File.swift
//  
//
//  Created by Pavel Trafimuk on 17/12/2022.
//

import Foundation
import Fluent

struct CreateSubscriber: AsyncMigration {
    // Prepares the database for storing Galaxy models.
    func prepare(on database: Database) async throws {
        try await database.schema(Subscriber.schema)
            .id()
            .field("name", .string)
            .field("avatar", .string)
            .field("status", .string)
            .field("last_context", .string)
            .field("external_id", .string)
            .field("external_status", .string)
            .create()
    }
    
    // Optionally reverts the changes made in the prepare method.
    func revert(on database: Database) async throws {
        try await database.schema(Subscriber.schema).delete()
    }
}
