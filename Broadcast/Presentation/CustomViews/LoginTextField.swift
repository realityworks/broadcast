//
//  LoginTextField.swift
//  Broadcast
//
//  Created by Piotr Suwara on 24/12/20.
//

import UIKit
import SwiftRichString

class LoginTextField: UITextField {
    static func standard(withPlaceholder placeholder: LocalizedString) -> LoginTextField {
        let textField = LoginTextField()
        textField.borderStyle = .roundedRect
        textField.attributedPlaceholder = placeholder.localized.set(style: Style.body).set(style: Style.lightGrey)
        textField.height(43)
        return textField

    }

    static func secure(withPlaceholder placeholder: LocalizedString) -> LoginTextField {
        let textField = standard(withPlaceholder: placeholder)
        textField.isSecureTextEntry = true
        return textField
    }
}
