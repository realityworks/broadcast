//
//  StandardCredentialsService.swift
//  Broadcast
//
//  Created by Piotr Suwara on 18/11/20.
//

import Foundation
import KeychainAccess

class StandardCredentialsService : CredentialsService {
    
    private let keychain = Keychain(service: Bundle.main.bundleIdentifier!)
    private let authenticationTokenKey = "authenticationToken"
    private let refreshTokenKey = "refreshToken"
    
    func clearCredentials() {
        #warning("TODO")
    }
    
    func updateCredentials(refreshToken: String,
                           authenticationToken: String) {
        self.refreshToken = refreshToken
        self.authenticationToken = authenticationToken
    }
    
    var refreshToken: String? {
        get {
            return keychain[refreshTokenKey]
        }
        
        set {
            keychain[refreshTokenKey] = newValue
        }
    }
    
    var authenticationToken: String? {
        get {
            return keychain[authenticationTokenKey]
        }
        
        set {
            keychain[authenticationTokenKey] = newValue
        }
    }
}

// MARK: Instance methods

extension StandardCredentialsService {
    static let standard: StandardCredentialsService = StandardCredentialsService()
}
