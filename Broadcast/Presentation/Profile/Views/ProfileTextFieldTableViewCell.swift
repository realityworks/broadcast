//
//  ProfileTextFieldTableViewCell.swift
//  Broadcast
//
//  Created by Piotr Suwara on 4/12/20.
//

import UIKit
import RxSwift
import RxCocoa

class ProfileTextFieldTableViewCell: UITableViewCell {
    static let identifier: String = "ProfileTextFieldTableViewCell"
    static let cellHeight: CGFloat = 100.0

    fileprivate let verticalStackView = UIStackView()
    fileprivate let titleLabel = UILabel.lightGreySmallBody()
    fileprivate var editingEnabled: Bool = true
    fileprivate let textField = UITextField.standard(insets: .left(16))
    
    var disposeBag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle,
                  reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureViews()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        disposeBag = DisposeBag()
    }
    
    private func configureViews() {
        
        verticalStackView.axis = .vertical
        verticalStackView.spacing = 10
        verticalStackView.alignment = .leading
        verticalStackView.distribution = .fill
        
        contentView.addSubview(verticalStackView)
        verticalStackView.topToSuperview(offset: 16)
        verticalStackView.leftToSuperview(offset: 24)
        verticalStackView.rightToSuperview(offset: -24)
        
        verticalStackView.addArrangedSubview(titleLabel)
        verticalStackView.addArrangedSubview(textField)
        
        textField.widthToSuperview()
    }

    private func setupActions() {
        textField.resignWhenFinished(disposeBag)
    }
    
    func configure(withTitle title: String, placeholder: String, text: String, editingEnabled: Bool) {
        titleLabel.text = title
        textField.text = text
        
        #warning("Refactor this into a universal textfield, spread across too many extensions/custom classes")
        if editingEnabled {
            textField.backgroundColor = .white
            textField.leftView = nil
            textField.textInsets = .left(16)
            textField.isUserInteractionEnabled = true
        } else {
            textField.backgroundColor = .tertiaryLightGrey
            
            let lockedIcon = UIImageView(image: UIImage.iconLock?.withRenderingMode(.alwaysTemplate))
            lockedIcon.contentMode = .scaleAspectFit
            lockedIcon.tintColor = .lightGray
            textField.isUserInteractionEnabled = false
            textField.leftView = lockedIcon
            textField.leftViewMode = .always
            textField.textInsets = .left(4)
        }
    }
}

extension Reactive where Base: ProfileTextFieldTableViewCell {
    /// Reactive wrapper for `Text Field` property.
    var text: ControlProperty<String?> {
        return base.textField.rx.controlProperty(editingEvents: [.editingDidEnd, .editingChanged],
                                       getter: { cell in
                                        cell.text
                                       }, setter: { cell, value in
                                        cell.text = value
                                       })
    }
}
