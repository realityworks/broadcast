//
//  ProfileUseCase.swift
//  Broadcast
//
//  Created by Piotr Suwara on 18/11/20.
//

import Foundation
import RxSwift

class ProfileUseCase {
    typealias T = ProfileUseCase
    
    var stateController: StateController!
    private let apiService: APIService
    
    let disposeBag = DisposeBag()
    
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

// MARK: - Functions

extension ProfileUseCase {
    func loadProfile() {
        apiService.loadProfile()
            .subscribe(onSuccess: { [self] profileResponse in
                stateController.state.profile = profileResponse.profile
            }, onError: { [self] error in
                #warning("TODO - Add error handling")
//                if case BoomdayError.notAuthenticated = error {
//                    stateController.state.sendError(.notAuthenticated)
//                } else {
//                    Logger.log(level: .warning, topic: .authentication, message: "Unable to load account details")
//                }
            })
            .disposed(by: disposeBag)
    }
    
    func updateProfile(displayName: String, biography: String) {
        
    }
}
