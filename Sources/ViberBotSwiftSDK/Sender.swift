import Foundation
import Vapor
import ViberSharedSwiftSDK

public struct ReceiversList: ExpressibleByArrayLiteral, ExpressibleByStringLiteral {
    let shouldSendAsBroadcast: Bool
    private let list: [String]
    
    public init(list: [String]) {
        self.list = list
        shouldSendAsBroadcast = list.count > 1
    }
    
    public init(arrayLiteral elements: String...) {
        self.list = elements
        shouldSendAsBroadcast = list.count > 1
    }
    
    public init(stringLiteral value: StringLiteralType) {
        self.list = [value]
        shouldSendAsBroadcast = false
    }
    
    public init(_ receiver: String) {
        self.list = [receiver]
        shouldSendAsBroadcast = false
    }
    
    var singleReceiverValue: String? {
        guard !shouldSendAsBroadcast else {
            return nil
        }
        return list.first
    }
    
    var broadcastReceiversValue: [String]? {
        guard !shouldSendAsBroadcast else {
            return nil
        }
        return list
    }
}

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
    
    private func send(content: any Content, asBroadcast: Bool) {
        Task {
            do {
                let config = request.application.viberBot.config
                if config.verboseLevel > 1 {
                    let jsonString = try content.toJSON()
                    request.logger.debug("Sending Msg Request: \(jsonString)")
                }
                // TODO: implement response model
                let response = try await request.client.post(asBroadcast ? .broadcastMessage : .sendMessage,
                                                             content: content)
                request.logger.debug("Sending Msg Response: \(response)")
            }
            catch {
                logError(error)
            }
        }
    }
    
    private func logError(_ error: Error) {
        request.logger.error("Error With Sending Msg: \(error)")
        if !request.application.environment.isRelease {
            // TODO: improve it
//                    send(text: "Error With Sending Msg: \(error)",
//                         trackingData: nil,
//                         to: )
        }
    }
}

extension Sender {
    public func send(random list: [String],
                     keyboard: UIGridViewBuilder? = nil,
                     trackingData: TrackingData?,
                     isSilent: Bool = false,
                     to receivers: ReceiversList) {
        do {
            send(random: list,
                 keyboard: keyboard,
                 rawTrackingData: try trackingData?.toJSON(),
                 isSilent: isSilent,
                 to: receivers)
        }
        catch {
            logError(error)
        }
    }
    
    public func send(random list: [String],
                     keyboard: UIGridViewBuilder? = nil,
                     rawTrackingData: String?,
                     isSilent: Bool = false,
                     to receivers: ReceiversList) {
        do {
            let builtKeyboard = try keyboard?.build()
            send(random: list,
                 keyboard: builtKeyboard,
                 rawTrackingData: rawTrackingData,
                 isSilent: isSilent,
                 to: receivers)
        }
        catch {
            logError(error)
        }
    }
    
    public func send(random list: [String],
                     keyboard: UIGridView? = nil,
                     rawTrackingData: String?,
                     isSilent: Bool = false,
                     to receivers: ReceiversList) {
        guard let text = list.randomElement() else {
            return
        }
        send(text: text,
             keyboard: keyboard,
             rawTrackingData: rawTrackingData,
             isSilent: isSilent,
             to: receivers)
    }
    
    public func send(text: String,
                     keyboard: UIGridViewBuilder? = nil,
                     trackingData: TrackingData?,
                     isSilent: Bool = false,
                     to receivers: ReceiversList) {
        do {
            send(text: text,
                 keyboard: keyboard,
                 rawTrackingData: try trackingData?.toJSON(),
                 isSilent: isSilent,
                 to: receivers)
        }
        catch {
            logError(error)
        }
    }
    
    public func send(text: String,
                     keyboard: UIGridViewBuilder? = nil,
                     rawTrackingData: String?,
                     isSilent: Bool = false,
                     to receivers: ReceiversList) {
        do {
            let builtKeyboard = try keyboard?.build()
            send(text: text,
                 keyboard: builtKeyboard,
                 rawTrackingData: rawTrackingData,
                 isSilent: isSilent,
                 to: receivers)
        }
        catch {
            logError(error)
        }
    }
    
    public func send(text: String,
                     keyboard: UIGridView? = nil,
                     rawTrackingData: String?,
                     isSilent: Bool = false,
                     to receivers: ReceiversList) {
        let message = TextMessageRequestModel(text: text,
                                              keyboard: keyboard,
                                              receiver: receivers.singleReceiverValue,
                                              broadcastList: receivers.broadcastReceiversValue,
                                              sender: senderInfo,
                                              rawTrackingData: rawTrackingData,
                                              minApiVersion: minApiVersion,
                                              authToken: apiKey,
                                              isSilent: isSilent)
        send(content: message, asBroadcast: receivers.shouldSendAsBroadcast)
    }
    
    public func send(image: String,
                     thumbnail: String?,
                     description: String = "",
                     keyboard: UIGridViewBuilder? = nil,
                     trackingData: TrackingData?,
                     isSilent: Bool = false,
                     to receivers: ReceiversList) {
        do {
            send(image: image,
                 thumbnail: thumbnail,
                 description: description,
                 keyboard: keyboard,
                 rawTrackingData: try trackingData?.toJSON(),
                 isSilent: isSilent,
                 to: receivers)
        }
        catch {
            logError(error)
        }
    }
    
