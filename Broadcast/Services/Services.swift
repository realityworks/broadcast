//
//  Services.swift
//  Broadcast
//
//  Created by Piotr Suwara on 18/11/20.
//

import Foundation

/// Collection of services provided for the application
class Services {
    var authenticationService: AuthenticationService
    
    init(authenticationService: AuthenticationService,
         credentialsService: CredentialsService) {
        self.authenticationService = authenticationService
    }
}

// MARK: Service definitions

extension Services {
    static let standard = {
        return Services(
            authenticationService: StandardAuthenticationService(stateController: StateController.standard),
            credentialsService: StandardCredentialsService())
    }()
    
    static let local = {
        return Services(
            authenticationService: LocalAuthenticationService(stateController: StateController.standard),
            credentialsService: StandardCredentialsService())
    }()
}
