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
    
    let username = BehaviorRelay<String?>(value: nil)
    let password = BehaviorRelay<String?>(value: nil)
    
    private let isLoadingSubject = BehaviorRelay<Bool>(value: false)
    
    let isLoginEnabled: Observable<Bool>
    let isLoading: Observable<Bool>
    
    init(dependencies: Dependencies = .standard) {
        self.authenticationUseCase = dependencies.authenticationUseCase
        
        isLoginEnabled = Observable.combineLatest(username, password) { username, password in
            guard let username = username,
                  let password = password else { return false }
            return !username.isEmpty && !password.isEmpty
        }
        
        isLoading = isLoadingSubject.asObservable()
        
        super.init(stateController: dependencies.stateController)
    }
}

// MARK: - Dependencies

extension LoginViewModel {
    struct Dependencies {
        
        let stateController: StateController
        let authenticationUseCase: AuthenticationUseCase
        
        static let standard = Dependencies(
            stateController: Domain.standard.stateController,
            authenticationUseCase: Domain.standard.useCases.authenticationUseCase)
    }
}

// MARK: - Functions

extension LoginViewModel {
    func login() {
        stateController.state.authenticationState = AuthenticationState.loggingIn
        isLoadingSubject.accept(true)
        
        authenticationUseCase.login(username: username.value ?? "",
                                    password: password.value ?? "")
            .subscribe {
                
            } onError: { error in
                Logger.log(level: .warning, topic: .debug, message: "Error during login: \(error)")
                self.isLoadingSubject.accept(false)
            }
            .disposed(by: disposeBag)
    }
}
