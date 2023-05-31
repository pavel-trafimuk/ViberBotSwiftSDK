import Foundation
import Vapor

public enum Endpoint: String {
    case setWebhook = "set_webhook"
    case sendMessage = "send_message"
    case broadcastMessage = "broadcast_message"
    case getAccountInfo = "get_account_info"
    case getOnline = "get_online"
    
    private enum Constants {
        static let baseUrl = "https://chatapi.viber.com/pa/"
    }

    public var urlPath: String {
        Constants.baseUrl + rawValue
    }
    
    public var uri: URI {
        .init(stringLiteral: urlPath)
    }
    
    public var url: URL {
        URL(string: urlPath)!
    }
}

extension URI {
    public static let setWebhook: URI = Endpoint.setWebhook.uri
    public static let sendMessage: URI = Endpoint.sendMessage.uri
    public static let broadcastMessage: URI = Endpoint.broadcastMessage.uri
    public static let getOnline: URI = Endpoint.getOnline.uri
    public static let getAccountInfo: URI = Endpoint.getAccountInfo.uri
}
