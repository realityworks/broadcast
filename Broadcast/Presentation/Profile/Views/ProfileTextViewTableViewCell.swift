//
//  ProfileTextViewTableViewCell.swift
//  Broadcast
//
//  Created by Piotr Suwara on 4/12/20.
//

import UIKit
import RxSwift
import RxCocoa

class ProfileTextViewTableViewCell: UITableViewCell {
    static let identifier: String = "ProfileTextViewTableViewCell"
    static let cellHeight: CGFloat = 80.0

    fileprivate let titleLabel = UILabel.lightGreySmallBody()
    fileprivate let textView = UITextView()
    
    private let disposeBag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle,
                  reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureViews()
        styleView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViews() {
        contentView.addSubview(textView)
        textView.leftToSuperview(offset: 8)
        textView.rightToSuperview(offset: -8)
        textView.topToSuperview(offset: 8)
        textView.bottomToSuperview(offset: -8)
    }

    func configure(withTitle title: String, text: String) {
        titleLabel.text = title
        textView.text = text
    }
}

extension Reactive where Base: ProfileTextViewTableViewCell {
    /// Reactive wrapper for `Text Field` property.
    var text: ControlProperty<String?> {
        return base.textView.rx.text
    }
}
