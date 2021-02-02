//
//  UIView+Styling.swift
//  Broadcast
//
//  Created by Piotr Suwara on 28/1/21.
//

import UIKit

extension UIView {
    func roundedCorners(withCornerRadius cornerRadius: CGFloat = 16,
                        clipsToBounds: Bool = false) {
        layer.cornerRadius = cornerRadius
        self.clipsToBounds = clipsToBounds
    }
    
    func dropShadow() {
        layer.shadowOffset = CGSize(width: 0, height: 2.5)
        layer.shadowRadius = 5
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 0.5
    }
}

