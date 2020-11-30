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
    
    let postObservable: Observable<Post>
    
    init(postId: PostID, dependencies: Dependencies = .standard) {
        postObservable = dependencies.myPosts
            .compactMap { $0.first(where: { $0.id == postId }) }
        
        super.init(stateController: dependencies.stateController)
    }
}

/// NewPostViewModel dependencies component
extension PostDetailViewModel {
    struct Dependencies {
        
        let stateController: StateController
        let myPosts: Observable<[Post]>
        
        static let standard = Dependencies(
            stateController: StateController.standard,
            myPosts: Domain.standard.stateController.stateObservable(of: \.myPosts))
    }
}
