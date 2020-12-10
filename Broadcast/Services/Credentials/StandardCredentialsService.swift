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
    private let accessTokenKey = "accessToken"
    private let refreshTokenKey = "refreshToken"
    
    func clearCredentials() {
        #warning("TODO")
    }
    
    func updateCredentials(accessToken: String,
                           refreshToken: String) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
    
    var refreshToken: String? {
        get {
            return keychain[refreshTokenKey]
        }
        
        set {
            keychain[refreshTokenKey] = newValue
        }
    }
    
    var accessToken: String? {
        get {
            return keychain[accessTokenKey]
        }
        
        set {
            keychain[accessTokenKey] = newValue
        }
    }
}

// MARK: Instance methods

extension StandardCredentialsService {
    static let standard: StandardCredentialsService = StandardCredentialsService()
}
