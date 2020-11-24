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
    private let credentialsService: CredentialsService
    
    init(dependencies: Dependencies = .standard) {
        self.authenticationService = dependencies.authenticationService
        self.credentialsService = dependencies.credentialsService
    }
    
    func login(username: String,
               password: String) {
        credentialsService.clearCredentials()
        authenticationService.authenticate(withUsername: username,
                                           password: password)
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
        return AuthenticationUseCase(dependencies: .standard)
    }()
}

// MARK: - Dependencies

extension AuthenticationUseCase {
    struct Dependencies {
        let authenticationService: AuthenticationService
        let credentialsService: CredentialsService
        
        static let standard = Dependencies(
            authenticationService: Services.local.authenticationService,
            credentialsService: Services.local.credentialsService)
    }
}
