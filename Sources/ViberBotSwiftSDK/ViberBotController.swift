import Foundation
import Vapor
import Fluent
import ViberSharedSwiftSDK

// TODO: fix trailing whitespaces
// TODO: use ENVs for api key
// TODO: add suffix if you want several bots on the same instances!
// TODO: stop using Tasks, maybe Queues for it?

/// To first launch the bot don't forget:
/// 1) Setup config via app.viberBotConfig = ...
/// 2) Call WebhookUpdater.update(...) to inform Viber Servers about your actual host address
/// 3) Call DatabaseSetup.prepare(...) to launch the needed DB for this bot
/// 4) Setup your custom handling of incoming messages via app.viberBotHandling.on....
/// 5) Add routing via ViberBotController()

public struct ViberBotController: RouteCollection {
    
    public init() {}
    
    public func boot(routes: RoutesBuilder) throws {
        struct EmptyJson: Codable, Content { }
        
        routes.post(.constant(Constants.callBacksPath)) { req in
            let logger = req.logger

            guard req.isValidViberCallback() else {
                logger.error("Request not from Viber")
                if let event = try? req.content.decode(CallbackEvent.self) {
                    logger.error("Event: \(event)")
                }
                else {
                    logger.error("Can't be parsed")
                }
                return CallbackResponse.empty()
            }
            if req.viberBot.config.verboseLevel > 0 {
                logger.debug("Bot received: \(req.body)")
            }
            
            let event: CallbackEvent
            do {
                event = try req.content.decode(CallbackEvent.self)
            }
            catch {
                logger.critical("Can't parse model: \(error)")
                // To stop Viber trying to re-send it
                return CallbackResponse.empty()
            }
            
            do {
                if event.isImportantForDB,
                   let dbEvent = SavedCallbackEvent(event: event) {
                    do {
                        try await dbEvent.save(on: req.db)
                    }
                    catch {
                        logger.error("DB saving fail: \(error)")
                    }
                }
                
                switch event {
                case .delivered(model: let model):
                    if req.viberBot.config.verboseLevel > 0 {
                        logger.debug("Message was delivered \(model.messageToken) for \(model.userId)")
                    }
                    
                case .seen(model: let model):
                    if req.viberBot.config.verboseLevel > 0 {
                        logger.debug("Message was seen \(model.messageToken) for \(model.userId)")
                    }
                    
                case .failed(model: let model):
                    logger.error("Message sending failed \(model)")
                    
                case .subscribed(model: let model):
                    if req.viberBot.config.verboseLevel > 0 {
                        logger.debug("User subscribed \(model)")
                    }
                    
                    try await self.findCreateAndUpdateSubscriber(participant: model.user,
                                                                 isSubscribed: true,
                                                                 request: req)
                    
                case .unsubscribed(model: let model):
                    if req.viberBot.config.verboseLevel > 0 {
                        logger.debug("User unsubscribed \(model)")
                    }
                    
                    if req.viberBot.config.databaseLevel.contains(.subscriberInfo) {
                        if let existing = try await Subscriber.find(model.userId, on: req.db) {
                            existing.isSubscribed = false
                            if req.viberBot.config.verboseLevel > 0 {
                                logger.debug("Already found \(existing.name)")
                            }
                            do {
                                try await existing.save(on: req.db)
                            }
                            catch {
                                logger.error("Failed with saving to DB: \(error)")
                            }
                        }
                        else {
                            if req.viberBot.config.verboseLevel > 0 {
                                logger.debug("Unsubscribed user \(model.userId) is not found")
                            }
                        }
                    }
                    
                case .conversationStarted(model: let model):
                    if req.viberBot.config.verboseLevel > 0 {
                        logger.debug("Conversation started \(model)")
                    }
                    
                    let subscriber = try await self.findCreateAndUpdateSubscriber(participant: model.user,
                                                                                  isSubscribed: true,
                                                                                  request: req)
                    
                    if let result = req.viberBot.handling.onConversationStarted?(req, model, subscriber) {
                        return try CallbackResponse(welcomeMessage: result)
                    }
                    else if let provider = req.viberBot.handling.dialogStepsProvider,
                            let step = provider.welcomeStepOnConversationStarted(model: model,
                                                                                 subscriber: subscriber,
                                                                                 request: req),
                            let content = step.getWelcomeMessageContent(participant: model.user,
                                                                 previousTrackingData: nil,
                                                                 request: req) {
                        return try CallbackResponse(welcomeMessage: content)
                    }
                    else {
                        return CallbackResponse.empty()
                    }
                    
                case .message(model: let model):
                    if req.viberBot.config.verboseLevel > 1 {
                        logger.debug("Received msg: \(model)")
                    }
                    else if req.viberBot.config.verboseLevel > 0 {
                        logger.debug("Received msg: \(model.message.text ?? "<no text>") from \(model.sender.name ?? model.sender.id)")
                    }
                    
                    let subscriber = try await self.findCreateAndUpdateSubscriber(participant: model.sender,
                                                                                  isSubscribed: true,
                                                                                  request: req)
                    
                    _ = req.application.eventLoopGroup.next().makeFutureWithTask {
                        logger.debug("Start handling")
                        req.viberBot.handling.onMessageFromUserReceived?(req, model, subscriber)
                        
                        if let provider = req.viberBot.handling.dialogStepsProvider {
                            provider.onMessageReceived(model: model,
                                                       foundSubscriber: subscriber,
                                                       request: req)
                        }
                    }
                    
                case .webhook(model: let model):
                    if req.viberBot.config.verboseLevel > 1 {
                        logger.debug("Webhook \(model)")
                    }
                    
                case .clientStatus(model: let model):
                    logger.debug("Client Status \(model)")
                    
                case .action:
                    logger.debug("Action Callback")
                }
            }
            catch {
                logger.debug("Error: \(error)")
            }
            return CallbackResponse.empty()
        }
    }
    
    @discardableResult
    private func findCreateAndUpdateSubscriber(participant: CallbackUser,
                                               isSubscribed: Bool,
                                               request: Request) async throws -> Subscriber? {
        guard request.viberBot.config.databaseLevel.contains(.subscriberInfo) else {
            return nil
        }
        let logger = request.logger
        
        let subscriber: Subscriber
        if let existing = try await Subscriber.find(participant.id, on: request.db) {
            subscriber = existing
            if request.viberBot.config.verboseLevel > 0 {
                logger.debug("Already found \(existing.name)")
            }
        }
        else {
            subscriber = Subscriber()
            if request.viberBot.config.verboseLevel > 0 {
                logger.debug("Created new one for \(participant)")
            }
        }
        subscriber.update(with: participant)
        subscriber.isSubscribed = isSubscribed
        do {
            try await subscriber.save(on: request.db)
        }
        catch {
            logger.error("Failed with saving \(participant), error: \(error)")
        }
        return subscriber
    }
}
