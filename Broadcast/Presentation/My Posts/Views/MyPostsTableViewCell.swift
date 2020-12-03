//
//  MyPostsTableViewCell.swift
//  Broadcast
//
//  Created by Piotr Suwara on 26/11/20.
//

import UIKit
import SDWebImage

class MyPostsTableViewCell : UITableViewCell {
    static let identifier = "MyPostTableViewCell"
    
    let postSummaryView: PostSummaryView!
        
    override init(style: UITableViewCell.CellStyle,
                  reuseIdentifier: String?) {
        postSummaryView = PostSummaryView(withStyling: .list)
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureView()
        styleView()
    }
    
    func configureView() {
        contentView.addSubview(postSummaryView)
        postSummaryView.edgesToSuperview()
    }
    
    func styleView() {
        contentView.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(withViewModel cellViewModel: MyPostsCellViewModel) {
        let postSummaryViewModel = PostSummaryViewModel(
            title: cellViewModel.title,
            thumbnailURL: cellViewModel.thumbnailURL,
            videoURL: nil,
            commentCount: cellViewModel.commentCount,
            lockerCount: cellViewModel.lockerCount,
            dateCreated: cellViewModel.dateCreated,
            isEncoding: cellViewModel.isEncoding,
            showVideoPlayer: false)
        
        postSummaryView.configure(withPostSummaryViewModel: postSummaryViewModel)
    }
}
