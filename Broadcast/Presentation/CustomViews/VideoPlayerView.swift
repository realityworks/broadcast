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
    let playerController = AVPlayerViewController()
    var player: AVPlayer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        /// Setup the AV Player layer and Player object. Add the layer to the player subview
        backgroundColor = .black
        playerController.view.backgroundColor = .black
        playerController.showsPlaybackControls = true
        playerController.view.contentMode = .scaleAspectFill
        addSubview(playerController.view)
    }
    
    deinit {
        print ("DEINIT VIDEO PLAYER")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    func playVideo(withURL url: URL?, autoplay: Bool = true) {
        guard let url = url else { return }
        
        player = AVPlayer(url: url)
        playerController.videoGravity = .resizeAspectFill
        playerController.player = player
        if autoplay == true {
            player?.rate = 1 //auto play
        }
    }
    
    /// Pause
    func pause() {
        guard let player = player else { return }
        player.pause()
    }
    
    func play() {
        guard let player = player else { return }
        player.play()
    }
}

