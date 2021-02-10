//
//  ProfileTextViewTableViewCell.swift
//  Broadcast
//
//  Created by Piotr Suwara on 4/12/20.
//

import UIKit
import RxSwift
import RxCocoa
import SwiftRichString

class ProfileTextViewTableViewCell: UITableViewCell {
    static let identifier: String = "ProfileTextViewTableViewCell"
    static let cellHeight: CGFloat = 180.0

    fileprivate let verticalStackView = UIStackView()
    fileprivate let titleLabel = UILabel.lightGreySmallBody()
    fileprivate let textView = UITextView.standard()
    
    var disposeBag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle,
                  reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureViews()
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
        verticalStackView.distribution = .equalSpacing
        
        contentView.addSubview(verticalStackView)
        verticalStackView.topToSuperview(offset: 16)
        verticalStackView.leftToSuperview(offset: 24)
        verticalStackView.rightToSuperview(offset: -24)
        
        verticalStackView.addArrangedSubview(titleLabel)
        verticalStackView.addArrangedSubview(textView)
        
        textView.widthToSuperview()
        textView.height(130)
    }

    func configure(withTitle title: String, text: String, placeholder: String) {
        titleLabel.text = title
        textView.text = text
        
        textView.placeholder = placeholder
    }
    
    func textViewResign() {
        textView.resignFirstResponder()
    }
}

extension Reactive where Base: ProfileTextViewTableViewCell {
    /// Reactive wrapper for `Text Field` property.
    var text: ControlProperty<String?> {
        return base.textView.rx.text
    }
}
