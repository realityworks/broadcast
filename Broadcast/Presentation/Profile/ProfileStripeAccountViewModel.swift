//
//  ProfileSubscriptionViewModel.swift
//  Broadcast
//
//  Created by Piotr Suwara on 3/12/20.
//

import Foundation

class ProfileStripeAccountViewModel : ViewModel {
    
    init(dependencies: Dependencies = .standard) {
        super.init(stateController: dependencies.stateController)
        
    }
    
}

/// NewPostViewModel dependencies component
extension ProfileStripeAccountViewModel {
    struct Dependencies {
        
        let stateController: StateController
        
        static let standard = Dependencies(
            stateController: StateController.standard)
    }
}

