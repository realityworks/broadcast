//
//  CredentialsService.swift
//  Broadcast
//
//  Created by Piotr Suwara on 18/11/20.
//

import Foundation

protocol CredentialsService {
    func clearCredentials()
    private (set) var refreshToken: String? { get set }
    private (set) var authenticationToken: String? { get set }
}
