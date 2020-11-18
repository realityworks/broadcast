//
//  ConnectivityUseCase.swift
//  Broadcast
//
//  Created by Piotr Suwara on 18/11/20.
//

import Foundation
import Network

class ConnectivityUseCase {
    typealias T = ConnectivityUseCase
    
    var stateController: StateController!
    
    private let monitor: NWPathMonitor
    private let backgroudQueue = DispatchQueue.global(qos: .background)
    
    init(monitor: NWPathMonitor) {
        self.monitor = monitor
    }
}

extension ConnectivityUseCase : StateControllerInjector {
    @discardableResult
    func with(stateController: StateController) -> ConnectivityUseCase {
        self.stateController = stateController
        return self
    }
}
