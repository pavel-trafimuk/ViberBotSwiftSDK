//
//  File.swift
//  
//
//  Created by Pavel Trafimuk on 04/11/2022.
//

import ViberSharedSwiftSDK
import Vapor

public protocol SendMessageRequestCommonValues: Content {
    var authToken: String { get }

    var receiver: String { get }
    var messageType: MessageType { get }
    var sender: SenderInfo  { get }
    
    // context of talking
    var trackingData: String? { get }
    
    var minApiVersion: Int { get }
}
