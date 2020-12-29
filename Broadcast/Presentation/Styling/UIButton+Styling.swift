//
//  UIButton+Styling.swift
//  Broadcast
//
//  Created by Piotr Suwara on 19/11/20.
//

import UIKit
import TinyConstraints

extension UIButton {
    
    static func standard(withTitle title: String?) -> UIButton {
        let button = UIButton()
        
        button.setBackgroundColor(.primaryRed, for: .normal)
        button.setBackgroundColor(UIColor.secondaryLightGrey, for: .disabled)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 24
        button.height(48)
        button.titleLabel?.font = UIFont.bodyBold
        button.setTitle(title, for: .normal)
        button.clipsToBounds = true
        
        return button
    }
    
    static func standard(withTitle title: LocalizedString? = nil) -> UIButton {
        return UIButton.standard(withTitle: title?.localized)
    }
    
    static func text(withTitle title: String?) -> UIButton {
        let button = UIButton()
        
        button.setTitleColor(.primaryBlack, for: .normal)
        button.setTitleColor(.primaryGrey, for: .highlighted)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.body
        
        return button
    }
    
    static func text(withTitle title: LocalizedString? = nil) -> UIButton {
        return UIButton.text(withTitle: title?.localized)
    }
    
    static func textDestructive(withTitle title: LocalizedString? = nil) -> UIButton {
        let button = UIButton.text(withTitle: title?.localized)
        button.setTitleColor(.primaryRed, for: .normal)
        button.titleLabel?.font = UIFont.bodyBold
        return button
    }
}

