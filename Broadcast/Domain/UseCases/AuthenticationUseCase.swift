//
//  AuthenticationUseCase.swift
//  Broadcast
//
//  Created by Piotr Suwara on 18/11/20.
//

import Foundation

class AuthenticationUseCase : StateControllerInjector {
    
    let authenticationService: AuthenticationService
    var stateController: StateController!
    
    init(authenticationService: AuthenticationService) {
        self.authenticationService = authenticationService
    }
    
    func with(stateController: StateController) {
        self.stateController = stateController
    }
}


extension AuthenticationUseCase {
    static let standard = {
        return AuthenticationUseCase(authenticationService: Services.local.authenticationService)
    }()
}
