//
//  MainViewController.swift
//  Broadcast
//
//  Created by Piotr Suwara on 17/11/20.
//

import UIKit

class MainViewController: UITabBarController {
    
    enum TabBarItems : Int {
        case myPosts = 0
        case upload = 1
        case profile = 2
    }
    
    private (set) var myPostsViewController: UIViewController!
    private (set) var profileViewController: UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
        
        myPostsViewController           = Route.myPosts.viewControllerInstance()
        profileViewController           = Route.profile.viewControllerInstance()
        
        addChild(myPostsViewController)
        addChild(profileViewController)
        
        // Do any additional setup after loading the view.
        configureViews()
        styleView()
    }
    
    /// Select a specific route in the Main View Controller
    /// - Parameter route: Selected Route
    func selectRoute(_ route: Route) {
        switch route {
        case .myPosts:
            selectedIndex = TabBarItems.myPosts.rawValue
        case .profile:
            selectedIndex = TabBarItems.profile.rawValue
            
        // Default handling is just to directly select the my posts item
        default:
            selectedIndex = TabBarItems.myPosts.rawValue
        }
    }
    
    /// Style the contentviews
    private func styleView() {
        view.backgroundColor = .white
        UITabBar.appearance().tintColor = .primaryRed
        UITabBarItem.appearance().setTitleTextAttributes(
            [NSAttributedString.Key.font: UIFont.smallBody],
            for: .normal)
    }
    
    private func configureViews() {
        /// Create the MyPosts Tab bar item
        let myPostsTabBarItem = UITabBarItem(
            title: LocalizedString.myPostsHeading.localized,
            image: UIImage.iconRadio,
            selectedImage: UIImage.iconRadio)

        myPostsViewController.tabBarItem = myPostsTabBarItem
        
        /// Create the Profile Tab bar item
        let profileTabBarItem = UITabBarItem(
            title: LocalizedString.myProfile.localized,
            image: UIImage.iconProfile,
            selectedImage: UIImage.iconProfile)
        
        profileViewController.tabBarItem = profileTabBarItem
        
        viewControllers = [myPostsViewController, profileViewController]
        
    }
}

// MARK: - MainView

extension MainViewController : UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController,
                          didSelect viewController: UIViewController) {
        Logger.log(level: .info,
                   topic: .appState,
                   message: "VIEWCONTROLLER: Selected \(viewController.title ?? "No title")")
    }
    
    func tabBarController(_ tabBarController: UITabBarController,
                          shouldSelect viewController: UIViewController) -> Bool {
        #warning("Do not pop back to the root view controller on double tap. Could possibly be fixed when we support multiple uploads.")
        return tabBarController.selectedViewController != viewController
    }
}
