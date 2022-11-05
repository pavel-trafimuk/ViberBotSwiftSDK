//
//  File.swift
//  
//
//  Created by Pavel Trafimuk on 04/11/2022.
//

import Foundation

public protocol SendMessageInternalRequestCommonValues {
    var authToken: String { get }

    var receiver: String { get }
    var messageType: MessageType { get }
    var sender: SenderInfo  { get }
    var trackingData: String? { get }
    var minApiVersion: Int { get }
}
