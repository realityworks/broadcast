//
//  APIService.swift
//  Broadcast
//
//  Created by Piotr Suwara on 18/11/20.
//

import Foundation
import RxSwift
import RxCocoa
import RxAlamofire

protocol APIService {
    func inject(credentialsService: CredentialsService)
    
    func createPost() -> Single<CreatePostResponse>
    func getUploadableMediaEndpoint() -> Single<GetUploadableMediaEndpointResponse>
    func uploadVideo(from fromUrl: URL, to toUrl: URL) -> Observable<(Data?, RxProgress)>
    
    
    func loadMyPosts() -> Single<LoadMyPostsResponse>
    func loadProfile() -> Single<LoadProfileResponse>
    func updateProfile(withDisplayName displayName: String, biography: String) -> Completable
    func uploadProfileImage(withData: Data) -> Completable
}
