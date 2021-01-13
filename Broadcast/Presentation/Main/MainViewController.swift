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
    private (set) var newPostViewController: UIViewController!
    private (set) var profileViewController: UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
        
        myPostsViewController           = Route.myPosts.viewControllerInstance()
        newPostViewController           = Route.newPostCreate.viewControllerInstance()
        profileViewController           = Route.profile.viewControllerInstance()
        
        addChild(myPostsViewController)
        addChild(newPostViewController)
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
        case .newPostCreate:
            selectedIndex = TabBarItems.upload.rawValue
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
        
        /// Create the New Post Tab bar item
        let newPostTabBarItem = UITabBarItem(
            title: LocalizedString.newPost.localized,
            image: UIImage.iconPlusCircle,
            selectedImage: UIImage.iconPlusCircle)
        
        newPostViewController.tabBarItem = newPostTabBarItem
        
        /// Create the Profile Tab bar item
        let profileTabBarItem = UITabBarItem(
            title: LocalizedString.myProfile.localized,
            image: UIImage.iconProfile,
            selectedImage: UIImage.iconProfile)
        
        profileViewController.tabBarItem = profileTabBarItem
        
        viewControllers = [myPostsViewController, newPostViewController, profileViewController]
        
    }
}

// MARK: - MainView

extension MainViewController : UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController,
                          didSelect viewController: UIViewController) {
        Logger.log(level: .info,
                   topic: .appState,
                   message: "Selected \(viewController.title ?? "No title")")
    }
}
