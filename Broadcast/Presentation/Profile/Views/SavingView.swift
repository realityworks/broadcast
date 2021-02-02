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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
        layoutViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViews() {
        roundedCorners(withCornerRadius: 8)
        backgroundColor = .primaryRed
        
        containerStackView.axis = .horizontal
        //containerStackView.alignment = .center
        containerStackView.distribution = .fill
        
        processingAnimation.loopMode = .loop
        processingAnimation.contentMode = .scaleAspectFill
        processingAnimation.contentScaleFactor = 4
        processingAnimation.play()
        
        titleLabel.textAlignment = .left
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
    }
}
