import Foundation

public enum ResponseStatus: Int, Codable, Error {
    /// Success
    case ok = 0
    
    /// The webhook URL is not valid
    case invalidUrl = 1
    
    /// The authentication token is not valid
    case invalidAuthToken = 2
    
    /// There is an error in the request itself (missing comma, brackets, etc.)
    case badData = 3
    
    /// Some mandatory data is missing
    case missingData = 4
    
    /// The receiver is not registered to Viber
    case receiverNotRegistered = 5
    
    /// The receiver is not subscribed to the account
    case receiverNotSubscribed = 6
    
    /// The account is blocked
    case publicAccountBlocked = 7
    
    /// The account associated with the token is not a account
    case publicAccountNotFound = 8
    
    /// The account is suspended
    case publicAccountSuspended = 9
    
    /// No webhook was set for the account
    case webhookNotSet = 10
    
    case receiverNoSuitableDevice = 11 // The receiver is using a device or a Viber version that don’t support accounts
    
    case tooManyRequests = 12 // Rate control breach
    
    case apiVersionNotSupported = 13 // Maximum supported account version by all user’s devices is less than the minApiVersion in the message
    
    case incompatibleWithVersion = 14 // minApiVersion is not compatible to the message fields
    
    case publicAccountNotAuthorized = 15 // The account is not authorized
    
    case inchatReplyMessageNotAllowed = 16 // Inline message not allowed
    
    case publicAccountIsNotInline = 17 // The account is not inline
    
    case noPublicChat = 18 // Failed to post to public account. The bot is missing a Public Chat interface
    
    case cannotSendBroadcast = 19 // Cannot send broadcast message
    
    case broadcastNotAllowed = 20 // Attempt to send broadcast message from the bot
    
    case unsupportedCountry = 21 // The message sent is not supported in the destination country
    
    /// The bot does not support payment messages
    case paymentUnsupported = 22
    
    /// The non-billable bot has reached the monthly threshold of free out of session messages
    case freeMessagesExceeded = 23
    
    /// No balance for a billable bot (when the “free out of session messages” threshold has been reached)
    case noBalance = 24
    
    /// General error
    case general = 1000
    
    public init(from decoder: Decoder) throws {
        let resultValue: Int
        
        if let raw = try? decoder.singleValueContainer().decode(String.self),
           let intRaw = Int(raw) {
            resultValue = intRaw
        }
        else if let raw = try? decoder.singleValueContainer().decode(Int.self) {
            resultValue = raw
        }
        else {
            resultValue = 1000
        }
        // TODO: fix it
        self.init(rawValue: resultValue)!
    }
}
