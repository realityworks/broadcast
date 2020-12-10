//
//  AuthenticationUseCase.swift
//  Broadcast
//
//  Created by Piotr Suwara on 18/11/20.
//

import Foundation
import RxSwift
import RxCocoa

/// This use case provides the functionality to authenticate and handles
/// all functions related to authentication
class AuthenticationUseCase {
    typealias T = AuthenticationUseCase
    
    var stateController: StateController!
    private let authenticationService: AuthenticationService
    private let credentialsService: CredentialsService
    private let schedulers: Schedulers
    
    init(dependencies: Dependencies = .standard) {
        self.authenticationService = dependencies.authenticationService
        self.credentialsService = dependencies.credentialsService
        self.schedulers = dependencies.schedulers
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
        let schedulers: Schedulers
        
        static let standard = Dependencies(
            authenticationService: Services.standard.authenticationService,
            credentialsService: Services.local.credentialsService,
            schedulers: Schedulers.standard)
    }
}

// MARK: - Functions

extension AuthenticationUseCase {
    func login(username: String,
               password: String) -> Completable {
        credentialsService.clearCredentials()
        
        // Handle the response for authentication
        return authenticationService.authenticate(
            withUsername: username,
            password: password).do(
                afterSuccess: { [unowned self] authenticationResponse in
                    self.credentialsService.updateCredentials(
                        refreshToken: authenticationResponse.refreshToken,
                        authenticationToken: authenticationResponse.authenticationToken)
                })
            .observeOn(schedulers.main)
            .asCompletable()
    }
}
