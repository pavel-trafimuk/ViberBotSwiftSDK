import Foundation
import Vapor
import ViberSharedSwiftSDK

public protocol DialogStepsProvider {
    
    /// will be ask to find step, which user could select from keyboards menu
    func getAllAvailableSteps(request: Request) -> [any DialogStep]
    
    /// will be asked when user open bot's conversation
    func welcomeStepOnConversationStarted(model: ConversationStartedCallbackModel,
                                          subscriber: Subscriber?,
                                          request: Request) -> (any DialogStep)?
    
    /// when message from user is not a menu selection nor answer on a question
    func stepForUndefinedMessage(_ message: MessageCallbackModel,
                                 subscriber: Subscriber?,
                                 request: Request) -> (any DialogStep)?
}

extension DialogStepsProvider {
    /// main handler logic
    func onMessageReceived(model: MessageCallbackModel,
                           foundSubscriber: Subscriber?,
                           request: Request) {
        let allSteps = getAllAvailableSteps(request: request)
        let participantLanguage = model.sender.language
        let trackingData = model.message.trackingData
        
        // first let's try to find - maybe user selected any menu
        if let step = allSteps.selectedStep(byText: model.message.text,
                                            participantLanguage: participantLanguage,
                                            request: request) {
            request.logger.debug("Found that user strictly selected: \(step.id)")
            
            step.executeStepStarting(model: model,
                                     previousTrackingData: trackingData,
                                     foundSubscriber: foundSubscriber,
                                     request: request)
            return
        }

        // second, maybe user answer on specific step
        if let trackingData,
           let step = allSteps.first(where: { $0.id == trackingData.activeStep }) {
            request.logger.debug("Found that user answered on \(step.id)")
            // it's a response from user
            var replier = QuickReplier(participant: model.sender,
                                       foundSubscriber: foundSubscriber,
                                       previousTrackingData: trackingData,
                                       step: step,
                                       request: request)
            step.onUserAnswer(message: model,
                              replier: replier)
            return
        }
        
        // finally, user just something to write to us, it's not a menu or answer
        if let step = stepForUndefinedMessage(model,
                                              subscriber: foundSubscriber,
                                              request: request) {
            request.logger.debug("Found that user sent undefined (free talk) message, fall to \(step.id)")
            step.executeStepStarting(model: model,
                                     previousTrackingData: trackingData,
                                     foundSubscriber: foundSubscriber,
                                     request: request)
        }
        
    }
}

extension Array where Element == any DialogStep {
    func selectedStep(byText text: String?,
                      participantLanguage: String,
                      request: Request) -> Element? {
        // check by id
        if let found = first(where: { $0.id == text }) {
            return found
        }

        // also if step was with openUrl, it will send the url to the bot(
        if let found = first(where: { step in
            guard
                let builder = type(of: step).getKeyboardButtonRepresentation(participantLanguage: participantLanguage,
                                                                             request: request),
                builder._actionType == .openUrl
            else {
                return false
            }
            return builder._actionBody == text
        }) {
            return found
        }
        
        return nil
    }
}
