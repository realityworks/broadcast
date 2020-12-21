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
    let finishedProcessing: Bool
    let created: Date
    
    let media: PostMedia
    
    enum PostCodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case caption = "caption"
        case commentCount = "comment_count"
        case lockerCount = "locker_count"
        case thumbnailUrl = "thumbnail_url"
        case created = "created"
        case media = "media"
    }
    
    init(id: String,
         title: String,
         caption: String,
         comments: Int,
         lockers: Int,
         finishedProcessing: Bool,
         created: Date,
         media: PostMedia) {
        self.id = id
        self.title = title
        self.caption = caption
        self.comments = comments
        self.lockers = lockers
        self.created = created
        self.media = media
    }
    
    init(from decoder: Decoder) throws {
        #warning("TODO : Needs to be fully decoded")
        let container = try decoder.container(keyedBy: PostCodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.caption = try container.decode(String.self, forKey: .title)
        
        self.comments = 0
        self.lockers = 0
        self.created = Date()
        
        self.media = try container.decode(PostMedia.self, forKey: .media)
    }
    
    struct PostMedia : Equatable, Codable {
        let id: MediaID
        let url: String
        
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
