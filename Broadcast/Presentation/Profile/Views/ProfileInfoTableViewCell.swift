//
//  ProfileInfoTableViewCell.swift
//  Broadcast
//
//  Created by Piotr Suwara on 4/12/20.
//

import UIKit
import RxSwift
import SwiftRichString

class ProfileInfoTableViewCell: UITableViewCell {
    static let identifier: String = "ProfileInfoTableViewCell"
    static let cellHeight: CGFloat = 150
    
    let containerStackView = UIStackView()
    let thumbnailImageContainer = UIView()
    let thumbnailImageView = UIImageView()
    let changeThumbnailButton = UIButton.with(image: .iconCustomCamera)
    
    let subscribersContainerStackView = UIStackView()
    let displayNameLabel = UILabel.text(font: .tableTitle,
                                        textColor: .primaryLightGrey)
    let subscriberDetailContainerStackView = UIStackView()
    
    let subscribersImageContainer = UIView()
    let subscribersImage = UIImageView(image: .iconRadio)
    let subscribersLabel = UILabel()

    override init(style: UITableViewCell.CellStyle,
                  reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureViews()
        layoutViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViews() {
        containerStackView.axis = .horizontal
        containerStackView.alignment = .center
        containerStackView.distribution = .fillProportionally
        containerStackView.spacing = 0
        
        subscribersContainerStackView.axis = .vertical
        subscribersContainerStackView.spacing = 10
        subscribersContainerStackView.alignment = .leading
        subscribersContainerStackView.distribution = .fillEqually
        
        subscriberDetailContainerStackView.axis = .horizontal
        subscriberDetailContainerStackView.spacing = 0
        subscriberDetailContainerStackView.distribution = .equalSpacing
        
        displayNameLabel.numberOfLines = 1
        displayNameLabel.minimumScaleFactor = 0.5
        displayNameLabel.allowsDefaultTighteningForTruncation = true
        displayNameLabel.lineBreakMode = .byTruncatingTail
        displayNameLabel.adjustsFontSizeToFitWidth = true
    }
    
    private func layoutViews() {
        contentView.addSubview(containerStackView)
        containerStackView.edgesToSuperview()
        
        containerStackView.addSpace(24)
        containerStackView.addArrangedSubview(thumbnailImageContainer)
        containerStackView.addSpace(16)
        containerStackView.addArrangedSubview(subscribersContainerStackView)
        
        thumbnailImageContainer.addSubview(thumbnailImageView)
        thumbnailImageView.centerInSuperview()
        thumbnailImageContainer.height(100)
        thumbnailImageContainer.width(100)
        
        subscribersContainerStackView.addArrangedSubview(displayNameLabel)
        subscribersContainerStackView.addArrangedSubview(subscriberDetailContainerStackView)
        displayNameLabel.width(80)
        
        subscriberDetailContainerStackView.addArrangedSubview(subscribersImageContainer)
        subscriberDetailContainerStackView.addArrangedSubview(subscribersLabel)
        
        subscribersImageContainer.addSubview(subscribersImage)
        subscribersImage.height(20)
        subscribersImage.edgesToSuperview()
        subscribersImage.contentMode = .scaleAspectFit
        
        thumbnailImageView.contentMode = .scaleAspectFit
        thumbnailImageView.height(100)
        thumbnailImageView.width(100)
        
        thumbnailImageView.layer.cornerRadius = 50
        thumbnailImageView.clipsToBounds = true
        
        contentView.addSubview(changeThumbnailButton)
        changeThumbnailButton.right(to: thumbnailImageView)
        changeThumbnailButton.bottom(to: thumbnailImageView)
    }
    
    func configure(withProfileImage profileImage: UIImage, displayName: String, subscribers: Int) {
        thumbnailImageView.image = profileImage
        displayNameLabel.text = displayName
        subscribersLabel.attributedText =
            (" \(subscribers) ").set(style: Style.smallBody) +
            LocalizedString.subscribers.localized.set(style: Style.smallBody).set(style: Style.lightGrey)
    }
}
