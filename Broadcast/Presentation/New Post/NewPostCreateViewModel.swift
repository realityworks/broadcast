//
//  NewPostCreateViewModel.swift
//  Broadcast
//
//  Created by Piotr Suwara on 8/12/20.
//

import Foundation
import RxSwift
import RxCocoa


class NewPostCreateViewModel : ViewModel {
    
    let postContentUseCase: PostContentUseCase
    
    let title = BehaviorRelay<String>(value: "")
    let caption = BehaviorRelay<String>(value: "")
    
    var postId: PostID? = nil
    var mediaId: MediaID? = nil
    var uploadUrl: URL? = nil
    
    init(dependencies: Dependencies = .standard) {
        self.postContentUseCase = dependencies.postContentUseCase
        
        super.init(stateController: dependencies.stateController)
    }
}

// MARK: - Dependencies

extension NewPostCreateViewModel {
    struct Dependencies {
        
        let stateController: StateController
        let postContentUseCase: PostContentUseCase
        
        static let standard = Dependencies(
            stateController: Domain.standard.stateController,
            postContentUseCase: Domain.standard.useCases.postContentUseCase)
    }
}

// MARK: - Functions

extension NewPostCreateViewModel {
    func uploadPost() {
        // Compose post and upload
        let newPost = PostContent(title: title.value, caption: caption.value)
        postContentUseCase.upload(content: newPost)
    }
    
    func createPost() {
        postContentUseCase.apiService.createPost()
            .subscribe { [weak self] response in
                print(response)
                self?.postId = response.postId
            } onError: { error in
                print(error)
            }
            .disposed(by: disposeBag)
    }
    
    func requestUploadUrl() {
        guard let postId = postId,
              let media = stateController.state.selectedMedia else { return }
        
        postContentUseCase.apiService.getUploadUrl(forPostID: postId, for: media)
            .subscribe { [weak self] response in
                print(response)
                self?.mediaId = response.mediaId
                self?.uploadUrl = URL(string: response.uploadUrl)
            } onError: { error in
                print(error)
            }
            .disposed(by: disposeBag)
    }
    
    func uploadFile() {
        guard
            let selectedMedia = stateController.state.selectedMedia,
            case Media.video(let url) = selectedMedia,
            let uploadUrl = uploadUrl else { return }
        postContentUseCase.apiService.uploadVideo(from: url, to: uploadUrl)
            .subscribe { response, progress in
                print ("PROGRESS : \(progress.bytesWritten) / \(progress.totalBytes)")
            } onError: { error in
                print ("ERROR: \(error)")
            } onCompleted: {
                print ("COMPLETED!")
            } onDisposed: {
                print ("DISPOSED!")
            }
            .disposed(by: disposeBag)
    }
    
    func completeFileUpload() {
        guard let postId = postId,
              let mediaId = mediaId else { return }
        postContentUseCase.apiService.mediaComplete(for: postId, mediaId)
            .subscribe {
                print ("FINALIZED MEDIA UPLOAD COMPLETE")
            } onError: { error in
                print (error)
            }
            .disposed(by: disposeBag)
    }
    
    func updateContent() {
        guard let postId = postId else { return }
        let newPost = PostContent(title: title.value, caption: caption.value)
        postContentUseCase.apiService.updatePostContent(
            postId: postId,
            newContent: newPost)
            .subscribe {
                print ("FINALIZED MEDIA UPLOAD COMPLETE")
            } onError: { error in
                print (error)
            }
            .disposed(by: disposeBag)
    }
    
    func publish() {
        guard let postId = postId else { return }
        postContentUseCase.apiService.publish(postId: postId)
            .subscribe {
                print ("PUBLISHED POST!")
            } onError: { error in
                print (error)
            }
            .disposed(by: disposeBag)
    }
}
