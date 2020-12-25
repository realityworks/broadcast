//
//  UIButton+Styling.swift
//  Broadcast
//
//  Created by Piotr Suwara on 19/11/20.
//

import UIKit
import TinyConstraints

extension UIButton {
    
    static func standard(withTitle title: String? = nil) -> UIButton {
        let button = UIButton()
        
        button.setBackgroundColor(.primaryRed, for: .normal)
        button.setBackgroundColor(UIColor.primaryRed.withAlphaComponent(0.5), for: .disabled)
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
    
    static func smallText(withTitle title: String? = nil) -> UIButton {
        let button = UIButton()
        
        button.setTitleColor(.blue, for: .normal)
        button.setTitleColor(.black, for: .highlighted)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.body
        
        return button
    }
    
    static func smallText(withTitle title: LocalizedString? = nil) -> UIButton {
        return UIButton.smallText(withTitle: title?.localized)
    }
}

