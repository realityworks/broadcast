//
//  UIApplication+Extensions.swift
//  Broadcast
//
//  Created by Piotr Suwara on 22/1/21.
//

import UIKit

extension UIApplication {
    
    /// Present the error object in a text popup
    /// - Parameter error: An object conforming to the error protocol
    open func showError(_ error: Error) {
        showError(withMessage: BoomdayError.errorString(from: error))
    }
    
    /// Shows a Text popup as an error, with selection options and a call back
    /// - Parameters:
    ///   - withMesssage: Message for the error popup
    ///   - options: Button option selection
    ///   - completed: Callback handler when a specified button is pressed
    fileprivate func showError(withMessage: String,
                   options: [TextPopup.Option] = [],// Todo
                   completed: ((Int)->())? = nil) {
        guard let appDelegate = self.delegate as? AppDelegate else { return }
        
        if let view = appDelegate.window?.rootViewController?.view {
            let textPopup = TextPopup()
            
            textPopup.titleLabel.text = LocalizedString.error.localized
        
            #warning("Temp until we implement the options correctly")
            textPopup.button.setTitle(LocalizedString.tryAgain, for: .normal)
            
            view.addSubview(textPopup)
            
            // Close the button
            textPopup.button.addTarget(textPopup,
                                       action: #selector(TextPopup.textPopupButtonPressed),
                                       for: .touchUpInside)
        }
    }
}
