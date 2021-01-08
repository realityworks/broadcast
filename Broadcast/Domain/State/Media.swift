//
//  Media.swift
//  Broadcast
//
//  Created by Piotr Suwara on 2/12/20.
//

import Foundation
import AVFoundation

typealias MediaID = String

/// Enum definition of a type of media with an associated access URL
enum Media : Equatable {
    case video(url: URL)
    case image(url: URL)
    
    var contentType: String {
        switch self {
        case .video:
            return "video/mp4"
        case .image:
            return "image"
        }
    }
    
    var url: URL {
        switch self {
        case .video(let url):
            return url
        case .image(let url):
            return url
        }
    }
    
    var duration: String {
        switch self {
        case .video(let url):
            let asset = AVAsset(url: url)
            let time = asset.duration
            let minutes = Int(CMTimeGetSeconds(time) / 60.0)
            let seconds = Int(CMTimeGetSeconds(time).truncatingRemainder(dividingBy: 60.0))
            return String(format: "%d:%02d", minutes, seconds)
        case .image:
            return ""
        }
    }
}
