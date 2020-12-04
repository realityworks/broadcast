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
    let textField = UITextField()
    
    static let identifier: String = "ProfileTextFieldTableViewCell"

    private let disposeBag = DisposeBag()

    override func awakeFromNib() {
        super.awakeFromNib()
        styleView()
        setupActions()
    }

    func configure(text: String) {
        textField.text = text
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
