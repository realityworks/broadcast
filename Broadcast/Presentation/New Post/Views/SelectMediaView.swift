//
//  SelectMediaView.swift
//  Broadcast
//
//  Created by Piotr Suwara on 27/12/20.
//

import UIKit

class SelectMediaView: UIView {

    // MARK: - UI Components
    let dashedBorderView    = CustomBorderView()
    let centralStackView    = UIStackView()
    let selectMediaButton   = UIButton()
    let selectMediaLabel    = UILabel.body(LocalizedString.addMedia)
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
        selectMediaButton.backgroundColor = .clear
        selectMediaButton.setImage(.iconPlusCircle, for: .normal)
        
        centralStackView.axis = .vertical
        centralStackView.alignment = .center
        
        backgroundColor = .primaryGrey
        layer.cornerRadius = 25
        
        dashedBorderView.layer.cornerRadius = 25
    }
    
    private func configureLayout() {
        addSubview(dashedBorderView)
        addSubview(centralStackView)
        
        dashedBorderView.edgesToSuperview()
        
        centralStackView.centerInSuperview()
        centralStackView.widthToSuperview()
        centralStackView.addArrangedSubview(selectMediaButton)
        centralStackView.addArrangedSubview(selectMediaLabel)
    }
}
