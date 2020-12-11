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
    
    private let profileUseCase: ProfileUseCase
    private let authenticationUseCase: AuthenticationUseCase
    
    init(dependencies: Dependencies = .standard) {
        self.profileUseCase = dependencies.profileUseCase
        self.authenticationUseCase = dependencies.authenticationUseCase
        super.init(stateController: dependencies.stateController)
    }
    
    func loadProfile() {
        profileUseCase.loadProfile()
    }
    
    func logout() {
        authenticationUseCase.logout()
    }
}

// MARK: - Dependencies

extension ProfileViewModel {
    struct Dependencies {
        
        let stateController: StateController
        let profileUseCase: ProfileUseCase
        let authenticationUseCase: AuthenticationUseCase
        
        static let standard = Dependencies(
            stateController: Domain.standard.stateController,
            profileUseCase: Domain.standard.useCases.profileUseCase,
            authenticationUseCase: Domain.standard.useCases.authenticationUseCase)
    }
}
