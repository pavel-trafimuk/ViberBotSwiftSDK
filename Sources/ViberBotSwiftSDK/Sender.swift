import Foundation
import Vapor
import ViberSharedSwiftSDK

// TODO: add more specific sender with predefined participant?

/// Short life structure for sending msgs
public struct Sender {
    private let request: Request
    private let senderInfo: SenderInfo
    
    public init(request: Request) {
        self.request = request
        self.senderInfo = request.viberBot.config.defaultSenderInfo
    }
    
    private var minApiVersion: Int {
        request.viberBot.config.minApiVersion
    }
    
    private var apiKey: String {
        request.viberBot.config.apiKey
    }
    
    private func send(content: any Content) {
        // TODO: seems like it's an error
        Task {
            do {
                let config = request.application.viberBot.config
                if config.verboseLevel > 1 {
                    let jsonString = try content.toJSON()
                    request.logger.debug("Sending Msg Request: \(jsonString)")
                }
                let response = try await request.client.post(.sendMessage,
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
                     isSilent: Bool = false,
                     to receiver: String) {
        guard let text = list.randomElement() else {
            return
        }
        send(text: text,
             keyboard: keyboard,
             trackingData: trackingData,
             isSilent: isSilent,
             to: receiver)
    }
    
    public func send(text: String,
                     keyboard: UIGridView? = nil,
                     trackingData: String?,
                     isSilent: Bool = false,
                     to receiver: String) {
        let message = TextMessageRequestModel(text: text,
                                              keyboard: keyboard,
                                              receiver: receiver,
                                              sender: senderInfo,
                                              trackingData: trackingData,
                                              minApiVersion: minApiVersion,
                                              authToken: apiKey,
                                              isSilent: isSilent)
        send(content: message)
    }
    
    public func send(image: String,
                     thumbnail: String?,
                     description: String = "",
                     keyboard: UIGridView? = nil,
                     trackingData: String?,
                     isSilent: Bool = false,
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
                                                 authToken: apiKey,
                                                 isSilent: isSilent)
        send(content: message)
    }
    
    public func send(url: URL,
                     keyboard: UIGridView? = nil,
                     trackingData: String?,
                     isSilent: Bool = false,
                     to receiver: String) {
        let message = UrlMessageRequestModel(media: url,
                                             keyboard: keyboard,
                                             receiver: receiver,
                                             sender: senderInfo,
                                             trackingData: trackingData,
                                             minApiVersion: minApiVersion,
                                             authToken: apiKey,
                                             isSilent: isSilent)
        
        send(content: message)
    }

    public func send(rich: UIGridView,
                     keyboard: UIGridView? = nil,
                     trackingData: String?,
                     isSilent: Bool = false,
                     to receiver: String) {
        let message = RichMessageRequestModel(richMedia: rich,
                                              keyboard: keyboard,
                                              receiver: receiver,
                                              sender: senderInfo,
                                              trackingData: trackingData,
                                              minApiVersion: minApiVersion,
                                              authToken: apiKey,
                                              isSilent: isSilent)
        
        send(content: message)
    }
}

// broadcasting
extension Sender {
    private func broadcast(content: any Content) {
        // TODO: seems like it's an error
        Task {
            do {
                let config = request.application.viberBot.config
                if config.verboseLevel > 1 {
                    let jsonString = try content.toJSON()
                    request.logger.debug("Sending Msg Request: \(jsonString)")
                }
                // TODO: implement response model
                let response = try await request.client.post(.broadcastMessage,
                                                             content: content)
                request.logger.debug("Sending Msg Response: \(response)")
            }
            catch {
                request.logger.error("Error With Sending Msg: \(error)")
            }
        }
    }
    
    public func broadcast(text: String,
                          keyboard: UIGridView? = nil,
                          trackingData: String?,
                          isSilent: Bool = false,
                          to receivers: [String]) {
        let message = TextMessageRequestModel(text: text,
                                              keyboard: keyboard,
                                              receiver: nil,
                                              broadcastList: receivers,
                                              sender: senderInfo,
                                              trackingData: trackingData,
                                              minApiVersion: minApiVersion,
                                              authToken: apiKey,
                                              isSilent: isSilent)
        send(content: message)
    }
    
    public func broadcast(image: String,
                          thumbnail: String?,
                          description: String = "",
                          keyboard: UIGridView? = nil,
                          trackingData: String?,
                          isSilent: Bool = false,
                          to receivers: [String]) {
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
                                                 receiver: nil,
                                                 broadcastList: receivers,
                                                 sender: senderInfo,
                                                 trackingData: trackingData,
                                                 minApiVersion: minApiVersion,
                                                 authToken: apiKey,
                                                 isSilent: isSilent)
        send(content: message)
    }
    
    public func broadcast(url: URL,
                          keyboard: UIGridView? = nil,
                          trackingData: String?,
                          isSilent: Bool = false,
                          to receivers: [String]) {
        let message = UrlMessageRequestModel(media: url,
                                             keyboard: keyboard,
                                             receiver: nil,
                                             broadcastList: receivers,
                                             sender: senderInfo,
                                             trackingData: trackingData,
                                             minApiVersion: minApiVersion,
                                             authToken: apiKey,
                                             isSilent: isSilent)
        
        send(content: message)
    }

    public func broadcast(rich: UIGridView,
                          keyboard: UIGridView? = nil,
                          trackingData: String?,
                          isSilent: Bool = false,
                          to receivers: [String]) {
        let message = RichMessageRequestModel(richMedia: rich,
                                              keyboard: keyboard,
                                              receiver: nil,
                                              broadcastList: receivers,
                                              sender: senderInfo,
                                              trackingData: trackingData,
                                              minApiVersion: minApiVersion,
                                              authToken: apiKey)
        
        send(content: message)
    }

}

extension Encodable {
    /// Converting object to postable JSON
    func toJSON(_ encoder: JSONEncoder = JSONEncoder()) throws -> String {
        let data = try encoder.encode(self)
        return String(decoding: data, as: UTF8.self)
    }
}
