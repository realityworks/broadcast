//
//  ProfileTableViewCell.swift
//  Broadcast
//
//  Created by Piotr Suwara on 3/12/20.
//

import UIKit
import SwiftRichString

class ProfileTableViewCell : UITableViewCell {
    static let identifier = "ProfileTableViewCell"
    static let cellHeight:CGFloat = 50
    
    let titleLabel = UILabel()
    let iconImageView = UIImageView()
        
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
                   icon: UIImage? = nil,
                   titleColor: UIColor = .darkGray) {
        let titleRed = Style { $0.color = titleColor }
        
        titleLabel.attributedText = titleText.localized
            .set(style: Style.title)
            .add(style: titleRed)
        
        iconImageView.image = icon?.withRenderingMode(.alwaysTemplate)
        iconImageView.tintColor = .darkGray
    }
    
    private func configureView() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(iconImageView)
        
        titleLabel.edgesToSuperview(excluding: [.right], insets: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0))
        titleLabel.rightToLeft(of: iconImageView)
        
        iconImageView.rightToSuperview(offset: -20)
        iconImageView.centerYToSuperview()
        iconImageView.height(20)
        iconImageView.aspectRatio(1)
        iconImageView.contentMode = .scaleAspectFit
    }
    
    private func styleView() {
        
    }
}

