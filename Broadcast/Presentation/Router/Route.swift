//
//  Route.swift
//  Broadcast
//
//  Created by Piotr Suwara on 18/11/20.
//

import UIKit

indirect enum Route {
    case none
    case login
    case main(child: Route)
    case myPosts
    case profile
    case postDetail
    case newPostGuide
    case newPostDetail
}

extension Route {
    func viewControllerInstance() -> UIViewController? {
        switch self {
        case .none:
            return nil
        case .login:
            return LoginViewController()
        case .main(let child):
            let mainViewController = MainViewController()
            mainViewController.selectRoute(child)
            return mainViewController
        case .myPosts:
            let myPostsViewController = MyPostsViewController()
            let navigationController = UINavigationController(rootViewController: myPostsViewController)
            return navigationController
        case .profile:
            return ProfileViewController()
        case .postDetail:
            return PostDetailViewController(isEditing: false)
        case .newPostGuide:
            let newPostGuideViewController = NewPostGuideViewController()
            let navigationController = UINavigationController(rootViewController: newPostGuideViewController)
            return navigationController
        case .newPostDetail:
            return PostDetailViewController(isEditing: true)
        }
    }
}
