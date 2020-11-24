//
//  UITextField+Styling.swift
//  Broadcast
//
//  Created by Piotr Suwara on 24/11/20.
//

import UIKit

extension UITextField {
    static func standard(withPlaceholder placeholder: String) -> UITextField {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = placeholder
        return textField
    }
    
    static func password(withPlaceholder placeholder: String) -> UITextField {
        let textField = standard(withPlaceholder: placeholder)
        textField.isSecureTextEntry = true
        return textField
    }
}
