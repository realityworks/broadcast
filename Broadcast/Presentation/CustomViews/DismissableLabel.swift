//
//  DismissableLabel.swift
//  Broadcast
//
//  Created by Piotr Suwara on 23/11/20.
//

import UIKit

class DismissableLabel : UIView {
    
    private let cancelButton = UIButton()
    private let textLabel = UILabel()
    
    convenience init(text: String,
                     backgroundColor: UIColor) {
        self.init(frame: .zero)
        configureViews()
        
        self.textLabel.text = text
        self.backgroundColor = backgroundColor
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureViews()
    }
    
    private func configureViews() {
        // Add the views and response
        addSubview(cancelButton)
        addSubview(textLabel)
        
        // Setup the layout of the views
    }
}
