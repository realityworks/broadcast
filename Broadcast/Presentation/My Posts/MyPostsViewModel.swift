//
//  MyPostsViewModel.swift
//  Broadcast
//
//  Created by Piotr Suwara on 20/11/20.
//

import UIKit
import RxSwift
import RxCocoa

class MyPostsViewModel : ViewModel {
    
    private let postContentUseCase: PostContentUseCase
    
    let myPostsObservable: Observable<[MyPostCellViewModel]>
    
    init(dependencies: Dependencies = .standard) {
        
        self.postContentUseCase = dependencies.postContentUseCase
        self.myPostsObservable = dependencies.myPostsObservable
            .map { posts in
                return posts.map { _ in
                    MyPostCellViewModel(title: "",
                                        thumbnailURL: URL(string: ""),
                                        isEncoding: false,
                                        dateCreated: "Created yesterday",
                                        commentCount: 100,
                                        lockerCount: 100)
                }
            }
        
        super.init(stateController: dependencies.stateController)
    }
    
    
    func refreshMyPostsList() {
        
    }
}

/// MainViewModel dependencies component
extension MyPostsViewModel {
    struct Dependencies {
        
        let stateController: StateController
        let postContentUseCase: PostContentUseCase
        let myPostsObservable: Observable<[Post]>
        
        static let standard = Dependencies(
            stateController: Domain.standard.stateController,
            postContentUseCase: Domain.standard.useCases.postContentUseCase,
            myPostsObservable: Domain.standard.stateController.stateObservable(of: \.myPosts))
        
    }
}
