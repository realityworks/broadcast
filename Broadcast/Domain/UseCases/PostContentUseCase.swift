//
//  PostContentUseCase.swift
//  Broadcast
//
//  Created by Piotr Suwara on 18/11/20.
//

import Foundation

class PostContentUseCase {
    typealias T = PostContentUseCase
    
    let apiService: APIService
    var stateController: StateController!
    
    init(apiService: APIService) {
        self.apiService = apiService
    }
}

// MARK: - StateControllerInjector

extension PostContentUseCase : StateControllerInjector {
    func with(stateController: StateController) -> PostContentUseCase {
        self.stateController = stateController
        return self
    }
}

// MARK: - Instances

extension PostContentUseCase {
    static let standard = {
        return PostContentUseCase(apiService: Services.local.apiService)
    }()
}
