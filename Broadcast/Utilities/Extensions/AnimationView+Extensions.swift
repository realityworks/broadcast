//
//  AnimationView+Extensions.swift
//  Broadcast
//
//  Created by Piotr Suwara on 24/12/20.
//

import UIKit
import Lottie

extension AnimationView {
    convenience init(animationAsset: AnimationAsset) {
        self.init(name: animationAsset.rawValue)
    }
}
