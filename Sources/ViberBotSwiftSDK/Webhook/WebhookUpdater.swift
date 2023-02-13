import Vapor

public struct WebhookUpdater {
    let app: Application
    
    public var fullUrl: String {
        let host = app.viberBot.config.hostAddress
        let route = app.viberBot.config.routePath
        var result = ""
        if host.hasSuffix("/") {
            result += host.dropLast()
        }
        else {
            result += host
        }
        result += "/"
        if route.hasPrefix("/") {
            result += route.dropFirst()
        }
        else {
            result += route
        }
        result += "/" + Constants.callBacksPath
        return result
    }
    
    public func update() async throws {
        let config = app.viberBot.config
        let url = fullUrl
        
        app.logger.debug("Update webhook to \(url)")
        let requestModel = SetWebhookRequestModel(url: url,
                                                  authToken: config.apiKey,
                                                  sendName: config.sendName,
                                                  sendPhoto: config.sendPhoto)
        let response = try await app.client.post(.setWebhook,
                                                 content: requestModel)
        if app.viberBot.config.verboseLevel > 1 {
            app.logger.debug("Webhook response: \(response)")
        }

        let responseModel = try response.content.decode(SetWebhookResponseModel.self)
        guard responseModel.status == .ok else {
            app.logger.error("Webhook is not updated")
            app.logger.error("Error: \(responseModel)")
            return
        }
        app.logger.debug("Webhook was updated")
    }
}
