//
//  Post.swift
//  Broadcast
//
//  Created by Piotr Suwara on 17/11/20.
//

import Foundation

typealias PostID = String

struct Post: Equatable, Codable {
    
    // MARK: Data Model
    let id: PostID
    let title: String
    let caption: String
    let comments: Int
    let lockers: Int
    let thumbnailUrl: String
    let created: Date
    
    let postVideo: PostVideo?
    let postImage: PostImage?
    
    // MARK: Computed properties
    var contentUrl: URL? {
        let urlString = [postVideo?.postVideoUrl, postImage?.postImageUrl].first(where: { $0 != nil }) as? String
        return URL(string: urlString)
    }
    
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
        let postVideoUrl: String
    }
    
    struct PostImage : Equatable, Codable {
        let postImageUrl: String
    }
    
}
