//
//  AuthenticationServiceProtocol.swift
//  Broadcast
//
//  Created by Piotr Suwara on 18/11/20.
//

import Foundation

protocol AuthenticationService {
    var stateController: StateController { get }
    
    func login(with username: String, password: String)
    func logout()
}

