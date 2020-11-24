//
//  UIButton+Styling.swift
//  Broadcast
//
//  Created by Piotr Suwara on 19/11/20.
//

import UIKit
import TinyConstraints

extension UIButton {
    static func loginButton() -> UIButton {
        let button = UIButton()
        
        button.backgroundColor = .blue
        button.setTitleColor(.white, for: .normal)
        button.height(80)
        button.layer.cornerRadius = 25
        button.setTitle("LOGIN", for: .normal)
        
        return button
    }
}

