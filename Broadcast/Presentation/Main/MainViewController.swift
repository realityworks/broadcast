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
        case profile = 1
    }
    
    private (set) var myPostViewController: UIViewController!
    private (set) var profileViewController: UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
        
        myPostViewController    = Route.myPosts.viewControllerInstance()
        profileViewController   = Route.profile.viewControllerInstance()

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
    }
    
    private func configureViews() {
        let myPostTabBarItem = UITabBarItem(
            title: "My Posts",
            image: UIImage(systemName: "person"),
            selectedImage: UIImage(systemName: "person.fill"))
        
        myPostViewController.tabBarItem = myPostTabBarItem
        
        let profileTabBarItem = UITabBarItem(
            title: "Profile",
            image: UIImage(systemName: "rectangle.stack.person.crop"),
            selectedImage: UIImage(systemName: "rectangle.stack.person.crop.fill"))
        
        profileViewController.tabBarItem = profileTabBarItem
        
        viewControllers = [myPostViewController, profileViewController]
    }
}

// MARK: - MainView

extension MainViewController : UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController,
                          didSelect viewController: UIViewController) {
            print("Selected \(viewController.title!)")
    }
}
