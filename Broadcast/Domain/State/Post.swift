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
    let commentCount: Int
    let lockerCount: Int
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
         commentCount: Int,
         lockerCount: Int,
         finishedProcessing: Bool,
         created: Date,
         postMedia: PostMedia) {
        self.id = id
        self.title = title
        self.caption = caption
        self.commentCount = commentCount
        self.lockerCount = lockerCount
        self.finishedProcessing = finishedProcessing
        self.created = created
        self.postMedia = postMedia
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: PostCodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.caption = try container.decode(String.self, forKey: .caption)
        self.commentCount = try container.decode(Int.self, forKey: .commentCount)
        self.lockerCount = try container.decode(Int.self, forKey: .lockerCount)
        self.finishedProcessing = try container.decode(Bool.self, forKey: .finishedProcessing)
        
        self.postMedia = try container.decode(PostMedia.self, forKey: .postMedia)
        
        let apiDateTimeString = try container.decode(String.self, forKey: .created)
        self.created = Date(apiDateTimeString: apiDateTimeString) ?? Date()
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
