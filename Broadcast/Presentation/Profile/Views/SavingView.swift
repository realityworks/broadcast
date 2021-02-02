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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViews() {
        roundedCorners(withCornerRadius: 8)
        backgroundColor = .primaryRed
        
        containerStackView.axis = .horizontal
        containerStackView.alignment = .center
        containerStackView.distribution = .equalCentering
        
        processingAnimation.loopMode = .loop
        processingAnimation.play()
    }
    
    private func layoutViews() {
        addSubview(containerStackView)
        containerStackView.edgesToSuperview()
        
        containerStackView.addArrangedSubview(processingAnimation)
        containerStackView.addArrangedSubview(titleLabel)
    }
}
