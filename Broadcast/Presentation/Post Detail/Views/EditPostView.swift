//
//  EditPostView.swift
//  Broadcast
//
//  Created by Piotr Suwara on 8/12/20.
//

import UIKit
import RxSwift
import RxCocoa
import SwiftRichString

class EditPostView: UIView {
    let verticalStackView = UIStackView()
    let titleTextField = UITextField.standard(withPlaceholder: LocalizedString.postDescription, insets: .left(16))
    let captionTextView = UITextView.standard(withPlaceholder: LocalizedString.captionDescription)
    let submitButton = UIButton.standard(withTitle: LocalizedString.submitPost)
    
    private let titleHeading = UILabel.lightGreySmallBody(LocalizedString.postTitle)
    private let captionHeading = UILabel.lightGreySmallBody(LocalizedString.captionTitle)
    
    init() {
        super.init(frame: .zero)

        configureView()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        verticalStackView.axis = .vertical
        verticalStackView.spacing = 10
        verticalStackView.alignment = .leading
        verticalStackView.distribution = .equalSpacing
        
        submitButton.setImage(UIImage.iconRadio?.withTintColor(.white), for: .normal)
        submitButton.setImage(UIImage.iconRadio?.withTintColor(.secondaryBlack), for: .disabled)
                
        submitButton.imageEdgeInsets = .right(10)
    }
    
    private func configureLayout() {
        addSubview(verticalStackView)
        
        verticalStackView.topToSuperview()
        verticalStackView.widthToSuperview()

        verticalStackView.addArrangedSubview(titleHeading)
        verticalStackView.addArrangedSubview(titleTextField)
        
        verticalStackView.addArrangedSubview(captionHeading)
        verticalStackView.addArrangedSubview(captionTextView)
        verticalStackView.addSpace(10)
        verticalStackView.addArrangedSubview(submitButton)
        
        submitButton.widthToSuperview()
        titleTextField.widthToSuperview()
        
        captionTextView.height(100)
        captionTextView.widthToSuperview()
    }
    
    func configure(withUploadTitle buttonTitle: LocalizedString) {
        submitButton.setTitle(buttonTitle.localized, for: .normal)
    }
}

// MARK: Reactive Extensions

extension Reactive where Base : EditPostView {
    
    var submitButtonTitle: Binder<String?> {
        return base.submitButton.rx.title()
    }
    
    var submitButtonEnabled: Binder<Bool> {
        return base.submitButton.rx.isEnabled
    }
    
    var submitButtonHidden: Binder<Bool> {
        return base.submitButton.rx.isHidden
    }

    var titleTextFieldEnabled: Binder<Bool> {
        return base.titleTextField.rx.isEnabled
    }
    
    var titleChanged: ControlEvent<()> {
        return base.titleTextField.rx.controlEvent(.editingChanged)
    }
    
    var titleEditEnd: ControlEvent<()> {
        return base.titleTextField.rx.controlEvent(.editingDidEndOnExit)
    }
    
    var captionText: ControlProperty<String?> {
        return base.captionTextView.rx.text
    }
    
    var submitTapped: ControlEvent<Void> {
        return base.submitButton.rx.tap
    }
}
