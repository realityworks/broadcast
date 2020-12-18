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
    
    func selectMedia(with media: Media) {
        stateController.state.selectedMedia = media
    }
    
    func upload(content: PostContent) {
        guard let selectedMedia = stateController.state.selectedMedia else { return }
        uploadService.upload(media: selectedMedia,
                             content: content)
            .subscribe(onNext: { uploadProgress in
                Logger.log(level: .info, topic: .api, message: "Upload progress : \(uploadProgress.progress)")
                #warning("TODO : Push this into an upload progress indicator")
            }, onCompleted: {
                print ("COMPLETED!")
            })
            .disposed(by: disposeBag)
    }
    
    func retrieveMyPosts() {
        // Load posts into the app state
        apiService.loadMyPosts()
            .subscribe(onSuccess: { [unowned self] response in
                self.stateController.state.myPosts = response.posts
            }, onError: { [unowned self] error in
                #warning("TODO")
                Logger.log(level: .warning, topic: .api, message: "Failed to load posts \(error)")
            })
            .disposed(by: disposeBag)
    }
}
