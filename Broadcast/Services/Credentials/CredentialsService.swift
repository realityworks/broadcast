//
//  CredentialsService.swift
//  Broadcast
//
//  Created by Piotr Suwara on 18/11/20.
//

import Foundation

protocol CredentialsService {
    func clearCredentials()
    func updateCredentials()
    var refreshToken: String? { get set }
    var authenticationToken: String? { get set }
}
