//
//  SelectMediaView.swift
//  Broadcast
//
//  Created by Piotr Suwara on 27/12/20.
//

import UIKit
import TinyConstraints

class SelectMediaView: UIView {

    // MARK: - UI Components
    let dashedBorderView    = CustomBorderView()
    let selectMediaButton   = TopImageButton()
    let imageMediaOverlay   = UIImageView()
    let videoMediaOverlay   = VideoPlayerView()
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        
        configureViews()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViews() {
        clipsToBounds = false
        backgroundColor = .white
        layer.cornerRadius = 25
        
        selectMediaButton.backgroundColor = .clear
        selectMediaButton.setImage(UIImage.iconPlusCircle?.withRenderingMode(.alwaysTemplate), for: .normal)
        selectMediaButton.imageView?.tintColor = UIColor.primaryRed
        selectMediaButton.setTitle(LocalizedString.addMedia, for: .normal)
        selectMediaButton.titleLabel?.font = UIFont.smallBodyBold
        selectMediaButton.setTitleColor(UIColor.secondaryBlack, for: .normal)
        
        dashedBorderView.layer.cornerRadius = 25
        
        videoMediaOverlay.layer.cornerRadius = 25
        videoMediaOverlay.clipsToBounds = true
        
        imageMediaOverlay.layer.cornerRadius = 25
        imageMediaOverlay.clipsToBounds = true
        imageMediaOverlay.contentMode = .scaleAspectFill
    }
    
    private func configureLayout() {
        addSubview(dashedBorderView)
        addSubview(selectMediaButton)
        addSubview(imageMediaOverlay)
        addSubview(videoMediaOverlay)
        
        dashedBorderView.edgesToSuperview()
        
        selectMediaButton.centerInSuperview()
        selectMediaButton.widthToSuperview()
        videoMediaOverlay.edgesToSuperview()
        imageMediaOverlay.edgesToSuperview()
    }
}
