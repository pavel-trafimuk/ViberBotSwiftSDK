//
//  File.swift
//  
//
//  Created by Pavel Trafimuk on 14/11/2022.
//

import Foundation

public enum UIGridError: Error {
    case titlesAndValuesNotBalanced
    case emptyButtons
}

// Simple version
public struct UIGridView: Codable {
    
    public enum GridType: String, Codable {
        case richMedia = "rich_media"
        case keyboard
    }
    
    public let type: GridType
    public let isDefaultHeight: Bool
    public let buttons: [Button]
    
    public enum CodingKeys: String, CodingKey {
        case type = "Type"
        case isDefaultHeight = "DefaultHeight"
        case buttons = "Buttons"
    }
}

extension UIGridView {
    public struct Button: Codable {
        
        public enum ActionType: String, Codable {
            case reply = "reply"
            case openUrl = "open-url"
        }
        
//        "Frame": {
//            "BorderWidth": 2,
//            "BorderColor": "#FFFFFF",
//            "CornerRadius": 10
//       },
        
        public let columns: Int
        public let rows: Int
        public let actionType: ActionType
        public let actionBody: String?
        public let image: URL?
        public let text: String?
        public let textSize: String? // medium
        public let textVAlign: String?
        public let textHAlign: String?
        
        public enum CodingKeys: String, CodingKey {
            case columns = "Columns"
            case rows = "Rows"
            case actionType = "ActionType"
            case actionBody = "ActionBody"
            case image = "Image"
            case text = "Text"
            case textSize = "TextSize"
            case textVAlign = "TextVAlign"
            case textHAlign = "TextHAlign"
        }
    }
}

extension UIGridView {
    public static func keyboardWithDefaultButtons(titles: [String],
                                                  values: [String]) throws -> UIGridView {
        guard titles.count == values.count else {
            throw UIGridError.titlesAndValuesNotBalanced
        }
        guard !titles.isEmpty else {
            throw UIGridError.emptyButtons
        }
        var buttons = [UIGridView.Button]()
        for (title, value) in zip(titles, values) {
            let button = UIGridView.Button(columns: 3,
                                           rows: 1,
                                           actionType: .reply,
                                           actionBody: value,
                                           image: nil,
                                           text: title,
                                           textSize: "medium",
                                           textVAlign: nil,
                                           textHAlign: nil)
            buttons.append(button)
        }
        return .init(type: .keyboard,
                     isDefaultHeight: false,
                     buttons: buttons)
    }
}
