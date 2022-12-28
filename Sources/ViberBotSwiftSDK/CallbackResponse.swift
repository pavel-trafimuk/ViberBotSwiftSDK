import Foundation
import Vapor
import ViberSharedSwiftSDK

public struct CallbackResponse {
    let content: Data?
    
    public static func empty() -> CallbackResponse {
        return .init(content: nil)
    }
    
    public init(content: Data?) {
        self.content = content
    }
    
    public init(welcomeMessage: TextMessageRequestModel) throws {
        self.content = try JSONEncoder().encode(welcomeMessage)
    }
    
    public init(welcomeMessage: PictureMessageRequestModel) throws {
        self.content = try JSONEncoder().encode(welcomeMessage)
    }
    
    public init(welcomeMessage: RichMessageRequestModel) throws {
        self.content = try JSONEncoder().encode(welcomeMessage)
    }
    
    public init(welcomeMessage: UrlMessageRequestModel) throws {
        self.content = try JSONEncoder().encode(welcomeMessage)
    }
}

extension CallbackResponse: AsyncResponseEncodable {
    public func encodeResponse(for request: Request) async throws -> Response {
        var headers = HTTPHeaders()
        headers.add(name: .contentType, value: "application/json")
        let body: Response.Body
        if let content {
            body = .init(data: content)
        }
        else {
            body = .empty
        }
        return .init(status: .ok,
                     headers: headers,
                     body: body)
    }
}
