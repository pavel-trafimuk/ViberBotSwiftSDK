import Foundation
import Vapor

public struct BotInfo {
    let app: Application
    let request: Request?

    private struct BotInfoKey: StorageKey {
        typealias Value = GetAccountInfo
    }

    private var logger: Logger {
        request?.logger ?? app.logger
    }
    
    private var client: Client {
        request?.client ?? app.client
    }
    
    public var cachedInfo: GetAccountInfo? {
        get {
            guard let result = app.storage[BotInfoKey.self] else {
                fatalError("Please config ViberBot")
            }
            return result
        }
        set {
            app.storage[BotInfoKey.self] = newValue
        }
    }
    
    @discardableResult
    public func getActualInfo() async throws -> GetAccountInfo {
        logger.debug("GetActualInfo")
        
        let response = try await client.post(.getAccountInfo,
                                             headers: [
                                                Constants.authHeaderKey: app.viberBot.config.apiKey
                                             ], beforeSend: { req in
                                                 //
                                             })
        let responseModel = try response.content.decode(GetAccountInfo.self)
        logger.debug("GetActualInfo result: \(responseModel)")
        app.storage[BotInfoKey.self] = responseModel
        return responseModel
    }
}
