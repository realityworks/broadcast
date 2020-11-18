//
//  ConnectivityUseCase.swift
//  Broadcast
//
//  Created by Piotr Suwara on 18/11/20.
//

import Foundation

class ConnectivityUseCase {
    typealias T = ConnectivityUseCase
    var stateController: StateController!
    
    init() {
        
    }
}

extension ConnectivityUseCase : StateControllerInjector {
}
