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
    #warning("TODO - Create a nice rotating view")
    
    let verticalStackView = UIStackView()
    let processingAnimation = AnimationView(animationAsset: .processing)
    let processingLabel = UILabel.extraLargeTitle(LocalizedString.processing, textColor: .white)
    
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
//        verticalStackView.edgesToSuperview()
        verticalStackView.width(200)
        verticalStackView.height(150)
        verticalStackView.centerInSuperview()
        
        verticalStackView.addArrangedSubview(processingAnimation)
        verticalStackView.addArrangedSubview(processingLabel)
        
        processingLabel.text = "PROCESSING"
        processingAnimation.loopMode = .loop
        
        backgroundColor = .clear
    }
    
    func startAnimating() {
        processingAnimation.play()
    }
}
