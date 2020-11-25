//
//  Domain.swift
//  Broadcast
//
//  Created by Piotr Suwara on 16/11/20.
//

import Foundation

class Domain {
    let stateController: StateController
    let useCases: UseCases
    let router: Router
    
    init(dependencies: Dependencies = .standard) {
        self.stateController = dependencies.stateController
        self.useCases = dependencies.useCases
        self.router = dependencies.router
    }
}

// MARK: - Instance Methods

extension Domain {
    static let standard = {
        return Domain()
    }()
}

// MARK: - Dependency Injection

extension Domain {
    struct Dependencies {
        
        let stateController: StateController
        let useCases: UseCases
        let router: Router
        
        static let standard = Dependencies(
            stateController: StateController.standard,
            useCases: UseCases.standard.with(stateController: StateController.standard),
            router: Router())
    }
}
