//
//  TextPopupManager.swift
//  Broadcast
//
//  Created by Piotr Suwara on 22/1/21.
//

import UIKit
import RxSwift

class TextPopupManager {
    /// Private initializer to keep this class as a singleton class
    init() {
    }
    
    open class func show(_ message: String) {
        
    }
}


// MARK: Instance

extension TextPopupManager {
    static let shared = {
        TextPopupManager()
    }()
}

extension Reactive where Base : TextPopupManager {
    
}
