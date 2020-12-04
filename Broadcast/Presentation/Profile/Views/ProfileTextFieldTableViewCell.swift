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

    let textField = UITextField()
    let iconImageView = UIImageView()
    
    private let disposeBag = DisposeBag()

    override func awakeFromNib() {
        super.awakeFromNib()
        configureViews()
        styleView()
        setupActions()
    }
    
    private func configureViews() {
        contentView.addSubview(textField)
        textField.edgesToSuperview(insets: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
        
        contentView.addSubview(iconImageView)
        iconImageView.edgesToSuperview(excluding: [.bottom, .left],
                                       insets: UIEdgeInsets(top: 5, left: 5, bottom: 0, right: 0))
        iconImageView.width(30)
        iconImageView.aspectRatio(1)
        iconImageView.image = UIImage(systemName: "pencil")?.withRenderingMode(.alwaysTemplate)
        iconImageView.tintColor = .darkGray
    }

    private func styleView() {
        
    }

    private func setupActions() {
        textField.resignWhenFinished(disposeBag)
    }
}

extension Reactive where Base: ProfileTextFieldTableViewCell {
    /// Reactive wrapper for `Text Field` property.
    var text: ControlProperty<String?> {
        return base.textField.rx.controlProperty(editingEvents: [.valueChanged],
                                       getter: { cell in
                                        cell.text
                                       }, setter: { cell, value in
                                        cell.text = value
                                       })
    }
}
