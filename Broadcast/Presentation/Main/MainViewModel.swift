//
//  MainViewModel.swift
//  Broadcast
//
//  Created by Piotr Suwara on 17/11/20.
//

import Foundation

class MainViewModel : ViewModel {
    
    init(dependencies: Dependencies = .standard) {
        super.init(stateController: StateController.standard)
        
    }
    
}

/// MainViewModel dependencies component
extension MainViewModel {
    struct Dependencies {
        
        let stateController: StateController
        
        static let standard = Dependencies(
            stateController: StateController.standard)
        
    }
}
