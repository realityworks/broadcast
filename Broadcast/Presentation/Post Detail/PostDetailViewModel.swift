//
//  PostDetailViewModel.swift
//  Broadcast
//
//  Created by Piotr Suwara on 20/11/20.
//

import Foundation
import RxSwift
import RxCocoa

class PostDetailViewModel : ViewModel {
    
    private let postContentUseCase: PostContentUseCase
    private let isEditingSubject = BehaviorRelay<Bool>(value: false)
    
    let postSummary: Observable<PostSummaryViewModel>
    private let postIdRelay = BehaviorRelay<PostID?>()
    
    init(dependencies: Dependencies = .standard) {
        let postObservable = Observable.combineLatest(
            dependencies.myPosts,
            dependencies.selectedPostId) { myPosts, selectedPostId in
                myPosts.first(where: { $0.id == selectedPostId })
            }
            .compactMap { $0 }
        
        postSummary = postObservable.map {
            PostSummaryViewModel(
                title: $0.title,
                caption: $0.caption,
                thumbnailUrl: URL(string: $0.postMedia.thumbnailUrl),
                media: $0.contentMedia,
                commentCount: $0.commentCount,
                lockerCount: $0.lockerCount,
                dateCreated: "Created \($0.created.timeAgo())",
                isEncoding: !$0.finishedProcessing,
                showVideoPlayer: true)
        }
        
        self.postContentUseCase = dependencies.postContentUseCase
        
        super.init(stateController: dependencies.stateController)
        
        dependencies.selectedPostId
            .bind(to: postIdRelay)
            .disposed(by: disposeBag)
    }
}

// MARK: Functions
extension PostDetailViewModel {
    func enableEdit(_ enable: Bool) {
        isEditingSubject.accept(enable)
    }
    
    func deletePost() {
        postContentUseCase.delete(post: postIdRelay.value)
    }
}

// MARK: Dependencies
extension PostDetailViewModel {
    struct Dependencies {
        
        let stateController: StateController
        let postContentUseCase: PostContentUseCase
        let myPosts: Observable<[Post]>
        let selectedPostId: Observable<PostID?>
        
        static let standard = Dependencies(
            stateController: StateController.standard,
            postContentUseCase: Domain.standard.useCases.postContentUseCase,
            myPosts: Domain.standard.stateController.stateObservable(of: \.myPosts),
            selectedPostId: Domain.standard.stateController.stateObservable(of: \.selectedPostId))
    }
}
