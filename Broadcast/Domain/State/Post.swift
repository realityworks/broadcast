//
//  Post.swift
//  Broadcast
//
//  Created by Piotr Suwara on 17/11/20.
//

import Foundation

struct Post: Equatable, Codable {
    
    let id: String
    let title: String
    let caption: String
    
    let postVideo: PostVideo?
    
    struct PostVideo : Codable {
        enum VideoState : String {
            case available
            case encoding
            case failed
            case new
            case uploadComplete
        }
        
        enum VideoProcessingStatus : String {
            case downloading
            case error
            case inProgress
            case none
            case pendingUpload
            case queued
            case ready
        }
        
        let videoState: VideoState
        let videoProcessingStatus: VideoProcessingStatus
        let postVideo: String
        
    }
    
    struct PostImage {
        let postImage: String
    }
    
}
