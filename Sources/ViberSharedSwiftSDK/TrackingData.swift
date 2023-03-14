import Foundation
import Vapor

public struct TrackingData: Codable, Content {

    public enum Constants {
        public static let maxLength = 4096
    }
    
    /// to reduce final size as we have limits
    public enum CodingKeys: String, CodingKey {
        case activeStep = "a"
        case storage = "s"
        case history = "h"
    }

    /// current step identifier, automatically filled by QuickReplier
    public var activeStep: String?
    
    /// for any temp values (e.g. during registration)
    /// please use the smallesk keys as you can
    public var storage: [String: String]?

    /// current step identifier, automatically filled by QuickReplier
    /// also automatically cleaned when trackingData reached the limit
    /// for sensitive information - use storage
    public struct HistoryItem: Codable, Content, Equatable {
        public enum Role {
            static let botPrefix = "⇲"
            case bot
            case participant
        }
        public let role: Role

        public let content: String
        
        public init(role: Role, content: String) {
            self.content = content
            self.role = role
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            let rawString = try container.decode(String.self)
            
            if rawString.hasPrefix(Role.botPrefix) {
                self.content = String(rawString.dropFirst(Role.botPrefix.count))
                self.role = .bot
            }
            else {
                self.content = rawString
                self.role = .participant
            }
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encode(jsonValue)
        }
        
        var jsonValue: String {
            switch role {
            case .bot:
                return Role.botPrefix + content
            case .participant:
                return content
            }
        }
    }
    public var history: [HistoryItem]?
    
    public mutating func pruneHistory() {
        guard history != nil else { return }
        guard lengthCountInJson > Constants.maxLength else { return }
       
        // not the best
        while lengthCountInJson > Constants.maxLength, !self.history!.isEmpty {
            self.history!.removeFirst()
        }
    }
    
    private var lengthCountWithoutHistory: Int {
        var result = 2 // {}
        
        if let activeStep {
            result += 2 // double " in key
            result += CodingKeys.activeStep.rawValue.lengthOfBytes(using: .utf8) // key
            result += 1 // :
            result += 2 // double " in value
            result += activeStep.lengthOfBytes(using: .utf8) // value
            if storage != nil || history != nil {
                result += 1 // ,
            }
        }
        if let storage {
            result += 2 // double " in key
            result += CodingKeys.storage.rawValue.lengthOfBytes(using: .utf8)
            result += 1 // :
            result += storage.lengthCountInJson
            if history != nil {
                result += 1 // ,
            }
        }
        return result
    }
    
    public var lengthCountInJson: Int {
        var result = lengthCountWithoutHistory
        if let history {
            result += 2 // double " in key
            result += CodingKeys.history.rawValue.lengthOfBytes(using: .utf8)
            result += 1 // :
            result += history.lengthCountInJson
        }
        return result
    }
    
    public init(activeStep: String?,
                storage: [String : String]?,
                history: [HistoryItem]?) {
        self.activeStep = activeStep
        self.storage = storage
        self.history = history
    }
    
    public init(previous: TrackingData?, activeStep: String?) {
        self.storage = previous?.storage
        self.history = previous?.history
        self.activeStep = activeStep
    }
}



extension TrackingData.HistoryItem {
    var lengthCountInJson: Int {
        jsonValue.lengthOfBytes(using: .utf8)
    }
}

extension Array where Element == TrackingData.HistoryItem {
    var lengthCountInJson: Int {
        var result = 2 // brackets
        for item in self {
            result += 2 // double " in key
            result += item.lengthCountInJson
        }
        if !self.isEmpty {
            result += self.count - 1 // , after each item
        }
        return result
    }
}

extension Dictionary where Key == String, Value == String {
    var lengthCountInJson: Int {
        var result = 2 // brackets
        for tuple in self {
            result += 2 // double " in key
            result += tuple.key.lengthOfBytes(using: .utf8)
            result += 1 // :
            result += 2 // double " in value
            result += tuple.value.lengthOfBytes(using: .utf8)
        }
        if !self.isEmpty {
            result += self.count - 1 // , after each tuple
        }
        return result
    }
}
