//
//  SelectMediaView.swift
//  Broadcast
//
//  Created by Piotr Suwara on 27/12/20.
//

import UIKit

class SelectMediaView: UIView {

    // MARK: - UI Components
    let dashedBorderView = CustomBorderView()
    let centralStackView  = UIStackView()
    let selectMediaButton = UIButton()
    let selectMediaLabel = UILabel()
    let imageMediaOverlay = UIImageView()
    let videoMediaOverlay = VideoPlayerView()
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        
        configureViews()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViews() {
        selectMediaButton.backgroundColor = .clear
        selectMediaButton.setImage(.iconPlusCircle, for: .normal)
        backgroundColor = .primaryGrey
        layer.bor
    }
    
    private func configureLayout() {
        
    }
}
