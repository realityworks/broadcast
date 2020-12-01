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
    var playerLayer: AVPlayerLayer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(vwPlayer)
        vwPlayer.edgesToSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func addPlayerTo(view: UIView) {
        player = AVPlayer()
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.videoGravity = .resizeAspectFill
        
        if let playerLayer = playerLayer {
            view.layer.addSublayer(playerLayer)
        }
    }
    
    override func layoutSubviews() {
        playerLayer?.frame = self.bounds
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
        let playerItem = AVPlayerItem(url: url)
        player?.replaceCurrentItem(with: playerItem)
        player?.play()
    }
}

