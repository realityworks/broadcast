//
//  APIService.swift
//  Broadcast
//
//  Created by Piotr Suwara on 18/11/20.
//

import Foundation
import RxSwift
import RxCocoa

protocol APIService {
    func retrieveMyPosts() -> Single<RetrieveMyPostsResponse>
}
