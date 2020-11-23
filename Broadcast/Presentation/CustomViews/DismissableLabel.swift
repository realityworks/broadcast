//
//  DismissableLabel.swift
//  Broadcast
//
//  Created by Piotr Suwara on 23/11/20.
//

import UIKit

class DimissableLabel : UIView {
    
    private let cancelButton = UIButton()
    private let textLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureViews()
    }
    
    private func configureViews() {
        
    }
}
