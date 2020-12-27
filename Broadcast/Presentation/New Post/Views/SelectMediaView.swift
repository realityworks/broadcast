//
//  SelectMediaView.swift
//  Broadcast
//
//  Created by Piotr Suwara on 27/12/20.
//

import UIKit

class SelectMediaView: UIView {

    // MARK: - UI Components
    let selectMediaButton = UIButton()
    let imageMediaOverlay = UIImageView()
    let videoMediaOverlay = VideoPlayerView()
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    init(frame: CGRect = .zero) {
        super.init(frame: frame)
    }
    
    private func configureViews() {
        
    }
    
    private func configureLayout() {
        
    }
}
