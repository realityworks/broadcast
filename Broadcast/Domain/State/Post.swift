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
    
    let postMedia: PostMedia
    
    var contentMedia: Media? {
        guard let contentUrl = URL(string: postMedia.contentUrl) else { return nil }
        return postMedia.contentType == .video
            ? Media.video(url: contentUrl)
            : Media.image(url: contentUrl)
    }
    
    enum PostCodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case caption = "caption"
        case finishedProcessing = "isProcessed"
        case commentCount = "commentCount"
        case lockerCount = "lockerCount"
        case created = "created"
        case postMedia = "media"
    }
    
    init(id: String,
         title: String,
         caption: String,
         comments: Int,
         lockers: Int,
         finishedProcessing: Bool,
         created: Date,
         postMedia: PostMedia) {
        self.id = id
        self.title = title
        self.caption = caption
        self.comments = comments
        self.lockers = lockers
        self.finishedProcessing = finishedProcessing
        self.created = created
        self.postMedia = postMedia
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
        
        self.media = try container.decode(PostMedia.self, forKey: .postMedia)
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
