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
    
    enum Styling {
        case list
        case detail
    }
    
    init(withStyling styling: Styling) {
        super.init(frame: .zero)
        
        configureViews()
        configureLayout(withStyling: styling)
        style()
    }
    
    func configureViews() {
        verticalStackView.axis = .vertical
        verticalStackView.distribution = .equalSpacing
        verticalStackView.spacing = 5
        
        thumbnailImageView.contentMode = .scaleAspectFill
        videoPlayerView.contentMode = .scaleAspectFit
        
        containerTopView.clipsToBounds = true
    }
    
    func configureLayout(withStyling styling: Styling) {
        
        // Layout vertical stack
        addSubview(verticalStackView)
        
        verticalStackView.addArrangedSubview(containerTopView)
        verticalStackView.addArrangedSubview(postTitleLabel)
        verticalStackView.addArrangedSubview(postStatsView)
        verticalStackView.addArrangedSubview(dateCreatedLabel)
        
        // Layout container top view
        containerTopView.edgesToSuperview(excluding: [.bottom])
        containerTopView.aspectRatio(1)
        
        // Order important
        containerTopView.addSubview(videoPlayerView)
        containerTopView.addSubview(thumbnailImageView)
        containerTopView.addSubview(processingView)
        
        videoPlayerView.edgesToSuperview()
        processingView.edgesToSuperview()
        thumbnailImageView.edgesToSuperview()
        
        postStatsView.height(15)
        verticalStackView.addSpace(10)
        
        switch styling {
        case .detail:
            let views = [postTitleLabel,
                         postStatsView,
                         dateCreatedLabel]
            
            views.forEach {
                $0.leftToSuperview(offset: 20)
                $0.rightToSuperview(offset: -20)
            }
            
            verticalStackView.edgesToSuperview()
            
        case .list:
            verticalStackView.leftToSuperview(offset: 20)
            verticalStackView.rightToSuperview(offset: -20)
            verticalStackView.topToSuperview(usingSafeArea: true)
            verticalStackView.bottomToSuperview()
            containerTopView.layer.cornerRadius = 20
        }
    }
    
    func style() {
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(withPostSummaryViewModel postSummaryViewModel: PostSummaryViewModel) {
        thumbnailImageView.isHidden = postSummaryViewModel.isEncoding
        
        if postSummaryViewModel.showVideoPlayer,
           let videoUrl = postSummaryViewModel.videoURL {
            videoPlayerView.playVideo(withURL: videoUrl)
        } else if let thumbnailUrl = postSummaryViewModel.thumbnailURL {
            thumbnailImageView.sd_setImage(with: thumbnailUrl,
                                           placeholderImage: UIImage(systemName: "paintbrush"))
        }
        
        processingView.isHidden = !postSummaryViewModel.isEncoding
        
        postStatsView.configure(withCommentCount: postSummaryViewModel.commentCount,
                                lockerCount: postSummaryViewModel.lockerCount)
        
        postTitleLabel.text = postSummaryViewModel.title
        dateCreatedLabel.text = postSummaryViewModel.dateCreated
    }
}

extension Reactive where Base: PostSummaryView {
    /// Reactive wrapper for `post` property.
    var summaryView: Binder<PostSummaryViewModel> {
        return Binder(base) {
            $0.configure(withPostSummaryViewModel: $1)
        }
    }    
}

