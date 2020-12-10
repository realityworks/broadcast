//
//  AuthenticateResponse.swift
//  Broadcast
//
//  Created by Piotr Suwara on 24/11/20.
//

import Foundation

struct AuthenticateResponse : Decodable {
    let accessToken: String
    let code: Int
    let count: Int
    let deviceCode: String
    let error: String
    let errorDescription: String
    let errorUri: String
    let expiresIn: Int
    let idToken: String
    let refreshToken: String
    let scope: String
    let state: String
    let tokenType: String
    let userCode: String
    
    /// Initializer for just an access token and refresh token
    /// - Parameters:
    ///   - accessToken: Initialize with predefined access token
    ///   - refreshToken: Initialize with predefined refresh token
    init(accessToken: String, refreshToken: String) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken

        self.code = 0
        self.count = 0
        self.deviceCode = ""
        self.error = ""
        self.errorDescription = ""
        self.errorUri = ""
        self.expiresIn = 0
        self.idToken = ""
        self.scope = ""
        self.state = ""
        self.tokenType = ""
        self.userCode = ""
    }
}
