//
//  UIButton+Extensions.swift
//  Broadcast
//
//  Created by Piotr Suwara on 25/11/20.
//

import UIKit

extension UIButton {
    /// Set the background color of the button image for a specific state.
    /// Internally this function creates an image from the color to apply as a background image
    /// - Parameters:
    ///   - color: Color supplied for the state
    ///   - state: Background for a `UIControl.State` will be set to the specified color
    public func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        setBackgroundImage(UIImage(color: color), for: state)
    }
    
    public func setTitle(_ title: LocalizedString, for state: UIControl.State) {
        setTitle(title.localized, for: state)
    }
}
