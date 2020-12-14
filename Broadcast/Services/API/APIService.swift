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
    func inject(credentialsService: CredentialsService)
    func loadMyPosts() -> Single<LoadMyPostsResponse>
    func loadProfile() -> Single<LoadProfileResponse>
    func updateProfile(withDisplayName displayName: String, biography: String) -> Completable
    func uploadProfileImage(withData: Data) -> Completable
}
