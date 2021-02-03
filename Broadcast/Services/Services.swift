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
    private (set) var apiService: APIService
    private (set) var persistenceService: PersistenceService
    
    init(
        authenticationService: AuthenticationService,
        credentialsService: CredentialsService,
        uploadService: UploadService,
        apiService: APIService,
        persistenceService: PersistenceService) {
        
        self.authenticationService = authenticationService
        self.credentialsService = credentialsService
        self.uploadService = uploadService
        self.apiService = apiService
        self.persistenceService = persistenceService
        
        apiService.inject(credentialsService: self.credentialsService)
        uploadService.inject(apiService: self.apiService)
    }
}

// MARK: Service definitions

extension Services {
    static let standard = {
        return Services(
            authenticationService: StandardAPIService.standard,
            credentialsService: StandardCredentialsService.standard,
            uploadService: StandardUploadService.standard,
            apiService: StandardAPIService.standard,
            persistenceService: StandardPersistenceService.standard)
    }()
    
    static let local = {
        return Services(
            authenticationService: LocalAuthenticationService.standard,
            credentialsService: StandardCredentialsService(),
            uploadService: StandardUploadService(),
            apiService: LocalAPIService.standard,
            persistenceService: StandardPersistenceService.standard)
    }()
}
