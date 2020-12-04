//
//  ProfileViewModel.swift
//  Broadcast
//
//  Created by Piotr Suwara on 20/11/20.
//

import Foundation

class ProfileViewModel : ViewModel {
    
    enum Row {
        case detail
        case stripeAccount
        case frequentlyAskedQuestions
        case privacyPolicy
        case termsAndConditions
        case share
        case logout
    }
    
    let profileUseCase: ProfileUseCase
    
    init(dependencies: Dependencies = .standard) {
        self.profileUseCase = dependencies.profileUseCase
        super.init(stateController: dependencies.stateController)
    }
    
}

/// NewPostViewModel dependencies component
extension ProfileViewModel {
    struct Dependencies {
        
        let stateController: StateController
        let profileUseCase: ProfileUseCase
        
        static let standard = Dependencies(
            stateController: Domain.standard.stateController,
            profileUseCase: Domain.standard.useCases.profileUseCase)
    }
}
