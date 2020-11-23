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
    func addSpace(height: CGFloat,
                  color: UIColor = .clear,
                  relation: TinyConstraints.ConstraintRelation = .equal,
                  priority: LayoutPriority = .required) -> UIView {
        let spaceView: UIView = UIView()
        addSubview(spaceView)
        
        spaceView.backgroundColor = color
        spaceView.height(height, relation: relation, priority: priority)
    }
}
