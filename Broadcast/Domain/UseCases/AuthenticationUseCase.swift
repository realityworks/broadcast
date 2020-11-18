//
//  AuthenticationUseCase.swift
//  Broadcast
//
//  Created by Piotr Suwara on 18/11/20.
//

import Foundation

class AuthenticationUseCase {
    typealias T = AuthenticationUseCase
    
    let authenticationService: AuthenticationService
    var stateController: StateController!
    
    init(authenticationService: AuthenticationService) {
        self.authenticationService = authenticationService
    }
}
    
// MARK: - StateControllerInjector

extension AuthenticationUseCase : StateControllerInjector {
    @discardableResult
    func with(stateController: StateController) -> AuthenticationUseCase {
        self.stateController = stateController
        return self
    }
}

// MARK: - Instances

extension AuthenticationUseCase {
    static let standard = {
        return AuthenticationUseCase(authenticationService: Services.local.authenticationService)
    }()
}
