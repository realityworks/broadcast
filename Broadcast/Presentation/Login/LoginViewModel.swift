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
    private let profileUseCase: ProfileUseCase
    private let postContentUseCase: PostContentUseCase
    
    let username = BehaviorRelay<String?>(value: nil)
    let password = BehaviorRelay<String?>(value: nil)
    
    private let isLoadingSubject = BehaviorRelay<Bool>(value: false)
    private let isErrorHiddenSubject = BehaviorRelay<Bool>(value: true)
    
    let isLoginEnabled: Observable<Bool>
    let isLoading: Observable<Bool>
    
    private let showAcceptTermsSubject = PublishSubject<()>()
    let showAcceptTerms: Observable<()>
    
    init(dependencies: Dependencies = .standard) {
        self.authenticationUseCase = dependencies.authenticationUseCase
        self.postContentUseCase = dependencies.postContentUseCase
        self.profileUseCase = dependencies.profileUseCase
        
        isLoading = isLoadingSubject.asObservable()
        showAcceptTerms = showAcceptTermsSubject.asObservable()
        
        isLoginEnabled = Observable.combineLatest(username, password, isLoading) { username, password, isLoading in
            guard let username = username,
                  let password = password else { return false }
            return !username.isEmpty && !password.isEmpty && !isLoading
        }
        
        super.init(stateController: dependencies.stateController)
    }
}

// MARK: - Dependencies

extension LoginViewModel {
    struct Dependencies {
        
        let stateController: StateController
        let authenticationUseCase: AuthenticationUseCase
        let profileUseCase: ProfileUseCase
        let postContentUseCase: PostContentUseCase
        
        static let standard = Dependencies(
            stateController: Domain.standard.stateController,
            authenticationUseCase: Domain.standard.useCases.authenticationUseCase,
            profileUseCase: Domain.standard.useCases.profileUseCase,
            postContentUseCase: Domain.standard.useCases.postContentUseCase)
    }
}

// MARK: - Functions

extension LoginViewModel {
    func acceptTerms() {
        guard let username = username.value else { return }
        profileUseCase.acceptTerms(forUser: username)
    }
    
    func checkTermsAccepted() {
        guard let username = username.value else { return }
        if profileUseCase.hasAcceptedTerms(forUser: username) {
            login()
        } else {
            showAcceptTermsSubject.onNext(())
        }
    }
    
    func login() {
        stateController.state.authenticationState = AuthenticationState.loggingIn
        isLoadingSubject.accept(true)
        
        authenticationUseCase.login(username: username.value ?? "",
                                    password: password.value ?? "")
            .subscribe {
                // Handle a successful login
                self.profileUseCase.loadProfile()
            } onError: { error in
                self.isLoadingSubject.accept(false)
            }
            .disposed(by: disposeBag)
    }
}
