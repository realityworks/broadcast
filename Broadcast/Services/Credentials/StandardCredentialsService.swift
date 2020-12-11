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

    
    func clearCredentials() {
        try? keychain.remove(accessTokenKey)
        try? keychain.remove(refreshTokenKey)
    }
    
    func updateCredentials(accessToken: String,
                           refreshToken: String) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
    
    func hasCredentials() -> Bool {
        let containsAccessToken     = (try? keychain.contains(accessTokenKey)) ?? false
        let containsRefreshToken    = (try? keychain.contains(refreshTokenKey)) ?? false
        return containsAccessToken && containsRefreshToken
    }
}

// MARK: Instance methods

extension StandardCredentialsService {
    static let standard: StandardCredentialsService = StandardCredentialsService()
}
