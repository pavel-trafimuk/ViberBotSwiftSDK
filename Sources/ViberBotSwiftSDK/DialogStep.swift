import Foundation
import Vapor
import ViberSharedSwiftSDK

public protocol DialogStep: Identifiable {
    
    /// to quickly generate buttons for menu
    static func getKeyboardButtonRepresentation(preferredLanguage: String,
                                                request: Request) -> UIGridButtonBuilder?

    /// random text will be sent to the participant when this step will be start,
    /// default value is nil
    func getTextsFromBot(preferredLanguage: String,
                         request: Request) -> [String]?
    
    /// keyboard which will be send with text above
    /// default value is nil
    func getKeyboardFromBot(participant: ViberSharedSwiftSDK.CallbackUser,
                            preferredLanguage: String,
                            request: Request) -> UIGridViewBuilder?
    
    /// any custom logic, which you want to execute, when participant starts this step
    func onStepWasStartedFromViberMessage(_ message: MessageCallbackModel,
                                          replier: QuickReplier)

    func onStepWasStartedFromExternalEvent(request: Request) async throws

    /// response logic, when bot receives user answer
    func onUserAnswer(message: MessageCallbackModel,
                      replier: QuickReplier)
}

public enum DialogStepConstants {
    static let stepPrefix = "s☧://"
    
    public static func isStepIdentifier(_ check: String) -> Bool {
        check.hasPrefix(DialogStepConstants.stepPrefix)
    }
    
}

public extension DialogStep {
    
    static var identifier: String {
        "\(DialogStepConstants.stepPrefix)\(String(describing: self))"
    }
    
    var id: String {
        "\(DialogStepConstants.stepPrefix)\(String(describing: type(of: self)))"
    }
    
    func executeStepStarting(model: MessageCallbackModel,
                             previousTrackingData: TrackingData?,
                             foundSubscriber: Subscriber?,
                             request: Request) {
        let finalTracking = previousTrackingData ?? model.message.trackingData
        let replier = QuickReplier(participant: model.sender,
                                   foundSubscriber: foundSubscriber,
                                   previousTrackingData: finalTracking,
                                   step: self,
                                   request: request)
        
        quickReplyOnStepStart(participant: model.sender,
                              replier: replier)
        onStepWasStartedFromViberMessage(model,
                                         replier: replier)
    }
    
    func quickReplyOnStepStart(participant: ViberSharedSwiftSDK.CallbackUser,
                               replier: QuickReplier) {
        guard let texts = getTextsFromBot(preferredLanguage: replier.preferredLanguage,
                                          request: replier.request) else {
            return
        }
        Task {
            replier.send(random: texts)
        }
    }
    
    func getWelcomeMessageContent(participant: ViberSharedSwiftSDK.CallbackUser,
                                  previousTrackingData: TrackingData?,
                                  request: Request) -> (any SendMessageRequestCommonValues)? {
        let preferredLanguage = previousTrackingData?.preferredLanguageCode ?? participant.language

        guard var text = getTextsFromBot(preferredLanguage: preferredLanguage,
                                         request: request)?.randomElement() else {
            return nil
        }
        // TODO: make it everywhere (in sender?)
        text = text.replacingOccurrences(of: Constants.usernamePlaceholder,
                                         with: participant.nameOrEmptyText)

        let keyboard: UIGridView?
        do {
            if let builder = getKeyboardFromBot(participant: participant,
                                                preferredLanguage: preferredLanguage,
                                                request: request) {
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
        let tracking = TrackingData(previous: previousTrackingData, activeStep: id)
        return TextMessageRequestModel(text: text,
                                       keyboard: keyboard,
                                       receiver: participant.id,
                                       sender: request.viberBot.config.defaultSenderInfo,
                                       trackingData: tracking,
                                       minApiVersion: request.viberBot.config.minApiVersion,
                                       authToken: request.viberBot.config.apiKey)

    }
}

