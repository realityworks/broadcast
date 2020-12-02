//
//  NewPostGuideViewModel.swift
//  Broadcast
//
//  Created by Piotr Suwara on 20/11/20.
//

import Foundation
import RxCocoa
import RxSwift

class NewPostGuideViewModel : ViewModel {
    
    let mediaSelected = PublishRelay<()>()
    
    init(dependencies: Dependencies = .standard) {
        super.init(stateController: dependencies.stateController)
        
    }
    
    func mediaSelected(_ mediaUrl: MediaUrl) {
        stateController.state.selectedMedia = mediaUrl
        mediaSelected.accept(())
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
