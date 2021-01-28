//
//  UIView+Styling.swift
//  Broadcast
//
//  Created by Piotr Suwara on 28/1/21.
//

import UIKit

extension UIView {
    func roundedCorners(withCornerRadius cornerRadius: CGFloat = 16) {
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
    }
}

