//
//  UIButton+Styling.swift
//  Broadcast
//
//  Created by Piotr Suwara on 19/11/20.
//

import UIKit
import TinyConstraints

extension UIButton {
    static func loginButton(withTitle title: String) -> UIButton {
        let button = UIButton()
        
        button.backgroundColor = .blue
        button.setTitleColor(.white, for: .normal)
        button.height(50)
        button.layer.cornerRadius = 12
        button.setTitle(title, for: .normal)
        
        return button
    }
}

