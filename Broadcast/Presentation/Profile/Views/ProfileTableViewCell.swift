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
    let icon = UIImageView()
        
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
        titleLabel.attributedText = titleText.localized.set(style: Style.title)
    }
    
    private func configureView() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(icon)
        titleLabel.leftToSuperview(offset: 10)
        titleLabel.rightToLeft(of: icon)
        titleLabel.topToSuperview()
        titleLabel.bottomToSuperview()
        
        icon.rightToSuperview(offset: -10)
        icon.centerYToSuperview()
        icon.height(20)
        icon.aspectRatio(1)
        icon.contentMode = .scaleAspectFit
    }
    
    private func styleView() {
        
    }
}

