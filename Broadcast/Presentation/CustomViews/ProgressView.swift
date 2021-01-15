//
//  ProgressView.swift
//  Broadcast
//
//  Created by Piotr Suwara on 11/1/21.
//

import UIKit
import TinyConstraints
import RxSwift
import RxCocoa
import Lottie

protocol Progress {
    var progressText: String { get set }
    var totalProgress: Float { get set }// 0-1
}

class ProgressView : UIView, Progress {
    
    fileprivate let progressSuccessContainerView = UIStackView()
    fileprivate let progressSuccessAnimation = AnimationView(animationAsset: .success)
    fileprivate let progressSuccessLabel = UILabel.tinyBody(LocalizedString.uploadCompleted)
    
    fileprivate let progressBarContainerView = UIView()
    fileprivate let progressBarView = UIProgressView()
    fileprivate let progressBarLabel = UILabel.tinyBody()

    var progressText: String {
        set {
            progressBarLabel.text = newValue
        }
        get {
            return progressBarLabel.text ?? ""
        }
    }
    
    var totalProgress: Float {
        set {
            return progressBarView.progress = newValue
        }
        get {
            return progressBarView.progress
        }
    }
    
    var progressCompleteSuccess: Bool = false {
        didSet {
            progressSuccessContainerView.isHidden = !progressCompleteSuccess
            progressSuccessAnimation.play()
            progressBarContainerView.isHidden = progressCompleteSuccess
            progressBarLabel.isHidden = progressCompleteSuccess
        }
    }

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        
        configureViews()
        layoutViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configureViews() {
        
        progressBarContainerView.backgroundColor = .clear
        progressBarContainerView.layer.cornerRadius = 8
        progressBarContainerView.layer.borderWidth = 1
        progressBarContainerView.layer.borderColor = UIColor.secondaryLightGrey.cgColor
        
        progressBarView.progressViewStyle = .bar
        progressBarView.progress = 0.0
        progressBarView.trackTintColor = .clear
        progressBarView.progressTintColor = .progressBarColor
        progressBarView.layer.cornerRadius = 4
        progressBarView.clipsToBounds = true
        
        progressBarLabel.textAlignment = .center
        
        progressSuccessContainerView.axis = .vertical
        progressSuccessContainerView.alignment = .center
        progressSuccessContainerView.distribution = .fill
        
        progressSuccessAnimation.loopMode = .playOnce
    }
    
    private func layoutViews() {
        /// Progress Container view wraps a simple border around the progress bar
        addSubview(progressBarContainerView)
        progressBarContainerView.addSubview(progressBarView)
        progressBarContainerView.centerXToSuperview()
        progressBarContainerView.widthToSuperview()
        progressBarContainerView.height(16)
        
        progressBarView.edgesToSuperview(insets: TinyEdgeInsets(top: 4, left: 5, bottom: 5, right: 5))
        
        addSubview(progressBarLabel)
        progressBarLabel.topToBottom(of: progressBarContainerView)
        progressBarLabel.widthToSuperview()
        progressBarLabel.height(16)
        
        addSubview(progressSuccessContainerView)
        
        let successAnimationContainer = UIView()
        progressSuccessContainerView.addArrangedSubview(successAnimationContainer)
        progressSuccessContainerView.addArrangedSubview(progressSuccessLabel)
        
        successAnimationContainer.height(50)
        successAnimationContainer.aspectRatio(1)
        successAnimationContainer.addSubview(progressSuccessAnimation)
        progressSuccessAnimation.edgesToSuperview()
        
        progressSuccessContainerView.centerInSuperview()
    }
}

// MARK: RxSwift Extensions

extension Reactive where Base : ProgressView {
    /// Reactive wrapper for `Title Text` property.
    var text: Binder<String> {
        Binder(base) { progress, text in
            progress.progressText = text
        }
    }

    var totalProgress: Binder<Float> {
        Binder(base) { progress, totalProgress in
            progress.totalProgress = totalProgress
        }
    }
    
    var uploadSuccess: Binder<Bool> {
        Binder(base) { progress, uploadSuccess in
            progress.progressCompleteSuccess = uploadSuccess
        }
    }
}
