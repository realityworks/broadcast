//
//  UploadEvent.swift
//  Broadcast
//
//  Created by Piotr Suwara on 18/12/20.
//

import Foundation

enum UploadEvent {
    case createPost(postId: PostID?)
    case requestUploadUrl(uploadUrl: URL?, mediaId: MediaID?)
    case uploadMedia(progress: Float) /// 0-1
    case completeUpload
    case postContent
    case publish
}
