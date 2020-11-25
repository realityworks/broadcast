//
//  ViewModel.swift
//  Broadcast
//
//  Created by Piotr Suwara on 16/11/20.
//

import Foundation
import RxSwift

/// Protocol extension for the base class
class ViewModel {

    let disposeBag = DisposeBag()
    let stateController: StateController
    let dispatchGroup = DispatchGroup()
    
    init(stateController: StateController) {
        self.stateController = stateController
    }
}