    public func send(image: String,
                     thumbnail: String?,
                     description: String = "",
                     keyboard: UIGridViewBuilder? = nil,
                     rawTrackingData: String?,
                     isSilent: Bool = false,
                     to receivers: ReceiversList) {
        do {
            let builtKeyboard = try keyboard?.build()
            send(image: image,
                 thumbnail: thumbnail,
                 description: description,
                 keyboard: builtKeyboard,
                 rawTrackingData: rawTrackingData,
                 isSilent: isSilent,
                 to: receivers)
        }
        catch {
            logError(error)
        }
    }
    
    public func send(image: String,
                     thumbnail: String?,
                     description: String = "",
                     keyboard: UIGridView? = nil,
                     rawTrackingData: String?,
                     isSilent: Bool = false,
                     to receivers: ReceiversList) {
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
                                                 receiver: receivers.singleReceiverValue,
                                                 broadcastList: receivers.broadcastReceiversValue,
                                                 sender: senderInfo,
                                                 rawTrackingData: rawTrackingData,
                                                 minApiVersion: minApiVersion,
                                                 authToken: apiKey,
                                                 isSilent: isSilent)
        send(content: message, asBroadcast: receivers.shouldSendAsBroadcast)
    }
    
    public func send(url: URL,
                     keyboard: UIGridView? = nil,
                     rawTrackingData: String?,
                     isSilent: Bool = false,
                     to receivers: ReceiversList) {
        let message = UrlMessageRequestModel(media: url,
                                             keyboard: keyboard,
                                             receiver: receivers.singleReceiverValue,
                                             broadcastList: receivers.broadcastReceiversValue,
                                             sender: senderInfo,
                                             rawTrackingData: rawTrackingData,
                                             minApiVersion: minApiVersion,
                                             authToken: apiKey,
                                             isSilent: isSilent)
        
        send(content: message, asBroadcast: receivers.shouldSendAsBroadcast)
    }
    
    public func send(rich: UIGridViewBuilder,
                     keyboard: UIGridViewBuilder? = nil,
                     trackingData: TrackingData?,
                     isSilent: Bool = false,
                     to receivers: ReceiversList) {
        do {
            let builtKeyboard = try keyboard?.build()
            let builtRich = try rich.build()
            let message = RichMessageRequestModel(richMedia: builtRich,
                                                  keyboard: builtKeyboard,
                                                  receiver: receivers.singleReceiverValue,
                                                  broadcastList: receivers.broadcastReceiversValue,
                                                  sender: senderInfo,
                                                  trackingData: trackingData,
                                                  minApiVersion: minApiVersion,
                                                  authToken: apiKey,
                                                  isSilent: isSilent)
            
            send(content: message, asBroadcast: receivers.shouldSendAsBroadcast)
        }
        catch {
            logError(error)
        }
    }
    
    public func send(rich: UIGridView,
                     keyboard: UIGridView? = nil,
                     rawTrackingData: String?,
                     isSilent: Bool = false,
                     to receivers: ReceiversList) {
        let message = RichMessageRequestModel(richMedia: rich,
                                              keyboard: keyboard,
                                              receiver: receivers.singleReceiverValue,
                                              broadcastList: receivers.broadcastReceiversValue,
                                              sender: senderInfo,
                                              rawTrackingData: rawTrackingData,
                                              minApiVersion: minApiVersion,
                                              authToken: apiKey,
                                              isSilent: isSilent)
        
        send(content: message, asBroadcast: receivers.shouldSendAsBroadcast)
    }
    
    public func send(sticker: String,
                     keyboard: UIGridViewBuilder? = nil,
                     trackingData: TrackingData?,
                     isSilent: Bool = false,
                     to receivers: ReceiversList) {
        do {
            let builtKeyboard = try keyboard?.build()
            send(sticker: sticker,
                 keyboard: builtKeyboard,
                 rawTrackingData: try trackingData?.toJSON(),
                 isSilent: isSilent,
                 to: receivers)
        }
        catch {
            logError(error)
        }
    }
    
    public func send(sticker: String,
                     keyboard: UIGridView? = nil,
                     rawTrackingData: String?,
                     isSilent: Bool = false,
                     to receivers: ReceiversList) {
        let message = StickerMessageRequestModel(stickerId: sticker,
                                                 keyboard: keyboard,
                                                 receiver: receivers.singleReceiverValue,
                                                 broadcastList: receivers.broadcastReceiversValue,
                                                 sender: senderInfo,
                                                 rawTrackingData: rawTrackingData,
                                                 minApiVersion: minApiVersion,
                                                 authToken: apiKey,
                                                 isSilent: isSilent)
        send(content: message, asBroadcast: receivers.shouldSendAsBroadcast)
    }
}

extension Encodable {
    /// Converting object to postable JSON
    func toJSON(_ encoder: JSONEncoder = JSONEncoder()) throws -> String {
        let data = try encoder.encode(self)
        return String(decoding: data, as: UTF8.self)
    }
}
