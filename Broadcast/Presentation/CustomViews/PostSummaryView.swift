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

    let postTitleContainer = UIView()
    let postTitleLabel = UILabel.largeTitle()
    
    let postStatsContainer = UIView()
    let postStatsView = PostStatsView()
    
    let dateCreatedContainer = UIView()
    let dateCreatedLabel = UILabel.body()
    
    enum Styling {
        case list
        case detail
    }
    
    let styling: Styling!
    
    init(withStyling styling: Styling) {
        self.styling = styling
        super.init(frame: .zero)
        
        configureViews()
        configureLayout()
        style()
    }
    
    func configureViews() {
        verticalStackView.axis = .vertical
        verticalStackView.distribution = .equalSpacing
        verticalStackView.spacing = 5
        
        thumbnailImageView.contentMode = .scaleAspectFill
        containerTopView.clipsToBounds = true
    }
    
    func configureLayout() {
        
        // Layout vertical stack
        addSubview(verticalStackView)
        
        postTitleContainer.addSubview(postTitleLabel)
        postStatsContainer.addSubview(postStatsView)
        dateCreatedContainer.addSubview(dateCreatedLabel)
        
        verticalStackView.addArrangedSubview(containerTopView)
        verticalStackView.addArrangedSubview(postTitleContainer)
        verticalStackView.addArrangedSubview(postStatsContainer)
        verticalStackView.addArrangedSubview(dateCreatedContainer)
        
        postTitleContainer.height(15)
        postStatsContainer.height(15)
        dateCreatedContainer.height(15)
        
        // Layout container top view
        containerTopView.edgesToSuperview(excluding: [.bottom])
        containerTopView.aspectRatio(1)
        
        // Order important
        if styling == .detail {
            containerTopView.addSubview(videoPlayerView)
            videoPlayerView.edgesToSuperview()
        }
        
        containerTopView.addSubview(thumbnailImageView)
        containerTopView.addSubview(processingView)
        // End order important
        
        processingView.edgesToSuperview()
        thumbnailImageView.edgesToSuperview()
        
        postStatsView.height(15)
        verticalStackView.addSpace(10)
        
        let containedViews = [postTitleLabel,
                              postStatsView,
                              dateCreatedLabel]
        
        switch styling {
        case .detail:
            containedViews.forEach {
                $0.leftToSuperview(offset: 20)
                $0.rightToSuperview(offset: -20)
            }
            
            verticalStackView.edgesToSuperview()
            
        case .list:
            containedViews.forEach {
                $0.leftToSuperview()
                $0.rightToSuperview()
            }
            
            verticalStackView.leftToSuperview(offset: 20)
            verticalStackView.rightToSuperview(offset: -20)
            verticalStackView.topToSuperview(usingSafeArea: true)
            verticalStackView.bottomToSuperview()
            containerTopView.layer.cornerRadius = 20
            
        case .none:
            break
        }
    }
    
    func style() {
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(withPostSummaryViewModel postSummaryViewModel: PostSummaryViewModel) {
        thumbnailImageView.isHidden = postSummaryViewModel.isEncoding
        
        if postSummaryViewModel.showVideoPlayer {
            switch postSummaryViewModel.media {
            case .image(let url):
                thumbnailImageView.sd_setImage(with: url,
                                               placeholderImage: UIImage(systemName: "paintbrush"))
            case .video(let url):
                videoPlayerView.playVideo(withURL: url)
            case .none:
                Log(level: .warning, topic: .debug, message: "Unsupported media type in PostSummaryViewModel configuration")
                break
            }
            
        } else if let thumbnailUrl = postSummaryViewModel.thumbnailUrl {
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

