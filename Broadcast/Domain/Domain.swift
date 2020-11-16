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
    
    init(stateController: StateController, useCases: UseCases) {
        self.stateController = stateController
        self.useCases = useCases
    }
}

extension Domain {
    static let standard = {
        return Domain(stateController: StateController.standard,
                      useCases: UseCases.standard.with(stateController: StateController.standard))
    }()
}
