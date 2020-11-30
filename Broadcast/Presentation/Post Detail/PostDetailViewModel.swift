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
    
    private let isEditingSubject = BehaviorRelay<Bool>(value: false)
    
    let postSummary: Observable<PostSummaryViewModel>
    let postCaption: Observable<String>
    
    init(dependencies: Dependencies = .standard) {
        
        #warning("Fix isEncoding")
        let postObservable = Observable.combineLatest(dependencies.myPosts,
                                                  dependencies.selectedPostId) { myPosts, selectedPostId in
                myPosts.first(where: { $0.id == selectedPostId })
            }
            .compactMap { $0 }
            
        postSummary = postObservable.map { PostSummaryViewModel(title: $0.title,
                                                                thumbnailURL: URL(string: $0.thumbnailUrl),
                                                                commentCount: $0.comments,
                                                                lockerCount: $0.lockers,
                                                                dateCreated: "Created \($0.created.timeAgo())",
                                                                isEncoding: false) }
        postCaption = postObservable.map { $0.caption }
        
        super.init(stateController: dependencies.stateController)
    }
    
    func enableEdit(_ enable: Bool) {
        isEditingSubject.accept(enable)
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
