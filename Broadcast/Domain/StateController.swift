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
    associatedtype T
    var stateController: StateController! { get set }
    
    @discardableResult
    func with(stateController: StateController) -> T
}

class StateController {
    private let schedulers: Schedulers
    private let stateSubject: BehaviorRelay<State>
    private let errorSubject: PublishRelay<Error>
    
    /// Current Model representing the app state, when did set, pushes the update up in the subject
    var state: State {
        didSet {
            stateSubject.accept(state)
        }
    }
    
    /// Required Initializer
    /// - Parameters:
    ///   - state: State object that will be used to describe the application local state
    ///   - schedulers: Collection of schedulers that will run the transports for state and error subjects
    init(dependencies: Dependencies = .standard) {
        self.state = dependencies.state
        self.schedulers = dependencies.schedulers
        
        stateSubject = BehaviorRelay<State>(value: state)
        errorSubject = PublishRelay<Error>()
    }
}

// MARK: Observing Change Functions

extension StateController {
    /// Create an observable on the keypath of the of the state
    /// - Parameter path: Key path of the state to observe
    /// - Returns: The observable. This needs to conform to Equatable
    func stateObservable<T: Equatable>(of path: KeyPath<State, T>, distinct: Bool = true) -> Observable<T> {
        
        let observable = stateSubject
            .map { $0[keyPath: path] }
            .observe(on: schedulers.main)
        
        return distinct ? observable.distinctUntilChanged() : observable
    }
    
    /// Get an observable on any errors that are propagated
    /// - Returns: An observable on errors in the app.
    func errorObservable() -> Observable<Error> {
        return errorSubject
            .asObservable()
            .observe(on: schedulers.main)
    }
    
    /// Get an observable on any errors that are propagated
    /// - Returns: An observable on errors in the app.
    func errorStringObservable() -> Observable<String> {
        return errorSubject
            .asObservable()
            .map { BoomdayError.errorString(from: $0) }
            .observe(on: schedulers.main)
    }
    
    func sendError(_ error: Error) {
        Logger.log(level: .warning,
                   topic: .debug,
                   message: BoomdayError.errorString(from: error))
        
        errorSubject.accept(error)
    }
    
    func stateChanged() {
        stateSubject.accept(state)
    }
}

// MARK: Instances

extension StateController {
    static let standard: StateController = {
        return StateController()
    }()
}

// MARK: Dependencies

extension StateController {
    struct Dependencies {
        let state: State
        let schedulers: Schedulers
        
        static var standard = Dependencies(state: State(),
                                           schedulers: Schedulers.standard)
    }
}
