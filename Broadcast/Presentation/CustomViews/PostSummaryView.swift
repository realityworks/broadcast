//
//  PostView.swift
//  Broadcast
//
//  Created by Piotr Suwara on 26/11/20.
//

import UIKit
import SDWebImage

class PostSummaryView : UIView {
    let verticalStackView = UIStackView()
    let thumbnailImageView = UIImageView()
    let processingView = ProcessingView()
    let containerTopView = UIView()

    let postTitleLabel = UILabel.postTitle()
    let postStatsView = PostStatsView()
    let dateCreatedLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureViews()
        configureLayout()
        style()
    }
    
    func configureViews() {
        verticalStackView.axis = .vertical
    }
    
    func configureLayout() {
        // Layout container top view
        addSubview(containerTopView)
        containerTopView.edgesToSuperview(excluding: [.bottom])
        
        containerTopView.addSubview(thumbnailImageView)
        containerTopView.addSubview(processingView)
        
        thumbnailImageView.edgesToSuperview()
        processingView.edgesToSuperview()
        
        // Layout vertical stack
        addSubview(verticalStackView)
        
        verticalStackView.addArrangedSubview(containerTopView)
        verticalStackView.addArrangedSubview(postStatsView)
        verticalStackView.addArrangedSubview(dateCreatedLabel)
    }
    
    func style() {
        
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
        isEncoding: Bool) {
        #warning("TODO")
        
        if let url = thumbnailURL {
            thumbnailImageView.sd_setImage(with: url, placeholderImage: UIImage(systemName: "paintbrush"))
        }
        
        postStatsView.configure(withCommentCount: commentCount,
                                lockerCount: lockerCount)
        
        dateCreatedLabel.text = dateCreated
    }
}
