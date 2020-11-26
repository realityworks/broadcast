//
//  PostView.swift
//  Broadcast
//
//  Created by Piotr Suwara on 26/11/20.
//

import UIKit
import SDWebImage

class PostSummaryView : UIView {
    let thumbnailImageView = UIImageView()
    #warning("TODO")
    let processingView = ProcessingView()

    let postTitleLabel = UILabel.postTitle()
    let postStatsView = PostStatsView()
    let dateCreatedLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(
        withTitle title: String,
        thumbnailURL: URL?,
        commentCount: Int,
        lockerCount: Int,
        dateCreated: String,
        isProcessing: Bool) {
        #warning("TODO")
        
        if let url = thumbnailURL {
            thumbnailImageView.sd_setImage(with: url, placeholderImage: UIImage(systemName: "paintbrush"))
        }
        
        postStatsView.configure(withCommentCount: commentCount,
                                lockerCount: lockerCount)
    }
}
