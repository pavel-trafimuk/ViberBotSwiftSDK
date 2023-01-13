//
//  File.swift
//  
//
//  Created by Pavel Trafimuk on 11/01/2023.
//

import Foundation

public enum UIGridBuilderError: Error {
    case typeNotProvided
    case columnsAreNotProvided
    case rowsAreNotProvided
    case actionTypeNotProvided
    case buttonsNotProvided
}

public final class UIGridViewBuilder {
    public init() {}
    public static var richMedia: UIGridViewBuilder { .init().type(.richMedia) }
    public static var keyboard: UIGridViewBuilder { .init().type(.keyboard) }

    private var _type: UIGridView.GridType?
    public func type(_ newValue: UIGridView.GridType) -> Self {
        _type = newValue
        return self
    }

    private var _isDefaultHeight: Bool?
    public func isDefaultHeight(_ newValue: Bool) -> Self {
        _isDefaultHeight = newValue
        return self
    }

    private var _backgroundColor: String?
    public func backgroundColor(_ newValue: String) -> Self {
        _backgroundColor = newValue
        return self
    }

    private var _buttons: [UIGridView.Button]?
    public func buttons(_ newValue: [UIGridView.Button]) -> Self {
        _buttons = newValue
        return self
    }

    private var _buttonsGroupColumns: Int?
    public func buttonsGroupColumns(_ newValue: Int) -> Self {
        _buttonsGroupColumns = newValue
        return self
    }

    private var _buttonsGroupRows: Int?
    public func buttonsGroupRows(_ newValue: Int) -> Self {
        _buttonsGroupRows = newValue
        return self
    }

    private var _inputFieldState: UIGridView.InputFieldState?
    public func inputFieldState(_ newValue: UIGridView.InputFieldState) -> Self {
        _inputFieldState = newValue
        return self
    }

    public func build() throws -> UIGridView {
        guard let _type else {
            throw UIGridBuilderError.typeNotProvided
        }
        guard let _buttons else {
            throw UIGridBuilderError.buttonsNotProvided
        }
        return UIGridView(type: _type,
                          isDefaultHeight: _isDefaultHeight,
                          backgroundColor: _backgroundColor,
                          buttons: _buttons,
                          buttonsGroupColumns: _buttonsGroupColumns,
                          buttonsGroupRows: _buttonsGroupRows,
                          inputFieldState: _inputFieldState)
    }
}

public final class UIGridButtonBuilder {
    public init() {}
    
    private var _columns: Int?
    private var _rows: Int?

    public func size(width: Int, height: Int) -> Self {
        _columns = width
        _rows = height
        return self
    }
    
    private var _backgroundColor: String?
    
    public func backgroundColor(_ newValue: String) -> Self {
        _backgroundColor = newValue
        return self
    }
    
    private var _isSilent: Bool?
    
    public func isSilent(_ newValue: Bool) -> Self {
        _isSilent = newValue
        return self
    }
    
    private var _actionType: UIGridView.Button.ActionType?
    public func action(_ type: UIGridView.Button.ActionType, body: String?) -> Self {
        _actionType = type
        _actionBody = body
        return self
    }
    
    private var _actionBody: String?

    private var _image: URL?
    public func image(_ newValue: URL) -> Self {
        _image = newValue
        return self
    }

    private var _text: String?
    public func text(_ newValue: String?) -> Self {
        _text = newValue
        return self
    }
    
    private var _textColor: String?
    public func textColor(_ newValue: String) -> Self {
        _textColor = newValue
        return self
    }

    private var _textSize: UIGridView.Button.TextSize?
    public func textSize(_ newValue: UIGridView.Button.TextSize) -> Self {
        _textSize = newValue
        return self
    }

    private var _textVAlign: String?
    public func textVAlign(_ newValue: String) -> Self {
        _textVAlign = newValue
        return self
    }

    private var _textHAlign: String?
    public func textHAlign(_ newValue: String) -> Self {
        _textHAlign = newValue
        return self
    }

    private var _openUrlType: UIGridView.Button.OpenUrlType?
    public func openUrlType(_ newValue: UIGridView.Button.OpenUrlType) -> Self {
        _openUrlType = newValue
        return self
    }

    private var _openUrlMediaType: UIGridView.Button.OpenUrlMediaType?
    public func openUrlMediaType(_ newValue: UIGridView.Button.OpenUrlMediaType) -> Self {
        _openUrlMediaType = newValue
        return self
    }

    private var _frame: UIGridView.Button.Frame?
    public func frame(_ newValue: UIGridView.Button.Frame) -> Self {
        _frame = newValue
        return self
    }

    public func build() throws -> UIGridView.Button {
        guard let _columns else {
            throw UIGridBuilderError.columnsAreNotProvided
        }
        guard let _rows else {
            throw UIGridBuilderError.rowsAreNotProvided
        }
        guard let _actionType else {
            throw UIGridBuilderError.actionTypeNotProvided
        }
        let finalText: String?
        if let color = _textColor {
            finalText = _text?.htmlTextColor(color)
        }
        else {
            finalText = _text
        }
        return UIGridView.Button.init(columns: _columns,
                                      rows: _rows,
                                      backgroundColor: _backgroundColor,
                                      actionType: _actionType,
                                      actionBody: _actionBody,
                                      isSilent: _isSilent,
                                      image: _image,
                                      openUrlType: _openUrlType,
                                      openUrlMediaType: _openUrlMediaType,
                                      text: finalText,
                                      textSize: _textSize,
                                      textVAlign: _textVAlign,
                                      textHAlign: _textHAlign,
                                      frame: _frame)
    }
}
