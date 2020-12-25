//
//  LoginTextField.swift
//  Broadcast
//
//  Created by Piotr Suwara on 24/12/20.
//

import UIKit

class LoginTextField: UITextField {
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.minX+10, y: 10, width: 25, height: bounds.height-20)
    }

    static func username(withPlaceholder placeholder: LocalizedString) -> LoginTextField {
        let textField = LoginTextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = placeholder.localized
        textField.height(43)
        return textField

    }

    static func password(withPlaceholder placeholder: LocalizedString) -> LoginTextField {
        let textField = username(withPlaceholder: placeholder)
        textField.isSecureTextEntry = true
        return textField
    }
}
