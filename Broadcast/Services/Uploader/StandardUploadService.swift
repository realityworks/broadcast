//
//  StandardUploadService.swift
//  Broadcast
//
//  Created by Piotr Suwara on 18/11/20.
//

import Foundation

class StandardUploadService : UploadService {
    private (set) var stateController: StateController
    
    func upload(content: UploadableContent) {
        // TODO
    }
    
    init(stateController: StateController) {
        self.stateController = stateController
    }
}
