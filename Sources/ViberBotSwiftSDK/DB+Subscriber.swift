//
//  File.swift
//  
//
//  Created by Pavel Trafimuk on 17/12/2022.
//

import Foundation
import Fluent
import Vapor
import ViberSharedSwiftSDK

public final class Subscriber: Model, Content {
    // Name of the table or collection.
    public static let schema = "subscribers"

    // Unique identifier for the subscriber.
    @ID(custom: "user_id")
    public var id: String?

    // The Subscriber's name.
    @Field(key: "name")
    public var name: String

    @OptionalField(key: "avatar")
    public var avatar: String?

    @OptionalField(key: "status")
    public var status: String?

    @OptionalField(key: "last_context")
    public var lastContext: String?

    // to map user with some external services
    @OptionalField(key: "external_id")
    public var externalId: String?

    @OptionalField(key: "external_status")
    public var externalStatus: String?

//    // When this Planet was last updated.
//        @Timestamp(key: "updated_at", on: .update)
//        var updatedAt: Date?
    
//    @Field(key: "external_extra")
//    public var externalExtra: AnyObject?
    
    // TODO:
    // last getInfo date
// "country":"UK",
// "language":"en",
    // "api_version":1,

// "primary_device_os":"android 7.1",
// "viber_version":"6.5.0",
// "mcc":1,
// "mnc":1,
// "device_type":"iPhone9,4"
    
    // Creates a new, empty Subscriber.
    public init() { }

    // Creates a new Subscriber with all properties set.
    public init(id: String,
                name: String,
                avatar: String?) {
        self.id = id
        self.name = name
        self.avatar = avatar
    }
}

extension Subscriber {
    public func update(with user: CallbackUser) {
        name = user.name
        avatar = user.avatar
        // TODO: update other values
    }
}
