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
    
    enum NavigationBarStyle {
        case dark(title: LocalizedString)
        case darkLogo
    }
    
    // Internal properties
    var disposeBag = DisposeBag()
    var backbarItem: UIBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    
    // MARK: View Controller overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the default background colour
        view.backgroundColor = UIColor.secondaryWhite
        
        navigationController?.navigationBar.barStyle = .black
                
        Logger.verbose(topic: .appState, message: "viewDidLoad")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Logger.verbose(topic: .appState, message: "viewWillAppear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Logger.verbose(topic: .appState, message: "viewDidAppear")
        navigationItem.backBarButtonItem = backbarItem
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
    
    func navigationBar(styleAs style: NavigationBarStyle) {
        switch style {
        case .dark(let titleString):
            title = titleString.localized
            navigationController?.navigationBar.setBackgroundImage(UIImage(color: UIColor.primaryBlack), for: .default)
            
            let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
            navigationController?.navigationBar.titleTextAttributes = textAttributes
            navigationController?.navigationBar.tintColor = .white
            navigationItem.backBarButtonItem?.tintColor = .white
            
        case .darkLogo:
            navigationController?.navigationBar.setBackgroundImage(UIImage(color: UIColor.primaryBlack), for: .default)
            navigationItem.titleView = UIImageView(image: .logoBoomdayBroadcaster)
            navigationController?.navigationBar.tintColor = .white
            navigationItem.backBarButtonItem?.tintColor = .white
            
        }
    }
}
