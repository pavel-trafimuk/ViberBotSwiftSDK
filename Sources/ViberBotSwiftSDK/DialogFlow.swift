//
//  File.swift
//  
//
//  Created by Pavel Trafimuk on 10/01/2023.
//

import Foundation
import Vapor
import ViberSharedSwiftSDK

public protocol DialogStepsProvider {
    
    /// will be ask to find step, which user could select from keyboards menu
    var allSteps: [any DialogStep] { get }
    
    /// will be asked when user open bot's conversation
    func welcomeStepOnConversationStarted(model: ConversationStartedCallbackModel,
                                          subscriber: Subscriber?,
                                          request: Request) -> (any DialogStep)?
    
    /// when message from user is not a menu selection nor answer on a question
    func stepForUndefinedMessage(_ message: MessageCallbackModel,
                                 subscriber: Subscriber?,
                                 request: Request) -> (any DialogStep)?
}

public struct DialogHandler {
    let provider: DialogStepsProvider
    let request: Request
    
    public init(provider: DialogStepsProvider,
                request: Request) {
        self.provider = provider
        self.request = request
    }
    
    /// main handler logic
    func onMessageReceived(model: MessageCallbackModel,
                           subscriber: Subscriber?) {
        let allSteps = provider.allSteps

        // first let's try to find - maybe user selected any menu
        if let step = allSteps.selectedStep(byText: model.message.text,
                                            trackingData: model.message.trackingData) {
            request.logger.debug("Found that user strictly selected: \(step.id)")
            
            step.quickReplyOnStepStart(participantId: model.sender.id,
                                       request: request)
            step.onStepWasStartedFromViberMessage(model,
                                                  subscriber: subscriber,
                                                  request: request)
            return
        }

        // second, maybe user answer on specific step
        if let trackingData = model.message.trackingData,
           let step = allSteps.first(where: { $0.id == trackingData }) {
            request.logger.debug("Found that user answered on \(step.id)")
            
            // it's a response from user
            step.onUserAnswer(message: model,
                              subscriber: subscriber,
                              request: request)
            return
        }
        
        // finally, user just something to write to us, it's not a menu or answer
        if let step = provider.stepForUndefinedMessage(model,
                                                       subscriber: subscriber,
                                                       request: request) {
            request.logger.debug("Found that user sent undefined (free talk) message, fall to \(step.id)")
            step.quickReplyOnStepStart(participantId: model.sender.id,
                                       request: request)
            step.onStepWasStartedFromViberMessage(model,
                                                  subscriber: subscriber,
                                                  request: request)
        }
        
    }
}

extension Array where Element == any DialogStep {
    func selectedStep(byText text: String?,
                      trackingData: String?) -> Element? {
        print("4444")
        // check by id
        if let found = first(where: { $0.id == text }) {
            return found
        }
        print("5555")

        // now compare the text
        // TODO: describe this issue more detail
//        if let found = first(where: { step in
//            if let button = try? step.keyboardButtonRepresentation?.build(),
//               let actionBody = button.actionBody,
//               actionBody == text {
//                return true
//            }
//            return false
//        }) {
//            return found
//        }
        
        return nil
    }
}
