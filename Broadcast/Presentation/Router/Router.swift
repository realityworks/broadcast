//
//  Router.swift
//  Broadcast
//
//  Created by Piotr Suwara on 18/11/20.
//

import UIKit
import RxCocoa
import RxSwift

/// The router class manages the view controller coordination based on the app state changes
class Router {
    
    // MARK: Computed properties
    var selectedRoute: Route {
        get {
            selectedRouteSubject.value
        }

        set {
            selectedRouteSubject.accept(newValue)
        }
    }

    // MARK: Public properties
    let selectedRouteObservable: Observable<Route>

    // MARK: Private properties
    private let stateController: StateController
    private let authenticationUseCase: AuthenticationUseCase
    private let errorObservable: Observable<Error>
    private let connectionStateObservable: Observable<ConnectionState>
    private let authenticationStateObservable: Observable<AuthenticationState>
    private let schedulers: Schedulers
    
    private let selectedRouteSubject: BehaviorRelay<Route> = BehaviorRelay(value: .none)
    private let disposeBag = DisposeBag()
    
    init(dependencies: Dependencies = .standard) {
        self.stateController = dependencies.stateController
        self.authenticationUseCase = dependencies.authenticationUseCase
        self.selectedRouteObservable = selectedRouteSubject.asObservable()
        self.errorObservable = dependencies.errorObservable
        self.connectionStateObservable = dependencies.connectionStateObservable
        self.authenticationStateObservable = dependencies.authenticationStateObservable
        self.schedulers = dependencies.schedulers
    }
    
    /// Configure the observables to catch the changes in
    /// the app state that will alter the current state of view controllers
    func setup() {
        authenticationStateObservable
            .subscribe(onNext: { authenticationState in
                self.authenticationStateChanged(authenticationState)
            })
            .disposed(by: disposeBag)
        
        // Initialize authentication state
        
        /// Listen to when a new route is pushed, the router here will force the selected route on
        /// to the root view controller. This handles the top level routing
        selectedRouteSubject
            .distinctUntilChanged()
            .subscribe(onNext: { route in
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
                appDelegate.window?.rootViewController = route.viewControllerInstance()
            })
            .disposed(by: disposeBag)
        
        errorObservable
            .compactMap { $0 as? BoomdayError }
            .subscribe(onNext: { boomdayError in
                switch boomdayError {
                case .unknown,
                     .unsupported,
                     .decoding,
                     .apiNotFound,
                     .authenticationFailed,
                     .apiStatusCode,
                     .internalMemoryError:
                    UIApplication.shared.showError(boomdayError)
                default:
                    break
                }
            })
            .disposed(by: disposeBag)
        
        stateController.state.authenticationState = authenticationUseCase.isLoggedIn ? .loggedIn : .loggedOut
    }
    
    private func authenticationStateChanged(
        _ authenticationState: AuthenticationState) {
        guard authenticationState != .loggingIn,
              authenticationState != .loggingOut else { return }
        
        switch authenticationState {
        case .loggedIn:
            selectedRoute = .main(child: .none)
        case .loggedOut:
            selectedRoute = .login
        default:
            fatalError("Unhandled authentication state, should never get here!")
        }
    }
}

// MARK: - Instance methods

extension Router {
    static let standard: Router = {
        Router()
    }()
}

// MARK: - Dependencies

extension Router {
    struct Dependencies {
        let stateController: StateController
        let authenticationUseCase: AuthenticationUseCase
        let errorObservable: Observable<Error>
        let connectionStateObservable: Observable<ConnectionState>
        let authenticationStateObservable: Observable<AuthenticationState>
        let schedulers: Schedulers
        
        static var standard = Dependencies(
            stateController: Domain.standard.stateController,
            authenticationUseCase: Domain.standard.useCases.authenticationUseCase,
            errorObservable: Domain.standard.stateController.errorObservable(),
            connectionStateObservable: Domain.standard.stateController.stateObservable(of: \.connectionState),
            authenticationStateObservable: Domain.standard.stateController.stateObservable(of: \.authenticationState),
            schedulers: Schedulers.standard)
    }
}
