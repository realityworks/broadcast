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
            apiService: Services.standard.apiService,
            uploadService: Services.standard.uploadService)
    }()
}

// MARK: - Functions

extension PostContentUseCase {
    func selectPost(with postId: PostID) {
        stateController.state.selectedPostId = postId
    }
        
    func upload(content: PostContent, media: Media) {
        uploadService.upload(media: media,
                             content: content)
            .subscribe(onNext: { uploadProgress in
                Logger.log(level: .info, topic: .api, message: "Upload progress : \(uploadProgress.progress)")
                self.stateController.state.currentUploadProgress = uploadProgress
            }, onCompleted: {
                Logger.log(level: .info, topic: .api, message: "Post content complete!")
                self.stateController.state.currentUploadProgress?.completed = true
            })
            .disposed(by: disposeBag)
    }
    
    func retrieveMyPosts() {
        // Load posts into the app state
        apiService.loadMyPosts()
            .subscribe(onSuccess: { [unowned self] response in
                self.stateController.state.myPosts = response
            }, onError: { [unowned self] error in
                Logger.log(level: .warning, topic: .api, message: "Failed to load posts \(error)")
                if let error = error as? BoomdayError {
                    self.stateController.sendError(error)
                }
                self.stateController.state.myPosts = []
            })
            .disposed(by: disposeBag)
    }
}
