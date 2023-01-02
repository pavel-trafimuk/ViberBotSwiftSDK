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
public typealias OnConversationStarted = (Request, ConversationStartedCallbackModel) -> (any SendMessageRequestCommonValues)?

public final class IncomesHandlingStorage {
    public var onMessageFromUserReceived: OnMessageFromUserReceived?
    public var onConversationStarted: OnConversationStarted?
}
