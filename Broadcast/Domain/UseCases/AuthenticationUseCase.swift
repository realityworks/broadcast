//
//  AuthenticationUseCase.swift
//  Broadcast
//
//  Created by Piotr Suwara on 18/11/20.
//

import Foundation

/// This use case provides the functionality to authenticate and handles
/// all functions related to authentication
class AuthenticationUseCase {
    typealias T = AuthenticationUseCase
    
    var stateController: StateController!
    
    private let authenticationService: AuthenticationService
    
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
