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
    
    func navigationBar(styleAs style: NavigationBarStyle) {
        switch style {
        case .dark(let titleString):
            /// Remove the background image view if one exists
//            if let imageView = navigationController?.navigationBar.subviews.first(where: { $0 is UIImageView }) {
//                imageView.removeFromSuperview()
//            }
            
            title = titleString.localized
            navigationController?.navigationBar.setBackgroundImage(UIImage(color: UIColor.primaryBlack), for: .default)
            
            let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
            navigationController?.navigationBar.titleTextAttributes = textAttributes
            
        case .darkLogo:
            /// Remove a background image if one exists
//            if let imageView = navigationController?.navigationBar.subviews.first(where: { $0 is UIImageView }) {
//                imageView.removeFromSuperview()
//            }
            
            navigationController?.navigationBar.setBackgroundImage(UIImage(color: UIColor.primaryBlack), for: .default)
            
            navigationItem.titleView = UIImageView(image: .logoBoomdayBroadcaster)
//            backgroundImageView.contentMode = .scaleAspectFit
//            navigationController?.navigationBar.addSubview(backgroundImageView)
//            backgroundImageView.centerInSuperview()
        }
    }
}
