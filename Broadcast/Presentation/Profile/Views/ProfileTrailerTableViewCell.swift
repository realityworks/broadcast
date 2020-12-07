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
    
    let verticalStack = UIStackView()
    let videoPlayerView = VideoPlayerView()
    let selectButton = UIButton.standard(withTitle: LocalizedString.select)

    override init(style: UITableViewCell.CellStyle,
                  reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        videoPlayerView.layer.cornerRadius = 10
        videoPlayerView.clipsToBounds = true
        
        verticalStack.axis = .vertical
        verticalStack.spacing = 5
        verticalStack.alignment = .center
        
        addSubview(verticalStack)
        verticalStack.edgesToSuperview(excluding: [.left, .right])
        verticalStack.leadingToSuperview(offset: 16)
        verticalStack.trailingToSuperview(offset: 16)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(thumbnailUrl: URL?) {
        if let thumbnailUrl = thumbnailUrl {
            verticalStack.addArrangedSubview(videoPlayerView)
            verticalStack.addArrangedSubview(selectButton)
            videoPlayerView.widthToSuperview()
            videoPlayerView.height(300)

            videoPlayerView.playVideo(withURL: thumbnailUrl)
        }
        
        verticalStack.addArrangedSubview(selectButton)
        selectButton.height(25)
        selectButton.width(100)
    }
}
