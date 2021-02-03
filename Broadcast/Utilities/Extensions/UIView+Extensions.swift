//
//  UIView+Extensions.swift
//  Broadcast
//
//  Created by Piotr Suwara on 28/1/21.
//

import UIKit

extension UIView {
    func addTopSeparator(withColor: UIColor = .customSeparator) {
        let view = UIView()
        addSubview(view)
        view.backgroundColor = .customSeparator
        view.edgesToSuperview(excluding: .bottom)
        view.height(1)
    }
    
    func addBottomSeparator(withColor: UIColor = .customSeparator) {
        let view = UIView()
        addSubview(view)
        view.backgroundColor = .customSeparator
        view.edgesToSuperview(excluding: .top)
        view.height(1)
    }
}

