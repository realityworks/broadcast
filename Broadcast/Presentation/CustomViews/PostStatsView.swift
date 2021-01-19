//
//  PostStatsView.swift
//  Broadcast
//
//  Created by Piotr Suwara on 26/11/20.
//

import UIKit
import SwiftRichString

class PostStatsView : UIView {
    let commentImageView = UIImageView()
    let commentCountLabel = UILabel()
    let commentStackView = UIStackView()
    
    let lockerImageView = UIImageView()
    let lockerCountLabel = UILabel()
    let lockerStackView = UIStackView()
    
    let horizontalStackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureViews()
        layoutViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViews() {
        commentImageView.contentMode = .scaleAspectFit
        commentImageView.image = UIImage.iconMessage?.withRenderingMode(.alwaysTemplate)
        commentImageView.tintColor = .primaryLightGrey
        
        commentImageView.aspectRatio(1)
        
        lockerImageView.contentMode = .scaleAspectFit
        lockerImageView.image = UIImage.iconBookMarkOff?.withRenderingMode(.alwaysTemplate)
        lockerImageView.tintColor = .primaryLightGrey
        
        lockerImageView.aspectRatio(1)
        
        horizontalStackView.axis = .horizontal
        horizontalStackView.distribution = .fillEqually
        horizontalStackView.alignment = .fill
    }
    
    private func layoutViews() {
        addSubview(horizontalStackView)
        
        lockerStackView.addArrangedSubview(lockerImageView)
        lockerStackView.addSpace(8)
        lockerStackView.addArrangedSubview(lockerCountLabel)
        
        commentStackView.addArrangedSubview(commentImageView)
        commentStackView.addSpace(8)
        commentStackView.addArrangedSubview(commentCountLabel)
        
        horizontalStackView.edgesToSuperview(excluding: [.left, .right])
        horizontalStackView.width(300)
        
        horizontalStackView.addArrangedSubview(lockerStackView)
        horizontalStackView.addArrangedSubview(commentStackView)
    }
    
    /// Configure the view content with view model data
    /// - Parameters:
    ///   - commentCount: Number of comments
    ///   - lockerCount: Number of lockers this post is in
    func configure(withCommentCount commentCount: Int, lockerCount: Int) {
        lockerCountLabel.attributedText =
            "\(commentCount) ".set(style: Style.smallBodyBold) +
            LocalizedString.locker.localized.set(style: Style.smallBody).set(style: Style.lightGrey)
        commentCountLabel.attributedText =
            "\(lockerCount) ".set(style: Style.smallBodyBold) +
            LocalizedString.comments.localized.set(style: Style.smallBody).set(style: Style.lightGrey)
    }
}
