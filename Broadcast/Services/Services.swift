//
//  Services.swift
//  Broadcast
//
//  Created by Piotr Suwara on 18/11/20.
//

import Foundation

/// Collection of services provided for the application
class Services {
    private (set) var authenticationService: AuthenticationService
    private (set) var credentialsService: CredentialsService
    private (set) var uploadService: UploadService
    
    init(authenticationService: AuthenticationService,
         credentialsService: CredentialsService,
         uploadService: UploadService) {
        self.authenticationService = authenticationService
        self.credentialsService = credentialsService
        self.uploadService = uploadService
    }
}

// MARK: Service definitions

extension Services {
    static let standard = {
        return Services(
            authenticationService: StandardAuthenticationService(stateController: StateController.standard),
            credentialsService: StandardCredentialsService(),
            uploadService: StandardUploadService(stateController: StateController.standard))
    }()
    
    static let local = {
        return Services(
            authenticationService: LocalAuthenticationService(stateController: StateController.standard),
            credentialsService: StandardCredentialsService(),
            uploadService: LocalUploadService(stateController: StateController.standard))
    }()
}
