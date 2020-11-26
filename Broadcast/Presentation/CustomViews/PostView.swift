//
//  PostView.swift
//  Broadcast
//
//  Created by Piotr Suwara on 26/11/20.
//

import UIKit

class PostView : UIView {
    let thumbnailImageView = UIImageView()
    let postTitleLabel = UILabel.postTitle()
    let postStatsView = PostStatsView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
