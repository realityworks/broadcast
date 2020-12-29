//
//  UITextField+Styling.swift
//  Broadcast
//
//  Created by Piotr Suwara on 24/11/20.
//

import UIKit

extension UITextField {
    static func standard(withPlaceholder placeholder: LocalizedString = .none, insets: UIEdgeInsets? = nil) -> UITextField {
        let textField: UITextField
        
        if let insets = insets {
            textField = UITextField.textFieldWith(insets: insets)
        } else {
            textField = UITextField()
        }
        
        textField.borderStyle = .none
        
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.textFieldBorder.cgColor
        textField.layer.cornerRadius = 5
        
        textField.placeholder = placeholder.localized
        textField.height(50)
        textField.font = .body
        return textField
    }
}
