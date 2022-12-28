//
//  File.swift
//  
//
//  Created by Pavel Trafimuk on 23/12/2022.
//

import Foundation
import Vapor
import ViberSharedSwiftSDK

public typealias OnMessageFromUserReceived = (Request, MessageCallbackModel) -> Void
public typealias OnConversationStarted = (Request, ConversationStartedCallbackModel) -> TextMessageRequestModel?

public final class IncomesHandlingStorage {
    public var onMessageFromUserReceived: OnMessageFromUserReceived?
    public var onConversationStarted: OnConversationStarted?
}

extension Application {
    
    private struct HandlingKey: StorageKey {
        typealias Value = IncomesHandlingStorage
    }
    
    public var viberBotHandling: IncomesHandlingStorage {
        if let existing = storage[HandlingKey.self] {
            return existing
        } else {
            let new = IncomesHandlingStorage()
            storage[HandlingKey.self] = new
            return new
        }
    }
}
