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
    
    let postCaptionContainer = UIView()
    let postCaptionLabel = UILabel.body()
    
    let postStatsContainer = UIView()
    let postStatsView = PostStatsView()
    
    let dateCreatedContainer = UIView()
    let dateCreatedLabel = UILabel.body()
    
    let blurEffect = UIBlurEffect(style: .light)
    let blurredEffectView: UIVisualEffectView!
    
    enum Styling {
        case list
        case detail
    }
    
    let styling: Styling!
    
    init(withStyling styling: Styling) {
        self.styling = styling
        self.blurredEffectView = UIVisualEffectView(effect: blurEffect)
        
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
        postCaptionContainer.addSubview(postCaptionLabel)
        postStatsContainer.addSubview(postStatsView)
        dateCreatedContainer.addSubview(dateCreatedLabel)
        
        switch styling {
        case .detail:
            configureDetailStyle()
            
        case .list:
            configureListStyle()
            
        case .none:
            break
        }
    }
    
    private func configureDetailStyle() {
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
        containerTopView.addSubview(blurredEffectView)
        containerTopView.addSubview(processingView)
        
        // End order important
        blurredEffectView.edgesToSuperview()
        processingView.edgesToSuperview()
        thumbnailImageView.edgesToSuperview()
        
        postStatsView.height(15)
        verticalStackView.addSpace(10)
        
        let containedViews = [postTitleLabel,
                              postStatsView,
                              dateCreatedLabel]
        
        containedViews.forEach {
            $0.leftToSuperview(offset: 20)
            $0.rightToSuperview(offset: -20)
        }
        
        verticalStackView.edgesToSuperview()
    }
    
    private func configureListStyle() {
        verticalStackView.addArrangedSubview(dateCreatedContainer)
        verticalStackView.addSeparator(withColor: .separator)
        verticalStackView.addArrangedSubview(postTitleContainer)
        verticalStackView.addArrangedSubview(postCaptionContainer)
        verticalStackView.addArrangedSubview(containerTopView)
        
        verticalStackView.addArrangedSubview(postStatsContainer)
        
        postTitleContainer.height(15)
        postCaptionContainer.height(15)
        postStatsContainer.height(15)
        dateCreatedContainer.height(15)
        
        postCaptionLabel.numberOfLines = 2
        postCaptionLabel.lineBreakMode = .byTruncatingTail
        
        // Layout container top view
        containerTopView.edgesToSuperview(excluding: [.top, .bottom])
        containerTopView.aspectRatio(1)
        
        // Order important
        if styling == .detail {
            containerTopView.addSubview(videoPlayerView)
            videoPlayerView.edgesToSuperview()
        }
        
        containerTopView.addSubview(thumbnailImageView)
        containerTopView.addSubview(blurredEffectView)
        containerTopView.addSubview(processingView)
        
        // End order important
        blurredEffectView.edgesToSuperview()
        processingView.edgesToSuperview()
        thumbnailImageView.edgesToSuperview()
        
        postStatsView.height(15)
        verticalStackView.addSpace(10)
        
        let containedViews = [postTitleLabel,
                              postCaptionLabel,
                              postStatsView,
                              dateCreatedLabel]
        
        containedViews.forEach {
            $0.leftToSuperview()
            $0.rightToSuperview()
        }
        
        verticalStackView.leftToSuperview(offset: 20)
        verticalStackView.rightToSuperview(offset: -20)
        verticalStackView.topToSuperview(usingSafeArea: true)
        verticalStackView.bottomToSuperview()
        containerTopView.layer.cornerRadius = 20
    }
    
    func style() {
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(withPostSummaryViewModel postSummaryViewModel: PostSummaryViewModel) {
        if postSummaryViewModel.showVideoPlayer,
           let media = postSummaryViewModel.media {
            thumbnailImageView.isHidden = true
            processingView.isHidden = true
            blurredEffectView.isHidden = true
            
            switch media {
            case .image(let url):
                thumbnailImageView.sd_setImage(with: url,
                                               placeholderImage: UIImage(systemName: "paintbrush"))
            case .video(let url):
                videoPlayerView.playVideo(withURL: url)
            }
            
        } else if let thumbnailUrl = postSummaryViewModel.thumbnailUrl {
            thumbnailImageView.sd_setImage(with: thumbnailUrl,
                                           placeholderImage: UIImage(systemName: "paintbrush"))
        }
        
        if !postSummaryViewModel.showVideoPlayer {
            blurredEffectView.isHidden = !postSummaryViewModel.isEncoding
            processingView.isHidden = !postSummaryViewModel.isEncoding
            processingView.startAnimating()
        }
        
        postStatsView.configure(withCommentCount: postSummaryViewModel.commentCount,
                                lockerCount: postSummaryViewModel.lockerCount)
        
        postTitleLabel.text = postSummaryViewModel.title
        postCaptionLabel.text = postSummaryViewModel.caption
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

