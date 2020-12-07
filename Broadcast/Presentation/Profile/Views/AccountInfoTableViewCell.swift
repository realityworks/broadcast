//
//  AccountInfoTableViewCell.swift
//  Broadcast
//
//  Created by Piotr Suwara on 7/12/20.
//

import UIKit
import SwiftRichString

class AccountInfoTableViewCell : UITableViewCell {
    static let identifier = "AccountInfoTableViewCell"
    static let cellHeight: CGFloat = 80
    
    //let verticalStackView = UIStackView()
    //let titleLabel = UILabel()
    let detailLabel = UILabel()
        
    override init(style: UITableViewCell.CellStyle,
                  reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureView()
        styleView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Configuration and Styling
    func configure(withTitle titleText: LocalizedString,
                   detail detailText: LocalizedString) {
        
//        verticalStackView.axis = .vertical
//        verticalStackView.alignment = .leading
//        titleLabel.attributedText = titleText.localized.set(style: Style.title)
        detailLabel.attributedText = detailText.localized.set(style: Style.body)
    }
    
    private func configureView() {
        
        contentView.addSubview(detailLabel)
//        verticalStackView.addArrangedSubview(titleLabel)
//        verticalStackView.addArrangedSubview(detailLabel)
//
//        verticalStackView.edgesToSuperview(insets: UIEdgeInsets(top: 0,
//                                                                left: 16,
//                                                                bottom: 0,
//                                                                right: 0))
    }
    
    private func styleView() {
        
    }
}
