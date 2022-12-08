//
//  File.swift
//  
//
//  Created by Pavel Trafimuk on 08/12/2022.
//

import Foundation

public final class ConversationContext {
    public let memberId: String
    public var contextId: String?
    
    public struct Log {
        let isFromBot: Bool
        let text: String
    }
    
    public var lastDiscussion = [Log]()
    
    public init(memberId: String) {
        self.memberId = memberId
    }
}
