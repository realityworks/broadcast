//
//  SavingView.swift
//  Broadcast
//
//  Created by Piotr Suwara on 2/2/21.
//

import UIKit
import Lottie

class SavingView: UIView {
    
    private let containerStackView = UIStackView()
    private let titleLabel = UILabel.largeTitle(LocalizedString.saving,
                                                textColor: .white)
    private let processingAnimation = AnimationView(animationAsset: .processing)
    private let successAnimation = AnimationView(animationAsset: .success)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
        layoutViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViews() {
        roundedCorners(withCornerRadius: 8, clipsToBounds: false)
        dropShadow()
        
        backgroundColor = .primaryRed
        
        containerStackView.axis = .horizontal
        containerStackView.distribution = .fill
        
        processingAnimation.loopMode = .loop
        processingAnimation.contentMode = .scaleAspectFill
        processingAnimation.contentScaleFactor = 4
        processingAnimation.play()
        
        titleLabel.textAlignment = .left
        
        successAnimation.animationSpeed = 2
        successAnimation.loopMode = .playOnce
    }
    
    private func layoutViews() {
        width(172)
        height(62)
        
        addSubview(containerStackView)
        containerStackView.centerXToSuperview()
        containerStackView.heightToSuperview()
        
        containerStackView.addArrangedSubview(processingAnimation)
        processingAnimation.width(60)
        
        containerStackView.addArrangedSubview(titleLabel)
        titleLabel.width(80)
        
        addSubview(successAnimation)
        successAnimation.edgesToSuperview()
        successAnimation.isHidden = true
        successAnimation.currentFrame = 0
        successAnimation.stop()
    }
    
    func showFinished() {
        successAnimation.isHidden = false
        
        successAnimation.currentFrame = 0
        successAnimation.play()
        
        UIView.animate(withDuration: TimeInterval(0.5)) { [weak self] in
            guard let self = self else { return }
            self.containerStackView.alpha = 0
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) { [weak self] in
            guard let self = self else { return }
            
            self.successAnimation.isHidden = true
            self.containerStackView.alpha = 1
        }
    }
}
