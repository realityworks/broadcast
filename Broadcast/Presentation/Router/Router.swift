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
    
    private let selectedRouteSubject: BehaviorRelay<Route> = BehaviorRelay(value: .main(child: .none))
    private let disposeBag = DisposeBag()
    
    init(dependencies: Dependencies = .standard) {
        self.stateController = dependencies.stateController
        self.selectedRouteObservable = selectedRouteSubject.asObservable()
        self.errorObservable = dependencies.errorObservable
        self.connectionStateObservable = dependencies.connectionStateObservable
        self.authenticationStateObservable = dependencies.authenticationStateObservable
    }
    
    /// Configure the observables to catch the changes in
    /// the app state that will alter the current state of view controllers
    func setup() {
        
    }
}

// MARK: - Dependencies

extension Router {
    struct Dependencies {
        let stateController: StateController
        let errorObservable: Observable<BoomdayError>
        let connectionStateObservable: Observable<ConnectionState>
        let authenticationStateObservable: Observable<AuthenticationState>
        
        static var standard = Dependencies(
            stateController: Domain.standard.stateController,
            errorObservable: Domain.standard.stateController.errorObservable(),
            connectionStateObservable: Domain.standard.stateController.stateObservable(of: \.connectionState),
            authenticationStateObservable: Domain.standard.stateController.stateObservable(of: \.authenticationState))
    }
}