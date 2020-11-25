//
//  MainViewController.swift
//  Broadcast
//
//  Created by Piotr Suwara on 17/11/20.
//

import UIKit

class MainViewController: UITabBarController {
    
    let myPostViewController    = MyPostsViewController()
    let profileViewController   = ProfileViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
        
        // Do any additional setup after loading the view.
        configureViews()
        styleView()
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
            image: UIImage(systemName: "person"),
            selectedImage: UIImage(systemName: "person.fill"))
        
        profileViewController.tabBarItem = profileTabBarItem
    }
}

// MARK: - MainView

extension MainViewController : UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController,
                          didSelect viewController: UIViewController) {
            print("Selected \(viewController.title!)")
    }
}
