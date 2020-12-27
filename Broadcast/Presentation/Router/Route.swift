//
//  Route.swift
//  Broadcast
//
//  Created by Piotr Suwara on 18/11/20.
//

import UIKit

indirect enum Route : Equatable {
    case none
    case login
    case main(child: Route)
    case myPosts
    case profile
    case profileDetail
    case stripeAccount
    case postDetail
    case newPostCreate
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
            let profileViewController = ProfileViewController()
            let navigationController = UINavigationController(rootViewController: profileViewController)
            return navigationController
        case .postDetail:
            return PostDetailViewController()
        case .newPostCreate:
            let newPostCreateViewController = NewPostCreateViewController()
            let navigationController = UINavigationController(rootViewController: newPostCreateViewController)
            return navigationController
        case .profileDetail:
            return ProfileDetailViewController()
        case .stripeAccount:
            return ProfileStripeAccountViewController()
        }
    }
}
