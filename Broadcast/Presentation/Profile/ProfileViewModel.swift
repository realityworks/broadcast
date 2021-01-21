//
//  ProfileViewModel.swift
//  Broadcast
//
//  Created by Piotr Suwara on 20/11/20.
//

import Foundation
import RxSwift
import RxCocoa

class ProfileViewModel : ViewModel {
    
    enum Row {
        case detail
        case stripeAccount
        case frequentlyAskedQuestions
        case privacyPolicy
        case termsAndConditions
        case share
        case logout
        case version
    }
    
    private let profileUseCase: ProfileUseCase
    private let authenticationUseCase: AuthenticationUseCase
    
    let shareProfileSubject = PublishRelay<()>()
    let shareProfileSignal: Observable<()>
    let profileHandle: Observable<String>
    
    init(dependencies: Dependencies = .standard) {
        self.profileUseCase = dependencies.profileUseCase
        self.authenticationUseCase = dependencies.authenticationUseCase
    
        shareProfileSignal = shareProfileSubject.asObservable()
        profileHandle = dependencies.profileObservable
            .compactMap { $0 }
            .map { $0.handle }
        
        super.init(stateController: dependencies.stateController)
    }
}

// MARK: - Dependencies

extension ProfileViewModel {
    struct Dependencies {
        
        let stateController: StateController
        let profileUseCase: ProfileUseCase
        let authenticationUseCase: AuthenticationUseCase
        let profileObservable: Observable<Profile?>
        
        static let standard = Dependencies(
            stateController: Domain.standard.stateController,
            profileUseCase: Domain.standard.useCases.profileUseCase,
            authenticationUseCase: Domain.standard.useCases.authenticationUseCase,
            profileObservable: Domain.standard.stateController.stateObservable(of: \.profile))
    }
}

// MARK: Functions

extension ProfileViewModel {
    func loadProfile() {
        profileUseCase.loadProfile()
    }
    
    func logout() {
        authenticationUseCase.logout()
    }
    
    func shareProfile() {
        shareProfileSubject.accept(())
    }
}
