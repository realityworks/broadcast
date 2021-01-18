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
    
    private let verticalStackView = UIStackView()
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
        verticalStackView.axis = .vertical
        verticalStackView.alignment = .center
        
        addSubview(verticalStackView)
        verticalStackView.width(200)
        verticalStackView.centerInSuperview()
        
        verticalStackView.addArrangedSubview(processingAnimation)
        
        processingAnimation.height(180)
        processingAnimation.width(200)
        processingAnimation.contentMode = .scaleAspectFill
        //processingAnimation.layoutIfNeeded()
        
        verticalStackView.addArrangedSubview(processingLabel)
        
        processingAnimation.loopMode = .loop
        processingAnimation.backgroundBehavior = .pauseAndRestore
        
        backgroundColor = .clear
    }
}
