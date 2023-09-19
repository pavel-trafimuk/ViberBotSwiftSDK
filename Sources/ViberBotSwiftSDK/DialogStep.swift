import Foundation
import Vapor
import ViberSharedSwiftSDK

public struct DialogEnvironment {
    public init(preferredLanguage: String, request: Request) {
        self.preferredLanguage = preferredLanguage
        self.request = request
    }
    
    public let preferredLanguage: String
    public let request: Request
}

public protocol DialogStep: Identifiable {
    
    /// useful to unify representation of this step in other menus
    static func asButtonInMenu(_ env: DialogEnvironment) -> UIGridButtonBuilder?

    /// random text will be sent to the participant when this step will be start,
    /// default value is nil
    func startingTextsFromBot(_ env: DialogEnvironment) -> [String]?
    
    /// keyboard which will be send with text above
    /// default value is nil
    func startingKeyboardFromBot(participant: CallbackUser?,
                                 env: DialogEnvironment) -> UIGridViewBuilder?
    
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
        let env = DialogEnvironment(preferredLanguage: replier.preferredLanguage,
                                    request: replier.request)
        guard let texts = startingTextsFromBot(env) else {
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
        let env = DialogEnvironment(preferredLanguage: preferredLanguage,
                                    request: request)
        guard var text = startingTextsFromBot(env)?.randomElement() else {
            return nil
        }
        // TODO: make it everywhere (in sender?)
        text = text.replacingOccurrences(of: Constants.usernamePlaceholder,
                                         with: participant.nameOrEmptyText)

        let keyboard: UIGridView?
        do {
            if let builder = startingKeyboardFromBot(participant: participant,
                                                     env: env) {
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

