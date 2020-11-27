//
//  UILabel+Styling.swift
//  Broadcast
//
//  Created by Piotr Suwara on 26/11/20.
//

import UIKit

extension UILabel {
    static func largeTitle(_ title: String? = nil) -> UILabel {
        let label = UILabel()
        label.text = title
        label.font = .largeTitle
        label.textColor = .blue
        return label
    }
    
    static func body(_ text: String? = nil) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .body
        label.textColor = .black
        return label
    }
}
