//
//  AuthenticateResponse.swift
//  Broadcast
//
//  Created by Piotr Suwara on 24/11/20.
//

import Foundation

struct AuthenticateResponse : Decodable {
    let accessToken: String
    let expiresIn: Int
    let refreshToken: String
    let tokenType: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case expiresIn = "expires_in"
        case refreshToken = "refresh_token"
        case tokenType = "token_type"
    }
    
    /// Initializer for just an access token and refresh token
    /// - Parameters:
    ///   - accessToken: Initialize with predefined access token
    ///   - refreshToken: Initialize with predefined refresh token
    init(accessToken: String, refreshToken: String) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.expiresIn = 0
        self.tokenType = ""
    }
}
