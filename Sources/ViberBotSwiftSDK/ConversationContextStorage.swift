//
//  File.swift
//  
//
//  Created by Pavel Trafimuk on 08/12/2022.
//

import Foundation

final class ConversationContextStorage {
    // memberId: context
    var storages = [String: ConversationContext]()
    
    init() {
    }
    
    func getContext(for memberId: String) -> ConversationContext {
        if let result = storages[memberId] {
            return result
        }
        let context = ConversationContext(memberId: memberId)
        storages[memberId] = context
        return context
    }
}
