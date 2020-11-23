//
//  LoginViewModel.swift
//  Broadcast
//
//  Created by Piotr Suwara on 18/11/20.
//

import Foundation
import RxCocoa
import RxSwift

class LoginViewModel : ViewModel {
    private let authenticationUseCase: AuthenticationUseCase
    
    let usernamePublisher = BehaviorRelay<String?>(value: nil)
    let passwordPublisher = BehaviorRelay<String?>(value: nil)
    let isLoadingActivityVisible = BehaviorRelay<Bool>(value: false)
    let isLoginEnabled: Observable<Bool>
    
    init(dependencies: Dependencies = .standard) {
        self.authenticationUseCase = dependencies.authenticationUseCase
        
        isLoginEnabled = Observable.combineLatest(usernamePublisher, passwordPublisher) { username, password in
            guard let username = username,
                  let password = password = 
            return username.
        }
        
        super.init(stateController: dependencies.stateController)
    }
}

/// LoginViewModel dependencies component
extension LoginViewModel {
    struct Dependencies {
        
        let stateController: StateController
        let authenticationUseCase: AuthenticationUseCase
        
        static let standard = Dependencies(
            stateController: Domain.standard.stateController,
            authenticationUseCase: Domain.standard.useCases.authenticationUseCase)
    }
}
