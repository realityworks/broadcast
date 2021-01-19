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
    
    let apiService: APIService
    private let uploadService: UploadService
    private let schedulers: Schedulers
    
    init(dependencies: Dependencies = .standard) {
        self.apiService = dependencies.apiService
        self.uploadService = dependencies.uploadService
        self.schedulers = dependencies.schedulers
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
        return PostContentUseCase(dependencies: .standard)
    }()
}


// MARK: - Dependencies

extension PostContentUseCase {
    struct Dependencies {
        let apiService: APIService
        let uploadService: UploadService
        let schedulers: Schedulers
        
        static let standard = Dependencies(
            apiService: Services.standard.apiService,
            uploadService: Services.standard.uploadService,
            schedulers: Schedulers.standard)
    }
}

// MARK: - Functions

extension PostContentUseCase {
    func selectPost(with postId: PostID) {
        stateController.state.selectedPostId = postId
    }
    
    func prepareUploadMedia() {
        stateController.state.currentMediaUploadProgress = nil
    }
        
    func upload(content: PostContent, media: Media) {
        /// Set the initial upload progress to be simply default values
        stateController.state.currentMediaUploadProgress = UploadProgress()
        
        uploadService.upload(media: media,
                             content: content)
            .subscribe(onNext: { uploadProgress in
                Logger.log(level: .info, topic: .api, message: "Upload progress : \(uploadProgress.progress)")
                self.stateController.state.currentMediaUploadProgress = uploadProgress
            }, onError: { error in
                self.stateController.state.currentMediaUploadProgress?.failed = true
                if let boomDayError = error as? BoomdayError {
                    self.stateController.state.currentMediaUploadProgress?.errorDescription = boomDayError.localizedDescription
                } else {
                    self.stateController.state.currentMediaUploadProgress?.errorDescription = error.localizedDescription
                }
                self.stateController.sendError(error)
            }, onCompleted: {
                Logger.log(level: .info, topic: .api, message: "Post content complete!")
                self.stateController.state.currentMediaUploadProgress?.completed = true
            })
            .disposed(by: disposeBag)
    }
    
    func retrieveMyPosts() {
        // Load posts into the app state
        stateController.state.isLoadingPosts = true
        apiService.loadMyPosts()
            .subscribe(onSuccess: { [unowned self] response in
                self.stateController.state.isLoadingPosts = false
                self.stateController.state.myPosts = response
            }, onFailure: { [unowned self] error in
                Logger.log(level: .warning, topic: .api, message: "Failed to load posts \(error)")
                self.stateController.state.isLoadingPosts = false
                self.stateController.sendError(error)
                self.stateController.state.myPosts = []
            })
            .disposed(by: disposeBag)
    }
    
    func deletePost(with postId: PostID) -> Completable {
        return apiService.deletePost(with: postId).do(onError: { error in
                self.stateController.sendError(error)
            }, onCompleted: {
                self.stateController.state.myPosts?.removeAll(where: { $0.id == postId })
            })
            .observe(on: schedulers.main)

    }
}
