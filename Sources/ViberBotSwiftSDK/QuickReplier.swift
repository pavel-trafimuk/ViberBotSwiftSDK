import Vapor
import ViberSharedSwiftSDK

public struct QuickReplier {
    public init(participant: CallbackUser,
                foundSubscriber: Subscriber?,
                previousTrackingData: TrackingData?,
                step: any DialogStep,
                request: Request) {
        self.participant = participant
        self.foundSubscriber = foundSubscriber
        self.step = step
        self.request = request
        self.previousTrackingData = previousTrackingData
        sender = Sender(request: request)
    }

    public let participant: CallbackUser
    
    public var preferredLanguage: String {
        previousTrackingData?.preferredLanguageCode ?? participant.language
    }
    public let foundSubscriber: Subscriber?

    public let previousTrackingData: TrackingData?
    
    private let step: any DialogStep
    public let request: Request
    public let sender: ViberBotSwiftSDK.Sender
    
    // TODO: add ability to send it with nil keyboard
    
    public func send(random list: [String],
                     customKeyboard: UIGridViewBuilder? = nil,
                     customTrackingData: TrackingData? = nil,
                     isSilent: Bool = false) {
        // TODO: make it everywhere (in sender?)
        var resultTexts = [String]()
        for source in list {
            let updated = source.replacingOccurrences(of: Constants.usernamePlaceholder,
                                                      with: participant.nameOrEmptyText)
            resultTexts.append(updated)
        }

        sender.send(random: resultTexts,
                    keyboard: getFinalKeyboard(customKeyboard),
                    trackingData: getFinalTrackingData(customTrackingData),
                    isSilent: isSilent,
                    to: .init(participant.id))
    }
    
    public func send(text: String,
                     customKeyboard: UIGridViewBuilder? = nil,
                     customTrackingData: TrackingData? = nil,
                     isSilent: Bool = false) {
        
        // TODO: make it everywhere (in sender?)
        let updated = text.replacingOccurrences(of: Constants.usernamePlaceholder,
                                                with: participant.nameOrEmptyText)

        sender.send(text: updated,
                    keyboard: getFinalKeyboard(customKeyboard),
                    trackingData: getFinalTrackingData(customTrackingData),
                    isSilent: isSilent,
                    to: .init(participant.id))
    }
    
    public func send(image: String,
                     thumbnail: String?,
                     description: String = "",
                     customKeyboard: UIGridViewBuilder? = nil,
                     customTrackingData: TrackingData? = nil,
                     isSilent: Bool = false) {
        sender.send(image: image,
                    thumbnail: thumbnail,
                    description: description,
                    keyboard: getFinalKeyboard(customKeyboard),
                    trackingData: getFinalTrackingData(customTrackingData),
                    isSilent: isSilent,
                    to: .init(participant.id))
    }
    
    public func send(rich: UIGridViewBuilder,
                     customKeyboard: UIGridViewBuilder? = nil,
                     customTrackingData: TrackingData? = nil,
                     isSilent: Bool = false) {
        sender.send(rich: rich,
                    keyboard: getFinalKeyboard(customKeyboard),
                    trackingData: getFinalTrackingData(customTrackingData),
                    isSilent: isSilent,
                    to: .init(participant.id))
    }
    
    private func getFinalTrackingData(_ custom: TrackingData?) -> TrackingData? {
        var result = custom ?? .init(previous: previousTrackingData, activeStep: step.id)
        result.pruneHistory()
        return result
    }
    
    private func getFinalKeyboard(_ custom: UIGridViewBuilder?) -> UIGridViewBuilder? {
        custom ?? step.startingKeyboardFromBot(participant: participant,
                                               env: .init(preferredLanguage: preferredLanguage,
                                                          request: request))
    }
}
