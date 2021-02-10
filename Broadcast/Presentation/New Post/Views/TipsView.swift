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
    private let topStackView = UIStackView()
    private let tipsStackView = UIStackView()
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
        TipData(image: UIImage.iconPortrait,
                title: LocalizedString.tip1Title,
                description: LocalizedString.tip1SubTitle),
        TipData(image: UIImage.iconSimpleSun,
                title: LocalizedString.tip2Title,
                description: LocalizedString.tip2SubTitle),
        TipData(image: UIImage.iconSmile,
                title: LocalizedString.tip3Title,
                description: LocalizedString.tip3SubTitle),
        TipData(image: UIImage.iconWifi,
                title: LocalizedString.tip4Title,
                description: LocalizedString.tip4SubTitle),
        TipData(image: UIImage.iconThumbUp,
                title: LocalizedString.tip5Title,
                description: LocalizedString.tip5SubTitle),
        TipData(image: UIImage.iconHelpCricle,
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
        
        topStackView.axis = .vertical
        topStackView.alignment = .center
        topStackView.translatesAutoresizingMaskIntoConstraints = false
        
        tipsStackView.axis = .vertical
        tipsStackView.alignment = .center
        tipsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.backgroundColor = .darkGrey
        containerView.roundedCorners()
        
        closeButton.setTitleColor(.primaryLightGrey, for: .normal)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureLayout() {
        addSubview(containerView)
        containerView.addSubview(scrollView)
        containerView.edgesToSuperview(insets:
                                        TinyEdgeInsets(top: 32,
                                                       left: 48,
                                                       bottom: 32,
                                                       right: 48))
        containerView.addSubview(topStackView)
        topStackView.topToSuperview(offset: 32)
        topStackView.edgesToSuperview(excluding: [.top, .bottom])
        scrollView.topToBottom(of: topStackView)
        scrollView.edgesToSuperview(excluding: .top, insets:
                                        TinyEdgeInsets(top: 32,
                                                       left: 24,
                                                       bottom: 62,
                                                       right: 24))
        scrollView.addSubview(tipsStackView)
        
        tipsStackView.topToSuperview()
        tipsStackView.widthToSuperview()
        
        topStackView.addArrangedSubview(subTitleLabel)
        topStackView.addArrangedSubview(titleLabel)
        
        tipsStackView.addSpace(16)
        tipData.forEach { tipData in
            tipsStackView.addSpace(30)
            
            let view = UIView()
            let imageView = UIImageView(image: tipData.image?.withTintColor(.white))
            view.addSubview(imageView)
            imageView.centerInSuperview()
            imageView.height(25)
            imageView.aspectRatio(1)
            
            imageView.contentMode = .scaleAspectFill
            view.height(40)
            view.aspectRatio(1)
            view.backgroundColor = .primaryRed
            view.clipsToBounds = true
            view.layer.cornerRadius = 20
            
            tipsStackView.addArrangedSubview(view)
            tipsStackView.addSpace(4)
            let titleLabel = UILabel.largeBodyBold(tipData.title, textColor: .white)
            titleLabel.height(24)
            tipsStackView.addArrangedSubview(titleLabel)
            
            let descriptionLabel = UILabel.smallBody(tipData.description, textColor: .white)
            descriptionLabel.numberOfLines = 0
            descriptionLabel.lineBreakMode = .byWordWrapping
            
            tipsStackView.addArrangedSubview(descriptionLabel)
        }
        
        tipsStackView.addSpace(30)
        
        containerView.addSubview(closeButton)
        
        closeButton.centerXToSuperview()
        closeButton.bottomToSuperview(offset: -16)
        closeButton.width(66)
        closeButton.height(30)
        
        print("INIT STACK VIEW")
        print(tipsStackView.frame.size)
        print(tipsStackView.intrinsicContentSize)
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        scrollView.contentSize = tipsStackView.frame.size
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
