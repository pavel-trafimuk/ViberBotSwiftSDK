import Foundation
import Vapor
import ViberSharedSwiftSDK

// Short life structure for sending msgs
public struct Sender {
    private let request: Request
    private let senderInfo: SenderInfo
    
    public init(request: Request) {
        self.request = request
        self.senderInfo = request.viberBotConfig.defaultSenderInfo
    }
    
    private var minApiVersion: Int {
        request.viberBotConfig.minApiVersion
    }
    
    private var apiKey: String {
        request.viberBotConfig.apiKey
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
    
    public func send(random list: [String],
                     keyboard: UIGridView? = nil,
                     trackingData: String?,
                     to receiver: String) {
        guard let text = list.randomElement() else {
            return
        }
        let message = TextMessageRequestModel(text: text,
                                              keyboard: keyboard,
                                              receiver: receiver,
                                              sender: senderInfo,
                                              trackingData: trackingData,
                                              minApiVersion: minApiVersion,
                                              authToken: apiKey)
        send(content: message)
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
                                              minApiVersion: minApiVersion,
                                              authToken: apiKey)
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
                                                 minApiVersion: minApiVersion,
                                                 authToken: apiKey)
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
                                             minApiVersion: minApiVersion,
                                             authToken: apiKey)
        
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
                                              minApiVersion: minApiVersion,
                                              authToken: apiKey)
        
        send(content: message)
    }
}

extension Request {
    public var viberBotSender: Sender {
        .init(request: self)
    }
}

extension Encodable {
    /// Converting object to postable JSON
    func toJSON(_ encoder: JSONEncoder = JSONEncoder()) throws -> String {
        let data = try encoder.encode(self)
        return String(decoding: data, as: UTF8.self)
    }
}
