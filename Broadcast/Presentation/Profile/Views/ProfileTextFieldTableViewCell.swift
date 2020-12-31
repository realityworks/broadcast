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

    fileprivate let textField = UITextField()
    fileprivate let iconImageView = UIImageView()
    
    private let disposeBag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle,
                  reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureViews()
        styleView()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViews() {
        contentView.addSubview(textField)
        textField.leftToSuperview(offset: 8)
        textField.rightToSuperview(offset: -8)
        textField.topToSuperview(offset: 8)
        textField.bottomToSuperview(offset: -8)
        
        contentView.addSubview(iconImageView)
        iconImageView.rightToSuperview(offset: -8)
        iconImageView.topToSuperview(offset: -8)
        iconImageView.width(30)
        iconImageView.aspectRatio(1)
        iconImageView.tintColor = .darkGray
    }

    private func styleView() {
        
    }

    private func setupActions() {
        textField.resignWhenFinished(disposeBag)
    }
    
    func configure(withText text: String, icon: UIImage?) {
        textField.text = text
        iconImageView.image = icon
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
