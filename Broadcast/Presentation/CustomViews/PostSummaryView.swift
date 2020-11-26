//
//  PostView.swift
//  Broadcast
//
//  Created by Piotr Suwara on 26/11/20.
//

import UIKit

class PostSummaryView : UIView {
    let thumbnailImageView = UIImageView()
    #warning("TODO")
    //let processingView =

    let postTitleLabel = UILabel.postTitle()
    let postStatsView = PostStatsView()
    let dateCreatedLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(withThumbnailURL: URL,
                   commentCount: Int,
                   lockerCount: Int,
                   isProcessing: Bool) {
        
    }
}
