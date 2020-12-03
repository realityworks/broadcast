//
//  ProfileViewModel.swift
//  Broadcast
//
//  Created by Piotr Suwara on 20/11/20.
//

import Foundation

class ProfileViewModel : ViewModel {
    
    private enum Row {
        case detail
        case subscription
        case frequentlyAskedQuestions
        case privacyPolicy
        case termsAndConditions
        case share
        case logout
    }
    
    init(dependencies: Dependencies = .standard) {
        super.init(stateController: dependencies.stateController)
        
    }
    
}

/// NewPostViewModel dependencies component
extension ProfileViewModel {
    struct Dependencies {
        
        let stateController: StateController
        
        static let standard = Dependencies(
            stateController: StateController.standard)
        
    }
}
