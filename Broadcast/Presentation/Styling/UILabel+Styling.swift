//
//  UILabel+Styling.swift
//  Broadcast
//
//  Created by Piotr Suwara on 26/11/20.
//

import UIKit

extension UILabel {
    static func postTitle(_ title: String) -> UILabel {
        let label = UILabel()
        label.text = title
        label.font = .postTitle
        return label
    }
}
