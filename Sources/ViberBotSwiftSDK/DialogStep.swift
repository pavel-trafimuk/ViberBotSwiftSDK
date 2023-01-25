//
//  File.swift
//  
//
//  Created by Pavel Trafimuk on 12/01/2023.
//

import Foundation
import Vapor
import ViberSharedSwiftSDK

public protocol DialogStep: Identifiable {
    
    /// to quickly generate buttons for menu
    static func getKeyboardButtonRepresentation(request: Request) -> UIGridButtonBuilder?

    /// random text will be sent to the participant when this step will be start,
    /// default value is nil
    func getTextsFromBot(request: Request) -> [String]?
    
    /// keyboard which will be send with text above
    /// default value is nil
    func getKeyboardFromBot(request: Request) -> UIGridViewBuilder?
    
    /// any custom logic, which you want to execute, when participant starts this step
    func onStepWasStartedFromViberMessage(_ message: MessageCallbackModel,
                                          subscriber: Subscriber?,
                                          request: Request)

    func onStepWasStartedFromExternalEvent(request: Request) async throws

    /// response logic, when bot receives user answer
    func onUserAnswer(message: MessageCallbackModel,
                      subscriber: Subscriber?,
                      request: Request)
}

public extension DialogStep {
    static var identifier: String {
        "step://_\(String(describing: self))_"
    }
    
    var id: String {
        "step://_\(String(describing: type(of: self)))_"
    }
    
    func quickReplyOnStepStart(participant: ViberSharedSwiftSDK.CallbackUser,
                               request: Request) {
        guard let texts = getTextsFromBot(request: request) else {
            return
        }
        // TODO: make it everywhere (in sender?)
        var resultTexts = [String]()
        for source in texts {
            let updated = source.replacingOccurrences(of: Constants.usernamePlaceholder,
                                                      with: participant.nameOrEmptyText)
            resultTexts.append(updated)
        }

        request.viberBot.sender.send(random: resultTexts,
                                     keyboard: getKeyboardFromBot(request: request),
                                     trackingData: id,
                                     to: participant.id)
    }
    
    func quickReplyContent(participant: ViberSharedSwiftSDK.CallbackUser,
                           request: Request) -> (any SendMessageRequestCommonValues)? {
        guard let text = getTextsFromBot(request: request)?.randomElement() else {
            return nil
        }
        let keyboard: UIGridView?
        do {
            if let builder = getKeyboardFromBot(request: request) {
                keyboard = try builder.build()
            }
            else {
                keyboard = nil
            }
        }
        catch {
            request.logger.error("Can't build keyboard: \(error)")
            keyboard = nil
        }
        return TextMessageRequestModel(text: text,
                                       keyboard: keyboard,
                                       receiver: participant.id,
                                       sender: request.viberBot.config.defaultSenderInfo,
                                       trackingData: id,
                                       minApiVersion: request.viberBot.config.minApiVersion,
                                       authToken: request.viberBot.config.apiKey)

    }
}

