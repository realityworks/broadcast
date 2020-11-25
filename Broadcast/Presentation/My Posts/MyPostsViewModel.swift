//
//  MyPostsViewModel.swift
//  Broadcast
//
//  Created by Piotr Suwara on 20/11/20.
//

import Foundation

class MyPostsViewModel : ViewModel {
    
    init(dependencies: Dependencies = .standard) {
        super.init(stateController: dependencies.stateController)
        
    }
    
}

/// MainViewModel dependencies component
extension MyPostsViewModel {
    struct Dependencies {
        
        let stateController: StateController
        let postContentUseCase: PostContentUseCase
        
        static let standard = Dependencies(
            stateController: Domain.standard.stateController,
            postContentUseCase: Domain.standard.useCases.postContentUseCase)
        
    }
}
