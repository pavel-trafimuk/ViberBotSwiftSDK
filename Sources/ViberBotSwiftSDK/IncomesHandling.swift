import Foundation
import Vapor
import ViberSharedSwiftSDK

public typealias OnMessageFromUserReceived = (Request, MessageCallbackModel, Subscriber?) -> Void
public typealias OnConversationStarted = (Request, ConversationStartedCallbackModel, Subscriber?) -> (any SendMessageRequestCommonValues)?

public final class IncomesHandlingStorage {
    /// handle it, usually just send a welcome message (return needed model)
    public var onConversationStarted: OnConversationStarted?
    
    /// low-lever way of handling
    public var onMessageFromUserReceived: OnMessageFromUserReceived?
    
    /// high-level dialog handling
    public var dialogStepsProvider: DialogStepsProvider?
    
}
