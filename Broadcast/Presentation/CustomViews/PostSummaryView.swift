//
//  PostView.swift
//  Broadcast
//
//  Created by Piotr Suwara on 26/11/20.
//

import UIKit
import RxSwift
import RxCocoa
import SDWebImage

class PostSummaryView : UIView {
    let verticalStackView = UIStackView()
    let thumbnailImageView = UIImageView()
    let processingView = ProcessingView()
    let videoPlayerView = VideoPlayerView()
    let containerTopView = UIView()

    let postTitleLabel = UILabel.largeTitle()
    let postStatsView = PostStatsView()
    let dateCreatedLabel = UILabel.body()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureViews()
        configureLayout()
        style()
    }
    
    func configureViews() {
        verticalStackView.axis = .vertical
        verticalStackView.distribution = .equalSpacing
        verticalStackView.spacing = 5
        
        thumbnailImageView.contentMode = .scaleAspectFill
        
        containerTopView.layer.cornerRadius = 20
        containerTopView.clipsToBounds = true
    }
    
    func configureLayout() {
        
        // Layout vertical stack
        addSubview(verticalStackView)
        verticalStackView.edgesToSuperview()
        
        verticalStackView.addArrangedSubview(containerTopView)
        verticalStackView.addArrangedSubview(postTitleLabel)
        verticalStackView.addArrangedSubview(postStatsView)
        verticalStackView.addArrangedSubview(dateCreatedLabel)
        
        // Layout container top view
        containerTopView.edgesToSuperview(excluding: [.bottom])
        containerTopView.height(210)
        
        // Order important
        containerTopView.addSubview(videoPlayerView)
        containerTopView.addSubview(processingView)
        containerTopView.addSubview(thumbnailImageView)
        
        videoPlayerView.edgesToSuperview()
        processingView.edgesToSuperview()
        thumbnailImageView.edgesToSuperview()
        
        postStatsView.height(15)
        verticalStackView.addSpace(10)
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
        
        thumbnailImageView.isHidden = isEncoding
        
        if let url = thumbnailURL {
            thumbnailImageView.sd_setImage(with: url, placeholderImage: UIImage(systemName: "paintbrush"))
        }
        
        postStatsView.configure(withCommentCount: commentCount,
                                lockerCount: lockerCount)
        
        postTitleLabel.text = title
        dateCreatedLabel.text = dateCreated
    }
}

extension Reactive where Base: PostSummaryView {
    /// Reactive wrapper for `post` property.
    var summaryView: Binder<PostSummaryViewModel> {
        return Binder(base) {
            $0.configure(
                withTitle: $1.title,
                thumbnailURL: $1.thumbnailURL,
                commentCount: $1.commentCount,
                lockerCount: $1.lockerCount,
                dateCreated: $1.dateCreated,
                isEncoding: $1.isEncoding)
        }
    }
    
    var playerView: Binder<PostSummaryViewModel> {
        return Binder(base) {
            
        }
    }
}

