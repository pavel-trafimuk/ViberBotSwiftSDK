//
//  File 2.swift
//  
//
//  Created by Pavel Trafimuk on 04/11/2022.
//

import Foundation
#if canImport(FoundationNetworking)
    import FoundationNetworking
#endif

public enum ViberBotError: Error {
    case senderNotDefined
    case endpointUrlIsNotValid
}

public final class ViberBot {
    let apiKey: String
    
    public var defaultSender: SenderInfo?
    
    public init(apiKey: String,
                defaultSender: SenderInfo? = nil) {
        self.apiKey = apiKey
        self.defaultSender = defaultSender
    }
}

//// send messages
//extension ViberBot {
//    public func sendTextMessage(to receiver: String,
//                                as sender: SenderInfo? = nil,
//                                model: TextMessageRequestModel) async throws -> SendMessageResponseModel {
//        guard let usedSender = sender ?? defaultSender else {
//            throw ViberBotError.senderNotDefined
//        }
//        
//        let internalModel = TextMessageInternalRequestModel(text: model.text,
//                                                            receiver: receiver,
//                                                            sender: usedSender,
//                                                            trackingData: model.trackingData,
//                                                            authToken: apiKey)
//        guard let url = URL(string: Endpoint.sendMessage.urlPath) else {
//            throw ViberBotError.endpointUrlIsNotValid
//        }
//        
//        var request = URLRequest(url: url)
//        try request.applyJSONAsBody(internalModel, verbose: 0)
//    }
//}
