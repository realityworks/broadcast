//
//  UploadEvent.swift
//  Broadcast
//
//  Created by Piotr Suwara on 18/12/20.
//

import Foundation

enum UploadEvent {
    case createPost(postId: PostID?)
    case createTrailer
    case requestPostUploadUrl(uploadUrl: URL?, mediaId: MediaID?)
    case requestTrailerUploadUrl(uploadUrl: URL?)
    case uploadMedia(progress: Float) /// 0-1
    case completeUpload
    case postContent
    case publish
}
