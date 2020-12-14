//
//  PostContentUseCase.swift
//  Broadcast
//
//  Created by Piotr Suwara on 18/11/20.
//

import UIKit
import RxSwift
import RxCocoa

class PostContentUseCase {
    typealias T = PostContentUseCase
    
    var disposeBag = DisposeBag()
    
    var stateController: StateController!
    
    private let apiService: APIService
    private let uploadService: UploadService
    
    init(apiService: APIService, uploadService: UploadService) {
        self.apiService = apiService
        self.uploadService = uploadService
    }
}

// MARK: - StateControllerInjector

extension PostContentUseCase : StateControllerInjector {
    @discardableResult
    func with(stateController: StateController) -> PostContentUseCase {
        self.stateController = stateController
        return self
    }
}

// MARK: - Instances

extension PostContentUseCase {
    static let standard = {
        return PostContentUseCase(
            apiService: Services.local.apiService,
            uploadService: Services.local.uploadService)
    }()
}

// MARK: - Functions

extension PostContentUseCase {
    func selectPost(with postId: PostID) {
        stateController.state.selectedPostId = postId
    }
    
    func selectMedia(with media: Media) {
        stateController.state.selectedMedia = media
    }
    
    func upload(content: PostContent) {
        guard let selectedMedia = stateController.state.selectedMedia else { return }
        uploadService.upload(media: selectedMedia,
                             content: content)
    }
    
    func retrieveMyPosts() {
        // Load posts into the app state
        apiService.loadMyPosts()
            .subscribe(onSuccess: { [unowned self] response in
                self.stateController.state.myPosts = response.posts
            }, onError: { [unowned self] error in
                #warning("TODO")
                Logger.log(level: .error, topic: .api, message: "Failed to load posts \(error)")
            })
            .disposed(by: disposeBag)
    }
}
