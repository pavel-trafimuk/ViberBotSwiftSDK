import Foundation
import Fluent
import ViberSharedSwiftSDK

public final class Subscriber: Model {
    /// Name of the table or collection.
    public static let schema = "subscribers"

    /// Unique identifier for the subscriber.
    @ID(custom: "user_id", generatedBy: .user)
    public var id: String?

    /// The Subscriber's name.
    @Field(key: "name")
    public var name: String

    @OptionalField(key: "avatar")
    public var avatar: String?

    @Field(key: "is_subscribed")
    public var isSubscribed: Bool

    @OptionalField(key: "last_context")
    public var lastContext: String?

    @OptionalField(key: "country")
    public var country: String?

    @OptionalField(key: "language")
    public var language: String?

    @OptionalField(key: "api_version")
    public var apiVersion: Int?

    @OptionalField(key: "primary_device_os")
    public var primaryDeviceOS: String?

    @OptionalField(key: "viber_version")
    public var viberVersion: String?

    @OptionalField(key: "device_type")
    public var deviceType: String?

    @OptionalField(key: "mcc")
    public var mcc: Int?

    @OptionalField(key: "mnc")
    public var mnc: Int?

    // to map user with some external services
    @OptionalField(key: "external_id")
    public var externalId: String?

    @OptionalField(key: "external_status")
    public var externalStatus: String?

//    @OptionalField(key: "external_value")
//    public var externalValue: Data?

    /// Creates a new, empty Subscriber.
    public init() { }

    /// Creates a new Subscriber with all properties set.
    public init(id: String,
                name: String,
                avatar: String?) {
        self.id = id
        self.name = name
        self.avatar = avatar
    }
}

extension Subscriber {
    public convenience init(with user: CallbackUser) {
        self.init()
        update(with: user)
    }
    
    public func update(with user: CallbackUser) {
        id = user.id
        name = user.name ?? ""
        avatar = user.avatar
        country = user.country
        language = user.language
//        apiVersion = user.apiVersion
    }
}
