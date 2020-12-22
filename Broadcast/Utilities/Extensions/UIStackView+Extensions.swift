//
//  UIStackView+Extensions.swift
//  Broadcast
//
//  Created by Piotr Suwara on 23/11/20.
//

import UIKit
import TinyConstraints

extension UIStackView {
    @discardableResult
    func addSpace(_ space: CGFloat,
                  color: UIColor = .clear,
                  relation: TinyConstraints.ConstraintRelation = .equal,
                  priority: LayoutPriority = .required) -> UIView {
        
        let spaceView: UIView = UIView()
        addArrangedSubview(spaceView)
        
        spaceView.backgroundColor = color
        
        if axis == .horizontal {
            spaceView.width(space, relation: relation, priority: priority)
        } else {
            spaceView.height(space, relation: relation, priority: priority)
        }
        
        return spaceView
    }
    
    @discardableResult
    func addSeparator(withColor color: UIColor) {
        addSpace(1, color: color)
    }
}
