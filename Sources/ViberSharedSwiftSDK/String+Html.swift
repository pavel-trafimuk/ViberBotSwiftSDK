//
//  File.swift
//  
//
//  Created by Pavel Trafimuk on 13/01/2023.
//

import Foundation

extension String {
    public func htmlBold() -> String {
        "<b>" + self.trimmingCharacters(in: .whitespaces) + "</b>"
    }
    
    /// 12...32
    public func htmlTextSize(_ size: Int) -> String {
        "<font size='\(size)'>" + self.trimmingCharacters(in: .whitespaces) + "</font>"
    }
    
    /// 12...32
    public func htmlTextColor(_ color: String) -> String {
        "<font color='\(color)'>" + self.trimmingCharacters(in: .whitespaces) + "</font>"
    }
}

extension String {
    public static var white: String { "#ffffff"}

    public static var black: String { "#000000"}
    
    public static var viberPurple: String { "#7360F2"}
}
