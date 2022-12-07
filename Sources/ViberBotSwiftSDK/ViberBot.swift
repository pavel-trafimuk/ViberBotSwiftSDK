//
//  ViberBot.swift
//  
//
//  Created by Pavel Trafimuk on 04/11/2022.
//

import Foundation
import Vapor
import ViberSharedSwiftSDK

public enum ViberBotError: Error {
    case senderNotDefined
    case routeUrlIsNotValid
}

public final class ViberBot {
    let apiKey: String
    public var defaultSender: SenderInfo
    public var verboseLevel = 1
    
    public var allKnownSubscribers = [String: String]() {
        didSet {
            print("allKnownSubscribers: \(allKnownSubscribers)")
        }
    }
    
    public init(apiKey: String,
                defaultSender: SenderInfo) {
        self.apiKey = apiKey
        self.defaultSender = defaultSender
    }
    
    public func updateWebhook(to host: String,
                              routeGroup: String,
                              app: Application) async throws {
        print("updateWebhook to \(host)")
        let requestModel = SetWebhookRequestModel(url: host + "//" + routeGroup,
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
                      onMessageReceived: @escaping (Request, MessageCallbackModel) -> Void
    ) throws {
            let group = app.grouped(.constant(routeGroup))
            group.post { req in
                print("Received from Bot: \(req.body)")
                
                let event = try req.content.decode(CallbackEvent.self)
                switch event {
                case .delivered(model: let model):
                    print("Message delivered \(model.messageToken)")
                    
                case .seen(model: let model):
                    print("Message seen \(model.messageToken)")
                    
                case .failed(model: let model):
                    print("Message failed \(model)")
                    
                case .subscribed(model: let model):
                    print("User subscribed \(model)")
                    
                    let participant = model.user.id
                    if self.allKnownSubscribers[participant] == nil {
                        self.allKnownSubscribers[participant] = model.user.name
                    }
                    
                case .unsubscribed(model: let model):
                    print("User unsubscribed \(model)")
                    
                case .conversationStarted(model: let model):
                    print("Conversation started \(model)")
                    
                    let participant = model.user.id
                    if self.allKnownSubscribers[participant] == nil {
                        self.allKnownSubscribers[participant] = model.user.name
                    }
                    
                    Task {
                        onConversationStarted(req, model)
                    }
                    
                case .message(model: let model):
                    print("Received msg: \(model)")
                    let participant = model.sender.id
                    
                    if self.allKnownSubscribers[participant] == nil {
                        self.allKnownSubscribers[participant] = model.sender.name
                    }

                    Task {
                        onMessageReceived(req, model)
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
                     to receiver: String,
                     as sender: SenderInfo? = nil,
                     req: Request) {
        let message = TextMessageRequestModel(text: text,
                                              keyboard: nil,
                                              receiver: receiver,
                                              sender: sender ?? defaultSender,
                                              authToken: apiKey)
        send(content: message, req: req)
    }
    
    public func send(image: String,
                     description: String = "",
                     to receiver: String,
                     as sender: SenderInfo? = nil,
                     req: Request) {
        guard let url = URL(string: image) else { return }
        let message = PictureMessageRequestModel(text: description,
                                                 media: url,
                                                 receiver: receiver,
                                                 sender: sender ?? defaultSender,
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
