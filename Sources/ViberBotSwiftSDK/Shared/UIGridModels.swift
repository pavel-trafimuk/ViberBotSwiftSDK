//
//  File.swift
//  
//
//  Created by Pavel Trafimuk on 14/11/2022.
//

import Foundation

// TODO: not finalized
public struct UIGridButton: Codable {
    public let columns: Int
    public let rows: Int
    public let actionType: String? // open-url  reply
    public let actionBody: String?
    public let image: URL?
    public let text: String?
    public let textSize: String? // medium
    public let textVAlign: String?
    public let textHAlign: String?
    
    public enum CodingKeys: String, CodingKey {
        case columns = "Columns"
        case rows = "Rows"
        case actionType = "ButtonsGroupRows"
        case actionBody = "BgColor"
        case image = "Image"
        case text = "Text"
        case textSize = "TextSize"
        case textVAlign = "TextVAlign"
        case textHAlign = "TextHAlign"
    }
}

public enum UIGridType: String, Codable {
    case richMedia = "rich_media"
}

public struct UIGridElement: Codable {
    public let type: String
    
    public let buttonsGroupColumns: Int
    public let buttonsGroupRows: Int
    public let bgColor: String?
    
    public let buttons: [UIGridButton]
    
    public enum CodingKeys: String, CodingKey {
//        BgMediaType
//        BgMedia
        case type = "Type"
        case buttonsGroupColumns = "ButtonsGroupColumns"
        case buttonsGroupRows = "ButtonsGroupRows"
        case bgColor = "BgColor"
        case buttons = "Buttons"
    }
}
