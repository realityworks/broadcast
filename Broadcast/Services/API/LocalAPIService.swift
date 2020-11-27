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
        Post(id: "2", title: "Test", caption: "Test", postVideo: nil, postImage: nil),
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
