//
//  VideoPlayerView.swift
//  Broadcast
//
//  Created by Piotr Suwara on 1/12/20.
//

import UIKit
import AVKit
import TinyConstraints

class VideoPlayer: UIView {
    let vwPlayer = UIView()
    var player: AVPlayer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(vwPlayer)
        vwPlayer.edgesToSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

