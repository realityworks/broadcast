//
//  UseCases.swift
//  Broadcast
//
//  Created by Piotr Suwara on 16/11/20.
//

import Foundation

/// Collection of the usecases available to the application. Each use case manages a specific
/// set of commands that are service independant
/// Usecases are the bridge between `Services` and `State`. This bridge is managed
/// by the `StateController`
class UseCases {
    typealias T = UseCases
    
    var stateController: StateController!
    
    let authenticationUseCase: AuthenticationUseCase
    let profileUseCase: ProfileUseCase
    let postContentUseCase: PostContentUseCase
    let appLifeCycleUseCase: AppLifeCycleUseCase
    let connectivityUseCase: ConnectivityUseCase
    
    init(authenticationUseCase: AuthenticationUseCase,
         profileUseCase: ProfileUseCase,
         postContentUseCase: PostContentUseCase,
         appLifeCycleUseCase: AppLifeCycleUseCase,
         connectivityUseCase: ConnectivityUseCase) {
        self.authenticationUseCase = authenticationUseCase
        self.profileUseCase = profileUseCase
        self.appLifeCycleUseCase = appLifeCycleUseCase
        self.postContentUseCase = postContentUseCase
        self.connectivityUseCase = connectivityUseCase
    }
}

extension UseCases : StateControllerInjector {
    func with(stateController: StateController) -> UseCases {
        self.stateController = stateController
        
        // Inject the StateController into the usecases
        authenticationUseCase.with(stateController: stateController)
        profileUseCase.with(stateController: stateController)
        
        return self
    }
}

// MARK: Instances

extension UseCases {
    static let standard: UseCases = {
        return UseCases(authenticationUseCase: AuthenticationUseCase.standard,
                        profileUseCase: ProfileUseCase.standard,
                        postContentUseCase: PostContentUseCase.standard,
                        appLifeCycleUseCase: AppLifeCycleUseCase.standard,
                        connectivityUseCase: ConnectivityUseCase.standard)
    }()
}
