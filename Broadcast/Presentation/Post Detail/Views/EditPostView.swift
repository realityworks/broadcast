//
//  EditPostView.swift
//  Broadcast
//
//  Created by Piotr Suwara on 8/12/20.
//

import UIKit
import RxSwift
import RxCocoa

class EditPostView: UIView {
    
    private let scrollView = UIScrollView()
    private let verticalStackView = UIStackView()
    
    private let uploadTitle = UILabel.bodyBold(LocalizedString.videoToUpload)
    
    private let titleHeading = UILabel.bodyBold(LocalizedString.addTitle)
    private let titleTextField = UITextField.standard(
        withPlaceholder: LocalizedString.addTitle)
    
    private let captionHeading = UILabel.bodyBold(LocalizedString.captionTitle)
    private let captionTextView = UITextView.standard()
    
    private let uploadButton = UIButton.standard(withTitle: LocalizedString.publish)
    
    init() {
        super.init(frame: .zero)
        
        verticalStackView.axis = .vertical
        verticalStackView.spacing = 10
        verticalStackView.alignment = .leading
        verticalStackView.distribution = .equalSpacing
        
        addSubview(scrollView)
        scrollView.topToSuperview()
        scrollView.bottomToSuperview()
        scrollView.leadingToSuperview(offset: 16)
        scrollView.trailingToSuperview(offset: 16)

        scrollView.addSubview(verticalStackView)
        
        verticalStackView.topToSuperview()
        verticalStackView.widthToSuperview()
        
        verticalStackView.addArrangedSubview(uploadTitle)
        
        verticalStackView.addArrangedSubview(titleHeading)
        verticalStackView.addArrangedSubview(titleTextField)
        
        verticalStackView.addArrangedSubview(captionHeading)
        verticalStackView.addArrangedSubview(captionTextView)
        
        scrollView.addSubview(uploadButton)
        
        uploadButton.topToBottom(of: verticalStackView, offset: 20)
        uploadButton.width(150)
        uploadButton.centerXToSuperview()
        
        captionTextView.height(100)
        captionTextView.width(200)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(withUploadTitle buttonTitle: LocalizedString) {
        uploadButton.setTitle(buttonTitle.localized, for: .normal)
    }
}
