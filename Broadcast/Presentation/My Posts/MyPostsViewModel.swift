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
    
    init(dependencies: Dependencies = .standard) {
        
        self.postContentUseCase = dependencies.postContentUseCase
        self.myPostsObservable = dependencies.myPostsObservable
            .map { posts in
                return posts.map { post in
                    #warning("Setup all the parameters in the data model")
                    return MyPostsCellViewModel(
                        postId: post.id,
                        title: post.title,
                        thumbnailURL: URL(string: post.thumbnailUrl),
                        isEncoding: false,
                        dateCreated: "Created yesterday",
                        commentCount: post.comments,
                        lockerCount: post.lockers)
                }
            }
        
        super.init(stateController: dependencies.stateController)
    }

    func refreshMyPostsList() {
        postContentUseCase.retrieveMyPosts()
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
                myPostsObservable: Domain.standard.stateController.stateObservable(of: \.myPosts))
        }
    }
}
