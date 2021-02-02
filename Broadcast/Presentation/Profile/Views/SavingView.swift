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
        
        processingAnimation.loopMode = .loop
        processingAnimation.play()
    }
    
    private func layoutViews() {
        addSubview(containerStackView)
        containerStackView.edgesToSuperview()
        
        containerStackView.addArrangedSubview(processingAnimation)
        containerStackView.addArrangedSubview(titleLabel)
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
