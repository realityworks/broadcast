//
//  LocalAPIService.swift
//  Broadcast
//
//  Created by Piotr Suwara on 18/11/20.
//

import Foundation
import RxSwift
import RxCocoa

class LocalAPIService : APIService {
    
    // MARK: Mock objects
    static let mockThumbnail = "https://cdn.lifestyleasia.com/wp-content/uploads/sites/6/2020/03/17155127/alo.jpg"
    static let mockPostVideo = Post.PostVideo(videoState: .available, videoProcessingStatus: .ready, postVideoUrl: "")
    
    // MARK: Local mock data
    let mockPostData: [Post] = [
        Post(id: "1", title: "Test", caption: "Test", comments: 100, lockers: 50, thumbnailUrl: LocalAPIService.mockThumbnail, created: Date(), postVideo: LocalAPIService.mockPostVideo, postImage: nil),
        Post(id: "2", title: "Test 1", caption: "Test 1", comments: 12, lockers: 88, thumbnailUrl: LocalAPIService.mockThumbnail, created: Date(), postVideo: LocalAPIService.mockPostVideo, postImage: nil),
        Post(id: "3", title: "Test 2", caption: "Test 2", comments: 12, lockers: 41, thumbnailUrl: LocalAPIService.mockThumbnail, created: Date(), postVideo: LocalAPIService.mockPostVideo, postImage: nil),
        Post(id: "4", title: "Test 3", caption: "Test 3", comments: 50, lockers: 12,  thumbnailUrl: LocalAPIService.mockThumbnail, created: Date(), postVideo: LocalAPIService.mockPostVideo, postImage: nil),
        Post(id: "5", title: "This is a great title!", caption: "This is a caption", comments: 50, lockers: 12, thumbnailUrl: LocalAPIService.mockThumbnail, created: Date(), postVideo: LocalAPIService.mockPostVideo, postImage: nil),
    ]
    
    func retrieveMyPosts() -> Single<RetrieveMyPostsResponse> {
        let single = Single<RetrieveMyPostsResponse>.create { [unowned self] observer in
            observer(.success(RetrieveMyPostsResponse(posts: self.mockPostData)))
            return Disposables.create { }
        }
        return single
    }
}

// MARK: - Instance

extension LocalAPIService {
    static let standard = {
        LocalAPIService()
    }()
}
