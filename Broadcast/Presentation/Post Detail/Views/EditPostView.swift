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
    
    private let verticalStackView = UIStackView()
    private let titleTextField = UITextField()
    private let captionTextView = UITextView()
    private let uploadButton = UIButton.standard()
    
    init() {
        super.init(frame: .zero)
        
        addSubview(verticalStackView)
        verticalStackView.addArrangedSubview(titleTextField)
        verticalStackView.addArrangedSubview(captionTextView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(withUploadTitle buttonTitle: LocalizedString) {
        uploadButton.setTitle(buttonTitle.localized, for: .normal)
    }
}
