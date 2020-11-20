//
//  PostDetailViewModel.swift
//  Broadcast
//
//  Created by Piotr Suwara on 20/11/20.
//

import Foundation

/// NewPostViewModel dependencies component
extension PostDetailViewModel {
    struct Dependencies {
        
        let stateController: StateController
        
        static let standard = Dependencies(
            stateController: StateController.standard)
        
    }
}
