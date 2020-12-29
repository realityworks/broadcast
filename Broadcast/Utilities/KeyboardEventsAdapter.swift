//
//  KeyboardEventsAdapter.swift
//  Broadcast
//
//  Created by Piotr Suwara on 17/11/20.
//

import UIKit

/// Protocol definition that provides the functionality
/// to listen to keyboard events that an object will
/// need to respond to accordingly.
protocol KeyboardEventsAdapter: NSObjectProtocol {
    func registerForKeyboardEvents()
    func unregisterForKeyboardEvents()
    var dismissKeyboardGestureRecognizer: UIGestureRecognizer { get }
}

extension KeyboardEventsAdapter where Self: UIViewController {
    /// Begin listening to keyboard notifications and add a gesture recognizer
    /// to handle the dismissing of the keyboard.
    func registerForKeyboardEvents() {
        let defaultCenter = NotificationCenter.default

        var observerShow: NSObjectProtocol!
        observerShow = defaultCenter.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { [weak self] notification in
            guard let self = self else {
                defaultCenter.removeObserver(observerShow as Any)
                return
            }
            self.keyboardWillShow(notification: notification as NSNotification)
        }

        var observerHide: NSObjectProtocol!
        observerHide = defaultCenter.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { [weak self] notification in
            guard let self = self else {
                defaultCenter.removeObserver(observerHide as Any)
                return
            }
            self.keyboardWillHide(notification: notification as NSNotification)
        }

        var observerChange: NSObjectProtocol!
        observerChange = defaultCenter.addObserver(forName: UIResponder.keyboardWillChangeFrameNotification, object: nil, queue: .main) { [weak self] notification in
            guard let self = self else {
                defaultCenter.removeObserver(observerChange as Any)
                return
            }

            self.keyboardWillChange(notification: notification as NSNotification)
        }

        view.addGestureRecognizer(dismissKeyboardGestureRecognizer)
        
        // UIControl subclasses have issues with this enabled by default
        // Should have always been set to false when initialised
        dismissKeyboardGestureRecognizer.isEnabled = false
    }
    
    /// Remove the gesture recognizer and remove the notification center listener
    func unregisterForKeyboardEvents() {
        view.removeGestureRecognizer(dismissKeyboardGestureRecognizer)
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Keyboard Notifications
    
    /// Handler function for when the keyboard will appear.
    /// - Parameter notification: The notification that signalled the keyboard appearance.
    func keyboardWillShow(notification: NSNotification) {
        let userInfo = notification.userInfo!
        let keyboardHeight = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
        let animationDuration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let animationCurve = (userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as! NSNumber).uintValue
        
        let offsetHeight = tabBarController?.tabBar.frame.height ?? 0
        let edgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight - offsetHeight, right: 0)
        additionalSafeAreaInsets = edgeInsets
        
        UIView.animate(withDuration: animationDuration, delay: 0, options: UIView.AnimationOptions(rawValue: animationCurve), animations: {
            self.view.layoutIfNeeded()
            return
        }, completion: { _ in
            self.dismissKeyboardGestureRecognizer.isEnabled = true
        })
    }
    
    /// Handler function for when the keyboard will dissappear.
    /// - Parameter notification: The notification that signalled the keyboard appearance.
    func keyboardWillHide(notification: NSNotification) {
        let userInfo = notification.userInfo!
        let animationDuration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let animationCurve = (userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as! NSNumber).uintValue

        let edgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        additionalSafeAreaInsets = edgeInsets
        
        UIView.animate(withDuration: animationDuration, delay: 0, options: UIView.AnimationOptions(rawValue: animationCurve), animations: {
            self.view.layoutIfNeeded()
            return
        }, completion: { _ in
            self.dismissKeyboardGestureRecognizer.isEnabled = false
        })
    }

    func keyboardWillChange(notification: NSNotification) {
        let userInfo = notification.userInfo!
        let keyboardHeight = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
        let animationDuration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let animationCurve = (userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as! NSNumber).uintValue

        additionalSafeAreaInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)

        UIView.animate(withDuration: animationDuration, delay: 0, options: UIView.AnimationOptions(rawValue: animationCurve), animations: {
            self.view.layoutIfNeeded()
            return
        })
    }
}


