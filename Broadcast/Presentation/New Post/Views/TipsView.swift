//
//  TipsView.swift
//  Broadcast
//
//  Created by Piotr Suwara on 29/12/20.
//

import UIKit
import RxSwift
import RxCocoa
import TinyConstraints

class TipsView : UIView {
    
    // MARK: UI Components
    
    private let verticalStackView = UIStackView()
    private let subTitleLabel = UILabel.bodyBold(LocalizedString.hotTips, textColor: UIColor.white)
    private let titleLabel = UILabel.extraLargeTitle(LocalizedString.greatContent, textColor: UIColor.white)
    private let scrollView = UIScrollView()
    private let containerView = UIView()
    let closeButton = UIButton.text(withTitle: LocalizedString.close)
    
    struct TipData {
        let image: UIImage?
        let title: LocalizedString
        let description: LocalizedString
    }
    
    let tipData: [TipData] = [
        TipData(image: UIImage.iconCustomPortraitMode,
                title: LocalizedString.tip1Title,
                description: LocalizedString.tip1SubTitle),
        TipData(image: UIImage.iconCustomPortraitMode,
                title: LocalizedString.tip2Title,
                description: LocalizedString.tip2SubTitle),
        TipData(image: UIImage.iconCustomPortraitMode,
                title: LocalizedString.tip3Title,
                description: LocalizedString.tip3SubTitle),
        TipData(image: UIImage.iconCustomPortraitMode,
                title: LocalizedString.tip4Title,
                description: LocalizedString.tip4SubTitle),
        TipData(image: UIImage.iconCustomPortraitMode,
                title: LocalizedString.tip5Title,
                description: LocalizedString.tip5SubTitle),
        TipData(image: UIImage.iconCustomPortraitMode,
                title: LocalizedString.tip6Title,
                description: LocalizedString.tip6SubTitle)

    ]
    
    init() {
        super.init(frame: .zero)
        
        configureView()
        configureLayout()
    }
    
    private func configureView() {
        backgroundColor = UIColor.darkGrey.withAlphaComponent(0.94)
        
        verticalStackView.axis = .vertical
        verticalStackView.alignment = .center
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.backgroundColor = .darkGrey
        containerView.roundedCorners()
        
        closeButton.setTitleColor(.primaryLightGrey, for: .normal)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureLayout() {
        addSubview(containerView)
        containerView.addSubview(scrollView)
        
        containerView.width(315)
        containerView.centerInSuperview()
        
        scrollView.edgesToSuperview(insets:
                                        TinyEdgeInsets(top: 32,
                                                       left: 24,
                                                       bottom: 62,
                                                       right: 24))
        verticalStackView.edgesToSuperview(excluding: .bottom)
        
        verticalStackView.addArrangedSubview(subTitleLabel)
        verticalStackView.addArrangedSubview(titleLabel)
        verticalStackView.addSpace(16)
        tipData.forEach { tipData in
            verticalStackView.addSpace(30)
            verticalStackView.addArrangedSubview(UIImageView(image: tipData.image))
            verticalStackView.addSpace(4)
            let titleLabel = UILabel.largeBodyBold(tipData.title, textColor: .white)
            titleLabel.height(24)
            verticalStackView.addArrangedSubview(titleLabel)
            
            let descriptionLabel = UILabel.smallBody(tipData.description, textColor: .white)
            descriptionLabel.numberOfLines = 0
            descriptionLabel.lineBreakMode = .byWordWrapping
            
            verticalStackView.addArrangedSubview(descriptionLabel)
        }
        
        verticalStackView.addSpace(30)
        
        containerView.addSubview(closeButton)
        
        closeButton.centerXToSuperview()
        closeButton.bottomToSuperview()
        closeButton.width(66)
        closeButton.height(30)
        
        //scrollView.contentSize = verticalStackView.frame.size
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
