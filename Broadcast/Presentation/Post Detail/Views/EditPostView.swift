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
    let titleTextField = UITextField.standard()
    let captionTextView = UITextView.standard()
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
        
        submitButton.setImage(UIImage.iconRadio?.withRenderingMode(.alwaysTemplate), for: .normal)
        submitButton.imageEdgeInsets = .right(10)
        submitButton.imageView?.tintColor = .white
        
        titleTextField.attributedPlaceholder = LocalizedString.postDescription
            .localized
            .set(style: Style.body)
            .set(style: Style.lightGrey)
    }
    
    private func configureLayout() {
        addSubview(verticalStackView)
        
        verticalStackView.topToSuperview()
        verticalStackView.widthToSuperview()

        verticalStackView.addArrangedSubview(titleHeading)
        verticalStackView.addArrangedSubview(titleTextField)
        
        verticalStackView.addArrangedSubview(captionHeading)
        verticalStackView.addArrangedSubview(captionTextView)
        
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
