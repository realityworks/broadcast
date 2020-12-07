//
//  ProfileTrailerTableViewCell.swift
//  Broadcast
//
//  Created by Piotr Suwara on 4/12/20.
//

import UIKit
import RxSwift

class ProfileTrailerTableViewCell: UITableViewCell {
    static let identifier: String = "ProfileTrailerTableViewCell"
    static let cellHeight: CGFloat = 300
    
    let verticalStack = UIStackView()
    let videoPlayerView = VideoPlayerView()
    let selectButton = UIButton.standard(withTitle: LocalizedString.select)

    override init(style: UITableViewCell.CellStyle,
                  reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        videoPlayerView.layer.cornerRadius = 10
        videoPlayerView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(thumbnailUrl: URL?) {
        if let thumbnailUrl = thumbnailUrl {
            verticalStack.addArrangedSubview(videoPlayerView)
            verticalStack.addArrangedSubview(selectButton)
        } else {
            
        }
    }
}
