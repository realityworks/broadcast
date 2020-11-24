//
//  StandardAuthenticationService.swift
//  Broadcast
//
//  Created by Piotr Suwara on 18/11/20.
//

import Foundation

/// The service performs only local authentication and login/logout
class StandardAuthenticationService : AuthenticationService {
    private (set) var stateController: StateController
    
    init(stateController: StateController) {
        self.stateController = stateController
    }
    
    func authenticate(withUsername username: String, password: String) -> Single<AuthenticateResponse> {
        
    }    
}
