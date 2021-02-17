//
//  ProcessingView.swift
//  Broadcast
//
//  Created by Piotr Suwara on 26/11/20.
//

import UIKit
import Lottie

/// Animating view that is displayed when something is processing.
/// Processing circle and animation speed define how the processing works.
class ProcessingView : UIView {
    
    var animating: Bool = false {
        didSet {
            if animating {
                processingAnimation.play()
            } else {
                processingAnimation.pause()
            }
        }
    }
    
    private let processingAnimation = AnimationView(animationAsset: .processing)
    private let processingLabel = UILabel.smallBody(LocalizedString.processing, textColor: .white)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Place and layout views
    private func configureViews() {
        addSubview(processingAnimation)
        processingAnimation.centerXToSuperview()
        processingAnimation.centerYToSuperview(offset: -36)
        processingAnimation.contentMode = .scaleAspectFill
        
        addSubview(processingLabel)
        processingLabel.textAlignment = .center
        processingLabel.numberOfLines = 0
        processingLabel.lineBreakMode = .byWordWrapping
        processingLabel.topToBottom(of: processingAnimation, offset: -16)
        processingLabel.centerXToSuperview()
        processingLabel.width(200)
        
        processingAnimation.loopMode = .loop
        processingAnimation.backgroundBehavior = .pauseAndRestore
        
        backgroundColor = .clear
    }
}
