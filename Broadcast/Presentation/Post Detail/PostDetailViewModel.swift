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
    
    let schedulers: Schedulers
    private let postContentUseCase: PostContentUseCase
    private let isEditingSubject = BehaviorRelay<Bool>(value: false)
    
    let postSummary: Observable<PostSummaryViewModel>
    private let postIdRelay = BehaviorRelay<PostID?>(value: nil)
    
    let deletedSubject = PublishSubject<()>()
    
    private let isDeletingRelay = BehaviorRelay<Bool>(value: false)
    let isDeleting: Observable<Bool>
    
    private let deleteButtonEnabledRelay = BehaviorRelay<Bool>(value: true)
    let deleteButtonEnabled: Observable<Bool>
    
    init(dependencies: Dependencies = .standard) {
        
        self.schedulers = dependencies.schedulers
        
        let postObservable = Observable.combineLatest(
            dependencies.myPosts.compactMap { $0 },
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
                dateCreated: String.localizedStringWithFormat(
                    LocalizedString.createdAgo,
                    $0.created.timeAgo()),
                isEncoding: !$0.finishedProcessing,
                showVideoPlayer: true)
        }
        
        self.postContentUseCase = dependencies.postContentUseCase
        self.isDeleting = isDeletingRelay.asObservable()
        self.deleteButtonEnabled = deleteButtonEnabledRelay.asObservable()
        
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
        guard let postId = postIdRelay.value else { return }
        isDeletingRelay.accept(true)
        deleteButtonEnabledRelay.accept(false)
        postContentUseCase.deletePost(with: postId)
            .subscribe(onCompleted: {
                self.postContentUseCase.retrieveMyPosts()
                self.isDeletingRelay.accept(false)
                self.deletedSubject.onNext(())
            }, onError: { _ in
                self.deleteButtonEnabledRelay.accept(true)
                self.isDeletingRelay.accept(false)
            })
            .disposed(by: disposeBag)

    }
}

// MARK: Dependencies
extension PostDetailViewModel {
    struct Dependencies {
        
        let stateController: StateController
        let schedulers: Schedulers
        let postContentUseCase: PostContentUseCase
        let myPosts: Observable<[Post]?>
        let selectedPostId: Observable<PostID?>
        
        static let standard = Dependencies(
            stateController: StateController.standard,
            schedulers: Schedulers.standard,
            postContentUseCase: Domain.standard.useCases.postContentUseCase,
            myPosts: Domain.standard.stateController.stateObservable(of: \.myPosts),
            selectedPostId: Domain.standard.stateController.stateObservable(of: \.selectedPostId))
    }
}
