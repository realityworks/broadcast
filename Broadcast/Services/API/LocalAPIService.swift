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
    
    let mockPostData: [Post] = [
        Post(id: "1", title: "Test", caption: "Test", postVideo: nil, postImage: nil),
        Post(id: "2", title: "Test 1", caption: "Test 1", postVideo: nil, postImage: nil),
        Post(id: "3", title: "Test 2", caption: "Test 2", postVideo: nil, postImage: nil),
        Post(id: "4", title: "Test 3", caption: "Test 3", postVideo: nil, postImage: nil),
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
