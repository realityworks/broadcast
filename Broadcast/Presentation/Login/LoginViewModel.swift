//
//  LoginViewModel.swift
//  Broadcast
//
//  Created by Piotr Suwara on 18/11/20.
//

import Foundation


class LoginViewModel : ViewModel {
    
    init(dependencies: Dependencies = .standard) {
        super.init(stateController: dependencies.stateController)
    }
}

/// LoginViewModel dependencies component
extension LoginViewModel {
    struct Dependencies {
        
        let stateController: StateController
        
        static let standard = Dependencies(
            stateController: StateController.standard)
        
    }
}
