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
        case finishedProcessing = "isProcessed"
        case commentCount = "comment_count"
        case lockerCount = "locker_count"
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
        self.finishedProcessing = finishedProcessing
        self.created = created
        self.media = media
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: PostCodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.caption = try container.decode(String.self, forKey: .title)
        self.finishedProcessing = try container.decode(Bool.self, forKey: .finishedProcessing)
        
        #warning("TODO - Waiting on Bryan for endpoint")
        self.comments = 0
        self.lockers = 0
        
        let iso8601String = try container.decode(String.self, forKey: .created)
        self.created = Date(iso8601String: iso8601String) ?? Date()
        
        self.media = try container.decode(PostMedia.self, forKey: .media)
    }
    
    struct PostMedia : Equatable, Codable {
        
        enum ContentType: String, Codable {
            case image = "image/jpeg"
            case video = "video/mp4"
        }
        
        let id: MediaID
        let thumbnailUrl: String?
        let contentUrl: String
        let contentType: ContentType
    }
}
