//
//  UIApplication+Extensions.swift
//  Broadcast
//
//  Created by Piotr Suwara on 22/1/21.
//

import UIKit

extension UIApplication {
    
    /// Shows a Text popup as an error, with selection options and a call back
    /// - Parameters:
    ///   - withMesssage: Message for the error popup
    ///   - options: Button option selection
    ///   - completed: <#completed description#>
    func showError(withMessage: String,
                   options: [TextPopup.Option],// Todo
                   completed: ((Int)->())? = nil) {
        guard let appDelegate = self.delegate as? AppDelegate else { return }
        
        if let view = appDelegate.window?.rootViewController?.view {
            let textPopup = TextPopup()
            textPopup.titleLabel.text = LocalizedString.error.localized
            view.addSubview()
        }
    }
    
    func
}
