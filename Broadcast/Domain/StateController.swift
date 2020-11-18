//
//  StateController.swift
//  Broadcast
//
//  Created by Piotr Suwara on 16/11/20.
//

import Foundation
import RxCocoa
import RxSwift

protocol StateControllerInjector {
    var stateController: StateController! { get set }
    func with(stateController: StateController)
}

class StateController {
    private let schedulers: Schedulers
    private let stateSubject: BehaviorRelay<State>
    private let errorSubject: PublishRelay<BoomdayError>
    
    /// Current Model representing the app state, when did set, pushes the update up in the subject
    private var state: State {
        didSet {
            stateSubject.accept(state)
        }
    }
    
    /// Required Initializer
    /// - Parameters:
    ///   - state: State object that will be used to describe the application local state
    ///   - schedulers: Collection of schedulers that will run the transports for state and error subjects
    init(state: State, schedulers: Schedulers) {
        self.state = state
        self.schedulers = schedulers
        
        stateSubject = BehaviorRelay<State>(value: state)
        errorSubject = PublishRelay<BoomdayError>()
    }
}

// MARK: Observing Change Functions

extension StateController {
    func stateObservable<T: Equatable>(of path: KeyPath<State, T>) -> Observable<T> {
        return stateSubject
            .map { $0[keyPath: path] }
            .distinctUntilChanged()
            .observeOn(schedulers.main)
    }
    
    func errorObservable() -> Observable<BoomdayError> {
        return errorSubject
            .asObservable()
            .observeOn(schedulers.main)
    }
    
    func sendError(_ error: BoomdayError) {
        errorSubject.accept(error)
    }
    
    func stateChanged() {
        stateSubject.accept(state)
    }
}

// MARK: Instances

extension StateController {
    static let standard: StateController = {
        return StateController(state: State(), schedulers: Schedulers.standard)
    }()
}
