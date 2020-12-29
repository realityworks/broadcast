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
                             textColor: UIColor = .secondaryBlack) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = font
        label.textColor = textColor
        return label
    }
    
    static func body(_ text: LocalizedString = .none, textColor: UIColor = .text) -> UILabel {
        return Self.text(text.localized, textColor: textColor)
    }
    
    static func largeTitle(_ text: LocalizedString = .none, textColor: UIColor = .text) -> UILabel {
        return Self.text(text.localized, font: .largeTitle, textColor: textColor)
    }
    
    static func extraLargeTitle(_ text: LocalizedString = .none, textColor: UIColor = .text) -> UILabel {
        return Self.text(text.localized, font: .extraLargeTitle, textColor: textColor)
    }
    
    static func subTitle(_ text: LocalizedString = .none, textColor: UIColor = .text) -> UILabel {
        return Self.text(text.localized, font: .largeTitle, textColor: textColor)
    }
    
    static func bodyBold(_ text: LocalizedString = .none, textColor: UIColor = .text) -> UILabel {
        return Self.text(text.localized, font: .bodyBold, textColor: textColor)
    }
    
    static func lightGreySmallBody(_ text: LocalizedString = .none) -> UILabel {
        return Self.text(text.localized, font: .smallBody, textColor: .primaryLightGrey)
    }
    
    static func tinyBody(_ text: LocalizedString = .none) -> UILabel {
        return Self.text(text.localized, font: .tinyBody)
    }
    
    static func largeBodyBold(_ text: LocalizedString = .none) -> UILabel {
        return Self.text(text.localized, font: .largeBodyBold)
    }
    
    static func smallBody(_ text: LocalizedString = .none) -> UILabel {
        return Self.text(text.localized, font: .smallBody)
    }
}
