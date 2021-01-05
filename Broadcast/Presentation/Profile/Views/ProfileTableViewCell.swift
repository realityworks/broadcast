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
    
    private let titleLabel = UILabel.text(font: UIFont.profileCellTitle, textColor: .secondaryBlack)
    private let leftIconImageView = UIImageView()
    private let disclosureImageView = UIImageView(image: <#T##UIImage?#>)
    private let separator = UIView()
        
    override init(style: UITableViewCell.CellStyle,
                  reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Configuration and Styling
    func configure(withTitle titleText: LocalizedString,
                   icon: UIImage? = nil,
                   showDisclosure = false,
                   leftInset: CGFloat = 20) {
        titleLabel.text = titleText.localized
        leftIconImageView.image = icon?.withRenderingMode(.alwaysTemplate)
        leftIconImageView.tintColor = .primaryGrey
        
        separator.removeConstraints(separator.constraints)
        separator.edgesToSuperview(excluding: [.top, .left])
        separator.leftToSuperview(offset: leftInset)
        separator.height(1)
    }
    
    private func configureView() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(leftIconImageView)
        contentView.addSubview(disclosureImageView)
        contentView.addSubview(separator)
        
        leftIconImageView.leftToSuperview(offset: 20)
        leftIconImageView.centerYToSuperview()
        leftIconImageView.height(20)
        leftIconImageView.aspectRatio(1)
        leftIconImageView.contentMode = .scaleAspectFit
        
        titleLabel.edgesToSuperview(excluding: [.left],
                                    insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        titleLabel.leftToRight(of: leftIconImageView, offset: 10)
        
        separator.backgroundColor = .customSeparator
    }
}

