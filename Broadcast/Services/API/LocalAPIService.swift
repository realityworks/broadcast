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
    static let mockThumbnailUrl = "https://cdn.lifestyleasia.com/wp-content/uploads/sites/6/2020/03/17155127/alo.jpg"
    static let mockPortraitUrl = "https://d1k8hez1mxkuxw.cloudfront.net/external_data/64969944-s10/127582414.jpeg"
    static let mockVideoUrl = "https://multiplatform-f.akamaihd.net/i/multi/april11/sintel/sintel-hd_,512x288_450_b,640x360_700_b,768x432_1000_b,1024x576_1400_m,.mp4.csmil/master.m3u8"
    static let mockPostVideo = Post.PostVideo(videoState: .available, videoProcessingStatus: .ready, postVideoUrl: LocalAPIService.mockVideoUrl)
    
    // MARK: Local mock data
    let mockPostData: [Post] = [
        Post(id: "1", title: "Test", caption: "Test", comments: 100, lockers: 50, thumbnailUrl: LocalAPIService.mockThumbnailUrl, created: Date(), postVideo: LocalAPIService.mockPostVideo, postImage: nil),
        Post(id: "2", title: "Test 1", caption: "Test 1", comments: 12, lockers: 88, thumbnailUrl: LocalAPIService.mockThumbnailUrl, created: Date(), postVideo: LocalAPIService.mockPostVideo, postImage: nil),
        Post(id: "3", title: "Test 2", caption: "Test 2", comments: 12, lockers: 41, thumbnailUrl: LocalAPIService.mockThumbnailUrl, created: Date(), postVideo: LocalAPIService.mockPostVideo, postImage: nil),
        Post(id: "4", title: "Test 3", caption: "Test 3", comments: 50, lockers: 12,  thumbnailUrl: LocalAPIService.mockThumbnailUrl, created: Date(), postVideo: LocalAPIService.mockPostVideo, postImage: nil),
        Post(id: "5", title: "This is a great title!", caption: "This is a caption", comments: 50, lockers: 12, thumbnailUrl: LocalAPIService.mockThumbnailUrl, created: Date(), postVideo: LocalAPIService.mockPostVideo, postImage: nil),
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
            currency: "$",
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

extension LocalAPIService {
    
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
}
