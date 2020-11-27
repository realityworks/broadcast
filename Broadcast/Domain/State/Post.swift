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
    let postImage: PostImage?
    
    struct PostVideo : Equatable, Codable {
        
        enum VideoState : String, Equatable, Codable {
            case available
            case encoding
            case failed
            case new
            case uploadComplete
        }
        
        enum VideoProcessingStatus : String, Equatable, Codable {
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
    
    struct PostImage : Equatable, Codable {
        let postImage: String
    }
    
}
