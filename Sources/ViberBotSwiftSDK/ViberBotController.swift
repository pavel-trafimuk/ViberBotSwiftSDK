//
//  ViberBot.swift
//  
//
//  Created by Pavel Trafimuk on 04/11/2022.
//

import Foundation
import Vapor
import Fluent
import FluentSQLiteDriver
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
        routes.post(.constant(Constants.callBacksPath)) { req in
            let logger = req.logger
            logger.debug("Received from Bot: \(req.body)")
            
            let event: CallbackEvent
            do {
                event = try req.content.decode(CallbackEvent.self)
            }
            catch {
                logger.critical("Can't parse model: \(error)")
                // To stop Viber trying to re-send it
                return HTTPStatus.ok
            }
            
            switch event {
            case .delivered(model: let model):
                logger.debug("Message was delivered \(model.messageToken) for \(model.userId)")
                
            case .seen(model: let model):
                logger.debug("Message was seen \(model.messageToken) for \(model.userId)")
                
            case .failed(model: let model):
                logger.error("Message sending failed \(model)")
                
            case .subscribed(model: let model):
                logger.debug("User subscribed \(model)")
                
                let participant: Subscriber
                if let existing = try await Subscriber.find(model.user.id, on: req.db) {
                    participant = existing
                    logger.debug("Already found \(existing.name)")
                }
                else {
                    participant = Subscriber()
                    logger.debug("A new one for \(model.user)")
                }
                participant.update(with: model.user)
                participant.status = .subscribed
                try await participant.save(on: req.db)
                
            case .unsubscribed(model: let model):
                logger.debug("User unsubscribed \(model)")
                
                if let existing = try await Subscriber.find(model.userId, on: req.db) {
                    existing.status = .unsubscribed
                    logger.debug("Already found \(existing.name)")
                    try await existing.save(on: req.db)
                }
                else {
                    logger.debug("Unsubscribed user \(model.userId) is not found")
                }
                
            case .conversationStarted(model: let model):
                logger.debug("Conversation started \(model)")
                
                let participant: Subscriber
                if let existing = try await Subscriber.find(model.user.id, on: req.db) {
                    participant = existing
                    logger.debug("Already found \(existing.name)")
                }
                else {
                    participant = Subscriber()
                    logger.debug("A new one for \(model.user)")
                }
                participant.update(with: model.user)
                participant.status = .subscribed
                try await participant.save(on: req.db)
                
                if let result = req.application.viberBotHandling.onConversationStarted?(req, model) {
                    return result
                }
                else {
                    return HTTPStatus.ok
                }
                
            case .message(model: let model):
                logger.debug("Received msg: \(model)")
                let participantId = model.sender.id
                
                let participant: Subscriber
                if let existing = try await Subscriber.find(participantId, on: req.db) {
                    participant = existing
                    logger.debug("Already found \(existing.name)")
                }
                else {
                    participant = Subscriber()
                    logger.debug("A new one for \(model.sender)")
                }
                participant.update(with: model.sender)
                participant.status = .subscribed
                try await participant.save(on: req.db)
                
                Task {
                    req.application.viberBotHandling.onMessageFromUserReceived?(req, model)
                }
                
            case .webhook(model: let model):
                logger.debug("Webhook \(model)")
                
            case .clientStatus(model: let model):
                logger.debug("Client Status \(model)")
                
            case .action:
                logger.debug("Action Callback")
            }
            return HTTPStatus.ok
        }
    }
}
