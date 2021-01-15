//
//  UITextField+Styling.swift
//  Broadcast
//
//  Created by Piotr Suwara on 24/11/20.
//

import UIKit
import SwiftRichString

extension UITextField {
    static func standard(withPlaceholder placeholder: LocalizedString = .none, insets: UIEdgeInsets? = nil) -> UITextField {
        let textField: UITextField
        
        if let insets = insets {
            textField = UITextField.textFieldWith(insets: insets)
        } else {
            textField = UITextField()
        }
        
        textField.borderStyle = .none
        
        textField.backgroundColor = .white
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.textFieldBorder.cgColor
        textField.layer.cornerRadius = 5
        
        textField.attributedPlaceholder = placeholder.localized.set(style: Style.body).set(style: Style.lightGrey)
        textField.height(50)
        textField.font = .body
        return textField
    }
}
