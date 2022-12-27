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

public struct UIGridView: Codable {
    
    public enum GridType: String, Codable {
        case richMedia = "rich_media"
        case keyboard
    }
    public let type: GridType
    
    /// When true - the keyboard will always be displayed with the same height
    /// as the native keyboard.
    /// When false - short keyboards will be displayed with the minimal possible height.
    /// Maximal height will be native keyboard height
    /// Default value is false
    public let isDefaultHeight: Bool?
    
    /// #FFAABB hex format
    /// Default value, Viber keyboard background
    public let backgroundColor: String?
    
    /// Array containing all keyboard buttons by order.
    /// See buttons parameters below for buttons parameters details
    public let buttons: [Button]
    
    public enum InputFieldState: String, Codable {
        case regular
        case minimized
        case hidden
    }
    
    /// Customize the keyboard input field.
    /// regular - display regular size input field.
    /// minimized - display input field minimized by default.
    /// hidden - hide the input field
    /// Default value is regular
    public let inputFieldState: InputFieldState?
    
    public enum CodingKeys: String, CodingKey {
        case type = "Type"
        case isDefaultHeight = "DefaultHeight"
        case buttons = "Buttons"
        case backgroundColor = "BgColor"
        case inputFieldState = "InputFieldState"
    }
    
    public static func keyboard(with buttons: [Button],
                                isDefaultHeight: Bool = false,
                                backgroundColor: String? = nil,
                                inputFieldState: InputFieldState = .regular) -> Self {
        .init(type: .keyboard,
              isDefaultHeight: isDefaultHeight,
              backgroundColor: backgroundColor,
              buttons: buttons,
              inputFieldState: inputFieldState)
    }
}

extension UIGridView {
    public struct Button: Codable {
        
        public let columns: Int
        
        public let rows: Int
        
        /// Background color of button
        /// #FFAABB hex format
        /// Default value, Viber button color
        public let backgroundColor: String?

        public let isSilent: Bool?
        
        /// Type of action pressing the button will perform.
        /// Reply - will send a reply to the bot.
        /// open-url - will open the specified URL and send the URL as reply to the bot.
        /// See reply logic for more details.
        /// Note: location-picker and share-phone are not supported on desktop,
        /// and require adding any text in the ActionBody parameter.
        public enum ActionType: String, Codable {
            case none
            case reply = "reply"
            case openUrl = "open-url"
            case sharePhone = "share-phone"
        }
        
        public let actionType: ActionType
        
        /// text or url
        public let actionBody: String?
        
        /// Valid URL. JPEG and PNG files are supported. Max size: 500 kb
        public let image: URL?
        
        public let text: String?
        
        public enum TextSize: String, Codable {
            case small
            case regular
            case large
        }
        public let textSize: TextSize? // regular
        
        public let textVAlign: String? // middle
        public let textHAlign: String? // center
        
        // TODO: finish with it
//        public struct InternalBrowser: Codable {
//            public actionButton
//
//            public enum CodingKeys: String, CodingKey {
//                case actionButton = "ActionButton"
//            }
//        }
//        public let internalBrowser: InternalBrowser?
        
        public struct Frame: Codable {
            public init(borderWidth: Int? = nil,
                        borderColor: String? = nil,
                        cornerRadius: Int? = nil) {
                self.borderWidth = borderWidth
                self.borderColor = borderColor
                self.cornerRadius = cornerRadius
            }
            
            /// 0...10, default is 1
            public let borderWidth: Int?
            
            /// Color of border
            /// Format #AABBCC
            /// Default is #000000
            public let borderColor: String?
            
            /// 0...10
            public let cornerRadius: Int?
            
            public enum CodingKeys: String, CodingKey {
                case borderWidth = "BorderWidth"
                case borderColor = "BorderColor"
                case cornerRadius = "CornerRadius"
            }
        }
        public let frame: Frame?
        
        public init(columns: Int,
                    rows: Int,
                    backgroundColor: String? = nil,
                    actionType: UIGridView.Button.ActionType,
                    actionBody: String? = nil,
                    isSilent: Bool? = false,
                    image: URL? = nil,
                    text: String? = nil,
                    textSize: UIGridView.Button.TextSize? = nil,
                    textVAlign: String? = nil,
                    textHAlign: String? = nil,
                    frame: UIGridView.Button.Frame? = nil) {
            self.columns = columns
            self.rows = rows
            self.backgroundColor = backgroundColor
            self.actionType = actionType
            self.actionBody = actionBody
            self.image = image
            self.isSilent = isSilent
            self.text = text
            self.textSize = textSize
            self.textVAlign = textVAlign
            self.textHAlign = textHAlign
            self.frame = frame
        }
        
        public enum CodingKeys: String, CodingKey {
            case columns = "Columns"
            case rows = "Rows"
            case backgroundColor = "BgColor"
            case actionType = "ActionType"
            case actionBody = "ActionBody"
            case image = "Image"
            case text = "Text"
            case textSize = "TextSize"
            case textVAlign = "TextVAlign"
            case textHAlign = "TextHAlign"
            case isSilent = "Silent"
//            case internalBrowser = "InternalBrowser"
            case frame = "Frame"
        }
    }
}
