//
//  NewPostGuideViewModel.swift
//  Broadcast
//
//  Created by Piotr Suwara on 20/11/20.
//

import Foundation

class NewPostGuideViewModel : ViewModel {
    
    init(dependencies: Dependencies = .standard) {
        super.init(stateController: dependencies.stateController)
    }
    
}

/// MainViewModel dependencies component
extension NewPostGuideViewModel {
    struct Dependencies {
        
        let stateController: StateController
        
        static let standard = Dependencies(
            stateController: StateController.standard)
        
    }
}
