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
    let rightLabel = UILabel.body(textColor: .primaryGrey)
    let failedLabel = UILabel.bodyMedium(.uploadFailed,
                                         textColor: .secondaryBlack)
    
    fileprivate let failedContainerView = UIView()
    fileprivate let failedStackView = UIStackView()
    fileprivate let failedIconView = UIImageView(image: UIImage.iconSlash?.withTintColor(.primaryRed))
        
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
        
        failedStackView.axis = .vertical
        failedStackView.spacing = 0
        failedStackView.alignment = .center
        failedStackView.distribution = .fill
        
        submitButton.setImage(UIImage.iconRadio?.withTintColor(.buttonTitle), for: .normal)
        submitButton.setImage(UIImage.iconRadio?.withTintColor(.disabledButtonTitle), for: .disabled)
                
        submitButton.imageEdgeInsets = .right(10)
        
        failedIconView.contentMode = .scaleAspectFit
        
        titleTextField.rightView = rightLabel
        titleTextField.rightViewMode = .always
        
        rightLabel.textAlignment = .center
        
        failedLabel.lineBreakMode = .byWordWrapping
        failedLabel.numberOfLines = 0
        failedLabel.textAlignment = .center
    }
    
    private func configureLayout() {
        addSubview(verticalStackView)
        
        verticalStackView.topToSuperview()
        verticalStackView.widthToSuperview()

        verticalStackView.addArrangedSubview(titleTextField)
        verticalStackView.addSpace(2)
        verticalStackView.addArrangedSubview(captionTextView)
        verticalStackView.addSpace(10)
        verticalStackView.addArrangedSubview(failedContainerView)
        verticalStackView.addArrangedSubview(submitButton)
        
        submitButton.widthToSuperview()
        titleTextField.widthToSuperview()
        
        captionTextView.height(100)
        captionTextView.widthToSuperview()
        
        failedContainerView.addSubview(failedStackView)
        failedStackView.edgesToSuperview()
        
        failedContainerView.widthToSuperview()
        
        failedStackView.addArrangedSubview(failedIconView)
        failedStackView.addArrangedSubview(failedLabel)
        failedStackView.addSpace(4)
        
        rightLabel.width(55)
    }
    
    func configure(withUploadTitle buttonTitle: LocalizedString) {
        submitButton.setTitle(buttonTitle.localized, for: .normal)
    }
}

// MARK: Reactive Extensions

extension Reactive where Base : EditPostView {
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
    
    var titleText: ControlProperty<String?> {
        return base.titleTextField.rx.text
    }
        
    var captionText: ControlProperty<String?> {
        return base.captionTextView.rx.text
    }
    
    var titleRightLabelText: Binder<String?> {
        return base.rightLabel.rx.text
    }
    
    var submitTapped: ControlEvent<Void> {
        return base.submitButton.rx.tap
    }
    
    var failed: Binder<Bool> {
        return Binder(base) { target, failed in
            let title = failed ?
                LocalizedString.tryAgain.localized :
                LocalizedString.submitPost.localized
            
            target.submitButton.setTitle(title, for: .normal)
            
            let image = failed ?
                UIImage.iconReload?.withTintColor(.white) :
                UIImage.iconRadio?.withTintColor(.white)
            
            target.submitButton.setImage(image, for: .normal)
            
            target.failedContainerView.isHidden = !failed
        }
    }
}
