//
//  VideoPlayerView.swift
//  Broadcast
//
//  Created by Piotr Suwara on 1/12/20.
//

import UIKit
import AVKit
import TinyConstraints

class VideoPlayerView: UIView {
    //let vwPlayer = UIView()
    let playerController = AVPlayerViewController()
    var player: AVPlayer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        /// Setup the AV Player layer and Player object. Add the layer to the player subview
        backgroundColor = .black
        playerController.view.backgroundColor = .black
        playerController.showsPlaybackControls = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureVideoPlayer() {
        addSubview(playerController.view)
    }
    
    override func layoutSubviews() {
        playerController.view.frame = self.bounds
    }
    
    /// Play video from local file
    /// - Parameters:
    ///   - filename: Filename reference in the bundle
    ///   - type: Type extension of the video
    func playVideo(withFilename filename: String, ofType type: String) {
        guard let filePath = Bundle.main.path(forResource: filename, ofType: type) else { return }
        
        let videoURL = URL(fileURLWithPath: filePath)
        playVideo(withURL: videoURL)
    }
    
    /// Play video from URL
    /// - Parameter withURL: Reference URL to play
    func playVideo(withURL url: URL) {
        player = AVPlayer(url: url)
        playerController.player = player
        player?.rate = 1 //auto play
    }
}

