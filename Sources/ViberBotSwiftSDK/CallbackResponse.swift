import Foundation
import Vapor
import ViberSharedSwiftSDK

public struct CallbackResponse: Content {
    let content: Data?
    
    public static func empty() -> CallbackResponse {
        return .init(content: nil)
    }
    
    public init(content: Data?) {
        self.content = content
    }

    public init(welcomeMessage: any SendMessageRequestCommonValues) throws {
        self.content = try JSONEncoder().encode(welcomeMessage)
    }
}

extension CallbackResponse: AsyncResponseEncodable {
    public func encodeResponse(for request: Request) async throws -> Response {
        var headers = HTTPHeaders()
        headers.add(name: .contentType, value: "application/json")
        headers.add(name: Constants.authHeaderKey, value: request.viberBot.config.apiKey)
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
