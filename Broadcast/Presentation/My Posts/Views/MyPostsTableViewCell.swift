//
//  MyPostsTableViewCell.swift
//  Broadcast
//
//  Created by Piotr Suwara on 26/11/20.
//

import UIKit
import SDWebImage
import Lottie

class MyPostsTableViewCell : UITableViewCell {
    static let identifier = "MyPostTableViewCell"
    static let bottomSpace: CGFloat = 32
    
    let postSummaryView: PostSummaryView!
    private let animationView = AnimationView(animationAsset: .playVideo)

    override init(style: UITableViewCell.CellStyle,
                  reuseIdentifier: String?) {
        postSummaryView = PostSummaryView(withStyling: .list)
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    
        configureView()
        styleView()
    }
    
    func configureView() {
        contentView.addSubview(postSummaryView)
        postSummaryView.backgroundColor = .white
        postSummaryView.topToSuperview()
        postSummaryView.leftToSuperview(offset: 16)
        postSummaryView.rightToSuperview(offset: -16)
        
        let bottomSpaceView = UIView()
        contentView.addSubview(bottomSpaceView)
        
        bottomSpaceView.topToBottom(of: postSummaryView)
        bottomSpaceView.edgesToSuperview(excluding: [.top])
        bottomSpaceView.height(Self.bottomSpace)
    }
    
    func styleView() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(withViewModel cellViewModel: MyPostsCellViewModel) {
        let postSummaryViewModel = PostSummaryViewModel(
            title: cellViewModel.title,
            caption: cellViewModel.caption,
            thumbnailUrl: cellViewModel.thumbnailUrl,
            media: cellViewModel.media,
            commentCount: cellViewModel.commentCount,
            lockerCount: cellViewModel.lockerCount,
            dateCreated: cellViewModel.dateCreated,
            isEncoding: cellViewModel.isEncoding,
            showVideoPlayer: false)
        
        postSummaryView.configure(withPostSummaryViewModel: postSummaryViewModel)
    }
}
