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
}
