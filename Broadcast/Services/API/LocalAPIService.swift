//
//  LocalAPIService.swift
//  Broadcast
//
//  Created by Piotr Suwara on 18/11/20.
//

import Foundation
import RxSwift
import RxCocoa
import RxAlamofire
import Alamofire

class LocalAPIService {
    
    // MARK: Mock objects
    static let mockThumbnailUrl = "https://cdn.lifestyleasia.com/wp-content/uploads/sites/6/2020/03/17155127/alo.jpg"
    static let mockPortraitUrl = "https://d1k8hez1mxkuxw.cloudfront.net/external_data/64969944-s10/127582414.jpeg"
    static let mockVideoUrl = "https://multiplatform-f.akamaihd.net/i/multi/april11/sintel/sintel-hd_,512x288_450_b,640x360_700_b,768x432_1000_b,1024x576_1400_m,.mp4.csmil/master.m3u8"
    static let mockPostVideo = Post.PostMedia(id: "1",
                                              thumbnailUrl: LocalAPIService.mockThumbnailUrl,
                                              contentUrl: LocalAPIService.mockVideoUrl,
                                              contentType: .video)
    
    // MARK: Local mock data
    let mockPostData: [Post] = [
        Post(id: "1",
             title: "Title 1",
             caption: "Caption 1",
             commentCount: 100,
             lockerCount: 120,
             finishedProcessing: true,
             created: Date(),
             postMedia: LocalAPIService.mockPostVideo),
        Post(id: "2",
             title: "Title 2",
             caption: "Caption 2",
             commentCount: 100,
             lockerCount: 120,
             finishedProcessing: true,
             created: Date(),
             postMedia: LocalAPIService.mockPostVideo),
        Post(id: "3",
             title: "Title 3",
             caption: "Caption 3",
             commentCount: 100,
             lockerCount: 120,
             finishedProcessing: true,
             created: Date(),
             postMedia: LocalAPIService.mockPostVideo),
        Post(id: "4",
             title: "Title 4",
             caption: "Caption 4",
             commentCount: 100,
             lockerCount: 120,
             finishedProcessing: true,
             created: Date(),
             postMedia: LocalAPIService.mockPostVideo),
        Post(id: "5",
             title: "Title 5",
             caption: "Caption 5",
             commentCount: 100,
             lockerCount: 120,
             finishedProcessing: true,
             created: Date(),
             postMedia: LocalAPIService.mockPostVideo),
        Post(id: "6",
             title: "Title 6",
             caption: "Caption 6",
             commentCount: 100,
             lockerCount: 120,
             finishedProcessing: true,
             created: Date(),
             postMedia: LocalAPIService.mockPostVideo)
    ]
    
    let mockProfileData: Profile = Profile(
        firstName: "First",
        lastName: "Suwara",
        biography: "This is a big hope",
        displayName: "DisplayName@display.com",
        subscribers: 2311,
        thumbnailUrl: LocalAPIService.mockPortraitUrl,
        trailerUrl: LocalAPIService.mockVideoUrl,
        stripeAccount: Profile.StripeAccount(
            name: "stripeaccount@stripe.com",
            id: "prod_iUmEPMQJFjaLs6",
            currencyCode: CurrencyCode.gdp,
            pricing: 10.0,
            balance: 80.0,
            totalVolume: 100.0,
            paymentsDisabled: false,
            payoutsDisabled: false))
}

// MARK: - Instance

extension LocalAPIService {
    static let standard = {
        LocalAPIService()
    }()
}

// MARK: - Functions

extension LocalAPIService : APIService {
    
    func createPost() -> Single<CreatePostResponse> {
        let single = Single<CreatePostResponse>.create { observer in
            observer(.success(CreatePostResponse(postId: "")))
            return Disposables.create { }
        }
        return single
    }
    
    func getUploadUrl(forPostID postID: PostID, for media: Media) -> Single<GetUploadUrlResponse> {
        let single = Single<GetUploadUrlResponse>.create { observer in
            observer(.success(GetUploadUrlResponse(uploadUrl: "", mediaId: "")))
            return Disposables.create { }
        }
        return single
    }
    
    func uploadVideo(from fromUrl: URL, to toUrl: URL) -> Observable<(HTTPURLResponse, RxProgress)> {
        return Observable<(HTTPURLResponse, RxProgress)>.create { observer in
            
            DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 10, execute: {
                observer.onNext((HTTPURLResponse(), RxProgress(bytesWritten: 1, totalBytes: 1)))
                observer.onCompleted()
              })
            
            return Disposables.create()
        }
    }
    
    func mediaComplete(for postId: PostID, _ mediaId: MediaID) -> Completable {
        return Completable.empty()
    }
    
    func updatePostContent(postId: PostID, newContent: PostContent) -> Completable {
        return Completable.empty()
    }
    
    func publish(postId: PostID) -> Completable  {
        return Completable.empty()
    }
    
    func loadMyPosts() -> Single<LoadMyPostsResponse> {
        let single = Single<LoadMyPostsResponse>.create { [unowned self] observer in
            observer(.success(LoadMyPostsResponse(posts: self.mockPostData)))
            return Disposables.create { }
        }
        return single
    }
    
    func loadProfile() -> Single<LoadProfileResponse> {
        let single = Single<LoadProfileResponse>.create { [unowned self] observer in
            observer(.success(LoadProfileResponse(profile: self.mockProfileData)))
            return Disposables.create { }
        }
        return single
    }
    
    func updateProfile(withDisplayName displayName: String, biography: String) -> Completable {
        return .empty()
    }
    
    func uploadProfileImage(withData: Data) -> Completable {
        return .empty()
    }
    
    func inject(credentialsService: CredentialsService) {
        // Nothing needed here
    }
}
