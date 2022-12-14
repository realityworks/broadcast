//
//  MyPostsViewModel.swift
//  Broadcast
//
//  Created by Piotr Suwara on 20/11/20.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class MyPostsViewModel : ViewModel {
    
    private let postContentUseCase: PostContentUseCase
    
    let myPostsObservable: Observable<[MyPostsCellViewModel]>
    let selectedSubject = PublishRelay<()>()
    
    private let newPostsLoadedSubject = PublishSubject<()>()
    let newPostsLoadedSignal: Observable<()>
    
    private let createPostSubject = PublishRelay<()>()
    let createPostSignal: Observable<()>
    
    let isLoadingPostsFirstTimeObservable: Observable<Bool>
    let isPostListEmptyObservable: Observable<Bool>
    
    init(dependencies: Dependencies = .standard) {
        
        self.postContentUseCase = dependencies.postContentUseCase
        self.newPostsLoadedSignal = newPostsLoadedSubject.asObservable()
        
        self.isLoadingPostsFirstTimeObservable = Observable.combineLatest(
                dependencies.isLoadingPostsObservable,
                dependencies.myPostsObservable.map { $0 == nil }) { isLoading, nilPosts in
                return isLoading && nilPosts
            }
        
        self.isPostListEmptyObservable = dependencies.myPostsObservable
            .compactMap { $0 }
            .map { $0.count == 0 }
                
        self.myPostsObservable = dependencies.myPostsObservable.compactMap { $0 }
            .map { posts in
                return posts.map {
                    let thumbnailUrl = URL(string: $0.postMedia.thumbnailUrl)
                    let viewModel = MyPostsCellViewModel(
                        postId: $0.id,
                        title: $0.title,
                        caption: $0.caption,
                        thumbnailUrl: thumbnailUrl?.appendingQueryItem("utc", value: "\(Int64(Date.now.timeIntervalSince1970*1000))"),
                        media: $0.contentMedia,
                        isEncoding: !$0.finishedProcessing,
                        dateCreated: String.localizedWithFormat(
                            LocalizedString.createdAgo,
                            $0.created.timeAgo()),
                        commentCount: $0.commentCount,
                        lockerCount: $0.lockerCount)
                    return viewModel
                }
            }
        
        self.createPostSignal = createPostSubject.asObservable()
        
        super.init(stateController: dependencies.stateController)
        
        self.myPostsObservable
            .subscribe(onNext: { _ in
                self.newPostsLoadedSubject.onNext(())
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Dependencies

extension MyPostsViewModel {
    struct Dependencies {
        
        let stateController: StateController
        let postContentUseCase: PostContentUseCase
        let myPostsObservable: Observable<[Post]?>
        let isLoadingPostsObservable: Observable<Bool>
        let willEnterForeground: Observable<Void>
        
        static var standard: Dependencies {
            let notificationCenter = NotificationCenter.default.rx
            return Dependencies(
                stateController: Domain.standard.stateController,
                postContentUseCase: Domain.standard.useCases.postContentUseCase,
                myPostsObservable: Domain.standard.stateController.stateObservable(of: \.myPosts, distinct: false),
                isLoadingPostsObservable: Domain.standard.stateController.stateObservable(of: \.isLoadingPosts),
                willEnterForeground: notificationCenter.notification(UIApplication.willEnterForegroundNotification).map { _ in () })
        }
    }
}

// MARK: - ViewModel Functions

extension MyPostsViewModel {
    func refreshMyPostsList() {
        postContentUseCase.retrieveMyPosts()
    }
    
    func selectPost(with postId: PostID) {
        postContentUseCase.selectPost(with: postId)
        selectedSubject.accept(())
    }
    
    func createPost() {
        createPostSubject.accept(())
    }
}
