//
//  ViewController.swift
//  Broadcast
//
//  Created by Piotr Suwara on 16/11/20.
//

import UIKit
import RxSwift

/// Base class that wraps core functionality for the view controllers
/// used in the the Broadcast app.
class ViewController : UIViewController {
    
    var disposeBag = DisposeBag()
    
    // MARK: View Controller overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the default background colour
        view.backgroundColor = .white
        
        Logger.verbose(topic: .appState, message: "viewDidLoad")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Logger.verbose(topic: .appState, message: "viewWillAppear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Logger.verbose(topic: .appState, message: "viewDidAppear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Logger.verbose(topic: .appState, message: "viewWillDisappear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        Logger.verbose(topic: .appState, message: "viewDidDisappear")
    }
    
    // MARK: Configuration
}
