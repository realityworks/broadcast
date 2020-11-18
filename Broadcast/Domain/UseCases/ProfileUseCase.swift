//
//  ProfileUseCase.swift
//  Broadcast
//
//  Created by Piotr Suwara on 18/11/20.
//

import Foundation

class ProfileUseCase {
    typealias T = ProfileUseCase
    
    let apiService: APIService
    var stateController: StateController!
    
    init(apiService: APIService) {
        self.apiService = apiService
    }
}

// MARK: - StateControllerInjector

extension ProfileUseCase : StateControllerInjector {
    @discardableResult
    func with(stateController: StateController) -> ProfileUseCase {
        self.stateController = stateController
        return self
    }
}

// MARK: - Instances

extension ProfileUseCase {
    static let standard = {
        return ProfileUseCase(apiService: Services.local.apiService)
    }()
}
