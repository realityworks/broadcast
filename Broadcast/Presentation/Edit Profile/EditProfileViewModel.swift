//
//  EditProfileViewModel.swift
//  Broadcast
//
//  Created by Piotr Suwara on 20/11/20.
//

import Foundation

class EditProfileViewModel : ViewModel {
    
    init(dependencies: Dependencies = .standard) {
        super.init(stateController: dependencies.stateController)
    }
}

/// AddPostViewModel dependencies component
extension EditProfileViewModel {
    struct Dependencies {
        
        let stateController: StateController
        
        static let standard = Dependencies(
            stateController: StateController.standard)
        
    }
}
