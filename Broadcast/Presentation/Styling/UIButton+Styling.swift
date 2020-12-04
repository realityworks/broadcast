//
//  UIButton+Styling.swift
//  Broadcast
//
//  Created by Piotr Suwara on 19/11/20.
//

import UIKit
import TinyConstraints

extension UIButton {
    static func standard(withTitle title: LocalizedString) -> UIButton {
        let button = UIButton()
        
        button.setBackgroundColor(.blue, for: .normal)
        button.setBackgroundColor(UIColor.blue.withAlphaComponent(0.5), for: .disabled)
        button.setTitleColor(.white, for: .normal)
        button.height(50)
        button.layer.cornerRadius = 12
        button.setTitle(title.localized, for: .normal)
        button.clipsToBounds = true
        
        return button
    }
    
    static func smallText(withTitle title: LocalizedString) -> UIButton {
        let button = UIButton()
        
        button.setTitleColor(.blue, for: .normal)
        button.setTitleColor(.black, for: .highlighted)
        button.setTitle(title.localized, for: .normal)
        button.titleLabel?.font = UIFont.body
        button.height(25)
        
        return button
    }
}

