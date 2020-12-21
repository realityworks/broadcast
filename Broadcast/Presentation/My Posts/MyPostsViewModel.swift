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
    
    init(dependencies: Dependencies = .standard) {
        
        self.postContentUseCase = dependencies.postContentUseCase
        self.newPostsLoadedSignal = newPostsLoadedSubject.asObservable()
        
        self.myPostsObservable = dependencies.myPostsObservable
            .map { posts in
                return posts.map {
                    let thumbnailUrl = URL(string: $0.postMedia.thumbnailUrl)
                    
                    let viewModel = MyPostsCellViewModel(
                        postId: $0.id,
                        title: $0.title,
                        caption: $0.caption,
                        thumbnailUrl: thumbnailUrl,
                        media: $0.contentMedia,
                        isEncoding: !$0.finishedProcessing,
                        dateCreated: "Created \($0.created.timeAgo()) ago",
                        commentCount: $0.commentCount,
                        lockerCount: $0.lockerCount)
                    return viewModel
                }
            }
        
        super.init(stateController: dependencies.stateController)
        
        self.myPostsObservable
            .subscribe(onNext: { _ in
                self.newPostsLoadedSubject.onNext(())
            })
            .disposed(by: disposeBag)
    }

    func refreshMyPostsList() {
        postContentUseCase.retrieveMyPosts()
    }
    
    func selectPost(with postId: PostID) {
        postContentUseCase.selectPost(with: postId)
        selectedSubject.accept(())
    }
}

/// MainViewModel dependencies component
extension MyPostsViewModel {
    struct Dependencies {
        
        let stateController: StateController
        let postContentUseCase: PostContentUseCase
        let myPostsObservable: Observable<[Post]>
        
        static var standard: Dependencies {
            return Dependencies(
                stateController: Domain.standard.stateController,
                postContentUseCase: Domain.standard.useCases.postContentUseCase,
                myPostsObservable: Domain.standard.stateController.stateObservable(of: \.myPosts, distinct: false))
        }
    }
}
