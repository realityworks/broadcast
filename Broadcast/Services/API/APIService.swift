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
    func getMediaUploadUrl(forPostID postID: PostID, for media: Media) -> Single<GetMediaUploadUrlResponse>
    func uploadMedia(from fromUrl: URL, to toUrl: URL) -> Observable<(HTTPURLResponse?, RxProgress)>
    func uploadMediaComplete(for postId: PostID, _ mediaId: MediaID) -> Completable
    func updatePostContent(postId: PostID, newContent: PostContent) -> Completable
    func publish(postId: PostID) -> Completable
    
    func getTrailerUploadUrl() -> Single<GetTrailerUploadUrlResponse>
    func uploadTrailerComplete() -> Completable
    
    func loadMyPosts() -> Single<LoadMyPostsResponse>
    func deletePost(with postId: PostID) -> Completable
    func loadProfile() -> Single<LoadProfileResponse>
    func updateProfile(withDisplayName displayName: String, biography: String) -> Completable
    func uploadProfileImage(withData: Data) -> Observable<RxProgress>
}
