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
        Post(),
        Post()
    ]
    
    func retrieveMyPosts() -> Single<RetrieveMyPostsResponse> {
        let single = Single<RetrieveMyPostsResponse>.create { [unowned self] observer in
            observer(.success(RetrieveMyPostsResponse(posts: self.mockPostData)))
            return Disposables.create { }
        }
        return single

    }
}
