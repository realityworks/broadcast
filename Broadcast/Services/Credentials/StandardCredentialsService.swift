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
    private let pairingTokenKey = "pairingToken"
    private let accessTokenKey = "accessToken"
    
    func clearCredentials() {
        #warning("TODO")
    }
    
    func updateCredentials(refreshToken: String,
                           authenticationToken: String) {
        
    }
    
    var refreshToken: String? = nil
    var authenticationToken: String? = nil
}
