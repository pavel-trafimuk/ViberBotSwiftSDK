//
//  File.swift
//  
//
//  Created by Pavel Trafimuk on 13/01/2023.
//

import Foundation

// Markdown supported only in text/picture messages
extension String {
    public func bold() -> String {
        "*" + self.trimmingCharacters(in: .whitespaces) + "*"
    }
    
    public func italics() -> String {
        "_" + self.trimmingCharacters(in: .whitespaces) + "_"
    }
    
    public func monospace() -> String {
        "```" + self.trimmingCharacters(in: .whitespaces) + "```"
    }
    
    public func strikethrough() -> String {
        "~" + self.trimmingCharacters(in: .whitespaces) + "~"
    }
}
