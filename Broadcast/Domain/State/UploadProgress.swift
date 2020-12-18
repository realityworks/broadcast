//
//  UploadProgress.swift
//  Broadcast
//
//  Created by Piotr Suwara on 17/12/20.
//

import Foundation

struct UploadProgress : Equatable {
    var postId: PostID?
    var mediaId: MediaID?
    var sourceUrl: URL?
    var destinationURL: URL?
    var progress: Float
    var uploadProgress: Float
    var totalProgress: Float
    var completed: Bool
    
    init() {
        self.postId = nil
        self.mediaId = nil
        self.sourceUrl = nil
        self.destinationURL = nil
        self.progress = 0
        self.uploadProgress = 0
        self.totalProgress = 0
        self.completed = false
    }
    
    init(sourceUrl: URL) {
        self.init()
        self.sourceUrl = sourceUrl
    }
}
