//
//  UploadService.swift
//  Broadcast
//
//  Created by Piotr Suwara on 18/11/20.
//

import Foundation
import RxSwift
import RxCocoa
import RxAlamofire

enum UploadEvent {
    case createPost(postId: PostID?)
    case requestUploadUrl(uploadUrl: URL?, mediaId: MediaID?)
    case uploadMedia(progress: Float) /// 0-1
    case completeUpload
    case postContent
    case publish
}

protocol UploadProgress {
    var postId: PostID? { get set }
    var mediaId: MediaID? { get set }
    var sourceUrl: URL? { get set }
    var destinationURL: URL? { get set }
    var progress: Float { get } // Progress indicator on how much of the upload is complete
}

protocol UploadService {
    func inject(apiService: APIService)
    func upload(media: Media, content: PostContent) -> Observable<UploadProgress>?
}
