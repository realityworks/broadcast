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
    private let isErrorHiddenSubject = BehaviorRelay<Bool>(value: true)
    
    let isLoginEnabled: Observable<Bool>
    let isLoading: Observable<Bool>
    let isErrorHidden: Observable<Bool>
    let errorText: Observable<String>
    
    init(dependencies: Dependencies = .standard) {
        self.authenticationUseCase = dependencies.authenticationUseCase
        
        isLoginEnabled = Observable.combineLatest(username, password) { username, password in
            guard let username = username,
                  let password = password else { return false }
            return !username.isEmpty && !password.isEmpty
        }
        
        isLoading = isLoadingSubject.asObservable()
        isErrorHidden = isErrorHiddenSubject.asObservable()
        
        errorText = dependencies.stateController.errorStringObservable()
        
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
                // Handle a successful login
            } onError: { error in
                Logger.log(level: .warning, topic: .debug, message: "Error during login: \(error)")
                self.stateController.sendError(error)
                self.isLoadingSubject.accept(false)
                self.isErrorHiddenSubject.accept(false)
            }
            .disposed(by: disposeBag)
    }
    
    func closeError() {
        isErrorHiddenSubject.accept(true)
    }
}
