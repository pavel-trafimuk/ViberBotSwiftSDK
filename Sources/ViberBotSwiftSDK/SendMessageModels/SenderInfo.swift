import Foundation

public struct SenderInfo: Codable, Sendable {
    public let name: String
    public let avatar: URL?
    
    public init(name: String,
                avatar: URL? = nil) {
        self.name = name
        self.avatar = avatar
    }
}
