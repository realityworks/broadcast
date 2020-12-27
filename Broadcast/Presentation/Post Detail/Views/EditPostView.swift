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
    let verticalStackView = UIStackView()
    let titleTextField = UITextField.standard(withPlaceholder: LocalizedString.postDescription)
    let captionTextView = UITextView.standard()
    let uploadButton = UIButton.standard(withTitle: LocalizedString.publish)
    
    private let titleHeading = UILabel.bodyBold(LocalizedString.postTitle)
    private let captionHeading = UILabel.bodyBold(LocalizedString.captionTitle)
    
    init() {
        super.init(frame: .zero)
        
        verticalStackView.axis = .vertical
        verticalStackView.spacing = 10
        verticalStackView.alignment = .leading
        verticalStackView.distribution = .equalSpacing

        addSubview(verticalStackView)
        
        verticalStackView.topToSuperview()
        verticalStackView.widthToSuperview()

        verticalStackView.addArrangedSubview(titleHeading)
        verticalStackView.addArrangedSubview(titleTextField)
        
        verticalStackView.addArrangedSubview(captionHeading)
        verticalStackView.addArrangedSubview(captionTextView)
        
        addSubview(uploadButton)
        
        uploadButton.topToBottom(of: verticalStackView, offset: 20)
        uploadButton.widthToSuperview()
        
        titleTextField.width(200)
        
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
