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
    
    private let postContentUseCase: PostContentUseCase
    
    let title = BehaviorRelay<String?>(value: nil)
    let caption = BehaviorRelay<String?>(value: nil)
    
    init(dependencies: Dependencies = .standard) {
        self.postContentUseCase = dependencies.postContentUseCase
        
        super.init(stateController: dependencies.stateController)
    }
}

/// LoginViewModel dependencies component
extension NewPostCreateViewModel {
    struct Dependencies {
        
        let stateController: StateController
        let postContentUseCase: PostContentUseCase
        
        static let standard = Dependencies(
            stateController: Domain.standard.stateController,
            postContentUseCase: Domain.standard.useCases.postContentUseCase)
    }
}
