import Foundation
import Vapor
import ViberSharedSwiftSDK

// Short life structure for sending msgs
public struct Sender {
    private let request: Request
    private let config: BotConfig
    private let senderInfo: SenderInfo
    // TODO: fix it
    private let minApi = 7
    
    public init(request: Request,
                config: BotConfig) {
        self.request = request
        self.config = config
        self.senderInfo = config.defaultSenderInfo
    }
    
    private func send(content: any Content) {
        // TODO: seems like it's an error
        Task {
            do {
                let config = request.application.viberBotConfig
                let route = Endpoint.sendMessage
                if config.verboseLevel > 1 {
                    let jsonString = try content.toJSON()
                    request.logger.debug("Sending Msg Request: \(jsonString)")
                }
                let response = try await request.client.post(.init(stringLiteral: route.urlPath),
                                                             content: content)
                request.logger.debug("Sending Msg Response: \(response)")
            }
            catch {
                request.logger.error("Error With Sending Msg: \(error)")
            }
        }
    }
    
    public func send(text: String,
                     keyboard: UIGridView? = nil,
                     trackingData: String?,
                     to receiver: String) {
        let message = TextMessageRequestModel(text: text,
                                              keyboard: keyboard,
                                              receiver: receiver,
                                              sender: senderInfo,
                                              trackingData: trackingData,
                                              minApiVersion: minApi,
                                              authToken: config.apiKey)
        send(content: message)
    }
    
    public func send(image: String,
                     thumbnail: String?,
                     description: String = "",
                     keyboard: UIGridView? = nil,
                     trackingData: String?,
                     to receiver: String) {
        guard let url = URL(string: image) else { return }
        let thumbnailUrl: URL?
        if let thumbnail {
            thumbnailUrl = URL(string: thumbnail)
        }
        else {
            thumbnailUrl = nil
        }
        let message = PictureMessageRequestModel(text: description,
                                                 media: url,
                                                 thumbnail: thumbnailUrl,
                                                 keyboard: keyboard,
                                                 receiver: receiver,
                                                 sender: senderInfo,
                                                 trackingData: trackingData,
                                                 minApiVersion: minApi,
                                                 authToken: config.apiKey)
        send(content: message)
    }
    
    public func send(url: URL,
                     keyboard: UIGridView? = nil,
                     trackingData: String?,
                     to receiver: String) {
        let message = UrlMessageRequestModel(media: url,
                                             keyboard: keyboard,
                                             receiver: receiver,
                                             sender: senderInfo,
                                             trackingData: trackingData,
                                             minApiVersion: minApi,
                                             authToken: config.apiKey)
        
        send(content: message)
    }

    public func send(rich: UIGridView,
                     keyboard: UIGridView? = nil,
                     trackingData: String?,
                     to receiver: String) {
        let message = RichMessageRequestModel(richMedia: rich,
                                              keyboard: keyboard,
                                              receiver: receiver,
                                              sender: senderInfo,
                                              trackingData: trackingData,
                                              minApiVersion: minApi,
                                              authToken: config.apiKey)
        
        send(content: message)
    }

    public func sendWelcomeMessage(_ text: String,
                                   keyboard: UIGridView? = nil,
                                   trackingData: String?,
                                   to receiver: String) {
        let content = TextMessageRequestModel(text: text,
                                              keyboard: keyboard,
                                              receiver: receiver,
                                              sender: senderInfo,
                                              trackingData: trackingData,
                                              minApiVersion: minApi,
                                              authToken: config.apiKey)
        Task {
            do {
                if config.verboseLevel > 1 {
                    let jsonString = try content.toJSON()
                    request.logger.debug("Sending Welcome Msg Request: \(jsonString)")
                }
                let address = "https://" + (request.peerAddress?.ipAddress ?? "")
                
                let response = try await request.client.post(.init(stringLiteral: address),
                                                             content: content)
                request.logger.debug("Bot Sending Msg Response: \(response)")
            }
            catch {
                request.logger.error("Error With Sending Msg: \(error)")
            }
        }
    }
}

extension Request {
    public var viberBotSender: Sender {
        .init(request: self, config: application.viberBotConfig)
    }
}

extension Encodable {
    /// Converting object to postable JSON
    func toJSON(_ encoder: JSONEncoder = JSONEncoder()) throws -> String {
        let data = try encoder.encode(self)
        return String(decoding: data, as: UTF8.self)
    }
}
