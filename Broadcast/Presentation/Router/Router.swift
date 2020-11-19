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
    private let selectedRouteSubject: BehaviorRelay<Route> = BehaviorRelay(value: .main(child: .none))
    private let disposeBag = DisposeBag()
    
    init(dependencies: Dependencies = .standard) {
        self.stateController = dependencies.stateController
        self.selectedRouteObservable = selectedRouteSubject.asObservable()
    }
}

// MARK: - Dependencies

extension Router {
    struct Dependencies {
        let stateController: StateController
    
        static var standard = Dependencies(stateController: Domain.standard.stateController)
    }
}
