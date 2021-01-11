//
//  ProfileTrailerTableViewCell.swift
//  Broadcast
//
//  Created by Piotr Suwara on 4/12/20.
//

import UIKit
import RxSwift
import RxCocoa

class ProfileTrailerTableViewCell: UITableViewCell {
    static let identifier: String = "ProfileTrailerTableViewCell"
    
    let verticalStack = UIStackView()
    let videoPlayerView = VideoPlayerView()
    let selectButton = UIButton.standard(withTitle: LocalizedString.select)
    let progressView = ProgressView()
    
    let disposeBag = DisposeBag()

    override init(style: UITableViewCell.CellStyle,
                  reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        videoPlayerView.layer.cornerRadius = 10
        videoPlayerView.clipsToBounds = true
        
        verticalStack.axis = .vertical
        verticalStack.spacing = 5
        verticalStack.alignment = .center
        
        contentView.addSubview(verticalStack)
        verticalStack.edgesToSuperview(excluding: [.left, .right])
        verticalStack.leadingToSuperview(offset: 16)
        verticalStack.trailingToSuperview(offset: 16)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(trailerVideoUrl: URL?, uploadProgress: UploadProgress?) {
        if let trailerVideoUrl = trailerVideoUrl {
            verticalStack.addArrangedSubview(videoPlayerView)
            videoPlayerView.widthToSuperview()
            videoPlayerView.height(300)

            videoPlayerView.playVideo(withURL: trailerVideoUrl)
        }
        
        verticalStack.addArrangedSubview(selectButton)
        selectButton.height(25)
        selectButton.width(100)
        
        verticalStack.addArrangedSubview(progressView)
        progressView.widthToSuperview()
        
        progressView.isHidden = uploadProgress == nil
        
        #warning("If this is used else where, how about using an extension to update from UploadProgress?")
        if let uploadProgress = uploadProgress {
            progressView.progressText = uploadProgress.progressText
            progressView.totalProgress = uploadProgress.totalProgress
        }
    }
}
