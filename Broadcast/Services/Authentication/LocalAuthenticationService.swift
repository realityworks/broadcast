//
//  LocalAuthenticationService.swift
//  Broadcast
//
//  Created by Piotr Suwara on 18/11/20.
//

import Foundation

/// The service performs only local authentication and login/logout
class LocalAuthenticationService : AuthenticationService {
    var stateController: StateController
    
    init(stateController: StateController) {
        self.stateController = stateController
    }
    
    func login(with username: String, password: String) {
        
    }
    
    func logout() {
        
    }
}
