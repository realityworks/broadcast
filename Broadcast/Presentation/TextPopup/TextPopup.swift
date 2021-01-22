//
//  TextPopup.swift
//  Broadcast
//
//  Created by Piotr Suwara on 25/12/20.
//

import UIKit
import RxSwift
import RxCocoa
import TinyConstraints

class TextPopup : UIView {
    
    // MARK: UI Components
    private let verticalStackView = UIStackView()
    private let containerView = UIView()
    let button = UIButton.standard()
    let titleLabel = UILabel.largeTitle()
    let descriptionLabel = UILabel.body()
    
    init() {
        super.init(frame: .zero)
        
        configureView()
        configureLayout()
    }
    
    private func configureView() {
        backgroundColor = UIColor.darkGrey.withAlphaComponent(0.94)
        
        verticalStackView.axis = .vertical
        verticalStackView.alignment = .leading
        
        containerView.backgroundColor = .darkGrey
        containerView.layer.cornerRadius = 16
                
        titleLabel.textColor = .primaryWhite
        descriptionLabel.textColor = .primaryWhite
        
        descriptionLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.numberOfLines = 0
    }
    
    private func configureLayout() {
        addSubview(containerView)
        containerView.addSubview(verticalStackView)
        
        containerView.width(315)
        containerView.centerInSuperview()
        
        verticalStackView.edgesToSuperview(insets: TinyEdgeInsets(top: 32, left: 24, bottom: 32, right: 24))
        
        verticalStackView.addArrangedSubview(titleLabel)
        verticalStackView.addSpace(16)
        verticalStackView.addArrangedSubview(descriptionLabel)
        verticalStackView.addSpace(32)
        verticalStackView.addArrangedSubview(button)
        button.edges(to: verticalStackView, excluding: [.bottom, .top])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension Reactive where Base: TextPopup {
    /// Reactive wrapper for `Button Title Text` property.
    var buttonTitle: Binder<String?> {
        return base.button.rx.title()
    }
    
    /// Reactive wrapper for `Title Text` property.
    var titleText: Binder<String?> {
        return base.titleLabel.rx.text
    }
    
    /// Reactive wrapper for `Description Text` property.
    var descriptionText: Binder<String?> {
        return base.descriptionLabel.rx.text
    }
}
