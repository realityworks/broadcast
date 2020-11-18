//
//  Router.swift
//  Broadcast
//
//  Created by Piotr Suwara on 18/11/20.
//

import Foundation

class Router {
    private let stateController: StateController
    
    init(dependencies: Dependencies = .standard) {
        self.stateController = stateController
    }
}

extension Router {
    struct Dependencies {
        let stateController: StateController
    
        static var standard = Dependencies(stateController: Domain.standard.stateController)
    }
}
