//
//  File.swift
//  
//
//  Created by Pavel Trafimuk on 23/12/2022.
//

import Vapor

public struct WebhookUpdater {
    let app: Application
    
    public func update() async throws {
        let config = app.viberBot.config
        
        let fullUrl: String = {
            var result = ""
            if config.hostAddress.hasSuffix("/") {
                result += config.hostAddress.dropLast()
            }
            else {
                result += config.hostAddress
            }
            result += "/"
            if config.routePath.hasPrefix("/") {
                result += config.routePath.dropFirst()
            }
            else {
                result += config.routePath
            }
            result += "/" + Constants.callBacksPath
            return result
        }()
        
        app.logger.debug("Update webhook to \(fullUrl)")
        let requestModel = SetWebhookRequestModel(url: fullUrl,
                                                  authToken: config.apiKey,
                                                  sendName: config.sendName,
                                                  sendPhoto: config.sendPhoto)
        
        let endpoint = Endpoint.setWebhook
        let response = try await app.client.post(.init(stringLiteral: endpoint.urlPath),
                                                 content: requestModel)
        
        let responseModel = try response.content.decode(SetWebhookResponseModel.self)
        app.logger.debug("Webhook result: \(responseModel)")
    }
}
