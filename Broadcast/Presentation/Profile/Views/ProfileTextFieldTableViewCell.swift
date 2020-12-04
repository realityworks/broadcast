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
        textField.rx.controlEvent([.editingDidEnd])
            .subscribe(onNext: { [weak self] _ in
                self?.renameProperty()
            })
            .disposed(by: disposeBag)
    }

    private func renameProperty() {
        guard let name = textField.text, let propertyID = propertyID else { return }
        DispatchQueue.main.async {
            appDomain.store.dispatch(SetPropertyNameAction(withInProgressValue: name, propertyId: propertyID))
        }
    }
}

extension Reactive where Base: ProfileTextFieldTableViewCell {
    /// Reactive wrapper for `Text Field` property.
    var text: ControlProperty<String> {
        return base.rx.controlProperty(editingEvents: [.valueChanged],
                                       getter: { cell in
                                        cell.text
                                       }, setter: { button, value in
                                           button.isOn = value
                                       })
    }
}
