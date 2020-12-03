//
//  UILabel+Styling.swift
//  Broadcast
//
//  Created by Piotr Suwara on 26/11/20.
//

import UIKit

extension UILabel {
    private static func text(_ text: String? = nil,
                             font: UIFont = .body,
                             textColor: UIColor = .black) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = font
        label.textColor = textColor
        return label
    }
    
    static func body(_ text: LocalizedString) -> UILabel {
        return Self.text(text.localized)
    }
    
    static func largeTitle(_ text: LocalizedString) -> UILabel {
        return Self.text(text.localized, font: .largeTitle, textColor: .blue)
    }
    
    static func bodyBold(_ text: LocalizedString = ) -> UILabel {
        return Self.text(text.localized, font: .bodyBold)
    }
}
