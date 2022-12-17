//
//  ViberBot.swift
//  
//
//  Created by Pavel Trafimuk on 04/11/2022.
//

import Foundation
import Vapor
import ViberSharedSwiftSDK
import Fluent
import FluentSQLiteDriver

public enum ViberBotError: Error {
    case senderNotDefined
    case routeUrlIsNotValid
}

public final class ViberBot {
    private let apiKey: String
    public var defaultSender: SenderInfo
    public var verboseLevel = 1
    
    private let contextStorage = ConversationContextStorage()
    
    public init(apiKey: String,
                defaultSender: SenderInfo) {
        self.apiKey = apiKey
        self.defaultSender = defaultSender
    }
}

// Setup Webhook
extension ViberBot {
    public func updateWebhook(to host: String,
                              routeGroup: String,
                              app: Application) async throws {
        print("updateWebhook to \(host)")
        let requestModel = SetWebhookRequestModel(url: host + routeGroup,
                                                  authToken: apiKey,
                                                  sendName: true,
                                                  sendPhoto: true)
        
        let endpoint = Routes.setWebhook
        let response = try await app.client.post(.init(stringLiteral: endpoint.urlPath),
                                                 content: requestModel)
        print("Received answer: \(response.description)")
        let responseModel = try response.content.decode(SetWebhookResponseModel.self)
        print("Webhook answer \(responseModel)")
    }
}



extension ViberBot {
    public func setup(host: String,
                      routeGroup: String,
                      app: Application,
                      onConversationStarted: @escaping (Request, ConversationStartedCallbackModel) -> Void,
                      onMessageReceived: @escaping (Request, MessageCallbackModel, ConversationContext) -> Void
    ) throws {
        let group = app.grouped(.constant(routeGroup))
        
        // it's for testing only
        app.databases.use(.sqlite(.memory), as: .sqlite)

        group.post { req in
            print("Received from Bot: \(req.body)")
            
            let event = try req.content.decode(CallbackEvent.self)
            switch event {
            case .delivered(model: let model):
                print("Message delivered \(model.messageToken) for \(model.userId)")
                
            case .seen(model: let model):
                print("Message seen \(model.messageToken) for \(model.userId)")
                
            case .failed(model: let model):
                print("Message failed \(model)")
                
            case .subscribed(model: let model):
                print("User subscribed \(model)")
                
                if let existing = try await Subscriber.find(model.user.id, on: req.db) {
                    print("Already found")
                    existing.update(with: model.user)
                    existing.status = "subscribed"
                }
                else {
                    print("A new one")
                    let justCreated = Subscriber(id: model.user.id, name: model.user.name, avatar: model.user.avatar)
                    justCreated.update(with: model.user)
                    justCreated.status = "subscribed"
                }
                
            case .unsubscribed(model: let model):
                print("User unsubscribed \(model)")
                
                if let existing = try await Subscriber.find(model.userId, on: req.db) {
                    print("Already found")
                    existing.status = "unsubscribed"
                }
                else {
                    print("Unsubscribed user \(model.userId) is not found")
                }
                
            case .conversationStarted(model: let model):
                print("Conversation started \(model)")
                
                // TODO: track activity
                if let existing = try await Subscriber.find(model.user.id, on: req.db) {
                    print("Already found")
                    existing.update(with: model.user)
//                    existing.status = "subscribed"
                }
                else {
                    print("A new one")
                    let justCreated = Subscriber(id: model.user.id, name: model.user.name, avatar: model.user.avatar)
                    justCreated.update(with: model.user)
//                    justCreated.status = "subscribed"
                }
                
                Task {
                    onConversationStarted(req, model)
                }
                
            case .message(model: let model):
                print("Received msg: \(model)")
                let participant = model.sender.id
                
                // TODO: track activity
                if let existing = try await Subscriber.find(model.sender.id, on: req.db) {
                    print("Already found")
                    existing.update(with: model.sender)
//                    existing.status = "subscribed"
                }
                else {
                    print("A new one")
                    let justCreated = Subscriber(id: model.sender.id, name: model.sender.name, avatar: model.sender.avatar)
                    justCreated.update(with: model.sender)
//                    justCreated.status = "subscribed"
                }
                
                let context = self.contextStorage.getContext(for: participant)
                
                Task {
                    onMessageReceived(req, model, context)
                }
                
            case .webhook(model: let model):
                print("Webhook \(model)")
            case .clientStatus(model: let model):
                print("Client Status \(model)")
            case .action:
                print("Action Callback")
            }
            return HTTPStatus.ok
        }
    }
}

extension ViberBot {
    private func send(content: any Content,
                      req: Request) {
        Task {
            do {
                let route = Routes.sendMessage
                if verboseLevel > 1 {
                    print("Bot Sending Msg Request: \(try content.toJSON())")
                }
                let response = try await req.client.post(.init(stringLiteral: route.urlPath),
                                                         content: content)
                print("Bot Sending Msg Response: \(response)")
            }
            catch {
                print("Error With Sending Msg: \(error)")
            }
        }
    }
    
    public func send(text: String,
                     keyboard: UIGridView? = nil,
                     trackingData: String?,
                     to receiver: String,
                     as sender: SenderInfo? = nil,
                     req: Request) {
        let message = TextMessageRequestModel(text: text,
                                              keyboard: keyboard,
                                              receiver: receiver,
                                              sender: sender ?? defaultSender,
                                              trackingData: trackingData,
                                              authToken: apiKey)
        send(content: message, req: req)
    }
    
    public func send(image: String,
                     description: String = "",
                     keyboard: UIGridView? = nil,
                     trackingData: String?,
                     to receiver: String,
                     as sender: SenderInfo? = nil,
                     req: Request) {
        guard let url = URL(string: image) else { return }
        let message = PictureMessageRequestModel(text: description,
                                                 media: url,
                                                 keyboard: keyboard,
                                                 receiver: receiver,
                                                 sender: sender ?? defaultSender,
                                                 trackingData: trackingData,
                                                 authToken: apiKey)
        send(content: message, req: req)
    }
    
    public func sendWelcomeMessage(_ text: String,
                                   to receiver: String,
                                   as sender: SenderInfo? = nil,
                                   req: Request) {
        let content = TextMessageRequestModel(text: text,
                                              keyboard: nil,
                                              receiver: receiver,
                                              sender: sender ?? defaultSender,
                                              trackingData: nil,
                                              authToken: apiKey)
        Task {
            do {
                print("Bot Sending Welcome Msg Request: \(try content.toJSON())")
                let response = try await req.client.post(.init(stringLiteral: receiver), content: content)
                print("Bot Sending Msg Response: \(response)")
            }
            catch {
                print("Error With Sending Msg: \(error)")
            }
        }
    }
}

extension Encodable {
    /// Converting object to postable JSON
    func toJSON(_ encoder: JSONEncoder = JSONEncoder()) throws -> NSString {
        let data = try encoder.encode(self)
        let result = String(decoding: data, as: UTF8.self)
        return NSString(string: result)
    }
}
