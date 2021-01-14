//
//  InsetTextField.swift
//  Broadcast
//
//  Created by Piotr Suwara on 29/12/20.
//

import UIKit

/// UITextField instantiation that supports custom edge insets
final class InsetTextField: UITextField {
    var insets: UIEdgeInsets {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    init(insets: UIEdgeInsets) {
        self.insets = insets
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return super.textRect(forBounds: bounds.inset(by: insets))
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return super.editingRect(forBounds: bounds.inset(by: insets))
    }
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.minX+10, y: 10, width: 25, height: bounds.height-20)
    }
}

// MARK: - Factory instance methods

extension UITextField {
    static func textFieldWith(insets: UIEdgeInsets) -> UITextField {
        return InsetTextField(insets: insets)
    }
}
