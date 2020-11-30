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
    
    let postObservable: Observable<PostSummaryViewModel>
    let postCaption: Observable<String>
    
    init(dependencies: Dependencies = .standard) {
        
        #warning("Fix thumbnail URL")
        postObservable = Observable.combineLatest(dependencies.myPosts,
                                                  dependencies.selectedPostId) { myPosts, selectedPostId in
                myPosts.first(where: { $0.id == selectedPostId })
            }
            .compactMap { $0 }
            .map { PostSummaryViewModel(title: $0.title,
                                        thumbnailURL: nil,
                                        commentCount: $0.comments,
                                        lockerCount: $0.lockers,
                                        dateCreated: "",
                                        isEncoding: <#T##Bool#>)}
            //.compactMap {  }
        
        postCaption = postObservable.map { $0.caption }
        
        super.init(stateController: dependencies.stateController)
    }
}

/// NewPostViewModel dependencies component
extension PostDetailViewModel {
    struct Dependencies {
        
        let stateController: StateController
        let myPosts: Observable<[Post]>
        let selectedPostId: Observable<PostID?>
        
        static let standard = Dependencies(
            stateController: StateController.standard,
            myPosts: Domain.standard.stateController.stateObservable(of: \.myPosts),
            selectedPostId: Domain.standard.stateController.stateObservable(of: \.selectedPostId))
    }
}
