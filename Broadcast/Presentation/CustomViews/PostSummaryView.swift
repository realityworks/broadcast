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
import Lottie

class PostSummaryView : UIView {
    let verticalStackView = UIStackView()
    let thumbnailImageView = UIImageView()
    let processingView = ProcessingView()
    let videoPlayerView = VideoPlayerView()
    let pressPlayOverlayView = AnimationView(animationAsset: .playVideo)
    let containerTopView = UIView()

    let postTitleContainer = UIView()
    let postTitleLabel = UILabel.text(font: .postCaptionTitle)
    
    let postCaptionContainer = UIView()
    let postCaptionLabel = UILabel.smallBody()
    
    let postStatsContainer = UIView()
    let postStatsView = PostStatsView()
    
    let dateCreatedContainer = UIView()
    let dateCreatedLabel = UILabel.smallBody(textColor: .primaryLightGrey)
    
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
        verticalStackView.addSpace(18)
        verticalStackView.addArrangedSubview(dateCreatedContainer)
        verticalStackView.addSpace(10)
        let separatorView = verticalStackView.addSeparator()
        verticalStackView.addSpace(8)
        verticalStackView.addArrangedSubview(postTitleContainer)
        verticalStackView.addSpace(8)
        verticalStackView.addArrangedSubview(postCaptionContainer)
        verticalStackView.addSpace(10)
        verticalStackView.addArrangedSubview(postStatsContainer)
        verticalStackView.addSpace(24)
        
        postStatsContainer.height(15)
        dateCreatedContainer.height(15)
        
        postTitleLabel.numberOfLines = 0
        postTitleLabel.lineBreakMode = .byWordWrapping
        
        postCaptionLabel.numberOfLines = 0
        postCaptionLabel.lineBreakMode = .byWordWrapping
        
        // Layout container top view
        containerTopView.edgesToSuperview(excluding: [.bottom])
        containerTopView.aspectRatio(1)
        
        // Order of view additions is important
        containerTopView.addSubview(videoPlayerView)
        containerTopView.addSubview(thumbnailImageView)
        containerTopView.addSubview(blurredEffectView)
        containerTopView.addSubview(processingView)
        
        videoPlayerView.edgesToSuperview()
        thumbnailImageView.edgesToSuperview()
        blurredEffectView.edgesToSuperview()
        processingView.edgesToSuperview()
        
        postStatsContainer.height(15)
        
        let containedViews = [postTitleLabel,
                              postCaptionLabel,
                              postStatsView,
                              dateCreatedLabel,
                              separatorView]
        
        containedViews.forEach {
            $0.leftToSuperview(offset: 20)
            $0.rightToSuperview(offset: -20)
        }
        
        postTitleLabel.edgesToSuperview(excluding: [.left, .right])
        postCaptionLabel.edgesToSuperview(excluding: [.left, .right])
        
        verticalStackView.edgesToSuperview(usingSafeArea: true)
    }
    
    private func configureListStyle() {
        verticalStackView.addSpace(18)
        verticalStackView.addArrangedSubview(dateCreatedContainer)
        verticalStackView.addSpace(10)
        verticalStackView.addSeparator()
        verticalStackView.addSpace(8)
        verticalStackView.addArrangedSubview(postTitleContainer)
        verticalStackView.addSpace(8)
        verticalStackView.addArrangedSubview(postCaptionContainer)
        verticalStackView.addArrangedSubview(containerTopView)
        verticalStackView.addSpace(10)
        verticalStackView.addArrangedSubview(postStatsContainer)
        verticalStackView.addSpace(8)
        
        postCaptionContainer.height(30)
        postStatsContainer.height(15)
        dateCreatedContainer.height(15)
        
        postTitleLabel.numberOfLines = 0
        postTitleLabel.lineBreakMode = .byWordWrapping
        
        postCaptionLabel.numberOfLines = 2
        postCaptionLabel.lineBreakMode = .byTruncatingTail
        
        pressPlayOverlayView.loopMode = .loop
        pressPlayOverlayView.backgroundBehavior = .pauseAndRestore
        
        // Layout container top view
        containerTopView.edgesToSuperview(excluding: [.top, .bottom])
        containerTopView.aspectRatio(1)
        
        // Order of view additions is important
        containerTopView.addSubview(thumbnailImageView)
        containerTopView.addSubview(pressPlayOverlayView)
        containerTopView.addSubview(blurredEffectView)
        containerTopView.addSubview(processingView)

        thumbnailImageView.edgesToSuperview()
        pressPlayOverlayView.centerInSuperview()
        blurredEffectView.edgesToSuperview()
        processingView.edgesToSuperview()
        
        postStatsView.height(22)
        verticalStackView.addSpace(10)
        
        let containedViews = [postTitleLabel,
                              postCaptionLabel,
                              postStatsView,
                              dateCreatedLabel]
        
        containedViews.forEach {
            $0.leftToSuperview(offset: 16)
            $0.rightToSuperview(offset: -16)
        }
        
        postTitleLabel.edgesToSuperview(excluding: [.left, .right])
        
        verticalStackView.leftToSuperview()
        verticalStackView.rightToSuperview()
        verticalStackView.topToSuperview(usingSafeArea: true)
        verticalStackView.bottomToSuperview()
        
        roundedCorners()
    }
    
    func style() {
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateThumbnail(withImageUrl url: URL?, showThumbnail: Bool = true) {
        guard let url = url else { return }
        
        thumbnailImageView.isHidden = !showThumbnail
        let noQueryUrl = url.queryParametersRemoved()
        thumbnailImageView.sd_setImage(with: noQueryUrl,
                                       placeholderImage: UIImage(color: .black))
    }
    
    private func configureAsImage(withPostSummaryViewModel postSummaryViewModel: PostSummaryViewModel) {
        updateThumbnail(withImageUrl: postSummaryViewModel.media.url)
    }
    
    private func configureAsVideo(withPostSummaryViewModel postSummaryViewModel: PostSummaryViewModel) {
        if postSummaryViewModel.showVideoPlayer {
            if !postSummaryViewModel.isEncoding,
                let url = postSummaryViewModel.media.url {
                videoPlayerView.isHidden = false
                videoPlayerView.playVideo(withURL: url)
            } else {
                updateThumbnail(withImageUrl: postSummaryViewModel.thumbnailUrl)
            }
        } else {
            updateThumbnail(withImageUrl: postSummaryViewModel.thumbnailUrl)
            
            pressPlayOverlayView.isHidden = false
            pressPlayOverlayView.play()
        }
        
        blurredEffectView.isHidden = !postSummaryViewModel.isEncoding
        processingView.isHidden = !postSummaryViewModel.isEncoding
        pressPlayOverlayView.isHidden = postSummaryViewModel.isEncoding
        processingView.animating = postSummaryViewModel.isEncoding
    }
    
    func configure(withPostSummaryViewModel postSummaryViewModel: PostSummaryViewModel) {
        videoPlayerView.isHidden = true
        thumbnailImageView.isHidden = true
        processingView.isHidden = true
        blurredEffectView.isHidden = true
        pressPlayOverlayView.isHidden = true
        
        switch postSummaryViewModel.media {
        case .image:
            // Image View
            configureAsImage(withPostSummaryViewModel: postSummaryViewModel)
        case .video:
            // Video View
            configureAsVideo(withPostSummaryViewModel: postSummaryViewModel)
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

