//
//  ProfileUseCase.swift
//  Broadcast
//
//  Created by Piotr Suwara on 18/11/20.
//

import Foundation

class ProfileUseCase : StateControllerInjector {
    let profileService: ProfileService
    var stateController: StateController!
    
    init(authenticationService: AuthenticationService) {
        self.authenticationService = authenticationService
    }
    
    func with(stateController: StateController) {
        self.stateController = stateController
    }
}
