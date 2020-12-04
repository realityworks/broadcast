//
//  ProfileInfoTableViewCell.swift
//  Broadcast
//
//  Created by Piotr Suwara on 4/12/20.
//

import UIKit
import RxSwift

class ProfileInfoTableViewCell: UITableViewCell {
    static let identifier: String = "ProfileTextFieldTableViewCell"
    
    let containerStackView = UIStackView()
    let thumbnailContainerStackView = UIStackView()
    let thumbnailImageView = UIImageView()
    let changeThumbnailButton = UIButton.smallText(withTitle: LocalizedString.change)
    
    let subscribersContainerStackView = UIStackView()
    let subscribersCountLabel = UILabel.largeTitle()
    let subscribersTitleLabel = UILabel.body(LocalizedString.subscribers)

    override init(style: UITableViewCell.CellStyle,
                  reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViews() {
        containerStackView.axis = .horizontal
        containerStackView.distribution = .fillEqually
        containerStackView.spacing = 5
        
        contentView.addSubview(containerStackView)
        containerStackView.addArrangedSubview(thumbnailContainerStackView)
        containerStackView.addArrangedSubview(subscribersContainerStackView)
        
        thumbnailContainerStackView.addArrangedSubview(thumbnailImageView)
        thumbnailContainerStackView.addArrangedSubview(changeThumbnailButton)
        
        subscribersContainerStackView.addArrangedSubview(subscribersTitleLabel)
    }
    
    func configure(withThumbailUrl thumbnailUrl: URL?, subscribers: Int) {
        thumbnailImageView.sd_setImage(with: thumbnailUrl)
        subscribersCountLabel.text = "\(subscribers)"
    }
}
