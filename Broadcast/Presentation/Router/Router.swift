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
    private let errorObservable: Observable<BoomdayError>
    private let connectionStateObservable: Observable<ConnectionState>
    private let authenticationStateObservable: Observable<AuthenticationState>
    private let schedulers: Schedulers
    
    private let selectedRouteSubject: BehaviorRelay<Route> = BehaviorRelay(value: .login)
    private let disposeBag = DisposeBag()
    
    init(dependencies: Dependencies = .standard) {
        self.stateController = dependencies.stateController
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
            .skip(1)
            .subscribe(onNext: { authenticationState in
                self.authenticationStateChanged(authenticationState)
            })
            .disposed(by: disposeBag)
        
        /// Listen to when a new route is pushed, the router here will force the selected route on
        /// to the root view controller. This handles the top level routing
        selectedRouteSubject
            .subscribe(onNext: { route in
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
                appDelegate.window?.rootViewController = route.viewControllerInstance()
            })
            .disposed(by: disposeBag)

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
        let errorObservable: Observable<BoomdayError>
        let connectionStateObservable: Observable<ConnectionState>
        let authenticationStateObservable: Observable<AuthenticationState>
        let schedulers: Schedulers
        
        static var standard = Dependencies(
            stateController: Domain.standard.stateController,
            errorObservable: Domain.standard.stateController.errorObservable(),
            connectionStateObservable: Domain.standard.stateController.stateObservable(of: \.connectionState),
            authenticationStateObservable: Domain.standard.stateController.stateObservable(of: \.authenticationState),
            schedulers: Schedulers.standard)
    }
}
