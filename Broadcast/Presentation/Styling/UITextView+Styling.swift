//
//  UITextView+Styling.swift
//  Broadcast
//
//  Created by Piotr Suwara on 8/12/20.
//

import UIKit
import SwiftRichString
import RSKPlaceholderTextView

extension UITextView {
    static func staticText() -> UITextView {
        let textView = UITextView()
        textView.tintColor = .primaryGrey
        textView.isEditable = false
        textView.isScrollEnabled = false
        return textView
    }
    
    static func standard(withPlaceholder placeholder: LocalizedString? = nil) -> UITextView {
        let textView = RSKPlaceholderTextView()
        
        textView.attributedPlaceholder = placeholder?.localized.set(style: Style.body).set(style: Style.lightGrey)
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.textFieldBorder.cgColor
        textView.layer.cornerRadius = 5
        textView.textContainerInset = UIEdgeInsets(top: 16, left: 12, bottom: 16, right: 16)
        
        textView.font = .body
        
        return textView
    }
    
    var placeholder: String? {
        get {
            if let textView = self as? RSKPlaceholderTextView {
                return textView.attributedPlaceholder?.string
            }
            return nil
        }
        
        set {
            if let textView = self as? RSKPlaceholderTextView {
                textView.attributedPlaceholder = newValue?.set(style: Style.body).set(style: Style.lightGrey)
            }
        }
    }
}
