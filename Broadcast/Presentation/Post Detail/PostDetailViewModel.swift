//
//  PostDetailViewModel.swift
//  Broadcast
//
//  Created by Piotr Suwara on 20/11/20.
//

import Foundation

class PostDetailViewModel : ViewModel {
    
    init(dependencies: Dependencies = .standard) {
        super.init(stateController: dependencies.stateController)
        
    }

    
    /// Configure the view model from the PostID passed into this function.
    /// Model will be updated with the new post detail
    func configure(withPostID postID: PostID) {
        
    }
}

/// NewPostViewModel dependencies component
extension PostDetailViewModel {
    struct Dependencies {
        
        let stateController: StateController
        
        static let standard = Dependencies(
            stateController: StateController.standard)
        
    }
}
