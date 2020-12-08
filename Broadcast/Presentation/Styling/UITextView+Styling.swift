//
//  UITextView+Styling.swift
//  Broadcast
//
//  Created by Piotr Suwara on 8/12/20.
//

import UIKit

extension UITextView {
    static func standard(withPlaceholder placeholder: LocalizedString? = nil) -> UITextView {
        let textView = UITextView()
        textView.layer.cornerRadius = 5
        textView.layer.borderColor = UIColor.gray.cgColor
        textView.layer.borderWidth = 1
        textView.font = .body
        return textView
    }
}
