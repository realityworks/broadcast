//
//  CredentialsService.swift
//  Broadcast
//
//  Created by Piotr Suwara on 18/11/20.
//

import Foundation

protocol CredentialsService {
    func clearCredentials()
    func updateCredentials(accessToken: String,
                           refreshToken: String)
    var refreshToken: String? { get set }
    var accessToken: String? { get set }
    func hasCredentials() -> Bool
}
