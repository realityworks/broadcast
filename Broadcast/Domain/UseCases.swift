//
//  UseCases.swift
//  Broadcast
//
//  Created by Piotr Suwara on 16/11/20.
//

import Foundation

/// Collection of the usecases available to the application. Each use case manages a specific
/// set of commands that are service independant
class UseCases {
    func with(stateController: StateController) -> UseCases {
        //self.stateController = stateController
        
        // Inject the StateController into the usecases
        
        return self
    }
}

// MARK: Instances

extension UseCases {
    static let standard: UseCases = {
       return UseCases()
    }()
}
