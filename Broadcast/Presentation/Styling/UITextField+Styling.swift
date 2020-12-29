//
//  UITextField+Styling.swift
//  Broadcast
//
//  Created by Piotr Suwara on 24/11/20.
//

import UIKit

extension UITextField {
    static func standard(withPlaceholder placeholder: LocalizedString = .none) -> UITextField {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = placeholder.localized
        textField.height(50)
        textField.font = .body
        return textField
    }
}
